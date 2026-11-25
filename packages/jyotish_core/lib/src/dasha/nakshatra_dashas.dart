import '../chart/rasi_chart.dart';
import '../model/enums.dart';
import '../rules/vimshottari.dart' show nakshatraRemaining;
import '../varga/varga.dart';
import 'dasha.dart';

/// The other nakshatra (udu) dashas of BPHS ch. 46: Ashtottari and the
/// conditional dashas. Each runs from the Moon's nakshatra like
/// Vimshottari; antardashas follow the same order from the mahadasha lord,
/// in proportion to the years.
///
/// None of the apps available for checking (AstroSage, Drik Panchang)
/// show these dashas; the rules follow BPHS and are pinned by hand-worked
/// tests (see DIVERGENCES.md).
enum NakshatraDashaKind {
  ashtottari('Ashtottari', 108),
  shodashottari('Shodashottari', 116),
  dwadashottari('Dwadashottari', 112),
  panchottari('Panchottari', 105),
  shatabdika('Shatabdika', 100),
  chaturashitiSama('Chaturashiti-sama', 84),
  dwisaptatiSama('Dwisaptati-sama', 72),
  shashtihayani('Shashtihayani', 60),
  shatTrimshaSama('Shat-trimsha-sama', 36);

  const NakshatraDashaKind(this.label, this.totalYears);
  final String label;
  final int totalYears;
}

class _Def {
  const _Def(this.lords, this.years, {this.countFrom, this.backwards = false, this.groups});
  final List<Graha> lords;
  final List<int> years;

  /// Count-based start: nakshatra index the count starts from.
  final int? countFrom;

  /// Count from the birth nakshatra to [countFrom] instead.
  final bool backwards;

  /// Group-based start: segments (of the 28 with Abhijit) per lord.
  final List<List<int>>? groups;
}

const _sun = Graha.sun, _moon = Graha.moon, _mars = Graha.mars,
    _merc = Graha.mercury, _jup = Graha.jupiter, _ven = Graha.venus,
    _sat = Graha.saturn, _rahu = Graha.rahu, _ketu = Graha.ketu;

const _defs = <NakshatraDashaKind, _Def>{
  // Groups start from Ardra; Saturn's includes Abhijit (segment 21).
  NakshatraDashaKind.ashtottari: _Def(
    [_sun, _moon, _mars, _merc, _sat, _jup, _rahu, _ven],
    [6, 15, 8, 17, 10, 19, 12, 21],
    groups: [
      [5, 6, 7, 8], [9, 10, 11], [12, 13, 14, 15], [16, 17, 18],
      [19, 20, 21, 22], [23, 24, 25], [26, 27, 0, 1], [2, 3, 4],
    ],
  ),
  NakshatraDashaKind.shodashottari: _Def(
    [_sun, _mars, _jup, _sat, _ketu, _moon, _merc, _ven],
    [11, 12, 13, 14, 15, 16, 17, 18],
    countFrom: 7, // Pushya
  ),
  NakshatraDashaKind.dwadashottari: _Def(
    [_sun, _jup, _ketu, _merc, _rahu, _mars, _sat, _moon],
    [7, 9, 11, 13, 15, 17, 19, 21],
    countFrom: 26, // from the birth nakshatra to Revati
    backwards: true,
  ),
  NakshatraDashaKind.panchottari: _Def(
    [_sun, _merc, _sat, _mars, _ven, _moon, _jup],
    [12, 13, 14, 15, 16, 17, 18],
    countFrom: 16, // Anuradha
  ),
  NakshatraDashaKind.shatabdika: _Def(
    [_sun, _moon, _ven, _merc, _jup, _mars, _sat],
    [5, 5, 10, 10, 20, 20, 30],
    countFrom: 26, // Revati
  ),
  NakshatraDashaKind.chaturashitiSama: _Def(
    [_sun, _moon, _mars, _merc, _jup, _ven, _sat],
    [12, 12, 12, 12, 12, 12, 12],
    countFrom: 14, // Swati
  ),
  NakshatraDashaKind.dwisaptatiSama: _Def(
    [_sun, _moon, _mars, _merc, _jup, _ven, _sat, _rahu],
    [9, 9, 9, 9, 9, 9, 9, 9],
    countFrom: 18, // Mula
  ),
  // Groups from Ashwini, alternately 3 and 4 nakshatras (with Abhijit).
  NakshatraDashaKind.shashtihayani: _Def(
    [_jup, _sun, _mars, _moon, _merc, _ven, _sat, _rahu],
    [10, 10, 10, 6, 6, 6, 6, 6],
    groups: [
      [0, 1, 2], [3, 4, 5, 6], [7, 8, 9], [10, 11, 12, 13],
      [14, 15, 16], [17, 18, 19, 20], [21, 22, 23], [24, 25, 26, 27],
    ],
  ),
  NakshatraDashaKind.shatTrimshaSama: _Def(
    [_moon, _sun, _jup, _mars, _merc, _sat, _ven, _rahu],
    [1, 2, 3, 4, 5, 6, 7, 8],
    countFrom: 21, // Shravana
  ),
};

/// Abhijit: the last quarter of Uttarashadha plus the first 1/15 of
/// Shravana (276°40′ – 280°53′20″).
const abhijitStart = 276 + 40 / 60;
const abhijitEnd = 280 + 53 / 60 + 20 / 3600;

