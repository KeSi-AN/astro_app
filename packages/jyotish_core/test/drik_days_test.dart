import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

import 'support/test_ephemeris.dart';

/// Every day captured from Drik Panchang (New Delhi, Nov 2026 – Jan 2027;
/// tools/drik/drik_days.json): special times, Aadal/Vidaal, Anandadi and
/// Tamil yoga, Kumbha Chakra, Jeevanama, Netrama and the nivas, within
/// 2 minutes.
void main() {
  late PanchangCalc calc;
  const delhi = PanchangPlace(latitude: 28.6, longitude: 77.2, utcOffsetHours: 5.5);
  setUpAll(() async => calc = PanchangCalc(await loadTestEphemeris()));

  final fixture = jsonDecode(File('../../tools/drik/drik_days.json').readAsStringSync())
      as Map<String, dynamic>;
  final days = (fixture['days'] as List).cast<Map<String, dynamic>>();

  const spanKeys = {
    'Aadal Yoga': SpecialTime.aadal,
    'Vidaal Yoga': SpecialTime.vidaal,
    'Varjyam': SpecialTime.varjyam,
    'Amrit Kalam': SpecialTime.amritKalam,
    'Dur Muhurtam': SpecialTime.durMuhurtam,
    'Sarvartha Siddhi Yoga': SpecialTime.sarvarthaSiddhi,
    'Amrit Siddhi Yoga': SpecialTime.amritaSiddhi,
    'Ravi Yoga': SpecialTime.raviYoga,
    'Ravi Pushya Yoga': SpecialTime.raviPushya,
    'Guru Pushya Yoga': SpecialTime.guruPushya,
    'Dwipushkar Yoga': SpecialTime.dwipushkar,
    'Tripushkar Yoga': SpecialTime.tripushkar,
    'Ganda Moola': SpecialTime.gandaMoola,
    'Godhuli Muhurta': SpecialTime.godhuli,
    'Brahma Muhurta': SpecialTime.brahmaMuhurta,
    'Nishita Muhurta': SpecialTime.nishita,
    'Vijaya Muhurta': SpecialTime.vijayaMuhurta,
    'Sayahna Sandhya': SpecialTime.sayahnaSandhya,
    'Pratah Sandhya': SpecialTime.pratahSandhya,
  };

  const drikAnandadi = {'Ketu/Dhwaja': 'Dhwaja', 'Dhata/Prajapati': 'Dhata', 'Mushala': 'Musala'};
  const drikGraha = {
    'Surya': Graha.sun, 'Sun': Graha.sun, 'Chandra': Graha.moon, 'Mangal': Graha.mars, 'Budha': Graha.mercury,
    'Guru': Graha.jupiter, 'Shukra': Graha.venus, 'Shani': Graha.saturn, 'Rahu': Graha.rahu,
    'Ketu': Graha.ketu,
  };
  const shiva = {
    'in Shmashana': Shivavasa.shmashana, 'on Kailash': Shivavasa.kailash,
    'with Gowri': Shivavasa.gowri, 'on Nandi': Shivavasa.nandi, 'in Sabha': Shivavasa.sabha,
    'in Bhojana': Shivavasa.bhojana, 'in Krida': Shivavasa.krida,
  };
  const dirs = {
    'East': Direction.east, 'South-East': Direction.southEast, 'South': Direction.south,
    'South-West': Direction.southWest, 'West': Direction.west, 'North-West': Direction.northWest,
    'North': Direction.north, 'North-East': Direction.northEast,
  };

  for (final day in days) {
    test(day['date'], () {
      final date = DateTime.parse(day['date'] as String);
      final d = DayPanchang.of(calc, delhi, DateTime.utc(date.year, date.month, date.day));
      final mid = calc.eph.julianDayUt(date.year, date.month, date.day, 0) - 5.5 / 24;
      int m(double jd) => ((jd - mid) * 1440).round();
      // Times set by the Sun changing nakshatra differ by the ayanamsa gap
      // (Drik's Lahiri is ~16" higher): allow 7 minutes near those.
      const span = 360 / 27;
      final sunChanges = <int>[];
      for (var t = d.sunrise; t < d.nextSunrise; t += 5 / 1440) {
        if ((calc.sun(t) / span).floor() != (calc.sun(t + 5 / 1440) / span).floor()) {
          sunChanges.add(m(t));
        }
      }
      void near(double jd, int? expected, String what) {
        if (expected == null) return;
        final tol = sunChanges.any((c) => (c - expected).abs() <= 12) ? 7 : 2;
        expect(m(jd), closeTo(expected, tol), reason: '${day['date']} $what');
      }

      final special = specialTimes(calc, d);
      for (final e in spanKeys.entries) {
        final want = (day[e.key] as List? ?? const []).cast<List>();
        final got = special.where((x) => x.value == e.value).toList();
        expect(got.length, want.length, reason: '${day['date']} ${e.key} count');
        for (var i = 0; i < got.length; i++) {
          near(got[i].start, want[i][0] as int?, '${e.key} start');
          near(got[i].end, want[i][1] as int?, '${e.key} end');
        }
      }

      /// Checks a value sequence: names and the "upto" times.
      void sequence<T>(String key, List<TimeSpan<T>> got, T Function(String) parse) {
        final raw = (day[key] as List?)?.cast<List>();
        if (raw == null) return;
        // Drik lists equal neighbours separately (one per nakshatra); merge.
        final want = <List>[];
        for (final w in raw) {
          if (want.isNotEmpty && want.last[0] == w[0]) {
            want[want.length - 1] = [w[0], w[1]];
          } else {
            want.add(w);
          }
        }
        expect(got.map((x) => x.value).toList(), want.map((w) => parse(w[0] as String)).toList(),
            reason: '${day['date']} $key');
        for (var i = 0; i < want.length; i++) {
          if (want[i][1] != null) near(got[i].end, want[i][1] as int, '$key end $i');
        }
      }

      final moon = MoonDayValues.of(calc, d);
      sequence('Tamil Yoga', moon.tamil,
          (s) => TamilYoga.values.byName(s.toLowerCase()));
      sequence('Anandadi Yoga', anandadiYogas(calc, d),
          (s) => anandadiNames.indexOf(drikAnandadi[s] ?? s));
      sequence('Kumbha Chakra', moon.kumbha,
          (s) => KumbhaPart.values.byName(s.toLowerCase()));
      sequence('Jeevanama', moon.jeevan,
          (s) => const {'Lifeless': 0, 'Half Life': 1, 'Full Life': 2}[s]!);
      sequence('Netrama', moon.netra,
          (s) => const {'Blind': 0, 'One Eye': 1, 'Two Eyes': 2}[s]!);
      final nivas = Nivas.of(calc, d);
      sequence('Homahuti', nivas.homahutis, (s) => drikGraha[s]!);
      sequence('Agnivasa', nivas.agnivasas, (s) => Agnivasa.values.byName(s.toLowerCase()));
      sequence('Shivavasa', nivas.shivavasas, (s) => shiva[s]!);
      sequence('Chandra Vasa', nivas.chandraVasas, (s) => dirs[s]!);
      if (day['Pravishte/Gate'] != null) {
        expect('${pravishte(calc, d)}', day['Pravishte/Gate'], reason: '${day['date']} pravishte');
      }
      if (day['National Nirayana Date'] != null) {
        const months = [
          'Chaitra', 'Vaishakha', 'Jyeshtha', 'Ashadha', 'Shravana', 'Bhadrapada',
          'Ashwina', 'Kartika', 'Margashirsha', 'Pausha', 'Magha', 'Phalguna',
        ];
        final (y, mo, dd) = nationalNirayanaDate(calc, d);
        expect('${months[mo - 1]} ${dd.toString().padLeft(2, '0')}, $y Shaka',
            day['National Nirayana Date'], reason: '${day['date']} nirayana');
      }
      if (day['Disha Shool'] != null) {
        expect(dishaShool[sundayIndex(d)], dirs[day['Disha Shool']]);
      }
      if (day['Rahu Vasa'] != null) {
        expect(rahuVasa[sundayIndex(d)], dirs[day['Rahu Vasa']]);
      }
    });
  }
}
