import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

import 'support/test_ephemeris.dart';

void main() {
  late Ephemeris eph;
  late RasiChart natal;
  setUpAll(() async {
    eph = await loadTestEphemeris();
    natal = RasiChart.calculate(eph, birthFromGolden(loadGoldenCharts().first));
  });

  test('transit at birth equals the natal chart', () {
    final t = TransitChart.at(eph, natal, natal.jdUt);
    for (final g in transitGrahas) {
      expect(t.positions[g], closeTo(natal.grahas[g]!.longitude, 1e-9));
      expect(t.infos[g]!.houseFromLagna, natal.grahas[g]!.house);
    }
    // Moon is in the 1st from itself.
    expect(t.infos[Graha.moon]!.houseFromMoon, 1);
  });

  test('SAV and BAV bindus come from the natal Ashtakavarga', () {
    final t = TransitChart.at(eph, natal, natal.jdUt + 400);
    final av = Ashtakavarga.of(natal);
    for (final g in transitGrahas) {
      final i = t.infos[g]!;
      expect(i.savBindus, av.sav[i.rashi.index]);
      if (avGrahas.contains(g)) expect(i.bavBindus, av.bav(g)[i.rashi.index]);
    }
  });

  test('gochara: Saturn in the 3rd from the Moon is good', () {
    // Find a date when Saturn is 3rd from natal Moon (Aries → Gemini).
    final from = natal.jdUt, to = from + 365.25 * 30;
    final entries = signIngresses(eph, Graha.saturn, from, to)
        .where((e) => e.description == 'sign:2' && !e.retrograde);
    expect(entries, isNotEmpty);
    final t = TransitChart.at(eph, natal, entries.first.jdUt + 30);
    expect(t.infos[Graha.saturn]!.houseFromMoon, 3);
    expect(t.infos[Graha.saturn]!.gochara, isNot(GocharaResult.bad));
  });

  test('crossings land on the target and include retrograde passes', () {
    final from = eph.julianDayUt(2026, 1, 1, 0), to = from + 365 * 3;
    final target = natal.grahas[Graha.moon]!.longitude;
    final ev = findCrossings(eph, Graha.jupiter, target, from, to);
    for (final e in ev) {
      final lon = eph.position(e.jdUt, Graha.jupiter, natal.settings).longitude;
      expect((lon - target).abs() % 360, lessThan(1e-4));
    }
    final sun = signIngresses(eph, Graha.sun, from, from + 365.25);
    expect(sun.length, 12);
    final rahu = signIngresses(eph, Graha.rahu, from, from + 365.25 * 2);
    expect(rahu.every((e) => e.retrograde), isTrue);
  });
}
