import '../chart/rasi_chart.dart';
import '../model/enums.dart';
import '../rules/dignity.dart';
import '../rules/vimshottari.dart';

/// How long a dasha "year" is. Software differs; the choice shifts dates by
/// days over a lifetime.
enum DashaYear {
  julian(365.25, '365.25 days'),
  tropical(365.2422, '365.2422 days (tropical)'),
  sidereal(365.25636, '365.2564 days (sidereal)'),
  savana(360, '360 days (savana)');

  const DashaYear(this.days, this.label);
  final double days;
  final String label;
}

/// One period at some level (1 = maha, 2 = antar, 3 = pratyantar,
/// 4 = sookshma, 5 = prana). Times are Julian days (UT).
class DashaPeriod<T> {
  const DashaPeriod({
    required this.lord,
    required this.start,
    required this.end,
    required this.level,
    this.parents = const [],
  });

  final T lord;
  final double start;
  final double end;
  final int level;

  /// Lords of the enclosing periods, outermost first.
  final List<T> parents;

  double get days => end - start;
  bool contains(double jd) => jd >= start && jd < end;

  @override
  String toString() => '${[...parents, lord].join('/')} $start–$end';
}

abstract class DashaSystem<T> {
  /// Top-level periods from the one running at birth to at least 120 years.
  List<DashaPeriod<T>> get mahadashas;

  /// The next level inside [p].
  List<DashaPeriod<T>> subPeriods(DashaPeriod<T> p);

  /// Periods running at [jd], outermost first, down to [depth] levels.
  List<DashaPeriod<T>> pathAt(double jd, {int depth = 5}) {
    final path = <DashaPeriod<T>>[];
    var level = mahadashas;
    for (var d = 0; d < depth; d++) {
      final hit = level.where((p) => p.contains(jd));
      if (hit.isEmpty) break;
      path.add(hit.first);
      if (d + 1 < depth) level = subPeriods(hit.first);
    }
    return path;
  }
}

/// Splits [p] proportionally: [order] gives the lords in sequence starting
/// with [first], [weight] their shares out of [total].
List<DashaPeriod<T>> _proportional<T>(
  DashaPeriod<T> p,
  List<T> order,
  T first,
  num Function(T) weight,
  num total,
) {
  final out = <DashaPeriod<T>>[];
  var t = p.start;
  final i0 = order.indexOf(first);
  for (var k = 0; k < order.length; k++) {
    final lord = order[(i0 + k) % order.length];
    final len = p.days * weight(lord) / total;
    out.add(DashaPeriod(
      lord: lord,
      start: t,
      end: t + len,
      level: p.level + 1,
      parents: [...p.parents, p.lord],
    ));
    t += len;
  }
  return out;
}

// ---------------------------------------------------------------------------
// Vimshottari (BPHS ch. 46)

class VimshottariDasha extends DashaSystem<Graha> {
  VimshottariDasha({
    required double moonLongitude,
    required this.birthJd,
    this.year = DashaYear.julian,
  }) {
    final nak = Nakshatra.ofLongitude(moonLongitude);
    final first = nak.lord;
    final firstYears = vimshottariYears[first]!;
    final elapsed = (1 - nakshatraRemaining(moonLongitude)) * firstYears;
    var t = birthJd - elapsed * year.days;
    final until = birthJd + 120 * year.days;
    var i = vimshottariOrder.indexOf(first);
    final list = <DashaPeriod<Graha>>[];
    while (t < until) {
      final lord = vimshottariOrder[i % 9];
      final len = vimshottariYears[lord]! * year.days;
      list.add(DashaPeriod(lord: lord, start: t, end: t + len, level: 1));
      t += len;
      i++;
    }
    mahadashas = list;
  }

  final double birthJd;
  final DashaYear year;

  @override
  late final List<DashaPeriod<Graha>> mahadashas;

  @override
  List<DashaPeriod<Graha>> subPeriods(DashaPeriod<Graha> p) => _proportional(
        p,
        vimshottariOrder,
        p.lord,
        (g) => vimshottariYears[g]!,
        vimshottariTotal,
      );
}

// ---------------------------------------------------------------------------
// Yogini (BPHS ch. 46; 36-year cycle)

enum Yogini {
  mangala('Mangala', Graha.moon, 1),
  pingala('Pingala', Graha.sun, 2),
  dhanya('Dhanya', Graha.jupiter, 3),
  bhramari('Bhramari', Graha.mars, 4),
  bhadrika('Bhadrika', Graha.mercury, 5),
  ulka('Ulka', Graha.saturn, 6),
  siddha('Siddha', Graha.venus, 7),
  sankata('Sankata', Graha.rahu, 8);

  const Yogini(this.label, this.graha, this.years);
  final String label;
  final Graha graha;
  final int years;
}

class YoginiDasha extends DashaSystem<Yogini> {
  YoginiDasha({
    required double moonLongitude,
    required this.birthJd,
    this.year = DashaYear.julian,
  }) {
    final nakNumber = Nakshatra.ofLongitude(moonLongitude).index + 1;
    // Nakshatra number + 3, counted in eights (0 → 8th yogini).
    final first = Yogini.values[(nakNumber + 3 - 1) % 8];
    final elapsed = (1 - nakshatraRemaining(moonLongitude)) * first.years;
    var t = birthJd - elapsed * year.days;
    final until = birthJd + 120 * year.days;
    var i = first.index;
    final list = <DashaPeriod<Yogini>>[];
    while (t < until) {
      final y = Yogini.values[i % 8];
      final len = y.years * year.days;
      list.add(DashaPeriod(lord: y, start: t, end: t + len, level: 1));
      t += len;
      i++;
    }
    mahadashas = list;
  }

