import '../ephemeris/ephemeris.dart';
import '../model/enums.dart';
import 'day_panchang.dart';

/// A named slice of time (JD UT).
class TimeSpan<T> {
  const TimeSpan(this.value, this.start, this.end);
  final T value;
  final double start, end;
  bool contains(double jd) => jd >= start && jd < end;
}

/// Weekday order Sun..Sat (index 0 = Sunday).
const _week = [
  Graha.sun, Graha.moon, Graha.mars, Graha.mercury,
  Graha.jupiter, Graha.venus, Graha.saturn,
];
int _w(Graha g) => _week.indexOf(g);

/// 24 planetary horas from sunrise: 12 by day, 12 by night, starting with
/// the weekday lord and following Sun → Venus → Mercury → Moon → Saturn →
/// Jupiter → Mars.
List<TimeSpan<Graha>> horas(DayPanchang d) {
  final out = <TimeSpan<Graha>>[];
  var i = _w(d.varaLord);
  for (var k = 0; k < 24; k++) {
    final day = k < 12;
    final len = (day ? d.dayLength : d.nightLength) / 12;
    final start = (day ? d.sunrise : d.sunset) + (k % 12) * len;
    out.add(TimeSpan(_week[i], start, start + len));
    i = (i + 5) % 7; // next in hora order = 5 steps on in weekday order
  }
  return out;
}

enum Chogadia { udveg, char, labh, amrit, kaal, shubh, rog }

const _chogadiaOf = {
  Graha.sun: Chogadia.udveg, Graha.venus: Chogadia.char,
  Graha.mercury: Chogadia.labh, Graha.moon: Chogadia.amrit,
  Graha.saturn: Chogadia.kaal, Graha.jupiter: Chogadia.shubh,
  Graha.mars: Chogadia.rog,
};

bool isGoodChogadia(Chogadia c) =>
    c == Chogadia.amrit || c == Chogadia.shubh || c == Chogadia.labh ||
    c == Chogadia.char;

/// 8 day and 8 night chogadias. Day starts with the weekday lord's and
/// follows hora order; night starts 4 weekdays on and steps 4 at a time.
List<TimeSpan<Chogadia>> chogadias(DayPanchang d) {
  final out = <TimeSpan<Chogadia>>[];
  var i = _w(d.varaLord);
  for (var k = 0; k < 8; k++) {
    final len = d.dayLength / 8;
    out.add(TimeSpan(_chogadiaOf[_week[i]]!, d.sunrise + k * len,
        d.sunrise + (k + 1) * len));
    i = (i + 5) % 7;
  }
  i = (_w(d.varaLord) + 4) % 7;
  for (var k = 0; k < 8; k++) {
    final len = d.nightLength / 8;
    out.add(TimeSpan(_chogadiaOf[_week[i]]!, d.sunset + k * len,
        d.sunset + (k + 1) * len));
    i = (i + 4) % 7;
  }
  return out;
}

enum Kaal { rahu, yamaganda, gulika, abhijit }

/// Rahu Kaal, Yamaganda, Gulika Kaal (one eighth of daylight each, by
/// weekday) and Abhijit muhurta (the 8th of 15 daytime muhurtas; not
/// counted on Wednesdays, by tradition).
Map<Kaal, TimeSpan<Kaal>> dayKaals(DayPanchang d) {
  // 1-based eighth of the day, indexed by weekday Sun..Sat.
  const rahu = [8, 2, 7, 5, 6, 4, 3];
  const yama = [5, 4, 3, 2, 1, 7, 6];
  const gulika = [7, 6, 5, 4, 3, 2, 1];
  final w = _w(d.varaLord);
  final e = d.dayLength / 8;
  TimeSpan<Kaal> eighth(Kaal k, int n) =>
      TimeSpan(k, d.sunrise + (n - 1) * e, d.sunrise + n * e);
  final m = d.dayLength / 15;
  return {
    Kaal.rahu: eighth(Kaal.rahu, rahu[w]),
    Kaal.yamaganda: eighth(Kaal.yamaganda, yama[w]),
    Kaal.gulika: eighth(Kaal.gulika, gulika[w]),
    if (d.weekday != DateTime.wednesday)
      Kaal.abhijit: TimeSpan(Kaal.abhijit, d.sunrise + 7 * m, d.sunrise + 8 * m),
  };
}

