import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

import 'support/test_ephemeris.dart';

/// Panchang-at-birth and Avakhada checks against golden charts that carry
/// `expected.panchang` / `expected.avakhada`.
void main() {
  late Ephemeris eph;
  setUpAll(() async => eph = await loadTestEphemeris());

  for (final g in loadGoldenCharts()) {
    final exp = g['expected'] as Map<String, dynamic>;
    final tol = (g['tolerancesArcSec'] as Map<String, dynamic>?) ?? const {};
    final pExp = exp['panchang'] as Map<String, dynamic>?;
    final aExp = exp['avakhada'] as Map<String, dynamic>?;
    if (pExp == null && aExp == null) continue;

    group('${g['id']} analysis', () {
      late ChartAnalysis a;
      setUpAll(() {
        final s = g['settings'] as Map<String, dynamic>;
        final settings = CalcSettings(
            ayanamsa: Ayanamsa.values.byName(s['ayanamsa'] as String));
        a = ChartAnalysis.of(
            RasiChart.calculate(eph, birthFromGolden(g), settings), eph);
      });

      if (pExp != null) {
        test('panchang names', () {
          final p = a.panchang;
          expect(p.tithiName, pExp['tithi']);
          expect(p.paksha, pExp['paksha']);
          expect(p.yogaName, pExp['yoga']);
          expect(p.karanaName, pExp['karana']);
          expect(p.weekdayName, pExp['weekday']);
        });

        test('sunrise, sunset, ishtkaal', () {
          final b = birthFromGolden(g);
          final offset = b.utcOffsetHours + b.dstHours;
          double localHours(double jd) => ((jd + 0.5 + offset / 24) % 1) * 24;
          final secTol = ((tol['sunriseSeconds'] ?? 30) as num).toDouble();
          for (final (key, jd) in [
            ('sunrise', a.panchang.sunriseJd!),
            ('sunset', a.panchang.sunsetJd!),
          ]) {
            final want = parseDms(pExp[key] as String);
            final diff = (localHours(jd) - want).abs() * 3600;
            expect(diff, lessThanOrEqualTo(secTol),
                reason: '$key: got ${Dms.of(localHours(jd)).clock}, '
                    'expected ${pExp[key]}');
          }
          // Ishtkaal printed as ghati-pal-vipal (60 pal per ghati).
          final parts = (pExp['ishtkaal'] as String).split('-').map(int.parse).toList();
          final want = parts[0] + parts[1] / 60 + parts[2] / 3600;
          final palTol = ((tol['ishtkaalPal'] ?? 1) as num).toDouble();
          expect((a.panchang.ishtkaalGhatis! - want).abs() * 60,
              lessThanOrEqualTo(palTol),
              reason: 'ishtkaal ${a.panchang.ishtkaalGhatis} vs $want');
        });
      }

      if (aExp != null) {
        test('avakhada attributes', () {
          final av = a.avakhada;
          expect(av.varna, aExp['varna']);
          expect(av.vashya, aExp['vashya']);
          expect(av.yoni, aExp['yoni']);
          expect(av.gana, aExp['gana']);
          expect(av.nadi, aExp['nadi']);
          if (aExp['payaNakshatra'] != null) {
            expect(av.payaByNakshatra, aExp['payaNakshatra']);
          }
          final c = a.chart;
          expect(c.lagna.rashi.lord.name, aExp['lagnaLord']);
          expect(c.grahas[Graha.moon]!.rashi.lord.name, aExp['rasiLord']);
          expect(c.grahas[Graha.moon]!.nakshatra.lord.name, aExp['nakshatraLord']);
        });

        test('dasha balance', () {
          final av = a.avakhada;
          expect(av.dashaLord.name, aExp['dashaLord']);
          final p = (aExp['dashaBalance'] as String).split('-').map(int.parse).toList();
          final wantDays = p[0] * 360 + p[1] * 30 + p[2];
          final gotDays = av.dashaBalanceYears * 360;
          final dayTol = ((tol['dashaBalanceDays'] ?? 1) as num).toDouble();
          expect((gotDays - wantDays).abs(), lessThanOrEqualTo(dayTol),
              reason: 'balance ${formatYmd(av.dashaBalanceYears)} vs ${aExp['dashaBalance']}');
        });
      }
    });
  }
}
