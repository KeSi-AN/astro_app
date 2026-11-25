import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

/// Hand-worked checks for Ashtottari and the conditional nakshatra dashas
/// (no app available to compare with; see DIVERGENCES.md).
void main() {
  const span = 360 / 27;
  const birth = 2451545.0; // J2000
  const y = 365.25;

  double balanceYears(NakshatraDasha d) =>
      (d.mahadashas.first.end - birth) / y;

  test('28-segment wheel carves Abhijit out of Uttarashadha/Shravana', () {
    expect(segmentOf(0).$1, 0);
    expect(segmentOf(20 * span + 1).$1, 20); // Uttarashadha
    expect(segmentOf(abhijitStart + 0.01).$1, 21);
    expect(segmentOf(abhijitEnd + 0.01).$1, 22); // Shravana
    expect(segmentOf(22 * span + 0.01).$1, 23); // Dhanishta
    expect(segmentOf(359.9).$1, 27); // Revati
    final (_, f) = segmentOf((abhijitStart + abhijitEnd) / 2);
    expect(f, closeTo(0.5, 1e-9));
  });

  group('Ashtottari (108 years, groups from Ardra)', () {
    NakshatraDasha at(double lon) => NakshatraDasha(
          NakshatraDashaKind.ashtottari,
          moonLongitude: lon,
          birthJd: birth,
        );

    test('start of Ardra: full Sun dasha (6 years)', () {
      final d = at(5 * span);
      expect(d.mahadashas.first.lord, Graha.sun);
      expect(balanceYears(d), closeTo(6, 1e-6));
      expect(d.mahadashas[1].lord, Graha.moon);
    });

    test('middle of Pushya: 1.5 of 4 parts of Sun left = 2.25 years', () {
      final d = at(7.5 * span);
      expect(d.mahadashas.first.lord, Graha.sun);
      expect(balanceYears(d), closeTo(2.25, 1e-6));
    });

    test('middle of Abhijit: Saturn, 1.5 of 4 parts of 10 years left', () {
      final d = at((abhijitStart + abhijitEnd) / 2);
      expect(d.mahadashas.first.lord, Graha.saturn);
      expect(balanceYears(d), closeTo(3.75, 1e-6));
    });

    test('Ashwini belongs to Rahu (third of four)', () {
      final d = at(0);
      expect(d.mahadashas.first.lord, Graha.rahu);
      expect(balanceYears(d), closeTo(6, 1e-6)); // 2 of 4 parts of 12
    });

    test('antardashas fill the mahadasha in order from its lord', () {
      final d = at(100);
      for (final m in d.mahadashas.take(8)) {
        final subs = d.subPeriods(m);
        expect(subs.first.lord, m.lord);
        expect(subs.first.start, closeTo(m.start, 1e-6));
        expect(subs.last.end, closeTo(m.end, 1e-6));
        expect(subs.length, 8);
      }
    });
  });

  test('count-based starts', () {
    NakshatraDasha d(NakshatraDashaKind k, int nak) => NakshatraDasha(
          k,
          moonLongitude: (nak + 0.5) * span,
          birthJd: birth,
        );
    // Shodashottari counts from Pushya: Pushya → Sun; Ashwini → 21st → Ketu.
    expect(d(NakshatraDashaKind.shodashottari, 7).mahadashas.first.lord, Graha.sun);
    expect(d(NakshatraDashaKind.shodashottari, 0).mahadashas.first.lord, Graha.ketu);
    // Dwadashottari counts from birth to Revati: Revati → Sun; Ashwini → 27th → Ketu.
    expect(d(NakshatraDashaKind.dwadashottari, 26).mahadashas.first.lord, Graha.sun);
    expect(d(NakshatraDashaKind.dwadashottari, 0).mahadashas.first.lord, Graha.ketu);
    // Panchottari from Anuradha: Jyeshtha → 2nd → Mercury.
    expect(d(NakshatraDashaKind.panchottari, 17).mahadashas.first.lord, Graha.mercury);
    // Shatabdika from Revati: Ashwini → 2nd → Moon.
    expect(d(NakshatraDashaKind.shatabdika, 0).mahadashas.first.lord, Graha.moon);
    // Chaturashiti-sama from Swati: Swati → Sun, 12 years, half left.
    final c = d(NakshatraDashaKind.chaturashitiSama, 14);
    expect(c.mahadashas.first.lord, Graha.sun);
    expect(balanceYears(c), closeTo(6, 1e-6));
    // Dwisaptati-sama from Mula: Purva Bhadrapada is 8th → Rahu.
    expect(d(NakshatraDashaKind.dwisaptatiSama, 25).mahadashas.first.lord, Graha.rahu);
    // Shat-trimsha-sama from Shravana: Shravana → Moon (1 year).
    final s = d(NakshatraDashaKind.shatTrimshaSama, 21);
    expect(s.mahadashas.first.lord, Graha.moon);
    expect(balanceYears(s), closeTo(0.5, 1e-6));
  });

  test('every system covers 120 years with the right cycle total', () {
    for (final k in NakshatraDashaKind.values) {
      final d = NakshatraDasha(k, moonLongitude: 123.4, birthJd: birth);
      expect(d.mahadashas.last.end, greaterThanOrEqualTo(birth + 120 * y), reason: k.name);
      final lords = d.mahadashas.map((p) => p.lord).toSet();
      final cycle = lords.fold<int>(0, (s, g) => s + d.yearsOf(g));
      expect(cycle, k.totalYears, reason: k.name);
    }
  });
}
