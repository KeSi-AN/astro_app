import 'dart:math';

import '../dasha/nakshatra_dashas.dart' show abhijitStart, abhijitEnd;
import '../ephemeris/ephemeris.dart';
import '../model/enums.dart';
import 'day_panchang.dart';
import 'muhurta.dart';

/// More of a day's panchang, as Drik Panchang shows it: special muhurtas,
/// auspicious and inauspicious yogas, nivas & shool, calendars and epochs.
/// Rules and the dates they were checked on: REA/drikpanchang/DRIK_TEARDOWN.md.

// ---------------------------------------------------------------------------
// Special times

enum SpecialTime {
  // Auspicious
  brahmaMuhurta(true),
  pratahSandhya(true),
  vijayaMuhurta(true),
  godhuli(true),
  sayahnaSandhya(true),
  nishita(true),
  amritKalam(true),
  sarvarthaSiddhi(true),
  amritaSiddhi(true),
  raviYoga(true),
  raviPushya(true),
  guruPushya(true),
  dwipushkar(true),
  tripushkar(true),
  // Inauspicious
  durMuhurtam(false),
  varjyam(false),
  gandaMoola(false),
  aadal(false),
  vidaal(false);

  const SpecialTime(this.good);
  final bool good;
}

/// Starting ghati (of the nakshatra's 60) of Varjyam and Amrit Kalam; each
/// lasts 4 ghatis of the nakshatra's own length.
const varjyamGhati = [
  50, 24, 30, 40, 14, 21, 30, 20, 32, 30, 20, 18, 21, 20,
  14, 14, 10, 14, 20, 24, 20, 10, 10, 18, 16, 24, 30,
];
const amritKalamGhati = [
  42, 48, 54, 52, 38, 35, 54, 44, 56, 54, 44, 42, 45, 44,
  38, 38, 34, 38, 44, 48, 44, 34, 34, 42, 40, 48, 54,
];

/// Day muhurtas (1–15) of Dur Muhurtam by weekday, Sunday first; Tuesday
/// also has the 7th muhurta of the night.
const _durMuhurta = [
  [14], [9, 12], [4], [8], [6, 12], [4, 9], [1, 2],
];

/// Nakshatra indexes (0 = Ashwini) by weekday, Sunday first.
const sarvarthaSiddhiNakshatras = [
  {0, 7, 11, 12, 18, 20, 25},
  {3, 4, 7, 16, 21},
  {0, 2, 8, 25},
  {2, 3, 4, 12, 16},
  {0, 6, 7, 16, 26},
  {0, 6, 16, 21, 26},
  {3, 14, 21},
];
const amritaSiddhiNakshatra = [12, 4, 0, 16, 7, 26, 3];
const gandaMoolaNakshatras = {0, 8, 9, 17, 18, 26};

/// Counts from the Sun's nakshatra to the Moon's that make Ravi Yoga.
const raviYogaCounts = {4, 6, 9, 10, 13, 20};

/// Sunday = 0 … Saturday = 6.
int sundayIndex(DayPanchang d) => d.weekday % 7;

/// 1-based count from nakshatra [from] to [to] (0-based indexes).
int nakshatraCount(int from, int to) => (to - from) % 27 + 1;

double _overlapStart(double a, double b) => max(a, b);
double _overlapEnd(double a, double b) => min(a, b);

