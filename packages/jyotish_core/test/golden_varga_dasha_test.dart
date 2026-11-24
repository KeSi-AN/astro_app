import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

import 'support/test_ephemeris.dart';

/// Vargas and dashas against AstroSage (fixture 004). Known differences
/// are listed explicitly with their cause, so a new difference fails.
void main() {
  late Ephemeris eph;
  setUpAll(() async => eph = await loadTestEphemeris());

  for (final g in loadGoldenCharts()) {
    final exp = g['expected'] as Map<String, dynamic>;
    if (exp['vargas'] == null) continue;

    group('${g['id']}', () {
      late RasiChart chart;
      setUpAll(() => chart = RasiChart.calculate(eph, birthFromGolden(g)));

      test('16 vargas match AstroSage except documented boundary cases', () {
        final cols = (exp['vargaColumns'] as List).cast<String>();
        final table = (exp['vargas'] as Map).cast<String, List>();
        final diffs = <String>[];
        for (final v in Varga.values) {
          final want = table[v.code]!.cast<int>();
          for (var i = 0; i < cols.length; i++) {
            final lon = cols[i] == 'lagna'
                ? chart.lagna.longitude
                : chart.grahas[Graha.values.byName(cols[i])]!.longitude;
            final got = vargaSign(lon, v).number;
            if (got != want[i]) diffs.add('${v.code} ${cols[i]}: ours $got, AstroSage ${want[i]}');
          }
        }
        // AstroSage's Moon is ~30″ behind ours (DIVERGENCES.md) and the
        // Moon sits on the 25°00′ Aries boundary, which is a division
        // edge in D12, D24, D30 and D60: all four flip.
        // Mars D7: Mars is at Leo 4°51′, past the first saptamsha
        // (4°17′8″), so BPHS gives Virgo; AstroSage shows Leo.
        expect(diffs.toSet(), {
          'D12 moon: ours 11, AstroSage 10',
          'D24 moon: ours 1, AstroSage 12',
          'D30 moon: ours 7, AstroSage 3',
          'D60 moon: ours 3, AstroSage 2',
          'D7 mars: ours 6, AstroSage 5',
        });
      });

      test('Yogini mahadashas end within 10 days of AstroSage', () {
        final y = YoginiDasha(
            moonLongitude: chart.grahas[Graha.moon]!.longitude,
            birthJd: chart.jdUt);
        for (final row in (exp['yoginiMahadashas'] as List).cast<List>()) {
          final lord = Yogini.values.byName(row[0] as String);
          final d = (row[1] as String).split('-').map(int.parse).toList();
          final p = y.mahadashas.firstWhere((p) => p.lord == lord);
          final want = eph.julianDayUt(d[0], d[1], d[2], 12);
          expect((p.end - want).abs(), lessThanOrEqualTo(10), reason: lord.label);
        }
      });

      test('Chara mahadashas match AstroSage except Aquarius', () {
        final c = CharaDasha(chart: chart, birthJd: chart.jdUt);
        final rows = (exp['charaMahadashaYears'] as List).cast<List>();
        final firstCycle = [
          for (final s in rows) Rashi.values.byName(s[0] as String),
        ];
        // Same order (our Aquarius has years, so all 12 appear).
        expect([for (final p in c.mahadashas.take(12)) p.lord], firstCycle);
        for (final row in rows) {
          final s = Rashi.values.byName(row[0] as String);
          if (s == Rashi.aquarius) {
            // Rahu sits in Aquarius, Saturn in Pisces. K.N. Rao: when one
            // lord is in the sign, use the other (Saturn) → 11 years.
            // AstroSage uses Rahu and prints 0 years (DIVERGENCES.md).
            expect(c.lordOf(s), Graha.saturn);
            expect(c.yearsOf(s), 11);
            continue;
          }
          expect(c.yearsOf(s), row[1], reason: s.label);
        }
        final ads = c.subPeriods(c.mahadashas.first);
        expect([for (final a in ads) a.lord.name], exp['charaFirstAntardashas']);
      });
    });
  }
}
