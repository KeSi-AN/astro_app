import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

import 'support/test_ephemeris.dart';

void main() {
  late Ephemeris eph;
  setUpAll(() async => eph = await loadTestEphemeris());

  test('Ashtakavarga totals are fixed by the tables', () {
    final chart = RasiChart.calculate(eph, birthFromGolden(loadGoldenCharts().first));
    final av = Ashtakavarga.of(chart);
    expect({for (final g in avGrahas) g: av.bavTotal(g)}, {
      Graha.sun: 48, Graha.moon: 49, Graha.mars: 39, Graha.mercury: 54,
      Graha.jupiter: 56, Graha.venus: 52, Graha.saturn: 39,
    });
    expect(av.sav.fold<int>(0, (a, b) => a + b), 337);
    for (final g in avGrahas) {
      for (final row in av.prastara[g]!) {
        expect(row.every((v) => v == 0 || v == 1), isTrue);
      }
    }
  });

  for (final g in loadGoldenCharts()) {
    final exp = g['expected'] as Map<String, dynamic>;
    if (exp['bavBySign'] == null) continue;

    group('${g['id']} strength', () {
      late ChartAnalysis a;
      setUpAll(() {
        a = ChartAnalysis.of(RasiChart.calculate(eph, birthFromGolden(g)), eph);
      });

      test('Bhinnashtakavarga matches AstroSage exactly', () {
        final av = Ashtakavarga.of(a.chart);
        final want = (exp['bavBySign'] as Map).cast<String, List>();
        for (final e in want.entries) {
          expect(av.bav(Graha.values.byName(e.key)), e.value.cast<int>(),
              reason: e.key);
        }
      });

      test('Shadbala components are in range; ranks vs AstroSage', () {
        final sb = Shadbala.of(a, eph);
        final buf = StringBuffer('\n');
        for (final gr in sevenGrahas) {
          final s = sb.grahas[gr]!;
          for (final (name, v, max) in [
            ('uchcha', s.uchcha, 60.0), ('saptavargaja', s.saptavargaja, 315.0),
            ('ojayugma', s.ojayugma, 30.0), ('kendradi', s.kendradi, 60.0),
            ('drekkana', s.drekkana, 15.0), ('dig', s.dig, 60.0),
            ('nathonnatha', s.nathonnatha, 60.0), ('paksha', s.paksha, 120.0),
            ('ayana', s.ayana, 120.0), ('cheshta', s.cheshta, 60.0),
          ]) {
            expect(v, inInclusiveRange(-1e-9, max + 1e-9), reason: '${gr.label} $name');
          }
          buf.writeln('${gr.label.padRight(8)} sthana ${s.sthana.toStringAsFixed(1)} '
              'dig ${s.dig.toStringAsFixed(1)} kala ${s.kala.toStringAsFixed(1)} '
              'cheshta ${s.cheshta.toStringAsFixed(1)} nais ${s.naisargika.toStringAsFixed(1)} '
              'drik ${s.drik.toStringAsFixed(1)} = ${s.rupas.toStringAsFixed(2)} rupas '
              '(rank ${sb.ranks[gr]}, AstroSage ${(exp['shadbalaRank'] as Map)[gr.name]})');
        }
        buf.writeln('bhava ranks ours      ${sb.bhavaRanks}');
        buf.writeln('bhava ranks AstroSage ${exp['bhavaBalaRank']}');
        // ignore: avoid_print
        print(buf);
      });
    });
  }
}
