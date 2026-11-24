import '../chart/rasi_chart.dart';
import '../ephemeris/ephemeris.dart';
import '../model/birth_data.dart';
import '../model/enums.dart';
import '../model/settings.dart';
import '../rules/vimshottari.dart';

/// Grahas used in KP (no outer planets).
const kpGrahas = [
  Graha.sun, Graha.moon, Graha.mars, Graha.mercury, Graha.jupiter,
  Graha.venus, Graha.saturn, Graha.rahu, Graha.ketu,
];

/// Sign, star, sub and sub-sub lords of a longitude.
class KpLords {
  KpLords(this.longitude)
      : sign = Rashi.ofLongitude(longitude).lord,
        _l = kpLords(longitude);
  final double longitude;
  final Graha sign;
  final List<Graha> _l;
  Graha get star => _l[0];
  Graha get sub => _l[1];
  Graha get subSub => _l[2];
}

/// The four levels of a planet's signification (KP Reader / AstroSage
/// "view 2"): houses occupied by its star lord, houses it occupies, houses
/// owned by its star lord, houses it owns.
class KpSignification {
  const KpSignification(this.levels);
  final List<List<int>> levels;
  List<int> get starLordOccupies => levels[0];
  List<int> get occupies => levels[1];
  List<int> get starLordOwns => levels[2];
  List<int> get owns => levels[3];

  /// All houses signified, sorted.
  List<int> get all => {for (final l in levels) ...l}.toList()..sort();
}

class RulingPlanets {
  const RulingPlanets({
    required this.dayLord,
    required this.ascSignLord,
    required this.ascStarLord,
    required this.ascSubLord,
    required this.moonSignLord,
    required this.moonStarLord,
    required this.moonSubLord,
  });
  final Graha dayLord, ascSignLord, ascStarLord, ascSubLord;
  final Graha moonSignLord, moonStarLord, moonSubLord;

  List<(String, Graha)> get rows => [
        ('dayLord', dayLord),
        ('ascSignLord', ascSignLord),
        ('ascStarLord', ascStarLord),
        ('ascSubLord', ascSubLord),
        ('moonSignLord', moonSignLord),
        ('moonStarLord', moonStarLord),
        ('moonSubLord', moonSubLord),
      ];
}

/// A KP chart: Placidus cusps and planets in the KP ayanamsa.
class KpChart {
  KpChart._({
    required this.chart,
    required this.cusps,
    required this.planets,
  });

  final RasiChart chart;

  /// Placidus cusp longitudes, index 0 = cusp 1.
  final List<double> cusps;
  final Map<Graha, double> planets;

  static KpChart calculate(
    Ephemeris eph,
    BirthData b, {
    Ayanamsa ayanamsa = Ayanamsa.kpOld,
  }) {
    final c = RasiChart.calculate(
      eph,
      b,
      CalcSettings(ayanamsa: ayanamsa, nodeType: NodeType.meanNode),
    );
    return KpChart._(
      chart: c,
      cusps: c.kpCusps,
      planets: {for (final g in kpGrahas) g: c.grahas[g]!.longitude},
    );
  }