/// Special times overlapping the day (sunrise to next sunrise).
List<TimeSpan<SpecialTime>> specialTimes(PanchangCalc calc, DayPanchang d) {
  final out = <TimeSpan<SpecialTime>>[];
  final w = sundayIndex(d);
  final dayM = d.dayLength / 15, nightM = d.nightLength / 15;
  // Previous night, for Brahma muhurta before this sunrise.
  void add(SpecialTime k, double s, double e) {
    if (e > s) out.add(TimeSpan(k, s, e));
  }

  // Muhurta-based times.
  final prevNightM = (d.sunrise - _previousSunset(calc, d)) / 15;
  add(SpecialTime.brahmaMuhurta, d.sunrise - 2 * prevNightM, d.sunrise - prevNightM);
  add(SpecialTime.pratahSandhya, d.sunrise - 1.5 * prevNightM, d.sunrise);
  add(SpecialTime.vijayaMuhurta, d.sunrise + 10 * dayM, d.sunrise + 11 * dayM);
  final (gs, ge) = godhuli(calc, d);
  add(SpecialTime.godhuli, gs, ge);
  add(SpecialTime.sayahnaSandhya, d.sunset, d.sunset + 1.5 * nightM);
  add(SpecialTime.nishita, d.sunset + 7 * nightM, d.sunset + 8 * nightM);
  for (final n in _durMuhurta[w]) {
    add(SpecialTime.durMuhurtam, d.sunrise + (n - 1) * dayM, d.sunrise + n * dayM);
  }
  if (w == 2) {
    add(SpecialTime.durMuhurtam, d.sunset + 6 * nightM, d.sunset + 7 * nightM);
  }

  // Nakshatra windows (Varjyam, Amrit Kalam) that start within the day.
  // Mula has a second Varjyam at ghati 56.
  final naks = calc.spansBetween(PanchangElement.nakshatra, d.sunrise - 1.2, d.nextSunrise);
  for (final n in naks) {
    final len = n.end - n.start;
    for (final (k, g) in [
      (SpecialTime.varjyam, varjyamGhati[n.index - 1]),
      if (n.index == 19) (SpecialTime.varjyam, 56),
      (SpecialTime.amritKalam, amritKalamGhati[n.index - 1]),
    ]) {
      final s = n.start + len * g / 60;
      if (s >= d.sunrise && s < d.nextSunrise) add(k, s, s + len * 4 / 60);
    }
  }

  // Weekday/nakshatra yogas, clipped to the day.
  for (final n in d.nakshatras) {
    final s = _overlapStart(n.start, d.sunrise);
    final e = _overlapEnd(n.end, d.nextSunrise);
    final i = n.index - 1;
    if (sarvarthaSiddhiNakshatras[w].contains(i)) add(SpecialTime.sarvarthaSiddhi, s, e);
    if (amritaSiddhiNakshatra[w] == i) add(SpecialTime.amritaSiddhi, s, e);
    if (i == 7 && w == 0) add(SpecialTime.raviPushya, s, e);
    if (i == 7 && w == 4) add(SpecialTime.guruPushya, s, e);
    if (gandaMoolaNakshatras.contains(i)) add(SpecialTime.gandaMoola, s, e);
    // Dwipushkar / Tripushkar: Sun, Tue or Sat + Bhadra tithi + nakshatra.
    if (w == 0 || w == 2 || w == 6) {
      final dwi = const {4, 13, 22}.contains(i);
      final tri = const {2, 6, 11, 15, 20, 24}.contains(i);
      if (dwi || tri) {
        for (final t in d.tithis) {
          if (!const {2, 7, 12}.contains((t.index - 1) % 15 + 1)) continue;
          final ss = max(s, t.start), ee = min(e, t.end);
          add(dwi ? SpecialTime.dwipushkar : SpecialTime.tripushkar, ss, ee);
        }
      }
    }
  }
  // Ravi Yoga: count (27 nakshatras) from the Sun's nakshatra, which may
  // change during the day.
  const nakSpan = 360 / 27;
  for (final (s, e, _, _, moonNak) in sunMoonSpans(calc, d.sunrise, d.nextSunrise)) {
    final sunNow = (norm360(calc.sun((s + e) / 2)) / nakSpan).floor();
    if (raviYogaCounts.contains(nakshatraCount(sunNow, moonNak))) {
      add(SpecialTime.raviYoga, s, e);
    }
  }

  // Aadal and Vidaal: count (28 nakshatras, with Abhijit) from the Sun's
  // nakshatra to the Moon's; ≡ 0 or 2 (mod 7) Aadal, ≡ 3 or 6 Vidaal.
  SpecialTime? prevKind;
  for (final (s, e, sunSeg, moonSeg, _) in sunMoonSpans(calc, d.sunrise, d.nextSunrise)) {
    final c = (moonSeg - sunSeg) % 28 + 1;
    final r = c % 7;
    final k = r == 0 || r == 2
        ? SpecialTime.aadal
        : (r == 3 || r == 6 ? SpecialTime.vidaal : null);
    // Join with the previous piece when the same yoga simply continues.
    if (k != null && k == prevKind && out.last.value == k && (out.last.end - s).abs() < 1e-6) {
      out[out.length - 1] = TimeSpan(k, out.last.start, e);
    } else if (k != null) {
      add(k, s, e);
    }
    prevKind = k;
  }
  out.sort((a, b) => a.start.compareTo(b.start));
  // Join back-to-back spans of the same yoga (e.g. Ganda Moola over two
  // nakshatras is shown as one span, as Drik does).
  final merged = <TimeSpan<SpecialTime>>[];
  for (final x in out) {
    final i = merged.lastIndexWhere((m) => m.value == x.value);
    if (i >= 0 && (merged[i].end - x.start).abs() < 1e-6 && x.value != SpecialTime.durMuhurtam) {
      merged[i] = TimeSpan(x.value, merged[i].start, x.end);
    } else {
      merged.add(x);
    }
  }
  return merged;
}

