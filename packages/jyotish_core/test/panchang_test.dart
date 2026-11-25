import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

import 'support/test_ephemeris.dart';

const agra = PanchangPlace(latitude: 27.1767, longitude: 78.0081, utcOffsetHours: 5.5, name: 'Agra');

void main() {
  late Ephemeris eph;
  late PanchangCalc calc;
  setUpAll(() async {
    eph = await loadTestEphemeris();
    calc = PanchangCalc(eph);
  });

  String t(DayPanchang d, double jd) => Dms.of(d.localHours(jd)).clock;

  test('element spans are contiguous and cover the day', () {
    final d = DayPanchang.of(calc, agra, DateTime.utc(2026, 11, 25));
    for (final list in [d.tithis, d.nakshatras, d.yogas, d.karanas]) {
      expect(list.first.contains(d.sunrise), isTrue);
      expect(list.last.end, greaterThanOrEqualTo(d.nextSunrise));
      for (var i = 1; i < list.length; i++) {
        expect(list[i].start, closeTo(list[i - 1].end, 1e-6));
        expect(list[i].index, list[i - 1].index % (list == d.karanas ? 60 : (list == d.tithis ? 30 : 27)) + 1);
      }
    }
  });

  test('horas: 24, starting with the weekday lord, Chaldean order', () {
    final d = DayPanchang.of(calc, agra, DateTime.utc(2026, 11, 22)); // Sunday
    final h = horas(d);
    expect(h.length, 24);
    expect(h.take(8).map((x) => x.value).toList(), [
      Graha.sun, Graha.venus, Graha.mercury, Graha.moon, Graha.saturn,
      Graha.jupiter, Graha.mars, Graha.sun,
    ]);
    expect(h[12].start, closeTo(d.sunset, 1e-9));
    expect(h.last.end, closeTo(d.nextSunrise, 1e-9));
  });

  test('chogadia: standard Sunday and Monday sequences', () {
    List<Chogadia> seq(DateTime day) => chogadias(DayPanchang.of(calc, agra, day))
        .map((c) => c.value).toList();
    const u = Chogadia.udveg, c = Chogadia.char, l = Chogadia.labh,
        a = Chogadia.amrit, k = Chogadia.kaal, s = Chogadia.shubh, r = Chogadia.rog;
    expect(seq(DateTime.utc(2026, 11, 22)), [u, c, l, a, k, s, r, u, s, a, c, r, k, l, u, s]);
    expect(seq(DateTime.utc(2026, 11, 23)).take(8).toList(), [a, k, s, r, u, c, l, a]);
    expect(seq(DateTime.utc(2026, 11, 23)).skip(8).toList(), [c, r, k, l, u, s, a, c]);
  });

  test('Rahu kaal by weekday', () {
    // Monday: 2nd eighth of the day.
    final d = DayPanchang.of(calc, agra, DateTime.utc(2026, 11, 23));
    final k = dayKaals(d);
    expect(k[Kaal.rahu]!.start, closeTo(d.sunrise + d.dayLength / 8, 1e-9));
    expect(k[Kaal.abhijit]!.start, closeTo(d.sunrise + 7 * d.dayLength / 15, 1e-9));
  });

  test('lagna table covers the day with 12 or 13 entries', () {
    final d = DayPanchang.of(calc, agra, DateTime.utc(2026, 11, 25));
    final lt = lagnaTable(d, eph, calc);
    expect(lt.length, inInclusiveRange(12, 13));
    expect(lt.first.start, d.sunrise);
    expect(lt.last.end, d.nextSunrise);
  });

  test('Bhadra is Vishti karana; Panchak is Moon in Aquarius/Pisces', () {
    final from = eph.julianDayUt(2026, 11, 1, 0), to = from + 30;
    final b = bhadra(calc, from, to);
    expect(b.length, inInclusiveRange(7, 10));
    for (final x in b) {
      expect(karanaName(calc.indexAt(PanchangElement.karana, (x.start + x.end) / 2)), 'Vishti');
    }
    final p = panchak(calc, from, to);
    expect(p, isNotEmpty);
    for (final x in p) {
      expect(calc.moon((x.start + x.end) / 2), greaterThanOrEqualTo(300));
      expect((x.end - x.start), inInclusiveRange(4, 6));
    }
  });

  test('2026 vrat list has the right counts', () {
    final v = vratDays(calc, agra, 2026);
    int n(Vrat k) => v.where((x) => x.vrat == k).length;
    expect(n(Vrat.sankranti), 12);
    expect(n(Vrat.ekadashi), inInclusiveRange(24, 26));
    expect(n(Vrat.purnima), inInclusiveRange(12, 13));
    expect(n(Vrat.amavasya), inInclusiveRange(12, 13));
    expect(n(Vrat.pradosh), inInclusiveRange(24, 26));
    expect(n(Vrat.sankashti), inInclusiveRange(12, 13));
    expect(n(Vrat.masikShivaratri), inInclusiveRange(12, 13));
  });

  test('print today at Agra', () {
    final d = DayPanchang.of(calc, agra, DateTime.utc(2026, 11, 25));
    final b = StringBuffer('\nsunrise ${t(d, d.sunrise)} sunset ${t(d, d.sunset)} '
        'moonrise ${d.moonrise == null ? '-' : t(d, d.moonrise!)} moonset ${d.moonset == null ? '-' : t(d, d.moonset!)}\n');
    for (final x in d.tithis) { b.writeln('tithi ${tithiName(x.index)} ${x.index} until ${t(d, x.end)}'); }
    for (final x in d.nakshatras) { b.writeln('nak ${Nakshatra.values[x.index - 1].label} until ${t(d, x.end)}'); }
    for (final x in d.yogas) { b.writeln('yoga ${yogaNames[x.index - 1]} until ${t(d, x.end)}'); }
    for (final x in d.karanas) { b.writeln('karana ${karanaName(x.index)} until ${t(d, x.end)}'); }
    b.writeln('month ${lunarMonths[d.month.amanta]} / purnimanta ${lunarMonths[d.month.purnimanta]} adhika ${d.month.adhika} shaka ${d.shaka} vikram ${d.vikram}');
    final k = dayKaals(d);
    for (final e in k.entries) { b.writeln('${e.key.name} ${t(d, e.value.start)}-${t(d, e.value.end)}'); }
    final v = vratDays(calc, agra, 2026).where((x) => x.date.month >= 11);
    for (final x in v) { b.writeln('${x.vrat.name} ${x.date.toIso8601String().substring(0, 10)} ${x.tithi} ${x.sign?.label ?? ''}'); }
    // ignore: avoid_print
    print(b);
  });
}
