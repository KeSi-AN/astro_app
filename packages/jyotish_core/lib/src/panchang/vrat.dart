import '../ephemeris/ephemeris.dart';
import '../model/enums.dart';
import 'day_panchang.dart';

enum Vrat {
  ekadashi, purnima, amavasya, pradosh, sankashti, masikShivaratri, sankranti,
}

class VratDay {
  const VratDay(this.vrat, this.date, this.tithi, {this.sign, this.at});
  final Vrat vrat;

  /// Civil date at the place.
  final DateTime date;

  /// Tithi (1–30) that makes it the vrat day; 0 for Sankranti.
  final int tithi;

  /// Sankranti: the sign the Sun enters, and the ingress time (JD UT).
  final Rashi? sign;
  final double? at;
}

/// Vrat and festival days of [year] at [place] (Smarta rules):
/// Ekadashi — tithi 11/26 at sunrise; Purnima/Amavasya — tithi 15/30 at
/// sunrise; Pradosh — tithi 13/28 at sunset or 6 ghatis after; Sankashti — tithi 19 at
/// moonrise; Masik Shivaratri — tithi 29 at local midnight. When a tithi
/// holds at no observation time (kshaya) the day it begins is used.
List<VratDay> vratDays(
  PanchangCalc calc,
  PanchangPlace place,
  int year, {
  SunriseMode sunriseMode = SunriseMode.upperLimb,
}) {
  final eph = calc.eph;
  final out = <VratDay>[];

  void add(Vrat v, DateTime d, int tithi) {
    // A tithi that holds at two sunrises (vriddhi) gives the vrat once:
    // keep the first day.
    final dup = out.any((x) =>
        x.vrat == v && x.tithi == tithi && d.difference(x.date).inDays.abs() <= 3);
    if (!dup) out.add(VratDay(v, d, tithi));
  }

  final days = DateTime.utc(year + 1).difference(DateTime.utc(year)).inDays;
  int? prevSunriseTithi;
  for (var i = -1; i <= days; i++) {
    final date = DateTime.utc(year, 1, 1).add(Duration(days: i));
    final midnight = eph.julianDayUt(date.year, date.month, date.day, 0) -
        place.utcOffsetHours / 24;
    final rise = eph.sunEvent(midnight, place.latitude, place.longitude,
            rise: true, mode: sunriseMode) ??
        midnight + 0.25;
    final set = eph.sunEvent(rise, place.latitude, place.longitude,
            rise: false, mode: sunriseMode) ??
        rise + 0.5;
    final moonrise =
        eph.moonEvent(midnight, place.latitude, place.longitude, rise: true);
    final atRise = calc.indexAt(PanchangElement.tithi, rise);
    final atSet = calc.indexAt(PanchangElement.tithi, set);
    final atMidnight = calc.indexAt(PanchangElement.tithi, midnight + 1);
    final atMoonrise = moonrise == null
        ? null
        : calc.indexAt(PanchangElement.tithi, moonrise);

    if (i >= 0 && i < days) {
      // Sunrise tithis, including a skipped (kshaya) one between sunrises.
      final sunriseTithis = <int>{atRise};
      if (prevSunriseTithi != null) {
        final gap = (atRise - prevSunriseTithi - 1) % 30;
        if (gap == 1) sunriseTithis.add((prevSunriseTithi % 30) + 1);
      }
      for (final t in sunriseTithis) {
        if (t == 11 || t == 26) add(Vrat.ekadashi, date, t);
        if (t == 15) add(Vrat.purnima, date, t);
        if (t == 30) add(Vrat.amavasya, date, t);
      }
      // Pradosh: trayodashi during the pradosh kaal (sunset + 6 ghatis).
      final atPradoshEnd = calc.indexAt(PanchangElement.tithi, set + 0.1);
      for (final t in {atSet, atPradoshEnd}) {
        if (t == 13 || t == 28) add(Vrat.pradosh, date, t);
      }
      if (atMoonrise == 19) add(Vrat.sankashti, date, 19);
      if (atMidnight == 29) add(Vrat.masikShivaratri, date, 29);

      // Sankranti: the Sun changes sign during this civil day.
      final s0 = Rashi.ofLongitude(calc.sun(midnight)).index;
      final s1 = Rashi.ofLongitude(calc.sun(midnight + 1)).index;
      if (s0 != s1) {
        var lo = midnight, hi = midnight + 1;
        for (var k = 0; k < 30; k++) {
          final mid = (lo + hi) / 2;
          if (Rashi.ofLongitude(calc.sun(mid)).index == s0) {
            lo = mid;
          } else {
            hi = mid;
          }
        }
        out.add(VratDay(Vrat.sankranti, date, 0,
            sign: Rashi.values[s1], at: hi));
      }
    }
    prevSunriseTithi = atRise;
  }
  out.sort((a, b) => a.date.compareTo(b.date));
  return out;
}
