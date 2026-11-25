import '../ephemeris/ephemeris.dart';
import '../model/enums.dart';
import '../model/settings.dart';
import 'birth_panchang.dart';

/// A place and its fixed clock offset for panchang calculations.
class PanchangPlace {
  const PanchangPlace({
    required this.latitude,
    required this.longitude,
    required this.utcOffsetHours,
    this.name = '',
  });
  final double latitude, longitude;
  final double utcOffsetHours;
  final String name;
}

/// A panchang element (tithi, nakshatra, yoga, karana) running over a span.
class ElementSpan {
  const ElementSpan(this.index, this.start, this.end);

  /// 1-based number (tithi 1–30, nakshatra 1–27, yoga 1–27, karana 1–60).
  final int index;

  /// Julian days (UT).
  final double start, end;
  bool contains(double jd) => jd >= start && jd < end;
}

enum PanchangElement {
  tithi(12),
  nakshatra(360 / 27),
  yoga(360 / 27),
  karana(6);

  const PanchangElement(this.size);
  final double size;
}

/// Low-level panchang calculations shared by the day view, muhurta tools
/// and the yearly vrat list.
class PanchangCalc {
  PanchangCalc(this.eph, [this.settings = const CalcSettings()]);
  final Ephemeris eph;
  final CalcSettings settings;

  double sun(double jd) => eph.position(jd, Graha.sun, settings).longitude;
  double moon(double jd) => eph.position(jd, Graha.moon, settings).longitude;

  /// The monotonically increasing angle behind each element.
  double angle(PanchangElement e, double jd) => switch (e) {
        PanchangElement.tithi ||
        PanchangElement.karana =>
          norm360(moon(jd) - sun(jd)),
        PanchangElement.nakshatra => norm360(moon(jd)),
        PanchangElement.yoga => norm360(sun(jd) + moon(jd)),
      };

  /// Average daily motion of the angle (degrees/day), for first guesses.
  static double _rate(PanchangElement e) => switch (e) {
        PanchangElement.tithi || PanchangElement.karana => 12.19,
        PanchangElement.nakshatra => 13.18,
        PanchangElement.yoga => 14.17,
      };

  int indexAt(PanchangElement e, double jd) =>
      (angle(e, jd) / e.size).floor() + 1;

  /// Time when [e]'s angle reaches [target] (degrees), searching forward
  /// (or backward with [forward] = false) from [jd].
  double reach(PanchangElement e, double jd, double target,
      {bool forward = true}) {
    double diff(double t) {
      var d = norm360(target - angle(e, t));
      if (!forward) d -= 360;
      return d;
    }

    var t = jd + diff(jd) / _rate(e);
    for (var i = 0; i < 12; i++) {
      var d = norm360(target - angle(e, t));
      if (d > 180) d -= 360;
      if (d.abs() < 1e-7) break;
      t += d / _rate(e);
    }
    return t;
  }

  /// The span of [e] running at [jd].
  ElementSpan spanAt(PanchangElement e, double jd) {
    final i = indexAt(e, jd);
    final start = reach(e, jd, (i - 1) * e.size, forward: false);
    final end = reach(e, jd, (i * e.size) % 360);
    return ElementSpan(i, start, end);
  }

  /// Spans of [e] that overlap [from, to).
  List<ElementSpan> spansBetween(PanchangElement e, double from, double to) {
    final out = <ElementSpan>[];
    var s = spanAt(e, from);
    while (s.start < to) {
      out.add(s);
      s = spanAt(e, s.end + 1e-6);
    }
    return out;
  }

  /// Most recent new moon (end of Amavasya) at or before [jd].
  double newMoonBefore(double jd) =>
      reach(PanchangElement.tithi, jd, 0, forward: false);
}

const lunarMonths = [
  'Chaitra', 'Vaishakha', 'Jyeshtha', 'Ashadha', 'Shravana', 'Bhadrapada',
  'Ashwin', 'Kartika', 'Margashirsha', 'Pausha', 'Magha', 'Phalguna',
];

class LunarMonth {
  const LunarMonth({
    required this.amanta,
    required this.purnimanta,
    required this.adhika,
  });

  /// 0 = Chaitra … 11 = Phalguna.
  final int amanta;
  final int purnimanta;
  final bool adhika;
}

