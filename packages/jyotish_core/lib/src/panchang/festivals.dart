import 'dart:math';

import '../ephemeris/ephemeris.dart';
import '../model/enums.dart';
import 'day_panchang.dart';
import 'muhurta.dart' show bhadra;

/// The part of the day when a festival's tithi must run.
enum Kala {
  /// At sunrise (udaya tithi); a kshaya tithi counts on the day it begins.
  sunrise,

  /// Midday (the 3rd fifth of daylight).
  madhyahna,

  /// Afternoon (the 4th fifth of daylight).
  aparahna,

  /// Evening: the first 6 ghatis (2 h 24 m) after sunset.
  pradosh,

  /// Midnight: the 8th of the 15 night muhurtas.
  nishita,

  /// At moonrise.
  moonrise,
}

/// A festival fixed by lunar month (amanta, 0 = Chaitra) and tithi (1–30),
/// observed on the day the tithi runs at [kala]; or by a solar ingress.
class FestivalRule {
  const FestivalRule(
    this.id,
    this.month,
    this.tithi,
    this.kala, {
    this.dayAfter = false,
    this.allowAdhika = false,
    this.special,
  }) : sign = null;
  const FestivalRule.solar(this.id, this.sign, {this.dayAfter = false})
      : month = -1,
        tithi = 0,
        kala = Kala.sunrise,
        allowAdhika = false,
        special = null;

  final String id;
  final int month;
  final int tithi;
  final Kala kala;
  final Rashi? sign;

  /// Observed the civil day after the one found (Holi after Holika Dahan).
  final bool dayAfter;

  /// Also kept in an adhika month (Drik keeps Ganga Dussehra there).
  final bool allowAdhika;

  /// Extra rule: 'holika' (Bhadra at pradosh), 'raksha' (Bhadra at
  /// aparahna), 'triMuhurta' (the udaya tithi must last 3 muhurtas).
  final String? special;
}

/// Major North Indian festivals (amanta months: Krishna paksha festivals
/// named in purnimanta, e.g. Janmashtami "Bhadrapada K8", fall in the
/// previous amanta month).
const festivalRules = <FestivalRule>[
  FestivalRule.solar('makarSankranti', Rashi.capricorn),
  FestivalRule('vasantPanchami', 10, 5, Kala.madhyahna),
  FestivalRule('rathaSaptami', 10, 7, Kala.sunrise),
  FestivalRule('mahaShivaratri', 10, 29, Kala.nishita),
  FestivalRule('holikaDahan', 11, 15, Kala.pradosh, special: 'holika'),
  FestivalRule('holi', 11, 15, Kala.pradosh, dayAfter: true, special: 'holika'),
  FestivalRule('chaitraNavratri', 0, 1, Kala.sunrise),
  FestivalRule('ramNavami', 0, 9, Kala.madhyahna),
  FestivalRule('hanumanJayanti', 0, 15, Kala.sunrise),
  FestivalRule('akshayaTritiya', 1, 3, Kala.sunrise, special: 'triMuhurta'),
  FestivalRule('buddhaPurnima', 1, 15, Kala.sunrise),
  FestivalRule('vatSavitri', 1, 30, Kala.sunrise),
  FestivalRule('gangaDussehra', 2, 10, Kala.sunrise, allowAdhika: true),
  FestivalRule('nirjalaEkadashi', 2, 11, Kala.sunrise),
  FestivalRule('rathYatra', 3, 2, Kala.sunrise),
  FestivalRule('devshayaniEkadashi', 3, 11, Kala.sunrise),
  FestivalRule('guruPurnima', 3, 15, Kala.sunrise),
  FestivalRule('hariyaliTeej', 4, 3, Kala.sunrise),
  FestivalRule('nagPanchami', 4, 5, Kala.sunrise),
  FestivalRule('rakshaBandhan', 4, 15, Kala.aparahna, special: 'raksha'),
  FestivalRule('kajariTeej', 4, 18, Kala.sunrise),
  FestivalRule('janmashtami', 4, 23, Kala.nishita),
  FestivalRule('hartalikaTeej', 5, 3, Kala.sunrise),
  FestivalRule('ganeshChaturthi', 5, 4, Kala.madhyahna),
  FestivalRule('rishiPanchami', 5, 5, Kala.madhyahna),
  FestivalRule('anantChaturdashi', 5, 14, Kala.sunrise),
  FestivalRule('sarvaPitruAmavasya', 5, 30, Kala.aparahna),
  FestivalRule('sharadNavratri', 6, 1, Kala.sunrise),
  FestivalRule('durgaAshtami', 6, 8, Kala.sunrise),
  FestivalRule('mahaNavami', 6, 9, Kala.aparahna),
  FestivalRule('dussehra', 6, 10, Kala.aparahna),
  FestivalRule('sharadPurnima', 6, 15, Kala.pradosh),
  FestivalRule('karwaChauth', 6, 19, Kala.moonrise),
  FestivalRule('ahoiAshtami', 6, 23, Kala.pradosh),
  FestivalRule('dhanteras', 6, 28, Kala.pradosh),
  FestivalRule('narakChaturdashi', 6, 29, Kala.sunrise),
  FestivalRule('diwali', 6, 30, Kala.pradosh),
  FestivalRule('govardhanPuja', 7, 1, Kala.sunrise),
  FestivalRule('bhaiDooj', 7, 2, Kala.aparahna),
  FestivalRule('chhathPuja', 7, 6, Kala.sunrise),
  FestivalRule('devUthaniEkadashi', 7, 11, Kala.sunrise),
  FestivalRule('kartikPurnima', 7, 15, Kala.sunrise),
  FestivalRule('vivahPanchami', 8, 5, Kala.sunrise),
  FestivalRule('gitaJayanti', 8, 11, Kala.sunrise),
  FestivalRule('dattaJayanti', 8, 15, Kala.pradosh),
  FestivalRule('mauniAmavasya', 9, 30, Kala.sunrise),
];