/// Stretches of [from, to) with a fixed Sun nakshatra and Moon nakshatra:
/// (start, end, Sun's 28-wheel segment, Moon's 28-wheel segment, Moon's
/// 27-nakshatra index).
List<(double, double, int, int, int)> sunMoonSpans(PanchangCalc calc, double from, double to) {
  final moon = moonSegments(calc, from, to);
  // Sun's nakshatra changes at most once a day or so.
  const span = 360 / 27;
  final cuts = <double>{from, to};
  var t = from;
  while (t < to) {
    final lon = norm360(calc.sun(t));
    final next = _sunReach(calc, t + 1e-7, ((lon / span).floor() + 1) * span % 360);
    if (next < to) cuts.add(next);
    t = next + 1e-6;
  }
  for (final (_, s, e) in moon) {
    if (s > from && s < to) cuts.add(s);
    if (e > from && e < to) cuts.add(e);
  }
  // The 27-nakshatra boundary inside Abhijit (Uttarashadha/Shravana).
  for (final n in calc.spansBetween(PanchangElement.nakshatra, from, to)) {
    if (n.start > from && n.start < to) cuts.add(n.start);
  }
  final list = cuts.toList()..sort();
  final out = <(double, double, int, int, int)>[];
  for (var i = 0; i + 1 < list.length; i++) {
    final mid = (list[i] + list[i + 1]) / 2;
    final sunNak = (norm360(calc.sun(mid)) / span).floor();
    final sunSeg = sunNak < 21 ? sunNak : sunNak + 1; // Sun never sits in Abhijit for this count
    final m = moon.lastWhere((x) => x.$2 <= mid, orElse: () => moon.first);
    final moonNak = (norm360(calc.moon(mid)) / span).floor();
    out.add((list[i], list[i + 1], sunSeg, m.$1, moonNak));
  }
  return out;
}

double _previousSunset(PanchangCalc calc, DayPanchang d) =>
    calc.eph.sunEvent(d.sunrise - 0.75, d.place.latitude, d.place.longitude, rise: false) ??
    d.sunrise - d.nightLength;

/// Sun's apparent altitude (degrees) at [jd] for the place of [d].
double sunAltitude(PanchangCalc calc, DayPanchang d, double jd) {
  final eph = calc.eph;
  final l = (calc.sun(jd) + eph.ayanamsa(jd, calc.settings)) * pi / 180;
  final eps = eph.trueObliquity(jd) * pi / 180;
  final dec = asin(sin(eps) * sin(l));
  final ra = atan2(cos(eps) * sin(l), cos(l));
  final lst = (eph.siderealTimeGreenwich(jd) * 15 + d.place.longitude) * pi / 180;
  final p = d.place.latitude * pi / 180;
  return asin(sin(p) * sin(dec) + cos(p) * cos(dec) * cos(lst - ra)) * 180 / pi;
}

/// Godhuli: from the Sun's centre on the apparent horizon (−0.57°) to civil
/// dusk (−6°). Matches Drik Panchang within 1–2 minutes.
(double, double) godhuli(PanchangCalc calc, DayPanchang d) {
  double when(double target) {
    var lo = d.sunset - 0.03, hi = d.sunset + 0.08;
    for (var i = 0; i < 40; i++) {
      final m = (lo + hi) / 2;
      if (sunAltitude(calc, d, m) > target) {
        lo = m;
      } else {
        hi = m;
      }
    }
    return lo;
  }

  return (when(-0.5667), when(-6));
}

// ---------------------------------------------------------------------------
// Anandadi yoga (28, counted with Abhijit from the weekday's nakshatra)

const anandadiNames = [
  'Ananda', 'Kaladanda', 'Dhumra', 'Dhata', 'Saumya', 'Dhwanksha', 'Dhwaja',
  'Shrivatsa', 'Vajra', 'Mudgara', 'Chhatra', 'Mitra', 'Manasa', 'Padma',
  'Lumbaka', 'Utpata', 'Mrityu', 'Kana', 'Siddhi', 'Shubha', 'Amrita',
  'Musala', 'Gada', 'Matanga', 'Rakshasa', 'Chara', 'Sthira', 'Vardhamana',
];

/// Auspicious Anandadi yogas: those whose Tamil yoga is Siddha or Amrita.
const goodAnandadi = {0, 3, 4, 6, 7, 10, 11, 12, 13, 18, 19, 20, 23, 25, 26, 27};

enum TamilYoga { siddha, amrita, marana }

/// Tamil yoga is a grouping of the Anandadi yoga (Drik Panchang, all 28
/// seen 26 Nov – 24 Dec 2026).
TamilYoga tamilYogaOf(int anandadi) {
  if (const {11, 12, 18, 20, 23, 26}.contains(anandadi)) return TamilYoga.amrita;
  if (goodAnandadi.contains(anandadi)) return TamilYoga.siddha;
  return TamilYoga.marana;
}

/// Starting segment (28-wheel, Abhijit = 21) for each weekday, Sunday first.
const _anandadiStart = [0, 4, 8, 12, 16, 20, 24];

/// Anandadi yogas over the day: value = 0-based index into [anandadiNames].
List<TimeSpan<int>> anandadiYogas(PanchangCalc calc, DayPanchang d) {
  final start = _anandadiStart[sundayIndex(d)];
  return [
    for (final (seg, s, e) in moonSegments(calc, d.sunrise, d.nextSunrise))
      TimeSpan((seg - start) % 28, max(s, d.sunrise), min(e, d.nextSunrise)),
  ];
}

