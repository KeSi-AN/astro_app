import 'package:birth_input/birth_input.dart';
import 'package:test/test.dart';

TimeResolution india(int y, int m, int d,
        {String admin1 = 'Uttar Pradesh',
        double lon = 78,
        TimeBasis? basis,
        bool? war}) =>
    TimeResolver.resolve(
      zoneName: 'Asia/Kolkata', longitude: lon, admin1: admin1,
      year: y, month: m, day: d, hour: 12, minute: 0,
      basis: basis, applyWarTime: war,
    );

void main() {
  setUpAll(TimeResolver.ensureInitialized);

  test('modern India is IST 5:30, no DST', () {
    final r = india(1990, 1, 1);
    expect(r.standardOffsetHours, 5.5);
    expect(r.dstHours, 0);
    expect(r.notes, isEmpty);
  });

  test('war time 1943 adds an hour, can be turned off', () {
    final on = india(1943, 6, 1);
    expect(on.isWarTime, isTrue);
    expect(on.totalOffsetHours, 6.5);
    final off = india(1943, 6, 1, war: false);
    expect(off.totalOffsetHours, 5.5);
  });

  test('mid-1942 gap between war-time periods is plain IST', () {
    expect(india(1942, 7, 1).totalOffsetHours, 5.5);
  });

  test('before 1906 defaults to local mean time', () {
    final r = india(1890, 5, 5, lon: 75);
    expect(r.basis, TimeBasis.lmt);
    expect(r.totalOffsetHours, 5.0);
    expect(r.alternatives, contains(TimeBasis.zone));
  });

  test('Bombay before 1955 suggests Bombay Time', () {
    final r = india(1950, 3, 3, admin1: 'Maharashtra');
    expect(r.basis, TimeBasis.zone);
    expect(r.alternatives, contains(TimeBasis.bombay));
    final b = india(1950, 3, 3, admin1: 'Maharashtra', basis: TimeBasis.bombay);
    expect(b.totalOffsetHours, closeTo(4 + 51 / 60, 1e-9));
  });

  test('Calcutta before 1948 suggests Calcutta Time', () {
    final r = india(1940, 3, 3, admin1: 'West Bengal');
    expect(r.alternatives, contains(TimeBasis.calcutta));
    expect(india(1950, 3, 3, admin1: 'West Bengal').alternatives, isEmpty);
  });

  test('New York daylight saving', () {
    final r = TimeResolver.resolve(
        zoneName: 'America/New_York', longitude: -74, year: 2026, month: 7,
        day: 1, hour: 12, minute: 0);
    expect(r.standardOffsetHours, -5);
    expect(r.dstHours, 1);
    expect(r.isWarTime, isFalse);
  });

  test('non-existent local time is flagged', () {
    final r = TimeResolver.resolve(
        zoneName: 'America/New_York', longitude: -74, year: 2026, month: 3,
        day: 8, hour: 2, minute: 30);
    expect(r.notes.map((n) => n.text).join(), contains('did not exist'));
  });

  test('ambiguous local time is flagged', () {
    final r = TimeResolver.resolve(
        zoneName: 'America/New_York', longitude: -74, year: 2026, month: 11,
        day: 1, hour: 1, minute: 30);
    expect(r.notes.map((n) => n.text).join(), contains('occurred twice'));
  });

  test('manual offset', () {
    final r = TimeResolver.resolve(
        zoneName: 'Asia/Kolkata', longitude: 78, year: 2000, month: 1, day: 1,
        hour: 0, minute: 0, basis: TimeBasis.manual, manualOffsetHours: 5.5,
        manualDstHours: 1);
    expect(r.totalOffsetHours, 6.5);
  });
}