class FestivalDay {
  const FestivalDay(this.id, this.date);
  final String id;

  /// Civil date at the place.
  final DateTime date;
}

/// Times of one civil day at a place (JD UT).
class _Day {
  _Day(this.date, this.sunrise, this.sunset, this.nextSunrise, this.moonrise);
  final DateTime date;
  final double sunrise, sunset, nextSunrise;
  final double? moonrise;
}

/// Festivals of [rules] falling in civil [year] at [place].
List<FestivalDay> festivalsOfYear(
  PanchangCalc calc,
  PanchangPlace place,
  int year, {
  List<FestivalRule> rules = festivalRules,
  SunriseMode sunriseMode = SunriseMode.upperLimb,
}) {
  final eph = calc.eph;
  final days = <_Day>[];
  final n = DateTime.utc(year + 1).difference(DateTime.utc(year)).inDays;
  for (var i = -2; i <= n + 1; i++) {
    final date = DateTime.utc(year, 1, 1).add(Duration(days: i));
    final midnight = eph.julianDayUt(date.year, date.month, date.day, 0) -
        place.utcOffsetHours / 24;
    double? sun(double from, bool rise) => eph.sunEvent(
        from, place.latitude, place.longitude, rise: rise, mode: sunriseMode);
    final rise = sun(midnight, true) ?? midnight + 0.25;
    final set = sun(rise, false) ?? rise + 0.5;
    final next = sun(rise + 0.5, true) ?? rise + 1;
    final moonrise = eph.moonEvent(midnight, place.latitude, place.longitude, rise: true);
    days.add(_Day(date, rise, set, next,
        moonrise != null && moonrise < midnight + 1 ? moonrise : null));
  }

  // Amanta month (0 = Chaitra) and adhika flag at a moment.
  (int, bool) monthAt(double jd) {
    final nm = calc.newMoonBefore(jd);
    final nmNext = calc.reach(PanchangElement.tithi, nm + 1, 0);
    final s = Rashi.ofLongitude(calc.sun(nm)).index;
    final sNext = Rashi.ofLongitude(calc.sun(nmNext)).index;
    return ((s + 1) % 12, s == sNext);
  }

  /// The kala of a day as a window (JD UT).
  (double, double) window(_Day d, Kala k) {
    final len = d.sunset - d.sunrise;
    return switch (k) {
      Kala.sunrise => (d.sunrise, d.sunrise),
      Kala.madhyahna => (d.sunrise + len * 0.4, d.sunrise + len * 0.6),
      Kala.aparahna => (d.sunrise + len * 0.6, d.sunrise + len * 0.8),
      Kala.pradosh => (d.sunset, d.sunset + 0.1),
      Kala.nishita => (
        d.sunset + (d.nextSunrise - d.sunset) * 7 / 15,
        d.sunset + (d.nextSunrise - d.sunset) * 8 / 15,
      ),
      Kala.moonrise => (d.moonrise ?? d.sunset + 0.1, d.moonrise ?? d.sunset + 0.1),
    };
  }

  double overlap(double a0, double a1, double b0, double b1) =>
      max(0, min(a1, b1) - max(a0, b0));

  final from = days.first.sunrise, to = days.last.nextSunrise;
  final tithis = calc.spansBetween(PanchangElement.tithi, from, to);
  final bhadraSpans = bhadra(calc, from, to);
  bool bhadraCovers(double a, double b) =>
      bhadraSpans.any((x) => x.start <= a + 1e-6 && x.end >= b - 1e-6);

  final out = <FestivalDay>[];
  for (final r in rules) {
    if (r.sign != null) {
      // The civil day of the ingress, or the next day if it comes after
      // sunset (the punya kaal is then the next morning).
      for (var i = 0; i < days.length - 1; i++) {
        final d = days[i];
        final atRise = Rashi.ofLongitude(calc.sun(d.sunrise));
        final atNext = Rashi.ofLongitude(calc.sun(d.nextSunrise));
        if (atRise == r.sign || atNext != r.sign) continue;
        final afterSunset = Rashi.ofLongitude(calc.sun(d.sunset)) != r.sign;
        final date = afterSunset ? days[i + 1].date : d.date;
        if (date.year == year) out.add(FestivalDay(r.id, date));
      }
      continue;
    }
    for (final t in tithis.where((x) => x.index == r.tithi)) {
      final (m, adhika) = monthAt((t.start + t.end) / 2);
      if (m != r.month || (adhika && !r.allowAdhika)) continue;
      // Civil days touching the tithi.
      final cand = [
        for (var i = 0; i < days.length; i++)
          if (days[i].nextSunrise > t.start && days[i].sunrise - 1 < t.end) i,
      ];
      int? pick;
      if (r.kala == Kala.sunrise) {
        // Udaya tithi; first day if it holds at two sunrises; the day it
        // begins if it holds at none (kshaya).
        final withRise = cand.where((i) => t.contains(days[i].sunrise)).toList();
        if (withRise.isNotEmpty) {
          pick = withRise.first;
          if (r.special == 'triMuhurta') {
            final d = days[pick];
            final muhurta = (d.sunset - d.sunrise) / 15;
            if (t.end - d.sunrise < 3 * muhurta && pick > 0) pick = pick - 1;
          }
        } else {
          pick = cand.firstWhere((i) => days[i].sunrise < t.start && days[i].nextSunrise > t.start,
              orElse: () => cand.first);
        }
      } else {
        // The day whose kala the tithi covers most (first on a tie).
        var best = 0.0;
        for (final i in cand) {
          final (w0, w1) = window(days[i], r.kala);
          final o = w0 == w1 ? (t.contains(w0) ? 1e-3 : 0.0) : overlap(w0, w1, t.start, t.end);
          if (o > best + 1e-9) {
            best = o;
            pick = i;
          }
        }
        if (pick == null) {
          // Skipped at the kala on every day: the day it holds at sunrise.
          final withRise = cand.where((i) => t.contains(days[i].sunrise));
          pick = withRise.isNotEmpty ? withRise.first : cand.first;
        }
        if (r.special == 'raksha' || r.special == 'holika') {
          final d = days[pick];
          final (w0, w1) = window(d, r.kala);
          final next = pick + 1 < days.length ? days[pick + 1] : null;
          if (next != null && bhadraCovers(max(w0, t.start), min(w1, t.end))) {
            final muhurta = (next.sunset - next.sunrise) / 15;
            final lastsNext = t.end - next.sunrise;
            if (r.special == 'raksha' && lastsNext >= 3 * muhurta) pick = pick + 1;
            if (r.special == 'holika') {
              // Purnima for 3 prahar after the next sunrise and a longer
              // pratipada: the next evening.
              final nextTithi = tithis.firstWhere((x) => x.start >= t.end - 1e-6, orElse: () => t);
              final prahar = (next.sunset - next.sunrise) / 4;
              if (lastsNext >= 3 * prahar && (nextTithi.end - nextTithi.start) > (t.end - t.start)) {
                pick = pick + 1;
              }
            }
          }
        }
      }
      var date = days[pick].date;
      if (r.dayAfter) date = date.add(const Duration(days: 1));
      // With an adhika month the festival comes twice; keep the first.
      if (r.allowAdhika &&
          out.any((x) => x.id == r.id && date.difference(x.date).inDays.abs() < 45)) {
        continue;
      }
      if (date.year == year) out.add(FestivalDay(r.id, date));
    }
  }
  out.sort((a, b) => a.date.compareTo(b.date));
  return out;
}
