import '../model/enums.dart';
import 'day_panchang.dart';
import 'day_extras.dart' show samvatsaraNames;

/// Brihaspati (Jupiter) samvatsara: the 60-year cycle stepping each time
/// mean Jupiter moves one sign. Period and epoch fitted to Drik Panchang's
/// changes Kalayukta → Siddharthi (25 Apr 2025 15:07 IST) and Siddharthi →
/// Raudra (21 Apr 2026 15:53 IST): 361.0319 days (Surya Siddhanta: 361.0266).
const brihaspatiYearDays = 2461151.932639 - 2460790.900694;
const _anchorJd = 2461151.932639; // 2026-04-21 10:23 UT
const _anchorIndex = 53; // Raudra

/// (0-based index into [samvatsaraNames], start JD, end JD) at [jdUt].
(int, double, double) brihaspatiSamvatsara(double jdUt) {
  final n = ((jdUt - _anchorJd) / brihaspatiYearDays).floor();
  final start = _anchorJd + n * brihaspatiYearDays;
  return ((_anchorIndex + n) % 60, start, start + brihaspatiYearDays);
}

/// The ten office-holders of a Vikram year: weekday lords at the start of
/// the year and at chosen solar ingresses.
enum MantriOffice {
  raja, mantri, senadhipati, sasyadhipati, dhanyadhipati, dhanadhipati,
  meghadhipati, rasadhipati, nirasadhipati, phaladhipati,
}

/// What fixes each office, as reproduced from Drik Panchang (Vikram 2082
/// and 2083):
/// a sankranti (sign entered) or, for Meghadhipati, the Sun entering Ardra;
/// Raja is the weekday of Chaitra Shukla Pratipada.
const _officeSign = <MantriOffice, Rashi>{
  MantriOffice.mantri: Rashi.aries,
  MantriOffice.sasyadhipati: Rashi.cancer,
  MantriOffice.senadhipati: Rashi.leo,
  MantriOffice.dhanadhipati: Rashi.virgo,
  MantriOffice.rasadhipati: Rashi.libra,
  MantriOffice.dhanyadhipati: Rashi.sagittarius,
  MantriOffice.nirasadhipati: Rashi.capricorn,
  MantriOffice.phaladhipati: Rashi.pisces, // the Meena sankranti closing the year
};

const _weekLords = [
  Graha.sun, Graha.moon, Graha.mars, Graha.mercury,
  Graha.jupiter, Graha.venus, Graha.saturn,
];

/// Mantri Mandala of the Vikram year beginning in civil [gregorianYear]
/// (Chaitra Shukla Pratipada in March/April), at [place].
Map<MantriOffice, Graha> mantriMandala(
  PanchangCalc calc,
  PanchangPlace place,
  int gregorianYear,
) {
  final eph = calc.eph;
  // Weekday lord of the Hindu day (sunrise to sunrise) holding [jd].
  Graha lordAt(double jd) {
    final local = jd + place.utcOffsetHours / 24;
    var day = (local + 0.5).floor();
    final midnight = day - 0.5 - place.utcOffsetHours / 24;
    final rise = eph.sunEvent(midnight, place.latitude, place.longitude, rise: true) ??
        midnight + 0.25;
    if (jd < rise) day -= 1;
    // JD day number: (day + 1) % 7 gives 0 = Sunday.
    return _weekLords[(day + 1) % 7];
  }

  double sunReach(double from, double target) {
    var t = from + norm360(target - calc.sun(from)) / 0.9856;
    for (var i = 0; i < 20; i++) {
      var d = norm360(target - calc.sun(t));
      if (d > 180) d -= 360;
      if (d.abs() < 1e-8) break;
      t += d / 0.9856;
    }
    return t;
  }

  // Chaitra Shukla Pratipada: the new moon with the Sun in Pisces, in
  // March/April of the year.
  var nm = calc.reach(PanchangElement.tithi, eph.julianDayUt(gregorianYear, 3, 1, 0), 0);
  while (Rashi.ofLongitude(calc.sun(nm)) != Rashi.pisces) {
    nm = calc.reach(PanchangElement.tithi, nm + 1, 0);
  }
  // Raja: the day Pratipada is observed (at the next sunrise, or the new
  // moon's own day when Pratipada ends before that sunrise).
  final nextRise = eph.sunEvent(nm, place.latitude, place.longitude, rise: true) ?? nm + 0.5;
  final kshaya = calc.indexAt(PanchangElement.tithi, nextRise) != 1;
  final out = <MantriOffice, Graha>{
    MantriOffice.raja: lordAt(kshaya ? nm : nextRise + 0.01),
  };
  final yearStart = nm;
  for (final e in _officeSign.entries) {
    out[e.key] = lordAt(sunReach(yearStart, e.value.index * 30.0));
  }
  out[MantriOffice.meghadhipati] = lordAt(sunReach(yearStart, 5 * 360 / 27));
  return out;
}
