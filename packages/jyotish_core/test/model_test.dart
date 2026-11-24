import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

void main() {
  group('Rashi', () {
    test('boundaries', () {
      expect(Rashi.ofLongitude(0), Rashi.aries);
      expect(Rashi.ofLongitude(29.9999), Rashi.aries);
      expect(Rashi.ofLongitude(30), Rashi.taurus);
      expect(Rashi.ofLongitude(359.9999), Rashi.pisces);
      expect(Rashi.ofLongitude(-0.5), Rashi.pisces);
      expect(Rashi.ofLongitude(360), Rashi.aries);
    });
  });

  group('Nakshatra', () {
    test('boundaries and padas', () {
      expect(Nakshatra.ofLongitude(0), Nakshatra.ashwini);
      expect(Nakshatra.padaOf(0), 1);
      expect(Nakshatra.padaOf(3.3333), 1);
      expect(Nakshatra.padaOf(3.3334), 2);
      expect(Nakshatra.ofLongitude(13.3334), Nakshatra.bharani);
      expect(Nakshatra.ofLongitude(359.99), Nakshatra.revati);
      expect(Nakshatra.padaOf(359.99), 4);
    });
    test('Vimshottari lords repeat every 9', () {
      for (var i = 0; i < 27; i++) {
        expect(Nakshatra.values[i].lord, Nakshatra.values[i % 9].lord);
      }
    });
  });

  group('Placement', () {
    test('whole-sign house counts from the lagna sign', () {
      final p = Placement(longitude: 15, ascendantSign: Rashi.cancer);
      expect(p.house, 10); // Aries is the 10th from Cancer
      final q = Placement(longitude: 100, ascendantSign: Rashi.cancer);
      expect(q.house, 1);
    });
    test('nodes are always retrograde', () {
      final n = Placement(
          longitude: 10, speed: 0.05, alwaysRetrograde: true,
          ascendantSign: Rashi.aries);
      expect(n.isRetrograde, isTrue);
    });
  });

  group('Bhavas', () {
    test('bhava of a longitude uses sandhi ranges, across 0°', () {
      final madhya = [for (var i = 0; i < 12; i++) (350 + i * 30) % 360.0];
      final sandhi = [for (var i = 0; i < 12; i++) (335 + i * 30) % 360.0];
      final b = Bhavas(madhya: madhya, sandhi: sandhi);
      expect(b.bhavaOf(340), 1);
      expect(b.bhavaOf(4), 1);
      expect(b.bhavaOf(5), 2);
      expect(b.bhavaOf(334), 12);
    });
  });

  group('Dms', () {
    test('rounds to the nearest second', () {
      expect(Dms.of(7 + 13 / 60 + 24.6 / 3600).degrees, '07°13′25″');
      expect(Dms.of(29.99999).degrees, '30°00′00″');
    });
    test('parses AstroSage formats', () {
      expect(parseDms('024-13-56'), closeTo(24 + 13 / 60 + 56 / 3600, 1e-9));
      expect(parseDms("29°13'58\""), closeTo(29 + 13 / 60 + 58 / 3600, 1e-9));
    });
  });

  group('BirthData', () {
    test('Agra LMT correction is −18 minutes', () {
      const b = BirthData(
          year: 2026, month: 11, day: 23, hour: 23, minute: 21, second: 37,
          latitude: 27.15, longitude: 78, utcOffsetHours: 5.5);
      expect(b.lmtCorrectionHours * 60, closeTo(-18, 1e-9));
      expect(b.utHours, closeTo(17 + 51 / 60 + 37 / 3600, 1e-9));
    });
  });
}
