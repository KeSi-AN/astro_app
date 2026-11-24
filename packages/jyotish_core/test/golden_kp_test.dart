import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

import 'support/test_ephemeris.dart';

void main() {
  late Ephemeris eph;
  setUpAll(() async => eph = await loadTestEphemeris());

  test('249 horary numbers', () {
    expect(KpChart.horaryAscendant(1), 0);
    expect(KpChart.horaryAscendant(249), lessThan(360));
    var prev = -1.0;
    for (var n = 1; n <= 249; n++) {
      final a = KpChart.horaryAscendant(n);
      expect(a, greaterThan(prev));
      prev = a;
    }
    // Every sign boundary is a horary start.
    for (var s = 0; s < 12; s++) {
      expect([for (var n = 1; n <= 249; n++) KpChart.horaryAscendant(n)]
          .any((a) => (a - s * 30).abs() < 1e-9), isTrue, reason: 'sign $s');
    }
  });

  for (final g in loadGoldenCharts()) {
    final kpExp = (g['expected'] as Map<String, dynamic>)['kp'] as Map<String, dynamic>?;
    if (kpExp == null) continue;
    final b = birthFromGolden(g);

    for (final ay in [Ayanamsa.kpNew, Ayanamsa.kpOld]) {
      test('${g['id']} ${ay.name}: positions vs AstroSage', () {
        final kp = KpChart.calculate(eph, b, ayanamsa: ay);
        final buf = StringBuffer('${ay.name}\n');
        final planets = (kpExp['planets'] as Map).cast<String, List>();
        for (final e in planets.entries) {
          final ours = e.key == 'lagna' ? kp.cusps[0] : kp.planets[Graha.values.byName(e.key)]!;
          final diff = ((ours - parseDms(e.value[0] as String)) * 3600).round();
          buf.write('${e.key}:$diff″ ');
        }
        // ignore: avoid_print
        print(buf);
      });
    }

    group('${g['id']} KP', () {
      late KpChart kp;
      setUpAll(() => kp = KpChart.calculate(eph, b));
      String s(Graha x) => x.short;

      test('lords of planets and cusps match AstroSage', () {
        final planets = (kpExp['planets'] as Map).cast<String, List>();
        final subSubDiffs = <String>{};
        for (final e in planets.entries) {
          final l = e.key == 'lagna'
              ? kp.cuspLords(1)
              : kp.lordsOf(Graha.values.byName(e.key));
          expect([s(l.sign), s(l.star), s(l.sub)], e.value.sublist(1, 4),
              reason: e.key);
          if (s(l.subSub) != e.value[4]) subSubDiffs.add(e.key);
        }
        final cusps = (kpExp['cusps'] as List).cast<List>();
        for (var h = 1; h <= 12; h++) {
          final l = kp.cuspLords(h);
          expect([s(l.sign), s(l.star), s(l.sub)], cusps[h - 1].sublist(1, 4),
              reason: 'cusp $h');
          if (s(l.subSub) != cusps[h - 1][4]) subSubDiffs.add('cusp$h');
          final diff = (kp.cusps[h - 1] - parseDms(cusps[h - 1][0] as String)).abs() * 3600;
          expect(diff, lessThan(120), reason: 'cusp $h degree');
        }
        // Sub-sub divisions are only minutes wide: AstroSage's Saturn is
        // ~90″ off and its cusps ~40″ (DIVERGENCES.md), so a few flip.
        expect(subSubDiffs, {'saturn', 'cusp2', 'cusp8'});
      });

      test('significations and house significators match AstroSage', () {
        final sig = (kpExp['significations'] as Map).cast<String, List>();
        for (final e in sig.entries) {
          final ours = kp.signification(Graha.values.byName(e.key));
          for (var lv = 0; lv < 4; lv++) {
            expect(ours.levels[lv].toSet(), (e.value[lv] as List).cast<int>().toSet(),
                reason: '${e.key} L${lv + 1}');
          }
        }
        final hs = (kpExp['houseSignificators'] as List).cast<List>();
        for (var h = 1; h <= 12; h++) {
          expect(kp.houseSignificators(h).map(s).toList(), hs[h - 1], reason: 'house $h');
        }
      });

      test('Nakshatra Nadi matches AstroSage', () {
        final want = (kpExp['nadi'] as Map).cast<String, List>();
        for (final e in want.entries) {
          expect(kp.nadi(Graha.values.byName(e.key)), e.value.cast<int>(),
              reason: e.key);
        }
      });

      test('CIL (sub) T1, T3, T4 match AstroSage', () {
        final cil = (kpExp['cilSub'] as Map).cast<String, List>();
        for (var h = 1; h <= 12; h++) {
          final c = kp.cilSub(h);
          expect(c.t1, (cil['T1']![h - 1] as List).cast<int>(), reason: 'T1 cusp $h');
          expect(c.t3, (cil['T3']![h - 1] as List).cast<int>(), reason: 'T3 cusp $h');
          expect(c.t4, cil['T4']![h - 1], reason: 'T4 cusp $h');
        }
      });

      test('4-step chains planet → star → sub → star of sub', () {
        final fs = kp.fourStep(Graha.sun);
        expect([for (final (g, _) in fs) g],
            [Graha.sun, Graha.saturn, Graha.mercury, Graha.rahu]);
        expect(fs[1].$2, kp.nadi(Graha.saturn));
      });

      test('ruling planets at birth match AstroSage', () {
        final rp = kp.rulingPlanets(Graha.moon); // Monday (Hindu weekday)
        final want = (kpExp['rulingPlanets'] as Map).cast<String, String>();
        for (final (k, v) in rp.rows) {
          expect(v.name, want[k], reason: k);
        }
      });
    });
  }
}
