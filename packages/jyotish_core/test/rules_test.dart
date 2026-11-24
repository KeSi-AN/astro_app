import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

void main() {
  group('KP lords', () {
    test('sub lord sequence starts with the star lord', () {
      // 0° Aries: Ashwini (Ketu), first sub Ketu, first sub-sub Ketu.
      expect(kpLords(0.0001), [Graha.ketu, Graha.ketu, Graha.ketu]);
      // Ketu sub of Ashwini spans 13°20′ × 7/120 = 0°46′40″.
      expect(kpLords(0.78)[1], Graha.venus);
      expect(kpLords(0.77)[1], Graha.ketu);
    });
    test('last sub of a nakshatra', () {
      // Just before 13°20′: Ashwini's last sub is Mercury.
      expect(kpLords(13.33)[1], Graha.mercury);
    });
  });

  group('relationships', () {
    test('natural table spot checks (BPHS)', () {
      expect(naturalRelation(Graha.sun, Graha.saturn), Relation.enemy);
      expect(naturalRelation(Graha.moon, Graha.saturn), Relation.neutral);
      expect(naturalRelation(Graha.mercury, Graha.moon), Relation.enemy);
      expect(naturalRelation(Graha.jupiter, Graha.venus), Relation.enemy);
      expect(naturalRelation(Graha.saturn, Graha.venus), Relation.friend);
    });
    test('temporal: 2,3,4,10,11,12 are friends', () {
      for (var h = 1; h <= 12; h++) {
        final r = temporalRelation(Rashi.aries, Rashi.values[h - 1]);
        expect(r == Relation.friend, {2, 3, 4, 10, 11, 12}.contains(h),
            reason: 'house $h');
      }
    });
    test('compound', () {
      expect(compoundRelation(Relation.friend, Relation.friend), Relation.greatFriend);
      expect(compoundRelation(Relation.neutral, Relation.enemy), Relation.enemy);
      expect(compoundRelation(Relation.enemy, Relation.friend), Relation.neutral);
      expect(compoundRelation(Relation.enemy, Relation.enemy), Relation.greatEnemy);
    });
  });

  group('dignity', () {
    test('exaltation, moolatrikona, own, debilitation', () {
      expect(dignityOf(Graha.sun, 10), Dignity.exalted); // Aries
      expect(dignityOf(Graha.sun, 190), Dignity.debilitated); // Libra
      expect(dignityOf(Graha.sun, 125), Dignity.moolatrikona); // Leo 5°
      expect(dignityOf(Graha.sun, 145), Dignity.own); // Leo 25°
      expect(dignityOf(Graha.moon, 31), Dignity.exalted); // Taurus 1°
      expect(dignityOf(Graha.moon, 40), Dignity.moolatrikona); // Taurus 10°
      expect(dignityOf(Graha.mercury, 160), Dignity.exalted); // Virgo 10°
      expect(dignityOf(Graha.mercury, 167), Dignity.moolatrikona); // Virgo 17°
      expect(dignityOf(Graha.mercury, 175), Dignity.own); // Virgo 25°
      expect(dignityOf(Graha.rahu, 10), isNull);
    });
    test('combustion orbs', () {
      expect(combustionOrb(Graha.mercury, retrograde: false), 14);
      expect(combustionOrb(Graha.mercury, retrograde: true), 12);
      expect(combustionOrb(Graha.sun, retrograde: false), isNull);
      expect(separation(355, 5), 10);
    });
  });

  group('navamsha', () {
    test('movable, fixed and dual signs', () {
      expect(vargaSign(1, Varga.d9), Rashi.aries); // Aries starts from Aries
      expect(vargaSign(31, Varga.d9), Rashi.capricorn); // Taurus from Capricorn
      expect(vargaSign(61, Varga.d9), Rashi.libra); // Gemini from Libra
      expect(vargaSign(29.9, Varga.d9), Rashi.sagittarius);
    });
  });

  group('panchang names', () {
    test('tithi, karana, yoga', () {
      expect(tithiName(tithiNumber(0, 167.8)), 'Chaturdashi');
      expect(tithiName(15), 'Purnima');
      expect(tithiName(30), 'Amavasya');
      expect(tithiName(16), 'Pratipada');
      expect(karanaName(1), 'Kimstughna');
      expect(karanaName(2), 'Bava');
      expect(karanaName(8), 'Vishti');
      expect(karanaName(60), 'Naga');
      expect(yogaNames[18], 'Parigha');
    });
  });

  group('years', () {
    test('Y/M/D with 30-day months', () {
      expect(yearsToYmd(2.5), (2, 6, 0));
      expect(formatYmd(1 + 1 / 360), '1y 0m 1d');
    });
  });
}
