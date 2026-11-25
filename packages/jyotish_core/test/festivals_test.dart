import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

import 'support/test_ephemeris.dart';

/// Festivals and eclipses of 2026 for New Delhi against Drik Panchang's
/// "Indian Festivals" list (captured 2026-11-26; REA/drikpanchang/
/// festivals2026.json).
void main() {
  late PanchangCalc calc;
  const delhi = PanchangPlace(latitude: 28.6, longitude: 77.2, utcOffsetHours: 5.5);
  setUpAll(() async => calc = PanchangCalc(await loadTestEphemeris()));

  test('46 festivals on Drik\'s dates', () {
    const drik = {
      'makarSankranti': '01-14', 'mauniAmavasya': '01-18', 'vasantPanchami': '01-23',
      'rathaSaptami': '01-25', 'mahaShivaratri': '02-15', 'holikaDahan': '03-03',
      'holi': '03-04', 'chaitraNavratri': '03-19', 'ramNavami': '03-26',
      'hanumanJayanti': '04-02', 'akshayaTritiya': '04-19', 'buddhaPurnima': '05-01',
      'vatSavitri': '05-16', 'gangaDussehra': '05-25', 'nirjalaEkadashi': '06-25',
      'rathYatra': '07-16', 'devshayaniEkadashi': '07-25', 'guruPurnima': '07-29',
      'hariyaliTeej': '08-15', 'nagPanchami': '08-17', 'rakshaBandhan': '08-28',
      'kajariTeej': '08-31', 'janmashtami': '09-04', 'hartalikaTeej': '09-14',
      'ganeshChaturthi': '09-14', 'rishiPanchami': '09-15', 'anantChaturdashi': '09-25',
      'sarvaPitruAmavasya': '10-10', 'sharadNavratri': '10-11', 'durgaAshtami': '10-19',
      'mahaNavami': '10-19', 'dussehra': '10-20', 'sharadPurnima': '10-25',
      'karwaChauth': '10-29', 'ahoiAshtami': '11-01', 'dhanteras': '11-06',
      'narakChaturdashi': '11-08', 'diwali': '11-08', 'govardhanPuja': '11-10',
      'bhaiDooj': '11-11', 'chhathPuja': '11-15', 'devUthaniEkadashi': '11-20',
      'kartikPurnima': '11-24', 'vivahPanchami': '12-14', 'gitaJayanti': '12-20',
      'dattaJayanti': '12-23',
    };
    final got = {
      for (final f in festivalsOfYear(calc, delhi, 2026))
        f.id: '${f.date.month.toString().padLeft(2, '0')}-${f.date.day.toString().padLeft(2, '0')}',
    };
    final wrong = [
      for (final e in drik.entries)
        if (got[e.key] != e.value) '${e.key}: ours ${got[e.key]}, Drik ${e.value}',
    ];
    expect(wrong, isEmpty);
    expect(got.length, drik.length);
  });

  test('eclipses of 2025–26 at New Delhi, with sutak', () {
    final eph = calc.eph;
    String t(double? jd) {
      if (jd == null) return '-';
      final x = DateTime.fromMillisecondsSinceEpoch(
        ((jd - 2440587.5) * 86400000 + 5.5 * 3600000).round(),
        isUtc: true,
      );
      return '${x.month}-${x.day} ${x.hour.toString().padLeft(2, '0')}:${x.minute.toString().padLeft(2, '0')}';
    }

    final list = eclipsesBetween(eph, delhi, eph.julianDayUt(2025, 6, 1, 0), eph.julianDayUt(2027, 1, 1, 0));
    final s = [
      for (final x in list)
        '${x.event.kind.name} ${x.event.type.name} ${t(x.event.maximum).split(' ')[0]} '
            '${x.event.visible ? 'visible' : 'not visible'}',
    ];
    // Drik lists Surya Grahan *Valayakara 17 Feb, *Purna 12 Aug and
    // Chandra Grahan *Anshika 28 Aug 2026.
    expect(s, [
      'lunar total 9-7 visible',
      'solar partial 9-22 not visible',
      'solar annular 2-17 not visible',
      'lunar total 3-3 visible',
      'solar total 8-12 not visible',
      'lunar partial 8-28 not visible',
    ]);
    // 7 Sep 2025: sutak 12:57 (9 h before 21:57), for children and the sick
    // from sunset; 3 Mar 2026: the Moon rises eclipsed, sutak from 06:20.
    expect(t(list[0].sutakStart), '9-7 12:57');
    expect(t(list[0].sutakKidsStart), '9-7 18:35');
    expect(t(list[3].sutakStart), '3-3 06:20');
    expect(t(list[3].visibleStart), '3-3 18:24');
  });

  test('Mantri Mandala of Vikram 2083 as Drik shows it', () {
    final m = mantriMandala(calc, delhi, 2026);
    expect(m, {
      MantriOffice.raja: Graha.jupiter,
      MantriOffice.mantri: Graha.mars,
      MantriOffice.senadhipati: Graha.moon,
      MantriOffice.sasyadhipati: Graha.jupiter,
      MantriOffice.dhanyadhipati: Graha.mercury,
      MantriOffice.dhanadhipati: Graha.jupiter,
      MantriOffice.meghadhipati: Graha.moon,
      MantriOffice.rasadhipati: Graha.saturn,
      MantriOffice.nirasadhipati: Graha.jupiter,
      MantriOffice.phaladhipati: Graha.moon,
    });
    // Vikram 2082 as Drik shows it (26 Nov 2025 page).
    expect(mantriMandala(calc, delhi, 2025), {
      MantriOffice.raja: Graha.sun,
      MantriOffice.mantri: Graha.sun,
      MantriOffice.senadhipati: Graha.saturn,
      MantriOffice.sasyadhipati: Graha.mercury,
      MantriOffice.dhanyadhipati: Graha.moon,
      MantriOffice.dhanadhipati: Graha.mars,
      MantriOffice.meghadhipati: Graha.sun,
      MantriOffice.rasadhipati: Graha.venus,
      MantriOffice.nirasadhipati: Graha.mercury,
      MantriOffice.phaladhipati: Graha.saturn,
    });
    // Widely published: 2024 (Vikram 2081) Raja Mars, Mantri Saturn.
    expect(mantriMandala(calc, delhi, 2024)[MantriOffice.raja], Graha.mars);
    expect(mantriMandala(calc, delhi, 2024)[MantriOffice.mantri], Graha.saturn);
  });

  test('Brihaspati samvatsara turns Siddharthi → Raudra on 21 Apr 2026', () {
    final eph = calc.eph;
    final before = brihaspatiSamvatsara(eph.julianDayUt(2026, 4, 21, 10));
    final after = brihaspatiSamvatsara(eph.julianDayUt(2026, 4, 21, 10.5));
    expect(samvatsaraNames[before.$1], 'Siddharthi');
    expect(samvatsaraNames[after.$1], 'Raudra');
    // Previous change: Kalayukta → Siddharthi, 25 Apr 2025 15:07 IST.
    final (i, start, _) = brihaspatiSamvatsara(eph.julianDayUt(2025, 6, 1, 0));
    expect(samvatsaraNames[i], 'Siddharthi');
    expect(start, closeTo(eph.julianDayUt(2025, 4, 25, 9 + 37 / 60), 1 / 1440));
  });
}