/// Moon's 28-wheel segments (Abhijit carved out) over [from, to).
List<(int, double, double)> moonSegments(PanchangCalc calc, double from, double to) {
  const span = 360 / 27;
  // Boundaries of the 28 segments, in longitude.
  final bounds = <double>[
    for (var k = 0; k <= 20; k++) k * span,
    abhijitStart,
    abhijitEnd,
    for (var k = 22; k < 27; k++) k * span,
  ];
  int segAt(double lon) {
    for (var k = bounds.length - 1; k >= 0; k--) {
      if (lon >= bounds[k]) return k;
    }
    return 0;
  }

  final out = <(int, double, double)>[];
  var t = from;
  while (t < to) {
    final lon = calc.moon(t + 1e-7);
    final seg = segAt(norm360(lon));
    final startLon = bounds[seg];
    final endLon = seg + 1 < bounds.length ? bounds[seg + 1] : 360.0;
    final s = calc.reach(PanchangElement.nakshatra, t + 1e-7, startLon, forward: false);
    final e = calc.reach(PanchangElement.nakshatra, t + 1e-7, endLon % 360);
    out.add((seg, s, e));
    t = e + 1e-6;
  }
  return out;
}

// ---------------------------------------------------------------------------
// Baana and Panchaka Rahita

enum Baana { mrityu, agni, raja, chora, roga }

/// The common "remainder of 9" mapping of Baana and Panchaka.
Baana? baanaOfRemainder(int r) => switch (r % 9) {
  1 => Baana.mrityu,
  2 => Baana.agni,
  4 => Baana.raja,
  6 => Baana.chora,
  8 => Baana.roga,
  _ => null,
};

/// Baana by the Sun's completed degrees in its sign, over the day.
List<TimeSpan<Baana>> baanas(PanchangCalc calc, DayPanchang d) {
  final out = <TimeSpan<Baana>>[];
  var t = d.sunrise;
  while (t < d.nextSunrise) {
    final lon = norm360(calc.sun(t));
    final deg = (lon % 30).floor();
    final next = _sunReach(calc, t, (lon - lon % 1 + 1) % 360);
    final e = min(next, d.nextSunrise);
    final b = baanaOfRemainder(deg);
    if (b != null) out.add(TimeSpan(b, t, e));
    t = next + 1e-6;
  }
  return out;
}

double _sunReach(PanchangCalc calc, double jd, double target) {
  var t = jd + norm360(target - calc.sun(jd)) / 0.9856;
  for (var i = 0; i < 10; i++) {
    var dd = norm360(target - calc.sun(t));
    if (dd > 180) dd -= 360;
    if (dd.abs() < 1e-8) break;
    t += dd / 0.9856;
  }
  return t;
}

/// Panchaka Rahita: (tithi + weekday + nakshatra + lagna) mod 9 over each
/// lagna/tithi/nakshatra stretch; null = Shubha (good).
List<TimeSpan<Baana?>> panchakaRahita(
  DayPanchang d,
  List<TimeSpan<Rashi>> lagnas,
) {
  final cuts = <double>{
    d.sunrise,
    d.nextSunrise,
    for (final l in lagnas) l.start,
    for (final x in d.tithis) x.start,
    for (final x in d.nakshatras) x.start,
  }.where((t) => t >= d.sunrise && t <= d.nextSunrise).toList()
    ..sort();
  T at<T>(List<TimeSpan<T>> l, double t) =>
      l.lastWhere((x) => x.start <= t, orElse: () => l.first).value;
  int idxAt(List<ElementSpan> l, double t) =>
      l.lastWhere((x) => x.start <= t, orElse: () => l.first).index;
  final out = <TimeSpan<Baana?>>[];
  for (var i = 0; i + 1 < cuts.length; i++) {
    final t = (cuts[i] + cuts[i + 1]) / 2;
    final sum = idxAt(d.tithis, t) +
        sundayIndex(d) + 1 +
        idxAt(d.nakshatras, t) +
        at(lagnas, t).index + 1;
    final b = baanaOfRemainder(sum);
    if (out.isNotEmpty && out.last.value == b) {
      out[out.length - 1] = TimeSpan(b, out.last.start, cuts[i + 1]);
    } else {
      out.add(TimeSpan(b, cuts[i], cuts[i + 1]));
    }
  }
  return out;
}

// ---------------------------------------------------------------------------
// Gowri Panchangam

enum Gowri { uthi, amirdha, rogam, laabam, dhanam, sugam, soram, visham }

bool isGoodGowri(Gowri g) =>
    g != Gowri.rogam && g != Gowri.soram && g != Gowri.visham;

const _u = Gowri.uthi, _a = Gowri.amirdha, _r = Gowri.rogam,
    _l = Gowri.laabam, _d = Gowri.dhanam, _s = Gowri.sugam,
    _so = Gowri.soram, _v = Gowri.visham;

