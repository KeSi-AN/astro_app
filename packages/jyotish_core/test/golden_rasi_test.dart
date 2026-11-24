import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

import 'support/test_ephemeris.dart';

/// Golden charts from reference programs (tools/golden/*.json).
///
/// Sign, nakshatra, pada and retrograde must match exactly. Degrees must
/// match within the fixture's `tolerancesArcSec` (default 2″ for precise
/// references such as Jagannatha Hora; wider for AstroSage, whose own
/// ephemeris is less precise – see DIVERGENCES.md).
void main() {
  late Ephemeris eph;
  setUpAll(() async => eph = await loadTestEphemeris());

  for (final g in loadGoldenCharts()) {
    final tol = (g['tolerancesArcSec'] as Map<String, dynamic>?) ?? const {};
    double tolFor(String key) =>
        ((tol[key] ?? tol['default'] ?? 2) as num).toDouble();

    group(g['id'], () {
      late RasiChart chart;
      setUpAll(() {
        final s = g['settings'] as Map<String, dynamic>;
        final ay = Ayanamsa.values.byName(s['ayanamsa'] as String);
        final node = s['node'] == 'true' ? NodeType.trueNode : NodeType.meanNode;
        chart = RasiChart.calculate(
            eph, birthFromGolden(g), CalcSettings(ayanamsa: ay, nodeType: node));
      });
      final exp = g['expected'] as Map<String, dynamic>;

      test('julian day', () {
        expect((chart.jdUt + 0.5).floor(), exp['julianDay']);
      });

      test('ayanamsa', () {
        _expectArcSec(chart.ayanamsa, exp['ayanamsa'] as String,
            tolFor('ayanamsa'), 'ayanamsa');
      });

      if (exp['obliquity'] != null) {
        test('obliquity', () {
          final v = exp['obliquityKind'] == 'mean'
              ? chart.meanObliquity
              : chart.obliquity;
          _expectArcSec(
              v, exp['obliquity'] as String, tolFor('obliquity'), 'obliquity');
        });
      }

      for (final row in (exp['positions'] as List).cast<List>()) {
        final name = row[0] as String;
        test(name, () {
          final p = name == 'lagna'
              ? chart.lagna
              : chart.grahas[Graha.values.byName(name)]!;
          expect(p.rashi.label, row[1], reason: '$name sign');
          expect(p.nakshatra.label, row[3], reason: '$name nakshatra');
          expect(p.pada, row[4], reason: '$name pada');
          if (name != 'lagna') {
            expect(p.isRetrograde, row[5], reason: '$name retrograde');
          }
          _expectArcSec(p.degreeInSign, row[2] as String, tolFor(name), name);
        });
      }
    });
  }
}

void _expectArcSec(double actualDeg, String expected, double tol, String what) {
  final exp = parseDms(expected);
  final diff = ((actualDeg - exp) * 3600).abs();
  expect(diff, lessThanOrEqualTo(tol + 0.5),
      reason: '$what: got ${Dms.of(actualDeg)}, expected ${Dms.of(exp)} '
          '(off by ${diff.toStringAsFixed(1)}″, allowed ${tol.toStringAsFixed(0)}″)');
}
