import '../ephemeris/ephemeris.dart';
import '../model/birth_data.dart';
import '../model/enums.dart';
import '../model/settings.dart';

/// One graha (or the lagna) placed in the sidereal zodiac.
class Placement {
  const Placement({
    required this.longitude,
    this.latitude = 0,
    this.speed = 0,
    this.alwaysRetrograde = false,
    required this.ascendantSign,
  });

  final double longitude;
  final double latitude;
  final double speed;

  /// Rahu/Ketu are conventionally marked retrograde regardless of the sign of
  /// the true node's momentary speed.
  final bool alwaysRetrograde;

  /// Lagna sign, used for whole-sign house numbers.
  final Rashi ascendantSign;

  bool get isRetrograde => alwaysRetrograde || speed < 0;
  Rashi get rashi => Rashi.ofLongitude(longitude);
  double get degreeInSign => norm360(longitude) % 30;
  Nakshatra get nakshatra => Nakshatra.ofLongitude(longitude);
  int get pada => Nakshatra.padaOf(longitude);
  Graha get nakshatraLord => nakshatra.lord;

  /// Whole-sign house from the lagna (1..12).
  int get house => (rashi.index - ascendantSign.index) % 12 + 1;
}

/// The bhava (Sripati) framework: madhya = Porphyry cusps, sandhi = midpoints.
class Bhavas {
  const Bhavas({required this.madhya, required this.sandhi});

  /// Bhava madhya (mid-point) longitudes, index 0 = bhava 1.
  final List<double> madhya;

  /// Bhava sandhi (start) longitudes, index 0 = start of bhava 1.
  final List<double> sandhi;

  /// Chalit bhava (1..12) of a longitude: the bhava whose sandhi range holds it.
  int bhavaOf(double lon) {
    for (var i = 0; i < 12; i++) {
      final start = sandhi[i], end = sandhi[(i + 1) % 12];
      final span = norm360(end - start);
      if (norm360(lon - start) < span) return i + 1;
    }
    return 12;
  }
}

/// Everything Phase 0 computes for a birth moment.
class RasiChart {
  RasiChart._({
    required this.birth,
    required this.settings,
    required this.jdUt,
    required this.ayanamsa,
    required this.lagna,
    required this.mc,
    required this.grahas,
    required this.bhavas,
    required this.kpCusps,
    required this.siderealTimeLocal,
    required this.obliquity,
    required this.meanObliquity,
  });

  final BirthData birth;
  final CalcSettings settings;
  final double jdUt;
  final double ayanamsa;
  final Placement lagna;
  final double mc;
  final Map<Graha, Placement> grahas;
  final Bhavas bhavas;

  /// Placidus cusps (sidereal), used by KP. Empty if Placidus failed
  /// (above the polar circles).
  final List<double> kpCusps;

  /// Local apparent sidereal time in hours.
  final double siderealTimeLocal;

  /// True obliquity (with nutation).
  final double obliquity;
  final double meanObliquity;

  static RasiChart calculate(
    Ephemeris eph,
    BirthData b, [
    CalcSettings s = const CalcSettings(),
  ]) {
    final jd = eph.julianDayUt(b.year, b.month, b.day, b.utHours);
    final whole =
        eph.houses(jd, b.latitude, b.longitude, HouseSystem.wholeSign, s);
    final ascSign = Rashi.ofLongitude(whole.ascendant);
    final lagna =
        Placement(longitude: whole.ascendant, ascendantSign: ascSign);

    final grahas = <Graha, Placement>{};
    for (final g in Graha.values) {
      final p = eph.position(jd, g, s);
      grahas[g] = Placement(
        longitude: p.longitude,
        latitude: p.latitude,
        speed: p.speed,
        alwaysRetrograde: g.isNode,
        ascendantSign: ascSign,
      );
    }

    final porphyry =
        eph.houses(jd, b.latitude, b.longitude, HouseSystem.porphyry, s);
    final madhya = porphyry.cusps;
    final sandhi = [
      for (var i = 0; i < 12; i++)
        norm360(madhya[(i + 11) % 12] +
            norm360(madhya[i] - madhya[(i + 11) % 12]) / 2),
    ];

    List<double> kp;
    try {
      kp = eph.houses(jd, b.latitude, b.longitude, HouseSystem.placidus, s).cusps;
    } catch (_) {
      kp = const [];
    }

    final lst = (eph.siderealTimeGreenwich(jd) + b.longitude / 15) % 24;

    return RasiChart._(
      birth: b,
      settings: s,
      jdUt: jd,
      ayanamsa: eph.ayanamsa(jd, s),
      lagna: lagna,
      mc: whole.mc,
      grahas: grahas,
      bhavas: Bhavas(madhya: madhya, sandhi: sandhi),
      kpCusps: kp,
      siderealTimeLocal: lst,
      obliquity: eph.trueObliquity(jd),
      meanObliquity: eph.meanObliquity(jd),
    );
  }
}