/// Day and night orders by weekday, Sunday first.
const _gowriDay = [
  [_u, _a, _r, _l, _d, _s, _so, _v],
  [_a, _v, _r, _l, _d, _s, _so, _u],
  [_r, _l, _d, _s, _so, _u, _v, _a],
  [_l, _d, _s, _so, _v, _u, _a, _r],
  [_d, _s, _so, _u, _a, _v, _r, _l],
  [_s, _so, _u, _a, _v, _r, _l, _d],
  [_so, _u, _v, _a, _r, _l, _d, _s],
];
const _gowriNight = [
  [_d, _s, _so, _u, _a, _v, _r, _l],
  [_s, _so, _u, _a, _v, _r, _l, _d],
  [_so, _u, _v, _a, _r, _l, _d, _s],
  [_u, _a, _r, _l, _d, _s, _so, _v],
  [_a, _v, _r, _l, _d, _s, _so, _u],
  [_r, _l, _d, _s, _so, _u, _v, _a],
  [_l, _d, _s, _so, _v, _u, _a, _r],
];

List<TimeSpan<Gowri>> gowriPanchangam(DayPanchang d) {
  final w = sundayIndex(d);
  final day = d.dayLength / 8, night = d.nightLength / 8;
  return [
    for (var k = 0; k < 8; k++)
      TimeSpan(_gowriDay[w][k], d.sunrise + k * day, d.sunrise + (k + 1) * day),
    for (var k = 0; k < 8; k++)
      TimeSpan(_gowriNight[w][k], d.sunset + k * night, d.sunset + (k + 1) * night),
  ];
}

// ---------------------------------------------------------------------------
// Chandrabalam and Tarabalam

enum Bala { good, pujaNeeded, bad }

/// Chandrabalam for a native of [rashi] while the Moon is in [moonSign].
Bala chandrabalam(Rashi rashi, Rashi moonSign) {
  final h = (moonSign.index - rashi.index) % 12 + 1;
  if (const {1, 3, 6, 7, 10, 11}.contains(h)) return Bala.good;
  if (const {2, 5, 9}.contains(h)) return Bala.pujaNeeded;
  return Bala.bad;
}

enum Tara { janma, sampat, vipat, kshema, pratyari, sadhaka, naidhana, mitra, paramitra }

/// Drik's grading: very good / good / not good / bad / totally bad.
const taraGrade = {
  Tara.janma: 'notGood', Tara.sampat: 'veryGood', Tara.vipat: 'bad',
  Tara.kshema: 'good', Tara.pratyari: 'notGood', Tara.sadhaka: 'veryGood',
  Tara.naidhana: 'totallyBad', Tara.mitra: 'good', Tara.paramitra: 'good',
};

/// Tara of the day's nakshatra for a native of [birth] (0-based indexes).
Tara tarabalam(int birth, int day) => Tara.values[(nakshatraCount(birth, day) - 1) % 9];

// ---------------------------------------------------------------------------
// Nivas & Shool

enum Direction { east, southEast, south, southWest, west, northWest, north, northEast }

/// Disha Shool by weekday, Sunday first.
const dishaShool = [
  Direction.west, Direction.east, Direction.north, Direction.north,
  Direction.south, Direction.west, Direction.east,
];

/// Rahu Vasa by weekday, Sunday first (Wednesday from the pattern).
const rahuVasa = [
  Direction.north, Direction.northWest, Direction.west, Direction.southWest,
  Direction.south, Direction.southEast, Direction.east,
];

/// Chandra Vasa: fiery signs east, earthy south, airy west, watery north.
Direction chandraVasa(Rashi moonSign) => const [
  Direction.east, Direction.south, Direction.west, Direction.north,
][moonSign.index % 4];

/// Nakshatra Shool: travel towards this direction is avoided while the Moon
/// is in Jyeshtha (east), Purva Bhadrapada (south), Rohini (west) or Uttara
/// Phalguni (north) (Drik Panchang, Dec 2026 – Jan 2027).
Direction? nakshatraShool(int moonNak) => const {
  17: Direction.east,
  24: Direction.south,
  3: Direction.west,
  11: Direction.north,
}[moonNak];

enum Agnivasa { prithvi, akasha, patala }

/// (tithi 1–30 + weekday Sun = 1 + 1) mod 4.
Agnivasa agnivasa(int tithi, int sundayIdx) => switch ((tithi + sundayIdx + 2) % 4) {
  1 => Agnivasa.akasha,
  2 => Agnivasa.patala,
  _ => Agnivasa.prithvi,
};

enum Shivavasa { shmashana, kailash, gowri, nandi, sabha, bhojana, krida }

/// (2 × tithi + 5) mod 7.
Shivavasa shivavasa(int tithi) => Shivavasa.values[(2 * tithi + 5) % 7];

enum Bhadravasa { swarga, patala, mrityu }

Bhadravasa bhadravasa(Rashi moonSign) => switch (moonSign) {
  Rashi.aries || Rashi.taurus || Rashi.gemini || Rashi.scorpio => Bhadravasa.swarga,
  Rashi.cancer || Rashi.leo || Rashi.aquarius || Rashi.pisces => Bhadravasa.mrityu,
  _ => Bhadravasa.patala,
};