/// The 30 muhurtas of a day (15 by day, 15 by night), each 2 ghatis.
const muhurtaNames = [
  'Rudra', 'Ahi', 'Mitra', 'Pitri', 'Vasu', 'Varaha', 'Vishvedeva',
  'Vidhi (Abhijit)', 'Satamukhi', 'Puruhuta', 'Vahni', 'Naktanchara',
  'Varuna', 'Aryama', 'Bhaga',
  'Girisha', 'Ajapada', 'Ahirbudhnya', 'Pusha', 'Ashvini', 'Yama', 'Agni',
  'Vidhata', 'Chanda', 'Aditi', 'Jiva', 'Vishnu', 'Dyumadgadyuti',
  'Brahma', 'Samudra',
];

/// Muhurtas usually treated as auspicious (Muhurta Chintamani).
const goodMuhurtas = {2, 4, 6, 7, 9, 12, 14, 18, 19, 22, 23, 24, 25, 26, 27, 28};

List<TimeSpan<int>> muhurtas(DayPanchang d) => [
      for (var k = 0; k < 30; k++)
        () {
          final day = k < 15;
          final len = (day ? d.dayLength : d.nightLength) / 15;
          final start = (day ? d.sunrise : d.sunset) + (k % 15) * len;
          return TimeSpan(k, start, start + len);
        }(),
    ];

/// Rising-sign table from sunrise to the next sunrise.
List<TimeSpan<Rashi>> lagnaTable(
    DayPanchang d, Ephemeris eph, PanchangCalc calc) {
  Rashi asc(double jd) => Rashi.ofLongitude(eph
      .houses(jd, d.place.latitude, d.place.longitude, HouseSystem.wholeSign,
          calc.settings)
      .ascendant);
  final out = <TimeSpan<Rashi>>[];
  var start = d.sunrise;
  var cur = asc(start);
  const step = 5 / 1440;
  for (var t = d.sunrise + step; t <= d.nextSunrise; t += step) {
    final s = asc(t);
    if (s == cur) continue;
    var lo = t - step, hi = t;
    for (var i = 0; i < 20; i++) {
      final mid = (lo + hi) / 2;
      if (asc(mid) == cur) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    out.add(TimeSpan(cur, start, hi));
    start = hi;
    cur = s;
  }
  out.add(TimeSpan(cur, start, d.nextSunrise));
  return out;
}

/// Panchak: Moon in Aquarius or Pisces (from Dhanishta pada 3 to the end
/// of Revati). Returns the period overlapping [from, to), if any.
List<TimeSpan<void>> panchak(PanchangCalc calc, double from, double to) {
  final out = <TimeSpan<void>>[];
  double moonAt(double jd) => calc.moon(jd);
  double reachMoon(double jd, double target, {bool forward = true}) {
    var t = jd + (forward ? 1 : -1) *
        (forward ? norm360(target - moonAt(jd)) : norm360(moonAt(jd) - target)) /
        13.18;
    for (var i = 0; i < 12; i++) {
      var dd = norm360(target - moonAt(t));
      if (dd > 180) dd -= 360;
      if (dd.abs() < 1e-7) break;
      t += dd / 13.18;
    }
    return t;
  }

  var t = from;
  while (t < to) {
    final m = moonAt(t);
    if (m >= 300) {
      final start = reachMoon(t, 300, forward: false);
      final end = reachMoon(t, 0);
      out.add(TimeSpan(null, start, end));
      t = end + 1e-4;
    } else {
      final start = reachMoon(t, 300);
      if (start >= to) break;
      t = start + 1e-4;
    }
  }
  return out;
}

/// Bhadra (Vishti karana) periods overlapping [from, to).
List<TimeSpan<void>> bhadra(PanchangCalc calc, double from, double to) => [
      for (final k in calc.spansBetween(PanchangElement.karana, from, to))
        if (k.index > 1 && k.index < 58 && (k.index - 2) % 7 == 6)
          TimeSpan(null, k.start, k.end),
    ];