  /// KP horary chart: planets at the moment of judgement, cusps for the
  /// moment that day when the ascendant reaches the start of the given
  /// sub (1–249).
  static KpChart horary(
    Ephemeris eph,
    BirthData question,
    int number, {
    Ayanamsa ayanamsa = Ayanamsa.kpOld,
  }) {
    final c = RasiChart.calculate(
      eph,
      question,
      CalcSettings(ayanamsa: ayanamsa, nodeType: NodeType.meanNode),
    );
    final target = horaryAscendant(number) + 1e-6;
    final s = CalcSettings(ayanamsa: ayanamsa);
    double asc(double jd) => eph
        .houses(jd, question.latitude, question.longitude, HouseSystem.placidus, s)
        .ascendant;
    // The ascendant goes round once a sidereal day: step through the day
    // in 4-minute steps to find where it crosses the target, then bisect.
    var lo = c.jdUt - 0.5, found = c.jdUt;
    for (var t = lo; t < lo + 1.0; t += 4 / 1440) {
      final a = norm360(asc(t) - target), b2 = norm360(asc(t + 4 / 1440) - target);
      if (a > 300 && b2 < 60) {
        var x = t, y = t + 4 / 1440;
        for (var i = 0; i < 40; i++) {
          final m = (x + y) / 2;
          if (norm360(asc(m) - target) > 180) {
            x = m;
          } else {
            y = m;
          }
        }
        found = y;
        if ((found - c.jdUt).abs() < 0.5) break;
      }
    }
    final cusps = eph
        .houses(found, question.latitude, question.longitude, HouseSystem.placidus, s)
        .cusps;
    return KpChart._(
      chart: c,
      cusps: cusps,
      planets: {for (final g in kpGrahas) g: c.grahas[g]!.longitude},
    );
  }

  /// Start longitude of KP horary number [n] (1–249): the 249 subs of the
  /// zodiac, with subs that straddle a sign boundary split in two.
  static double horaryAscendant(int n) {
    if (n < 1 || n > 249) throw RangeError.range(n, 1, 249);
    return _horaryStarts[n - 1];
  }

  static final List<double> _horaryStarts = () {
    final starts = <double>[];
    for (var nak = 0; nak < 27; nak++) {
      final base = nak * Nakshatra.span;
      final lord = Nakshatra.values[nak].lord;
      var i = vimshottariOrder.indexOf(lord);
      var pos = base;
      for (var k = 0; k < 9; k++) {
        final g = vimshottariOrder[(i + k) % 9];
        final len = Nakshatra.span * vimshottariYears[g]! / vimshottariTotal;
        starts.add(pos);
        // A sign boundary inside this sub starts a new horary number.
        final nextSign = ((pos ~/ 30) + 1) * 30.0;
        if (nextSign > pos + 1e-9 && nextSign < pos + len - 1e-9) {
          starts.add(nextSign);
        }
        pos += len;
      }
    }
    return starts;
  }();

  KpLords lordsOf(Graha g) => KpLords(planets[g]!);
  KpLords cuspLords(int house) => KpLords(cusps[house - 1]);

  /// House (1–12) containing [lon], by Placidus cusps.
  int houseOf(double lon) {
    for (var i = 0; i < 12; i++) {
      final start = cusps[i], end = cusps[(i + 1) % 12];
      if (norm360(lon - start) < norm360(end - start)) return i + 1;
    }
    return 12;
  }

  /// Houses whose cusp falls in a sign ruled by [g]. Nodes own nothing.
  List<int> owns(Graha g) => [
        for (var h = 1; h <= 12; h++)
          if (Rashi.ofLongitude(cusps[h - 1]).lord == g) h,
      ];

  KpSignification signification(Graha g) {
    final star = lordsOf(g).star;
    return KpSignification([
      [houseOf(planets[star]!)],
      [houseOf(planets[g]!)],
      owns(star),
      owns(g),
    ]);
  }

  /// True when no planet sits in [g]'s nakshatras, or [g] is in its own
  /// nakshatra (AstroSage's "+").
  bool isSelfSignifying(Graha g) {
    final inStar = kpGrahas.where((p) => p != g && lordsOf(p).star == g);
    return inStar.isEmpty || lordsOf(g).star == g;
  }

  /// Planets signifying house [h] at any level, in natural order.
  List<Graha> houseSignificators(int h) =>
      [for (final g in kpGrahas) if (signification(g).all.contains(h)) g];

  RulingPlanets rulingPlanets(Graha dayLord) {
    final asc = cuspLords(1), moon = lordsOf(Graha.moon);
    return RulingPlanets(
      dayLord: dayLord,
      ascSignLord: asc.sign,
      ascStarLord: asc.star,
      ascSubLord: asc.sub,
      moonSignLord: moon.sign,
      moonStarLord: moon.star,
      moonSubLord: moon.sub,
    );
  }
}