/// Homahuti: the graha receiving the oblation, by the count from the
/// Sun's nakshatra to the Moon's.
const _homahuti = [
  Graha.sun, Graha.mercury, Graha.venus, Graha.saturn, Graha.moon,
  Graha.mars, Graha.jupiter, Graha.rahu, Graha.ketu,
];
Graha homahuti(int sunNak, int moonNak) =>
    _homahuti[(nakshatraCount(sunNak, moonNak) - 1) ~/ 3];

/// Per-element values over the day, from tithi and Moon-sign changes.
class Nivas {
  Nivas._(this.homahutis, this.agnivasas, this.shivavasas, this.chandraVasas,
      this.bhadravasas, this.moonSigns);

  final List<TimeSpan<Graha>> homahutis;
  final List<TimeSpan<Agnivasa>> agnivasas;
  final List<TimeSpan<Shivavasa>> shivavasas;
  final List<TimeSpan<Direction>> chandraVasas;
  final List<TimeSpan<Bhadravasa>> bhadravasas;
  final List<TimeSpan<Rashi>> moonSigns;

  static Nivas of(PanchangCalc calc, DayPanchang d) {
    final w = sundayIndex(d);
    List<TimeSpan<T>> merge<T>(List<TimeSpan<T>> l) {
      final out = <TimeSpan<T>>[];
      for (final x in l) {
        if (out.isNotEmpty && out.last.value == x.value) {
          out[out.length - 1] = TimeSpan(x.value, out.last.start, x.end);
        } else {
          out.add(x);
        }
      }
      return out;
    }

    double cs(double s) => max(s, d.sunrise);
    double ce(double e) => min(e, d.nextSunrise);
    final signs = moonSignSpans(calc, d.sunrise, d.nextSunrise);
    Rashi signAt(double t) => signs.lastWhere((x) => x.start <= t, orElse: () => signs.first).value;
    return Nivas._(
      merge([
        for (final (s, e, _, _, m) in sunMoonSpans(calc, d.sunrise, d.nextSunrise))
          TimeSpan(
            homahuti((norm360(calc.sun((s + e) / 2)) / (360 / 27)).floor(), m),
            s,
            e,
          ),
      ]),
      merge([
        for (final t in d.tithis) TimeSpan(agnivasa(t.index, w), cs(t.start), ce(t.end)),
      ]),
      merge([
        for (final t in d.tithis) TimeSpan(shivavasa(t.index), cs(t.start), ce(t.end)),
      ]),
      merge([for (final s in signs) TimeSpan(chandraVasa(s.value), s.start, s.end)]),
      [
        for (final b in bhadra(calc, d.sunrise, d.nextSunrise))
          TimeSpan(bhadravasa(signAt(cs(b.start))), cs(b.start), ce(b.end)),
      ],
      signs,
    );
  }
}

/// Moon's signs over [from, to), clipped.
List<TimeSpan<Rashi>> moonSignSpans(PanchangCalc calc, double from, double to) {
  final out = <TimeSpan<Rashi>>[];
  var t = from;
  while (t < to) {
    final lon = norm360(calc.moon(t + 1e-7));
    final sign = Rashi.ofLongitude(lon);
    final end = calc.reach(PanchangElement.nakshatra, t + 1e-7, ((sign.index + 1) * 30) % 360.0);
    out.add(TimeSpan(sign, t, min(end, to)));
    t = end + 1e-6;
  }
  return out;
}

/// Moon's nakshatra padas (value: nakshatra index × 4 + pada − 1) over the day.
List<TimeSpan<int>> moonPadas(PanchangCalc calc, double from, double to) {
  const pada = 360 / 108;
  final out = <TimeSpan<int>>[];
  var t = from;
  while (t < to) {
    final lon = norm360(calc.moon(t + 1e-7));
    final p = (lon / pada).floor();
    final end = calc.reach(PanchangElement.nakshatra, t + 1e-7, ((p + 1) * pada) % 360);
    out.add(TimeSpan(p, t, min(end, to)));
    t = end + 1e-6;
  }
  return out;
}

/// Sun's nakshatra padas over the day.
List<TimeSpan<int>> sunPadas(PanchangCalc calc, double from, double to) {
  const pada = 360 / 108;
  final out = <TimeSpan<int>>[];
  var t = from;
  while (t < to) {
    final lon = norm360(calc.sun(t + 1e-7));
    final p = (lon / pada).floor();
    final end = _sunReach(calc, t + 1e-7, ((p + 1) * pada) % 360);
    out.add(TimeSpan(p, t, min(end, to)));
    t = end + 1e-6;
  }
  return out;
}

// ---------------------------------------------------------------------------
// Kumbha Chakra, Jeevanama, Netrama

/// Where the Moon's nakshatra falls on the pot, counting from the Sun's
/// nakshatra: 1 mouth, 2–5 east, 6–9 south, 10–13 west, 14–17 north,
/// 18–21 womb, 22–24 bottom, 25–27 throat.
enum KumbhaPart { mouth, east, south, west, north, womb, bottom, throat }

