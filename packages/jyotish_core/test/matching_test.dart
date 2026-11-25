import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

import 'support/test_ephemeris.dart';

void main() {
  late Ephemeris eph;
  setUpAll(() async => eph = await loadTestEphemeris());

  ChartAnalysis chartOf(String idPrefix) {
    final g = loadGoldenCharts().firstWhere((x) => (x['id'] as String).startsWith(idPrefix));
    return ChartAnalysis.of(RasiChart.calculate(eph, birthFromGolden(g)), eph);
  }

  test('yoni table is symmetric with 4 on the diagonal', () {
    const yonis = [
      'Horse', 'Elephant', 'Sheep', 'Serpent', 'Dog', 'Cat', 'Rat', 'Cow',
      'Buffalo', 'Tiger', 'Deer', 'Monkey', 'Mongoose', 'Lion',
    ];
    for (final a in yonis) {
      expect(yoniPoints(a, a), 4);
      for (final b in yonis) {
        expect(yoniPoints(a, b), yoniPoints(b, a), reason: '$a/$b');
      }
    }
    // Sworn enemies score 0.
    for (final (a, b) in [('Horse', 'Buffalo'), ('Elephant', 'Lion'),
        ('Sheep', 'Monkey'), ('Serpent', 'Mongoose'), ('Dog', 'Deer'),
        ('Cat', 'Rat'), ('Cow', 'Tiger')]) {
      expect(yoniPoints(a, b), 0, reason: '$a/$b');
    }
  });

  test('rajju cycle and vedha pairs', () {
    expect(rajjuOf(Nakshatra.ashwini), Rajju.pada);
    expect(rajjuOf(Nakshatra.mrigashira), Rajju.siro);
    expect(rajjuOf(Nakshatra.ashlesha), Rajju.pada);
    expect(rajjuOf(Nakshatra.magha), Rajju.pada);
    expect(rajjuOf(Nakshatra.revati), Rajju.pada);
    expect(isVedha(Nakshatra.ashwini, Nakshatra.jyeshtha), isTrue);
    expect(isVedha(Nakshatra.jyeshtha, Nakshatra.ashwini), isTrue);
    expect(isVedha(Nakshatra.ashwini, Nakshatra.bharani), isFalse);
  });

  test('Mumbai 1950 (boy) × Kolkata 1943 (girl), worked by hand: 16/36', () {
    // Boy: Moon Cancer, Ashlesha 4 — Brahmin, Jalachara, Cat, Rakshasa, Antya.
    // Girl: Moon Capricorn 21°, Shravana 4 — Vaishya, Jalachara, Monkey,
    // Deva, Antya.
    final m = Ashtakoota.of(chartOf('002'), chartOf('003'));
    final p = [for (final k in m.kootas) k.points];
    expect(p, [1, 2, 1.5, 3, 0.5, 1, 7, 0]);
    expect(m.total, 16);
    expect(m.nadiDosha, isTrue);
    expect(m.kootas[Koota.nadi.index].cancelled, isFalse);
    expect(m.bhakootDosha, isFalse);
  });

  test('totals stay within 0–36 and swapping roles changes only one-way kootas', () {
    final a = chartOf('001'), b = chartOf('003');
    final ab = Ashtakoota.of(a, b), ba = Ashtakoota.of(b, a);
    for (final m in [ab, ba]) {
      expect(m.total, inInclusiveRange(0, 36));
      for (final k in m.kootas) {
        expect(k.points, inInclusiveRange(0, k.koota.max));
      }
    }
    // Symmetric kootas.
    for (final k in [Koota.tara, Koota.yoni, Koota.grahaMaitri, Koota.bhakoot, Koota.nadi]) {
      expect(ab.kootas[k.index].points, ba.kootas[k.index].points, reason: k.name);
    }
  });

  test('ten poruthams are all evaluated', () {
    final p = poruthams(Ashtakoota.of(chartOf('002'), chartOf('003')));
    expect(p.length, 10);
    // Girl Shravana → boy Ashlesha: count 15, 15 % 9 = 6 → Dina good.
    expect(p[Porutham.dina], PoruthamResult.good);
    expect(p[Porutham.rajju], PoruthamResult.good); // Pada vs Kanta
  });
}