/// Segment of the 28-nakshatra wheel (Abhijit = 21, Shravana = 22 …
/// Revati = 27) holding [lon], and the fraction of it already passed.
(int, double) segmentOf(double lon) {
  final l = norm360(lon);
  const span = 360 / 27;
  if (l >= 20 * span && l < abhijitStart) {
    return (20, (l - 20 * span) / (abhijitStart - 20 * span));
  }
  if (l >= abhijitStart && l < abhijitEnd) {
    return (21, (l - abhijitStart) / (abhijitEnd - abhijitStart));
  }
  if (l >= abhijitEnd && l < 22 * span) {
    return (22, (l - abhijitEnd) / (22 * span - abhijitEnd));
  }
  final n = (l / span).floor();
  final frac = (l - n * span) / span;
  return (n < 21 ? n : n + 1, frac);
}

class NakshatraDasha extends DashaSystem<Graha> {
  NakshatraDasha(
    this.kind, {
    required double moonLongitude,
    required this.birthJd,
    this.year = DashaYear.julian,
  }) {
    final def = _defs[kind]!;
    final n = def.lords.length;
    late int first;
    late double elapsedFraction;
    if (def.groups != null) {
      final (seg, f) = segmentOf(moonLongitude);
      final g = def.groups!.indexWhere((x) => x.contains(seg));
      final pos = def.groups![g].indexOf(seg);
      first = g;
      elapsedFraction = (pos + f) / def.groups![g].length;
    } else {
      final nak = Nakshatra.ofLongitude(moonLongitude).index;
      final count = def.backwards
          ? (def.countFrom! - nak) % 27 + 1
          : (nak - def.countFrom!) % 27 + 1;
      first = (count - 1) % n;
      elapsedFraction = 1 - nakshatraRemaining(moonLongitude);
    }
    var t = birthJd - elapsedFraction * def.years[first] * year.days;
    final until = birthJd + 120 * year.days;
    final list = <DashaPeriod<Graha>>[];
    var i = first;
    while (t < until) {
      final len = def.years[i % n] * year.days;
      list.add(DashaPeriod(lord: def.lords[i % n], start: t, end: t + len, level: 1));
      t += len;
      i++;
    }
    mahadashas = list;
  }

  final NakshatraDashaKind kind;
  final double birthJd;
  final DashaYear year;

  @override
  late final List<DashaPeriod<Graha>> mahadashas;

  /// Years of [g]'s mahadasha in this system.
  int yearsOf(Graha g) {
    final def = _defs[kind]!;
    return def.years[def.lords.indexOf(g)];
  }

  @override
  List<DashaPeriod<Graha>> subPeriods(DashaPeriod<Graha> p) {
    final def = _defs[kind]!;
    return proportionalSubPeriods(
      p,
      def.lords,
      p.lord,
      (g) => def.years[def.lords.indexOf(g)],
      kind.totalYears,
    );
  }
}

/// Whether BPHS makes [kind] applicable to [chart]: `true`/`false`, or
/// `null` where the texts disagree on the condition.
///
/// [dayBirth]: born between sunrise and sunset (for Shat-trimsha-sama).
bool? nakshatraDashaApplies(
  NakshatraDashaKind kind,
  RasiChart chart, {
  bool? dayBirth,
}) {
  final lagna = chart.lagna;
  Rashi signOf(Graha g) => chart.grahas[g]!.rashi;
  int house(Rashi from, Rashi s) => (s.index - from.index) % 12 + 1;
  final lagnaLord = lagna.rashi.lord;
  switch (kind) {
    case NakshatraDashaKind.ashtottari:
      // Rahu in a kendra or trikona from the lagna lord, but not in lagna.
      final rahu = signOf(Graha.rahu);
      final h = house(signOf(lagnaLord), rahu);
      return rahu != lagna.rashi && const {1, 4, 5, 7, 9, 10}.contains(h);
    case NakshatraDashaKind.shodashottari:
      return null;
    case NakshatraDashaKind.dwadashottari:
      // Lagna in a navamsha of Venus.
      final d9 = vargaSign(lagna.longitude, Varga.d9);
      return d9 == Rashi.taurus || d9 == Rashi.libra;
    case NakshatraDashaKind.panchottari:
      // Cancer lagna in Cancer dwadashamsha.
      return lagna.rashi == Rashi.cancer &&
          vargaSign(lagna.longitude, Varga.d12) == Rashi.cancer;
    case NakshatraDashaKind.shatabdika:
      // Vargottama lagna.
      return vargaSign(lagna.longitude, Varga.d9) == lagna.rashi;
    case NakshatraDashaKind.chaturashitiSama:
      // Lord of the 10th in the 10th.
      final tenth = Rashi.values[(lagna.rashi.index + 9) % 12];
      return signOf(tenth.lord) == tenth;
    case NakshatraDashaKind.dwisaptatiSama:
      // Lagna lord in the 7th, or the 7th lord in lagna.
      final seventh = Rashi.values[(lagna.rashi.index + 6) % 12];
      return signOf(lagnaLord) == seventh || signOf(seventh.lord) == lagna.rashi;
    case NakshatraDashaKind.shashtihayani:
      // Sun in lagna.
      return signOf(Graha.sun) == lagna.rashi;
    case NakshatraDashaKind.shatTrimshaSama:
      // Day birth with lagna in the Sun's hora, or night birth in the Moon's.
      if (dayBirth == null) return null;
      final hora = vargaSign(lagna.longitude, Varga.d2);
      return dayBirth ? hora == Rashi.leo : hora == Rashi.cancer;
  }
}