KumbhaPart kumbhaPart(int sunNak, int moonNak) {
  final c = nakshatraCount(sunNak, moonNak);
  if (c == 1) return KumbhaPart.mouth;
  if (c <= 17) return KumbhaPart.values[1 + (c - 2) ~/ 4];
  if (c <= 21) return KumbhaPart.womb;
  if (c <= 24) return KumbhaPart.bottom;
  return KumbhaPart.throat;
}

/// Auspicious parts of the pot (Muhurta Chintamani's Kalasha chakra; Drik
/// marks north and womb bad, bottom good).
bool isGoodKumbha(KumbhaPart p) => const {
  KumbhaPart.south, KumbhaPart.west, KumbhaPart.bottom, KumbhaPart.throat,
}.contains(p);

/// Jeevanama ("life"), by the count from the Sun's nakshatra to the
/// Moon's: 2 full, 1 half, 0 none (Drik Panchang, Nov 2026 – Jan 2027).
int jeevanamaOf(int sunNak, int moonNak) {
  final c = nakshatraCount(sunNak, moonNak);
  if (c == 1 || c == 2 || c == 10 || c == 19 || c == 27) return 0;
  if (c >= 11 && c <= 18) return 2;
  return 1;
}

/// Netrama ("eyes"), by the same count: 2, 1 or 0 (blind).
int netramaOf(int sunNak, int moonNak) {
  final c = nakshatraCount(sunNak, moonNak);
  if (c >= 9 && c <= 20) return 2;
  if ((c >= 5 && c <= 8) || (c >= 21 && c <= 24)) return 1;
  return 0;
}

/// Moon-nakshatra-based values over the day (Tamil yoga, Kumbha, life, eyes).
class MoonDayValues {
  MoonDayValues._(this.tamil, this.kumbha, this.jeevan, this.netra);
  final List<TimeSpan<TamilYoga>> tamil;
  final List<TimeSpan<KumbhaPart>> kumbha;
  final List<TimeSpan<int>> jeevan, netra;

  static MoonDayValues of(PanchangCalc calc, DayPanchang d) {
    final spans = sunMoonSpans(calc, d.sunrise, d.nextSunrise);
    List<TimeSpan<T>> merge<T>(Iterable<TimeSpan<T>> l) {
      final out = <TimeSpan<T>>[];
      for (final x in l) {
        if (out.isNotEmpty && out.last.value == x.value) {
          out[out.length - 1] = TimeSpan(x.value, out.last.start, x.end);
        } else {
          out.add(x);
        }
      }
      return out;
    }

    const span = 360 / 27;
    int sunNakAt(double t) => (norm360(calc.sun(t)) / span).floor();
    return MoonDayValues._(
      merge([for (final a in anandadiYogas(calc, d)) TimeSpan(tamilYogaOf(a.value), a.start, a.end)]),
      merge([
        for (final (s, e, _, _, m) in spans) TimeSpan(kumbhaPart(sunNakAt((s + e) / 2), m), s, e),
      ]),
      merge([
        for (final (s, e, _, _, m) in spans) TimeSpan(jeevanamaOf(sunNakAt((s + e) / 2), m), s, e),
      ]),
      merge([
        for (final (s, e, _, _, m) in spans) TimeSpan(netramaOf(sunNakAt((s + e) / 2), m), s, e),
      ]),
    );
  }
}

// ---------------------------------------------------------------------------
// Calendars, ritu, epochs

const samvatsaraNames = [
  'Prabhava', 'Vibhava', 'Shukla', 'Pramoda', 'Prajapati', 'Angirasa',
  'Shrimukha', 'Bhava', 'Yuva', 'Dhata', 'Ishvara', 'Bahudhanya', 'Pramathi',
  'Vikrama', 'Vrisha', 'Chitrabhanu', 'Subhanu', 'Tarana', 'Parthiva', 'Vyaya',
  'Sarvajit', 'Sarvadhari', 'Virodhi', 'Vikriti', 'Khara', 'Nandana', 'Vijaya',
  'Jaya', 'Manmatha', 'Durmukhi', 'Hevilambi', 'Vilambi', 'Vikari', 'Sharvari',
  'Plava', 'Shubhakrit', 'Shobhakrit', 'Krodhi', 'Vishvavasu', 'Parabhava',
  'Plavanga', 'Kilaka', 'Saumya', 'Sadharana', 'Virodhikrit', 'Paridhavi',
  'Pramadi', 'Ananda', 'Rakshasa', 'Nala', 'Pingala', 'Kalayukta', 'Siddharthi',
  'Raudra', 'Durmati', 'Dundubhi', 'Rudhirodgari', 'Raktakshi', 'Krodhana',
  'Akshaya',
];

