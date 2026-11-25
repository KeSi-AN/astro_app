import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

import 'support/test_ephemeris.dart';

/// Panchang and muhurta against AstroSage (fixture 005, New Delhi).
void main() {
  late Ephemeris eph;
  late PanchangCalc calc;
  setUpAll(() async {
    eph = await loadTestEphemeris();
    calc = PanchangCalc(eph);
  });

  for (final g in loadGoldenCharts()) {
    if (g['date'] == null) continue;
    final exp = g['expected'] as Map<String, dynamic>;
    final pl = g['place'] as Map<String, dynamic>;
    final place = PanchangPlace(
      latitude: parseCoordinate(pl['latitude'] as String),
      longitude: parseCoordinate(pl['longitude'] as String),
      utcOffsetHours: (pl['utcOffsetHours'] as num).toDouble(),
    );
    final dp = (g['date'] as String).split('-').map(int.parse).toList();
    final date = DateTime.utc(dp[0], dp[1], dp[2]);
    final tol = ((g['tolerances'] as Map)['minutes'] as num).toDouble();

    group('${g['id']}', () {
      late DayPanchang d;
      setUpAll(() => d = DayPanchang.of(calc, place, date));

      /// "HH:MM" (or "HH:MM+" for the next day) → minutes since midnight.
      double minutes(String s) {
        final next = s.endsWith('+');
        final p = s.replaceAll('+', '').split(':').map(int.parse).toList();
        return p[0] * 60.0 + p[1] + (next ? 1440 : 0);
      }

      double ours(double jd) {
        final base = eph.julianDayUt(date.year, date.month, date.day, 0) -
            place.utcOffsetHours / 24;
        return (jd - base) * 1440;
      }

      void near(double jd, String want, String what) =>
          expect((ours(jd) - minutes(want)).abs(), lessThanOrEqualTo(tol + 0.5),
              reason: '$what: ours ${ours(jd).toStringAsFixed(1)} min vs $want');

      test('sun and moon rise/set', () {
        near(d.sunrise, exp['sunrise'] as String, 'sunrise');
        near(d.sunset, exp['sunset'] as String, 'sunset');
        near(d.moonrise!, exp['moonrise'] as String, 'moonrise');
        near(d.moonset!, exp['moonset'] as String, 'moonset');
      });

      test('panchang elements and end times', () {
        for (final (key, list) in [
          ('tithi', d.tithis), ('nakshatra', d.nakshatras), ('yoga', d.yogas),
        ]) {
          final w = exp[key] as List;
          expect(list.first.index, w[0], reason: key);
          near(list.first.end, w[1] as String, '$key end');
        }
        final ks = (exp['karanas'] as List).cast<List>();
        for (var i = 0; i < ks.length; i++) {
          expect(karanaName(d.karanas[i].index), ks[i][0], reason: 'karana $i');
          near(d.karanas[i].end, ks[i][1] as String, 'karana $i end');
        }
        expect(d.month.amanta, exp['monthAmanta']);
        expect(d.month.purnimanta, exp['monthPurnimanta']);
        expect(d.weekday, exp['weekday']);
      });

      test('Rahu Kaal, Yamaganda, Gulika; no Abhijit on Wednesday', () {
        final k = dayKaals(d);
        for (final (key, kaal) in [
          ('rahuKaal', Kaal.rahu), ('yamaganda', Kaal.yamaganda),
          ('gulikaKaal', Kaal.gulika),
        ]) {
          final w = (exp[key] as List).cast<String>();
          near(k[kaal]!.start, w[0], '$key start');
          near(k[kaal]!.end, w[1], '$key end');
        }
        expect(k[Kaal.abhijit], exp['abhijit']);
      });

      test('Rahu Kaal for the following week', () {
        for (final row in (exp['rahuKaalWeek'] as List).cast<List>()) {
          final p = (row[0] as String).split('-').map(int.parse).toList();
          final day = DateTime.utc(p[0], p[1], p[2]);
          final dd = DayPanchang.of(calc, place, day);
          final rk = dayKaals(dd)[Kaal.rahu]!;
          final base = eph.julianDayUt(p[0], p[1], p[2], 0) - place.utcOffsetHours / 24;
          for (final (jd, want) in [(rk.start, row[1]), (rk.end, row[2])]) {
            expect(((jd - base) * 1440 - minutes(want as String)).abs(),
                lessThanOrEqualTo(tol + 0.5), reason: '${row[0]}');
          }
        }
      });

      test('horas and chogadias', () {
        final h = horas(d);
        final hw = (exp['horas'] as List).cast<List>();
        for (var i = 0; i < hw.length; i++) {
          expect(h[i].value.name, hw[i][0], reason: 'hora $i');
          near(h[i].start, hw[i][1] as String, 'hora $i start');
        }
        final c = chogadias(d);
        expect(c.take(8).map((x) => x.value.name).toList(), exp['chogadiaDay']);
        expect(c.skip(8).map((x) => x.value.name).toList(), exp['chogadiaNight']);
        final ct = (exp['chogadiaTimes'] as List).cast<List>();
        for (var i = 0; i < ct.length; i++) {
          near(c[i].start, ct[i][0] as String, 'chogadia $i');
        }
      });

      test('Bhadra periods in the month', () {
        final from = eph.julianDayUt(date.year, date.month, 1, 0) - place.utcOffsetHours / 24;
        final b = bhadra(calc, from, from + 30)
            .where((x) => x.start >= from).toList();
        final w = (exp['bhadra'] as List).cast<List>();
        expect(b.length, w.length);
        double jdOf(String s) {
          final p = s.split(RegExp('[- :]')).map(int.parse).toList();
          return eph.julianDayUt(p[0], p[1], p[2], p[3] + p[4] / 60) - place.utcOffsetHours / 24;
        }
        for (var i = 0; i < w.length; i++) {
          expect((b[i].start - jdOf(w[i][0] as String)).abs() * 1440, lessThan(tol + 1), reason: 'bhadra $i');
          expect((b[i].end - jdOf(w[i][1] as String)).abs() * 1440, lessThan(tol + 1), reason: 'bhadra $i end');
        }
      });

      test('Panchak start matches (end differs, see DIVERGENCES)', () {
        final from = eph.julianDayUt(date.year, date.month, 1, 0) - place.utcOffsetHours / 24;
        final p = panchak(calc, from, from + 30).first;
        final w = ((exp['panchak'] as List).first as List).cast<String>();
        final s = w[0].split(RegExp('[- :]')).map(int.parse).toList();
        final want = eph.julianDayUt(s[0], s[1], s[2], s[3] + s[4] / 60) - place.utcOffsetHours / 24;
        expect((p.start - want).abs() * 1440, lessThan(tol + 1));
      });

      test('2026 vrat dates match AstroSage', () {
        final v = vratDays(calc, place, 2026);
        final want = (exp['vrat2026'] as Map).cast<String, List>();
        for (final e in want.entries) {
          final kind = Vrat.values.byName(e.key);
          final ours = {
            for (final x in v.where((x) => x.vrat == kind))
              '${x.date.month.toString().padLeft(2, '0')}-${x.date.day.toString().padLeft(2, '0')}',
          };
          // AstroSage's lists were captured in screens; every captured date
          // must be in ours.
          for (final dte in e.value.cast<String>()) {
            expect(ours, contains(dte), reason: '${e.key} $dte');
          }
        }
        expect(v.where((x) => x.vrat == Vrat.ekadashi).length, 24);
      });
    });
  }
}
