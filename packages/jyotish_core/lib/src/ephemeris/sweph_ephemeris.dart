import 'dart:io';
import 'dart:typed_data';

import 'package:sweph/sweph.dart';

import '../model/enums.dart';
import '../model/settings.dart';
import 'ephemeris.dart';

/// Ephemeris files used: planets, moon and main asteroids for 1800–2400 AD.
const swephDataFiles = ['sepl_18.se1', 'semo_18.se1', 'seas_18.se1'];

/// Swiss Ephemeris (AGPL-3.0 / Swiss Ephemeris Professional License).
///
/// Licence note: while this app is a private tool, AGPL is satisfied by
/// handing its source to whoever receives the APK. Before any public or paid
/// release, buy the Professional License or replace this class.
class SwephEphemeris implements Ephemeris {
  SwephEphemeris._();

  static SwephEphemeris? _instance;

  /// Initialise once per process.
  ///
  /// [epheDir] is a writable folder; the data files end up there and Swiss
  /// Ephemeris reads them from it. [loadAsset] supplies each file's bytes the
  /// first time (Flutter: rootBundle; tests: read from the package cache).
  /// [modulePath] is only needed outside a Flutter app (PC tests: sweph.dll).
  static Future<SwephEphemeris> init({
    required String epheDir,
    required Future<Uint8List> Function(String fileName) loadAsset,
    String? modulePath,
  }) async {
    if (_instance != null) return _instance!;
    await Sweph.init(
      modulePath: modulePath,
      epheFilesPath: epheDir,
      epheAssets: swephDataFiles,
      assetLoader: _FnAssetLoader(loadAsset),
    );
    return _instance = SwephEphemeris._();
  }

  /// Convenience for tests and tools: data files already sit in [dataDir].
  static Future<SwephEphemeris> initFromDirectory(
    String dataDir, {
    String? modulePath,
  }) =>
      init(
        epheDir: dataDir,
        modulePath: modulePath,
        loadAsset: (f) => File('$dataDir/$f').readAsBytes(),
      );

  static const _bodies = {
    Graha.sun: HeavenlyBody.SE_SUN,
    Graha.moon: HeavenlyBody.SE_MOON,
    Graha.mars: HeavenlyBody.SE_MARS,
    Graha.mercury: HeavenlyBody.SE_MERCURY,
    Graha.jupiter: HeavenlyBody.SE_JUPITER,
    Graha.venus: HeavenlyBody.SE_VENUS,
    Graha.saturn: HeavenlyBody.SE_SATURN,
    Graha.uranus: HeavenlyBody.SE_URANUS,
    Graha.neptune: HeavenlyBody.SE_NEPTUNE,
    Graha.pluto: HeavenlyBody.SE_PLUTO,
  };

  // The sidereal mode is process-global in Swiss Ephemeris, so set it on
  // every call that depends on it.
  SwephFlag _flags(CalcSettings s) {
    var f = SwephFlag.SEFLG_SWIEPH | SwephFlag.SEFLG_SPEED;
    final mode = s.ayanamsa.swephMode;
    if (mode != null) {
      if (s.ayanamsa == Ayanamsa.user) {
        final t0 = s.userT0, a0 = s.userAyanamsaAtT0;
        if (t0 == null || a0 == null) {
          throw ArgumentError('User ayanamsa needs userT0 and userAyanamsaAtT0');
        }
        Sweph.swe_set_sid_mode(SiderealMode.SE_SIDM_USER,
            SiderealModeFlag.SE_SIDBIT_NONE, t0, a0);
      } else {
        Sweph.swe_set_sid_mode(SiderealMode(mode));
      }
      f = f | SwephFlag.SEFLG_SIDEREAL;
    }
    return f;
  }

  @override
  double julianDayUt(int year, int month, int day, double utHours) =>
      Sweph.swe_julday(year, month, day, utHours, CalendarType.SE_GREG_CAL);

  @override
  EclipticPosition position(double jdUt, Graha graha, CalcSettings s) {
    final flags = _flags(s);
    if (graha.isNode) {
      final node = s.nodeType == NodeType.trueNode
          ? HeavenlyBody.SE_TRUE_NODE
          : HeavenlyBody.SE_MEAN_NODE;
      final r = Sweph.swe_calc_ut(jdUt, node, flags);
      final lon = graha == Graha.rahu ? r.longitude : norm360(r.longitude + 180);
      final lat = graha == Graha.rahu ? r.latitude : -r.latitude;
      return EclipticPosition(lon, lat, r.speedInLongitude);
    }
    final r = Sweph.swe_calc_ut(jdUt, _bodies[graha]!, flags);
    return EclipticPosition(r.longitude, r.latitude, r.speedInLongitude);
  }

  @override
  double ayanamsa(double jdUt, CalcSettings s) {
    if (s.ayanamsa.swephMode == null) return 0;
    final flags = _flags(s);
    return Sweph.swe_get_ayanamsa_ex_ut(jdUt, flags);
  }

  static const _hsys = {
    HouseSystem.placidus: Hsys.P,
    HouseSystem.sripati: Hsys.S,
    HouseSystem.porphyry: Hsys.O,
    HouseSystem.wholeSign: Hsys.W,
    HouseSystem.equal: Hsys.E,
  };

  @override
  HousesResult houses(double jdUt, double latitude, double longitude,
      HouseSystem system, CalcSettings s) {
    final flags = _flags(s);
    final r =
        Sweph.swe_houses_ex(jdUt, flags, latitude, longitude, _hsys[system]!);
    return HousesResult(
      cusps: r.cusps.sublist(1, 13),
      ascendant: r.ascmc[0],
      mc: r.ascmc[1],
    );
  }

  @override
  double siderealTimeGreenwich(double jdUt) => Sweph.swe_sidtime(jdUt);

  // SE_ECL_NUT returns [true obliquity, mean obliquity, nutation lon, nutation obl].
  CoordinatesWithSpeed _eclNut(double jdUt) =>
      Sweph.swe_calc_ut(jdUt, const HeavenlyBody(-1), SwephFlag.SEFLG_SWIEPH);

  @override
  double trueObliquity(double jdUt) => _eclNut(jdUt).longitude;

  @override
  double meanObliquity(double jdUt) => _eclNut(jdUt).latitude;

  @override
  double? sunEvent(double jdUtStart, double latitude, double longitude,
      {required bool rise, SunriseMode mode = SunriseMode.upperLimb}) {
    var rsmi = rise
        ? RiseSetTransitFlag.SE_CALC_RISE
        : RiseSetTransitFlag.SE_CALC_SET;
    if (mode == SunriseMode.hindu) {
      rsmi = rsmi | RiseSetTransitFlag.SE_BIT_HINDU_RISING;
    }
    return Sweph.swe_rise_trans(
      jdUtStart,
      HeavenlyBody.SE_SUN,
      SwephFlag.SEFLG_SWIEPH,
      rsmi,
      GeoPosition(longitude, latitude),
      0,
      0,
    );
  }
}

class _FnAssetLoader with AssetLoader {
  _FnAssetLoader(this._fn);
  final Future<Uint8List> Function(String) _fn;
  @override
  Future<Uint8List> load(String assetPath) => _fn(assetPath);
}