  final double birthJd;
  final DashaYear year;

  @override
  late final List<DashaPeriod<Yogini>> mahadashas;

  @override
  List<DashaPeriod<Yogini>> subPeriods(DashaPeriod<Yogini> p) =>
      _proportional(p, Yogini.values, p.lord, (y) => y.years, 36);
}

// ---------------------------------------------------------------------------
// Chara dasha (Jaimini, as taught by K.N. Rao)

/// Signs counted forwards ("savya", odd-footed): Aries, Taurus, Gemini,
/// Libra, Scorpio, Sagittarius. The rest are counted backwards.
bool isSavyaSign(Rashi r) => const {0, 1, 2, 6, 7, 8}.contains(r.index);

class CharaDasha extends DashaSystem<Rashi> {
  CharaDasha({
    required RasiChart chart,
    required this.birthJd,
    this.year = DashaYear.julian,
    this.exaltationAdjustment = true,
  }) : _chart = chart {
    final lagna = chart.lagna.rashi;
    // Sequence runs forwards when the 9th sign from the lagna is savya.
    forward = isSavyaSign(Rashi.values[(lagna.index + 8) % 12]);
    final first = [
      for (var k = 0; k < 12; k++)
        Rashi.values[(lagna.index + (forward ? k : -k)) % 12],
    ];
    final list = <DashaPeriod<Rashi>>[];
    var t = birthJd;
    final until = birthJd + 120 * year.days;
    var cycle = 0;
    while (t < until && cycle < 3) {
      for (final s in first) {
        final y1 = yearsOf(s);
        // Second cycle: 12 minus the first cycle's years.
        final y = cycle == 0 ? y1 : (cycle == 1 ? 12 - y1 : y1);
        if (y <= 0) continue;
        list.add(DashaPeriod(
          lord: s,
          start: t,
          end: t + y * year.days,
          level: 1,
        ));
        t += y * year.days;
        if (t >= until) break;
      }
      cycle++;
    }
    mahadashas = list;
  }

  final RasiChart _chart;
  final double birthJd;
  final DashaYear year;
  final bool exaltationAdjustment;
  late final bool forward;

  @override
  late final List<DashaPeriod<Rashi>> mahadashas;

  /// Lord used for [s]: Scorpio and Aquarius have two lords; the stronger
  /// is taken.
  Graha lordOf(Rashi s) => switch (s) {
        Rashi.scorpio => _stronger(Graha.mars, Graha.ketu, s),
        Rashi.aquarius => _stronger(Graha.saturn, Graha.rahu, s),
        _ => s.lord,
      };

  Graha _stronger(Graha a, Graha b, Rashi s) {
    final pa = _chart.grahas[a]!, pb = _chart.grahas[b]!;
    // 1. If one lord sits in the sign and the other doesn't, use the other.
    final aIn = pa.rashi == s, bIn = pb.rashi == s;
    if (aIn != bIn) return aIn ? b : a;
    // 2. More planets with it.
    int company(Graha g) => _chart.grahas.entries
        .where((e) =>
            e.key != g &&
            !e.key.isOuter &&
            e.value.rashi == _chart.grahas[g]!.rashi)
        .length;
    final ca = company(a), cb = company(b);
    if (ca != cb) return ca > cb ? a : b;
    // 3. Exalted lord.
    bool exalted(Graha g) =>
        exaltation[g]?.$1 == _chart.grahas[g]!.rashi;
    if (exalted(a) != exalted(b)) return exalted(a) ? a : b;
    // 4. More degrees in its sign (Rahu/Ketu counted backwards).
    double deg(Graha g) {
      final d = _chart.grahas[g]!.degreeInSign;
      return g.isNode ? 30 - d : d;
    }
    return deg(a) >= deg(b) ? a : b;
  }

  /// Years of [s]'s dasha in the first cycle.
  int yearsOf(Rashi s) {
    final lord = lordOf(s);
    final at = _chart.grahas[lord]!.rashi;
    final n = isSavyaSign(s)
        ? (at.index - s.index) % 12
        : (s.index - at.index) % 12;
    var years = n == 0 ? 12 : n;
    if (exaltationAdjustment && exaltation.containsKey(lord)) {
      if (exaltation[lord]!.$1 == at) years += 1;
      if (debilitationSign(lord) == at) years -= 1;
    }
    return years.clamp(1, 12);
  }

  /// Antardashas: twelve equal parts, starting from the sign after the
  /// mahadasha sign in the dasha's direction and ending with the sign
  /// itself.
  @override
  List<DashaPeriod<Rashi>> subPeriods(DashaPeriod<Rashi> p) {
    final len = p.days / 12;
    return [
      for (var k = 1; k <= 12; k++)
        DashaPeriod(
          lord: Rashi.values[(p.lord.index + (forward ? k : -k)) % 12],
          start: p.start + (k - 1) * len,
          end: p.start + k * len,
          level: p.level + 1,
          parents: [...p.parents, p.lord],
        ),
    ];
  }
}
