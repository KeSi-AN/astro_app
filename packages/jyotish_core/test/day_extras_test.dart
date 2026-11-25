import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

import 'support/test_ephemeris.dart';

/// Against Drik Panchang (Android 2.6.7), New Delhi, 26 Nov – 1 Dec 2026.
/// Screens: REA/drikpanchang/live and live/week. Times ±2 minutes.
void main() {
  late PanchangCalc calc;
  const delhi = PanchangPlace(
    latitude: 28.6,
    longitude: 77.2,
    utcOffsetHours: 5.5,
    name: 'New Delhi',
  );
  setUpAll(() async => calc = PanchangCalc(await loadTestEphemeris()));

  DayPanchang day(int m, int d) => DayPanchang.of(calc, delhi, DateTime(2026, m, d));

  /// Minutes after local midnight of the panchang date (may exceed 1440).
  int mins(DayPanchang d, double jd) {
    final mid = calc.eph.julianDayUt(d.date.year, d.date.month, d.date.day, 0) - 5.5 / 24;
    return ((jd - mid) * 1440).round();
  }

  int hm(String s) {
    final p = s.split(':').map(int.parse).toList();
    return p[0] * 60 + p[1];
  }

  void near(DayPanchang d, double jd, String expected, {String? reason, int tol = 2}) {
    expect(mins(d, jd), closeTo(hm(expected), tol), reason: reason ?? expected);
  }

  // Baana follows the Sun's degree; Drik's Lahiri is ~16" above ours (it
  // leaves out nutation), so its Baana changes come 4–6 minutes later.
  const baanaTol = 7;

  List<TimeSpan<SpecialTime>> of(List<TimeSpan<SpecialTime>> l, SpecialTime k) =>
      l.where((x) => x.value == k).toList();

  test('Thu 26 Nov: muhurtas, Varjyam, Amrit Kalam, sandhyas', () {
    final d = day(11, 26);
    final s = specialTimes(calc, d);
    final dur = of(s, SpecialTime.durMuhurtam);
    expect(dur.length, 2);
    near(d, dur[0].start, '10:23');
    near(d, dur[1].start, '14:36');
    near(d, dur[1].end, '15:18');
    final varj = of(s, SpecialTime.varjyam).single;
    near(d, varj.start, '25:15'); // 01:15 AM Nov 27
    near(d, varj.end, '26:41');
    final amrit = of(s, SpecialTime.amritKalam);
    near(d, amrit[0].start, '10:01');
    near(d, amrit[0].end, '11:26');
    near(d, amrit[1].start, '30:14');
    near(d, of(s, SpecialTime.brahmaMuhurta).single.start, '05:05');
    near(d, of(s, SpecialTime.brahmaMuhurta).single.end, '05:58');
    near(d, of(s, SpecialTime.pratahSandhya).single.start, '05:32');
    near(d, of(s, SpecialTime.vijayaMuhurta).single.start, '13:54');
    near(d, of(s, SpecialTime.godhuli).single.start, '17:22');
    near(d, of(s, SpecialTime.godhuli).single.end, '17:49');
    near(d, of(s, SpecialTime.sayahnaSandhya).single.end, '18:45');
    near(d, of(s, SpecialTime.nishita).single.start, '23:42');
    near(d, of(s, SpecialTime.nishita).single.end, '24:36');
    expect(of(s, SpecialTime.sarvarthaSiddhi), isEmpty);
    expect(of(s, SpecialTime.raviYoga), isEmpty);
  });

  test('Thu 26 Nov: Baana, Anandadi, nivas, calendars', () {
    final d = day(11, 26);
    final b = baanas(calc, d);
    expect(b.single.value, Baana.mrityu);
    near(d, b.single.start, '17:33', tol: baanaTol);
    final a = anandadiYogas(calc, d);
    expect(a.map((x) => anandadiNames[x.value]), ['Mrityu', 'Kana']);
    near(d, a.first.end, '17:47');

    final n = Nivas.of(calc, d);
    expect(n.homahutis.single.value, Graha.mars);
    expect(n.agnivasas.single.value, Agnivasa.prithvi);
    expect(n.shivavasas.map((x) => x.value), [Shivavasa.sabha, Shivavasa.krida]);
    near(d, n.shivavasas.first.end, '13:15');
    expect(n.chandraVasas.map((x) => x.value), [Direction.south, Direction.west]);
    near(d, n.chandraVasas.first.end, '07:11');
    expect(n.bhadravasas.single.value, Bhadravasa.swarga);
    near(d, n.bhadravasas.single.start, '23:30');
    expect(dishaShool[sundayIndex(d)], Direction.south);
    expect(rahuVasa[sundayIndex(d)], Direction.south);

    expect(pravishte(calc, d), 11);
    expect(samvatsaraNames[shakaSamvatsara(d.shaka)], 'Parabhava');
    expect(samvatsaraNames[vikramSamvatsara(d.vikram)], 'Siddharthi');
    expect(gujaratiYear(d), 2083);
    expect(samvatsaraNames[gujaratiSamvatsara(gujaratiYear(d))], 'Kalayukta');
    final trop = calc.sun(d.sunrise) + calc.eph.ayanamsa(d.sunrise, calc.settings);
    expect(drikRitu(trop), Ritu.hemanta);
    expect(vedicRitu(d.sunSign), Ritu.sharad);
    expect(isUttarayana(trop), isFalse);
    final jd0 = civilJd(calc.eph, d.date);
    expect(kaliAhargana(jd0), 1872905);
    expect(rataDie(jd0), 739946);
    expect(julianCalendarDate(jd0), (2026, 11, 13));
    expect(nationalCivilDate(d.date), (1948, 9, 5));
  });

  test('Thu 26 Nov: Panchaka Rahita and Gowri', () {
    final d = day(11, 26);
    final p = panchakaRahita(d, lagnaTable(d, calc.eph, calc));
    final expected = [
      (Baana.roga, '06:52'), (null, '08:29'), (Baana.mrityu, '10:33'),
      (Baana.agni, '12:16'), (null, '13:15'), (Baana.raja, '13:43'),
      (Baana.agni, '15:08'), (null, '16:43'), (Baana.raja, '17:47'),
      (null, '18:39'), (Baana.chora, '20:53'), (null, '23:14'),
      (Baana.roga, '25:31'), (null, '27:47'), (Baana.mrityu, '30:07'),
    ];
    expect(p.length, expected.length);
    for (var i = 0; i < p.length; i++) {
      expect(p[i].value, expected[i].$1, reason: 'segment $i');
      near(d, p[i].start, expected[i].$2, reason: 'segment $i');
    }
    final g = gowriPanchangam(d);
    expect(g.take(8).map((x) => x.value), [
      Gowri.dhanam, Gowri.sugam, Gowri.soram, Gowri.uthi,
      Gowri.amirdha, Gowri.visham, Gowri.rogam, Gowri.laabam,
    ]);
    expect(g[8].value, Gowri.amirdha);
    near(d, g[1].start, '08:11');
  });

  test('Fri 27 – Tue 1 Dec: yogas, Baana and Varjyam move as in Drik', () {
    final fri = day(11, 27);
    final sf = specialTimes(calc, fri);
    near(fri, of(sf, SpecialTime.sarvarthaSiddhi).single.start, '15:08');
    near(fri, of(sf, SpecialTime.varjyam).single.start, '25:59');
    expect(baanas(calc, fri).map((x) => x.value), [Baana.mrityu, Baana.agni]);
    near(fri, baanas(calc, fri).first.end, '17:17', tol: baanaTol);
    expect(anandadiYogas(calc, fri).map((x) => anandadiNames[x.value]), ['Padma', 'Lumbaka']);

    final sun = day(11, 29);
    final ss = specialTimes(calc, sun);
    near(sun, of(ss, SpecialTime.raviPushya).single.end, '10:59');
    near(sun, of(ss, SpecialTime.sarvarthaSiddhi).single.end, '10:59');
    near(sun, of(ss, SpecialTime.raviYoga).single.start, '10:59');
    near(sun, of(ss, SpecialTime.gandaMoola).single.start, '10:59');
    near(sun, of(ss, SpecialTime.durMuhurtam).single.start, '16:00');
    expect(baanas(calc, sun).single.value, Baana.raja);
    near(sun, baanas(calc, sun).single.start, '16:42', tol: baanaTol);
    expect(Nivas.of(calc, sun).homahutis.single.value, Graha.jupiter);
    expect(rahuVasa[sundayIndex(sun)], Direction.north);

    final mon = day(11, 30);
    final sm = specialTimes(calc, mon);
    near(mon, of(sm, SpecialTime.amritKalam).first.start, '08:11');
    near(mon, of(sm, SpecialTime.varjyam).single.start, '21:21');
    expect(Nivas.of(calc, mon).agnivasas.map((x) => x.value), [Agnivasa.akasha, Agnivasa.patala]);

    final tue = day(12, 1);
    final st = specialTimes(calc, tue);
    near(tue, of(st, SpecialTime.varjyam).single.start, '16:58');
    near(tue, of(st, SpecialTime.amritKalam).single.start, '26:32');
    expect(of(st, SpecialTime.durMuhurtam).length, 2);
    near(tue, of(st, SpecialTime.durMuhurtam)[0].start, '09:02');
    near(tue, of(st, SpecialTime.durMuhurtam)[1].start, '22:49');
    expect(Nivas.of(calc, tue).homahutis.map((x) => x.value), [Graha.jupiter, Graha.rahu]);
  });

  test('Chandrabalam and Tarabalam as Drik grades them', () {
    expect(chandrabalam(Rashi.aries, Rashi.taurus), Bala.pujaNeeded);
    expect(chandrabalam(Rashi.aries, Rashi.gemini), Bala.good);
    expect(chandrabalam(Rashi.gemini, Rashi.taurus), Bala.bad);
    expect(chandrabalam(Rashi.leo, Rashi.taurus), Bala.good);
    expect(tarabalam(0, 4), Tara.pratyari); // Ashwini native, Moon in Mrigashira
    expect(tarabalam(0, 5), Tara.sadhaka);
    expect(tarabalam(16, 4), Tara.naidhana); // Anuradha, Mrigashira
  });
}
