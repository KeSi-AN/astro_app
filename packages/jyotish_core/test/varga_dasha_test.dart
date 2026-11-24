import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

import 'support/test_ephemeris.dart';

/// Longitude helper: sign index (Aries = 0) plus degrees.
double at(Rashi r, double deg) => r.index * 30 + deg;

void main() {
  group('vargas (BPHS ch. 6 rules)', () {
    void expectSign(Varga v, Rashi s, double deg, Rashi want) =>
        expect(vargaSign(at(s, deg), v), want,
            reason: '${v.code} of ${s.label} $deg°');

    test('D2 hora', () {
      expectSign(Varga.d2, Rashi.aries, 10, Rashi.leo);
      expectSign(Varga.d2, Rashi.aries, 20, Rashi.cancer);
      expectSign(Varga.d2, Rashi.taurus, 10, Rashi.cancer);
      expectSign(Varga.d2, Rashi.taurus, 20, Rashi.leo);
    });
    test('D3 drekkana: same, 5th, 9th', () {
      expectSign(Varga.d3, Rashi.aries, 5, Rashi.aries);
      expectSign(Varga.d3, Rashi.aries, 15, Rashi.leo);
      expectSign(Varga.d3, Rashi.aries, 25, Rashi.sagittarius);
      expectSign(Varga.d3, Rashi.pisces, 25, Rashi.scorpio);
    });
    test('D4, D7, D10, D12', () {
      expectSign(Varga.d4, Rashi.aries, 8, Rashi.cancer);
      expectSign(Varga.d4, Rashi.aries, 29, Rashi.capricorn);
      expectSign(Varga.d7, Rashi.aries, 0.1, Rashi.aries);
      expectSign(Varga.d7, Rashi.taurus, 0.1, Rashi.scorpio);
      expectSign(Varga.d10, Rashi.aries, 29.9, Rashi.capricorn);
      expectSign(Varga.d10, Rashi.taurus, 0.1, Rashi.capricorn);
      expectSign(Varga.d12, Rashi.aries, 29.9, Rashi.pisces);
      expectSign(Varga.d12, Rashi.leo, 2.6, Rashi.virgo);
    });
    test('D16, D20, D24, D27', () {
      expectSign(Varga.d16, Rashi.aries, 0.1, Rashi.aries);
      expectSign(Varga.d16, Rashi.taurus, 0.1, Rashi.leo);
      expectSign(Varga.d16, Rashi.gemini, 0.1, Rashi.sagittarius);
      expectSign(Varga.d20, Rashi.taurus, 0.1, Rashi.sagittarius);
      expectSign(Varga.d20, Rashi.gemini, 0.1, Rashi.leo);
      expectSign(Varga.d24, Rashi.aries, 0.1, Rashi.leo);
      expectSign(Varga.d24, Rashi.taurus, 0.1, Rashi.cancer);
      expectSign(Varga.d27, Rashi.taurus, 0.1, Rashi.cancer);
      expectSign(Varga.d27, Rashi.gemini, 0.1, Rashi.libra);
      expectSign(Varga.d27, Rashi.cancer, 0.1, Rashi.capricorn);
    });
    test('D30 trimshamsha (unequal)', () {
      expectSign(Varga.d30, Rashi.aries, 3, Rashi.aries);
      expectSign(Varga.d30, Rashi.aries, 7, Rashi.aquarius);
      expectSign(Varga.d30, Rashi.aries, 15, Rashi.sagittarius);
      expectSign(Varga.d30, Rashi.aries, 20, Rashi.gemini);
      expectSign(Varga.d30, Rashi.aries, 27, Rashi.libra);
      expectSign(Varga.d30, Rashi.taurus, 3, Rashi.taurus);
      expectSign(Varga.d30, Rashi.taurus, 10, Rashi.virgo);
      expectSign(Varga.d30, Rashi.taurus, 15, Rashi.pisces);
      expectSign(Varga.d30, Rashi.taurus, 22, Rashi.capricorn);
      expectSign(Varga.d30, Rashi.taurus, 27, Rashi.scorpio);
    });
    test('D40, D45, D60', () {
      expectSign(Varga.d40, Rashi.aries, 0.1, Rashi.aries);
      expectSign(Varga.d40, Rashi.taurus, 0.1, Rashi.libra);
      expectSign(Varga.d45, Rashi.leo, 0.1, Rashi.leo);
      expectSign(Varga.d45, Rashi.virgo, 0.1, Rashi.sagittarius);
      expectSign(Varga.d60, Rashi.aries, 0.2, Rashi.aries);
      expectSign(Varga.d60, Rashi.aries, 29.9, Rashi.pisces);
      expectSign(Varga.d60, Rashi.leo, 0.6, Rashi.virgo);
    });
    test('D9 by the explicit rule equals continuous counting', () {
      for (var d = 0.05; d < 360; d += 0.37) {
        final sign = Rashi.ofLongitude(d).index;
        final start = switch (sign % 3) { 0 => sign, 1 => sign + 8, _ => sign + 4 };
        final want = Rashi.values[(start + (d % 30 / (10 / 3)).floor()) % 12];
        expect(vargaSign(d, Varga.d9), want, reason: '$d');
      }
    });
    test('every varga sign stays the same within a division', () {
      for (final v in Varga.values) {
        if (v == Varga.d30) continue;
        final w = 30 / v.division;
        for (var k = 0; k < v.division; k++) {
          final a = vargaSign(at(Rashi.gemini, k * w + w * 0.01), v);
          final b = vargaSign(at(Rashi.gemini, k * w + w * 0.99), v);
          expect(a, b, reason: '${v.code} part $k');
        }
      }
    });
  });

  group('dashas', () {
    late Ephemeris eph;
    late RasiChart chart;
    setUpAll(() async {
      eph = await loadTestEphemeris();
      chart = RasiChart.calculate(eph, birthFromGolden(loadGoldenCharts().first));
    });

    test('Vimshottari: contiguous, covers 120 years, balance matches', () {
      final moon = chart.grahas[Graha.moon]!.longitude;
      final v = VimshottariDasha(moonLongitude: moon, birthJd: chart.jdUt);
      final md = v.mahadashas;
      expect(md.first.contains(chart.jdUt), isTrue);
      expect(md.first.lord, Graha.venus); // Moon in Bharani
      for (var i = 1; i < md.length; i++) {
        expect(md[i].start, closeTo(md[i - 1].end, 1e-6));
      }
      expect(md.last.end - chart.jdUt, greaterThanOrEqualTo(120 * 365.25 - 1e-6));
      final balanceYears = (md.first.end - chart.jdUt) / 365.25;
      expect(balanceYears, closeTo(Avakhada.of(chart).dashaBalanceYears, 1e-9));
    });

    test('Vimshottari sub-periods fill the parent, 5 levels deep', () {
      final v = VimshottariDasha(
          moonLongitude: chart.grahas[Graha.moon]!.longitude,
          birthJd: chart.jdUt);
      var p = v.mahadashas[2];
      for (var level = 2; level <= 5; level++) {
        final subs = v.subPeriods(p);
        expect(subs.length, 9);
        expect(subs.first.lord, p.lord);
        expect(subs.first.start, closeTo(p.start, 1e-9));
        expect(subs.last.end, closeTo(p.end, 1e-6));
        expect(subs.first.level, level);
        p = subs[3];
      }
      final path = v.pathAt(chart.jdUt + 5000);
      expect(path.length, 5);
      for (final q in path) {
        expect(q.contains(chart.jdUt + 5000), isTrue);
      }
    });

    test('Vimshottari matches AstroSage TestChart Moon antardashas (±10 days)', () {
      // AstroSage v32.6 Dasha screen (REA/astrosage/live/08.png): end dates
      // of the antardashas in Moon mahadasha.
      const ends = [
        (Graha.moon, 2036, 3, 21), (Graha.mars, 2036, 10, 21),
        (Graha.rahu, 2038, 4, 21), (Graha.jupiter, 2039, 8, 21),
        (Graha.saturn, 2041, 3, 21), (Graha.mercury, 2042, 8, 21),
        (Graha.ketu, 2043, 3, 21), (Graha.venus, 2044, 11, 21),
        (Graha.sun, 2045, 5, 21),
      ];
      final v = VimshottariDasha(
          moonLongitude: chart.grahas[Graha.moon]!.longitude,
          birthJd: chart.jdUt);
      final moonMd = v.mahadashas.firstWhere((p) => p.lord == Graha.moon);
      final ads = v.subPeriods(moonMd);
      for (var i = 0; i < ends.length; i++) {
        final (lord, y, m, d) = ends[i];
        expect(ads[i].lord, lord);
        final want = eph.julianDayUt(y, m, d, 12);
        expect((ads[i].end - want).abs(), lessThanOrEqualTo(10),
            reason: '${lord.label} ends ${ads[i].end} vs $want');
      }
    });

    test('Yogini: Bharani starts with Bhadrika; 36-year cycle', () {
      final y = YoginiDasha(
          moonLongitude: chart.grahas[Graha.moon]!.longitude,
          birthJd: chart.jdUt);
      expect(y.mahadashas.first.lord, Yogini.bhadrika);
      expect(y.mahadashas[1].lord, Yogini.ulka);
      final cycle = y.mahadashas.sublist(1, 9).fold<double>(0, (s, p) => s + p.days);
      expect(cycle / 365.25, closeTo(36, 1e-9));
      final subs = y.subPeriods(y.mahadashas[1]);
      expect(subs.length, 8);
      expect(subs.first.lord, Yogini.ulka);
      expect(subs.last.end, closeTo(y.mahadashas[1].end, 1e-6));
    });

    test('Yogini start from nakshatra + 3', () {
      // Ashwini (1+3=4) → Bhramari, Ardra (6+3=9→1) → Mangala,
      // Revati (27+3=30→6) → Ulka.
      for (final (nak, want) in [
        (Nakshatra.ashwini, Yogini.bhramari),
        (Nakshatra.ardra, Yogini.mangala),
        (Nakshatra.revati, Yogini.ulka),
      ]) {
        final y = YoginiDasha(
            moonLongitude: nak.index * Nakshatra.span + 1, birthJd: 2451545);
        expect(y.mahadashas.first.lord, want, reason: nak.label);
      }
    });

    test('Chara dasha: TestChart worked by hand (K.N. Rao rules)', () {
      // Lagna Cancer; 9th = Pisces (not savya) → sequence runs backwards.
      final c = CharaDasha(chart: chart, birthJd: chart.jdUt);
      expect(c.forward, isFalse);
      final md = c.mahadashas;
      expect(md.take(4).map((p) => p.lord).toList(),
          [Rashi.cancer, Rashi.gemini, Rashi.taurus, Rashi.aries]);
      // Cancer (counted backwards): Moon in Aries → 3 signs back = 3 years.
      expect(c.yearsOf(Rashi.cancer), 3);
      // Gemini (forwards): Mercury in Libra → 4 years.
      expect(c.yearsOf(Rashi.gemini), 4);
      // Taurus: Venus in Libra → 5 years.
      expect(c.yearsOf(Rashi.taurus), 5);
      // Aries: Mars in Leo → 4 years.
      expect(c.yearsOf(Rashi.aries), 4);
      expect(md.first.start, closeTo(chart.jdUt, 1e-9));
      expect(md.first.days / 365.25, closeTo(3, 1e-9));
      final ads = c.subPeriods(md.first);
      expect(ads.length, 12);
      expect(ads.first.lord, Rashi.gemini); // next sign backwards
      expect(ads.last.lord, Rashi.cancer); // ends with itself
    });
  });
}
