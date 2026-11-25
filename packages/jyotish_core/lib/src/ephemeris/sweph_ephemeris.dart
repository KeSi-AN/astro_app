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
  double heliocentricLongitude(double jdUt, Graha graha) => Sweph.swe_calc_ut(
        jdUt,
        _bodies[graha]!,
        SwephFlag.SEFLG_SWIEPH | SwephFlag.SEFLG_HELCTR,
      ).longitude;

  @override
  double declination(double jdUt, Graha graha) {
    final body = graha.isNode ? HeavenlyBody.SE_MEAN_NODE : _bodies[graha]!;
    final eq = Sweph.swe_calc_ut(
      jdUt,
      body,
      SwephFlag.SEFLG_SWIEPH | SwephFlag.SEFLG_EQUATORIAL,
    );
    return graha == Graha.ketu ? -eq.latitude : eq.latitude;
  }

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

  @override
  EclipseEvent nextEclipse(
    EclipseKind kind,
    double jdUtStart,
    double latitude,
    double longitude,
  ) {
    final geo = GeoPosition(longitude, latitude);
    const flags = SwephFlag.SEFLG_SWIEPH;
    if (kind == EclipseKind.lunar) {
      final g = Sweph.swe_lun_eclipse_when(
        jdUtStart, flags, EclipseFlag.SE_ECL_ALLTYPES_LUNAR, false);
      final gt = g.times!;
      // Local search from just before it: the same eclipse if visible.
      final l = Sweph.swe_lun_eclipse_when_loc(gt[0] - 0.3, flags, geo, false);
      final lt = l.times!;
      final visible = (lt[0] - gt[0]).abs() < 0.1;
      if (!visible) {
        return EclipseEvent(
          kind: kind,
          type: _type(g.eclipseType!),
          maximum: gt[0],
          visible: false,
          begin: _t(gt, 2), end: _t(gt, 3),
          totalBegin: _t(gt, 4), totalEnd: _t(gt, 5),
          penumbralBegin: _t(gt, 6), penumbralEnd: _t(gt, 7),
        );
      }
      return EclipseEvent(
        kind: kind,
        // Named by its global type (a total eclipse may be seen only in part).
        type: _type(g.eclipseType!),
        maximum: gt[0],
        visible: true,
        // Lunar contacts happen at the same instant everywhere; the place
        // only limits what it sees (moonrise/moonset during the eclipse).
        begin: _t(gt, 2), end: _t(gt, 3),
        totalBegin: _t(gt, 4), totalEnd: _t(gt, 5),
        penumbralBegin: _t(gt, 6), penumbralEnd: _t(gt, 7),
        bodyRise: _t(lt, 8), bodySet: _t(lt, 9),
        magnitude: l.attributes![0],
      );
    }
    final g = Sweph.swe_sol_eclipse_when_glob(
      jdUtStart, flags, EclipseFlag.SE_ECL_ALLTYPES_SOLAR, false);
    final gt = g.times!;
    final l = Sweph.swe_sol_eclipse_when_loc(gt[0] - 0.3, flags, geo, false);
    final lt = l.times!;
    final visible = (lt[0] - gt[0]).abs() < 0.3;
    if (!visible) {
      return EclipseEvent(
        kind: kind,
        type: _type(g.eclipseType!),
        maximum: gt[0],
        visible: false,
        begin: _t(gt, 2), end: _t(gt, 3),
        totalBegin: _t(gt, 4), totalEnd: _t(gt, 5),
      );
    }
    final f = l.eclipseType ?? g.eclipseType!;
    return EclipseEvent(
      kind: kind,
      // What the place sees: partial unless it is in the central path.
      type: f.has(EclipseFlag.SE_ECL_TOTAL) || f.has(EclipseFlag.SE_ECL_ANNULAR)
          ? _type(f)
          : EclipseType.partial,
      maximum: lt[0],
      visible: true,
      begin: _t(lt, 1), end: _t(lt, 4),
      totalBegin: _t(lt, 2), totalEnd: _t(lt, 3),
      bodyRise: _t(lt, 5), bodySet: _t(lt, 6),
      magnitude: l.attributes![0],
    );
  }

  @override
  double? moonEvent(double jdUtStart, double latitude, double longitude,
          {required bool rise}) =>
      Sweph.swe_rise_trans(
        jdUtStart,
        HeavenlyBody.SE_MOON,
        SwephFlag.SEFLG_SWIEPH,
        rise ? RiseSetTransitFlag.SE_CALC_RISE : RiseSetTransitFlag.SE_CALC_SET,
        GeoPosition(longitude, latitude),
        0,
        0,
      );
}

extension on EclipseFlag {
  bool has(EclipseFlag f) => value & f.value != 0;
}

EclipseType _type(EclipseFlag f) {
  if (f.has(EclipseFlag.SE_ECL_ANNULAR_TOTAL)) return EclipseType.hybrid;
  if (f.has(EclipseFlag.SE_ECL_TOTAL)) return EclipseType.total;
  if (f.has(EclipseFlag.SE_ECL_ANNULAR)) return EclipseType.annular;
  if (f.has(EclipseFlag.SE_ECL_PARTIAL)) return EclipseType.partial;
  return EclipseType.penumbral;
}

double? _t(List<double> l, int i) => i < l.length && l[i] > 0 ? l[i] : null;

class _FnAssetLoader with AssetLoader {
  _FnAssetLoader(this._fn);
  final Future<Uint8List> Function(String) _fn;
  @override
  Future<Uint8List> load(String assetPath) => _fn(assetPath);
}