/// Everything shown for one civil day at one place.
class DayPanchang {
  DayPanchang({
    required this.date,
    required this.place,
    required this.sunrise,
    required this.sunset,
    required this.nextSunrise,
    required this.moonrise,
    required this.moonset,
    required this.weekday,
    required this.tithis,
    required this.nakshatras,
    required this.yogas,
    required this.karanas,
    required this.month,
    required this.shaka,
    required this.vikram,
    required this.sunSign,
    required this.moonSign,
  });

  final DateTime date;
  final PanchangPlace place;

  /// Julian days (UT).
  final double sunrise, sunset, nextSunrise;
  final double? moonrise, moonset;

  /// 1 = Monday … 7 = Sunday.
  final int weekday;

  /// Elements from sunrise to the next sunrise (first = running at sunrise).
  final List<ElementSpan> tithis, nakshatras, yogas, karanas;
  final LunarMonth month;
  final int shaka, vikram;
  final Rashi sunSign, moonSign;

  Graha get varaLord => varaLords[weekday - 1];
  int get paksha => tithis.first.index <= 15 ? 0 : 1; // 0 Shukla, 1 Krishna
  double get dayLength => sunset - sunrise;
  double get nightLength => nextSunrise - sunset;

  /// Local clock hours of a Julian day.
  double localHours(double jd) =>
      ((jd + 0.5 + place.utcOffsetHours / 24) % 1) * 24;

  static DayPanchang of(
    PanchangCalc calc,
    PanchangPlace place,
    DateTime date, {
    SunriseMode sunriseMode = SunriseMode.upperLimb,
  }) {
    final eph = calc.eph;
    // Local midnight starting the date, in JD UT.
    final midnight = eph.julianDayUt(date.year, date.month, date.day, 0) -
        place.utcOffsetHours / 24;
    double? sunEv(double from, bool rise) => eph.sunEvent(
        from, place.latitude, place.longitude, rise: rise, mode: sunriseMode);
    final sunrise = sunEv(midnight, true) ?? midnight + 0.25;
    final sunset = sunEv(sunrise, false) ?? sunrise + 0.5;
    final next = sunEv(sunrise + 0.5, true) ?? sunrise + 1;
    final moonrise =
        eph.moonEvent(midnight, place.latitude, place.longitude, rise: true);
    final moonset =
        eph.moonEvent(midnight, place.latitude, place.longitude, rise: false);

    // Lunar month: named after the Sun's sign at the new moon that begins
    // it (Sun in Pisces → Chaitra); adhika if the next new moon falls in
    // the same sign.
    final nm = calc.newMoonBefore(sunrise);
    final nmNext = calc.reach(PanchangElement.tithi, nm + 1, 0);
    final signAtNm = Rashi.ofLongitude(calc.sun(nm)).index;
    final signAtNext = Rashi.ofLongitude(calc.sun(nmNext)).index;
    final amanta = (signAtNm + 1) % 12;
    final tithi = calc.indexAt(PanchangElement.tithi, sunrise);
    final month = LunarMonth(
      amanta: amanta,
      purnimanta: tithi > 15 ? (amanta + 1) % 12 : amanta,
      adhika: signAtNm == signAtNext,
    );
    final shaka = date.year - 78 - (date.month <= 4 && amanta >= 8 ? 1 : 0);

    return DayPanchang(
      date: date,
      place: place,
      sunrise: sunrise,
      sunset: sunset,
      nextSunrise: next,
      moonrise: moonrise != null && moonrise < midnight + 1 ? moonrise : null,
      moonset: moonset != null && moonset < midnight + 1 ? moonset : null,
      weekday: date.weekday,
      tithis: calc.spansBetween(PanchangElement.tithi, sunrise, next),
      nakshatras: calc.spansBetween(PanchangElement.nakshatra, sunrise, next),
      yogas: calc.spansBetween(PanchangElement.yoga, sunrise, next),
      karanas: calc.spansBetween(PanchangElement.karana, sunrise, next),
      month: month,
      shaka: shaka,
      vikram: shaka + 135,
      sunSign: Rashi.ofLongitude(calc.sun(sunrise)),
      moonSign: Rashi.ofLongitude(calc.moon(sunrise)),
    );
  }
}