/// 0-based index into [samvatsaraNames].
int _cycle(int n) => (n - 1) % 60;
int shakaSamvatsara(int shaka) => _cycle(shaka + 12);
int vikramSamvatsara(int vikram) => _cycle(vikram + 10);
int gujaratiSamvatsara(int gujarati) => _cycle(gujarati + 9);

/// Gujarati Vikram year: starts at Kartika Shukla Pratipada.
int gujaratiYear(DayPanchang d) =>
    d.month.amanta >= 7 ? d.vikram : d.vikram - 1;

enum Ritu { vasanta, grishma, varsha, sharad, hemanta, shishira }

/// Drik (tropical) ritu: Vasanta from the Sun at 330°.
Ritu drikRitu(double tropicalSun) => Ritu.values[(norm360(tropicalSun + 30) ~/ 60) % 6];

/// Vedic ritu: two sidereal signs each from Aries.
Ritu vedicRitu(Rashi sunSign) => Ritu.values[sunSign.index ~/ 2];

/// Uttarayana when the Sun is between 270° and 90° (via 0°).
bool isUttarayana(double lon) {
  final l = norm360(lon);
  return l >= 270 || l < 90;
}

/// Day of the solar month (Pravishte/Gate): the civil day on which the Sun
/// enters the sign is day 1 (as Drik Panchang counts, even for a sankranti
/// after sunset).
int pravishte(PanchangCalc calc, DayPanchang d) {
  // The Sun's sign at the end of the civil day (local midnight).
  final midnight = calc.eph.julianDayUt(d.date.year, d.date.month, d.date.day, 0) -
      d.place.utcOffsetHours / 24 + 1;
  final sun = norm360(calc.sun(midnight));
  final sankranti = _sunReach(calc, midnight - (sun % 30) / 0.9856 - 2, sun - sun % 30);
  double localDay(double jd) => (jd + 0.5 + d.place.utcOffsetHours / 24).floorToDouble();
  return (localDay(midnight - 1e-6) - localDay(sankranti)).round() + 1;
}

/// National Nirayana (sidereal solar) date as Drik Panchang shows it:
/// (Shaka year, month 1 = Chaitra … 12, day). Each month (Mesha = Vaishakha)
/// starts the civil day before the sankranti day, so the day number is one
/// more than [pravishte].
(int, int, int) nationalNirayanaDate(PanchangCalc calc, DayPanchang d) {
  final next = DateTime.utc(d.date.year, d.date.month, d.date.day).add(const Duration(days: 1));
  final dn = DayPanchang.of(calc, d.place, next);
  final endOfNext = calc.eph.julianDayUt(next.year, next.month, next.day, 0) -
      d.place.utcOffsetHours / 24 + 1;
  final sign = Rashi.ofLongitude(calc.sun(endOfNext)).index;
  final month = (sign + 1) % 12 + 1; // Mesha → Vaishakha (2)
  // Shaka year turns at Vaishakha 1.
  final meshaThisYear = _sunReach(calc, calc.eph.julianDayUt(next.year, 3, 20, 0), 0);
  final shaka = next.year - (endOfNext >= meshaThisYear ? 78 : 79);
  return (shaka, month, pravishte(calc, dn));
}

/// Julian day number at 0h UT of the civil date.
double civilJd(Ephemeris eph, DateTime date) =>
    eph.julianDayUt(date.year, date.month, date.day, 0);

/// Days since the Kali Yuga epoch (JD 588465.5).
int kaliAhargana(double jd0) => (jd0 - 588465.5).round();

/// Rata Die (days since 1 Jan 1 CE, proleptic Gregorian).
int rataDie(double jd0) => (jd0 - 1721424.5).round();

/// Julian-calendar date of a Julian day number (at 0h).
(int, int, int) julianCalendarDate(double jd0) {
  final c = (jd0 + 0.5).floor() + 32082;
  final dd = (4 * c + 3) ~/ 1461;
  final e = c - (1461 * dd) ~/ 4;
  final m = (5 * e + 2) ~/ 153;
  final day = e - (153 * m + 2) ~/ 5 + 1;
  final month = m + 3 - 12 * (m ~/ 10);
  final year = dd - 4800 + m ~/ 10;
  return (year, month, day);
}

/// Indian National (civil Saka) calendar: (year, month 1–12 Chaitra…, day).
(int, int, int) nationalCivilDate(DateTime date) {
  final y = date.year;
  bool leap(int y) => (y % 4 == 0 && y % 100 != 0) || y % 400 == 0;
  // Chaitra 1 is 22 March (21 March in Gregorian leap years).
  DateTime start(int gy) => DateTime.utc(gy, 3, leap(gy) ? 21 : 22);
  final d = DateTime.utc(date.year, date.month, date.day);
  final s = d.isBefore(start(y)) ? start(y - 1) : start(y);
  final saka = s.year - 78;
  var days = d.difference(s).inDays;
  final lengths = [
    leap(s.year) ? 31 : 30, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 30,
  ];
  var m = 0;
  while (days >= lengths[m]) {
    days -= lengths[m];
    m++;
  }
  return (saka, m + 1, days + 1);
}
