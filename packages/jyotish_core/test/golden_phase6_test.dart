import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

import 'support/test_ephemeris.dart';

void main() {
  late Ephemeris eph;
  setUpAll(() async => eph = await loadTestEphemeris());

  test('navatara cycles from the birth star', () {
    final n = navatara(Nakshatra.bharani);
    expect(n[0], [Nakshatra.bharani, Nakshatra.purvaPhalguni, Nakshatra.purvaAshadha]);
    expect(n[8], [Nakshatra.magha, Nakshatra.mula, Nakshatra.ashwini]);
  });

  test('baladi and jagratadi boundaries', () {
    expect(baladi(1), Baladi.bala); // Aries 1°
    expect(baladi(29), Baladi.mrita);
    expect(baladi(31), Baladi.mrita); // Taurus 1° (even: reversed)
    expect(jagratadi(5), Jagratadi.jagrat);
    expect(jagratadi(35), Jagratadi.sushupta);
  });

  for (final g in loadGoldenCharts()) {
    final p6 = (g['expected'] as Map<String, dynamic>)['phase6'] as Map<String, dynamic>?;
    if (p6 == null) continue;

    group('${g['id']} phase 6', () {
      late ChartAnalysis a;
      setUpAll(() => a = ChartAnalysis.of(RasiChart.calculate(eph, birthFromGolden(g)), eph));

      test('Sun-based upagrahas match AstroSage (±2′)', () {
        final u = upagrahas(a, eph);
        final want = (p6['upagrahas'] as Map).cast<String, List>();
        for (final up in [Upagraha.dhuma, Upagraha.vyatipata, Upagraha.parivesha,
            Upagraha.indrachapa, Upagraha.upaketu]) {
          final w = want[up.name]!;
          expect(Rashi.ofLongitude(u[up]!).name, w[0], reason: up.name);
          final diff = ((norm360(u[up]!) % 30 - parseDms(w[1] as String)) * 60).abs();
          expect(diff, lessThan(2), reason: '${up.name} minutes');
        }
      });

      test('Baladi and Jagratadi match AstroSage', () {
        for (final e in (p6['baladi'] as Map).cast<String, String>().entries) {
          final lon = a.chart.grahas[Graha.values.byName(e.key)]!.longitude;
          expect(baladi(lon).name, e.value, reason: e.key);
        }
        for (final e in (p6['jagratadi'] as Map).cast<String, String>().entries) {
          final lon = a.chart.grahas[Graha.values.byName(e.key)]!.longitude;
          expect(jagratadi(lon).name, e.value, reason: e.key);
        }
      });

      test('Arudha padas match AstroSage', () {
        final ar = arudhas(a.chart);
        final want = (p6['arudhas'] as Map).cast<String, String>();
        for (var i = 1; i <= 12; i++) {
          expect(ar[i - 1].name, want['A$i'], reason: 'A$i');
        }
      });

      test('Mangal dosha and Kaal Sarp agree with AstroSage', () {
        final y = {for (final r in yogas(a)) r.id: r};
        final want = p6['yogas'] as Map<String, dynamic>;
        expect(y['mangal']!.present, want['mangalDosha']);
        // Found from the lagna (Mars in the 2nd) but cancelled by Jupiter.
        expect(y['mangal']!.found, isTrue);
        expect(y['mangal']!.cancelled, isTrue);
        expect(y['kaalSarp']!.present, want['kaalSarp']);
      });

      test('a yoga that did not form is never marked cancelled', () {
        for (final y in yogas(a)) {
          if (!y.found) expect(y.cancelled, isFalse, reason: y.id);
        }
      });

      test('named yogas present in AstroSage', () {
        final y = {for (final r in yogas(a)) r.id: r};
        // AstroSage names → our ids (Maala not implemented: definition unknown).
        const map = {
          'Malavya': 'malavya', 'Saraswati': 'saraswati', 'Vosi': 'vosi',
          'Parvata': 'parvata', 'Anapha': 'anapha', 'Dhana': 'dhana',
          'Parashari Raja': 'raja',
        };
        for (final e in map.entries) {
          expect(y[e.value]!.present, isTrue, reason: e.key);
        }
        // ignore: avoid_print
        print('present: ${[for (final r in y.values) if (r.present) r.id]}');
      });

      test('Sade Sati and Small Panoti periods match AstroSage (±3 days)', () {
        final ss = sadeSati(a.chart, eph);
        final rows = (p6['sadeSati'] as List).cast<List>();
        for (var i = 0; i < rows.length; i++) {
          final r = rows[i];
          final s = ss[i];
          expect(s.kind == SadeSatiKind.sadeSati ? 'sade' : 'small', r[0], reason: 'row $i kind');
          expect(s.sign.name, r[1], reason: 'row $i sign');
          double jd(String d) {
            final p = d.split('-').map(int.parse).toList();
            return eph.julianDayUt(p[0], p[1], p[2], 0);
          }
          // AstroSage prints the first day; ingress may be on the previous
          // local day, so compare within 3 days.
          if (i > 0) {
            expect((s.start - jd(r[2] as String)).abs(), lessThan(3), reason: 'row $i start');
          }
          expect((s.end - jd(r[3] as String)).abs(), lessThan(3), reason: 'row $i end');
        }
      });
    });
  }
}
