import 'package:astro_app/core/format/formatters.dart';
import 'package:astro_app/features/atlas/domain/place.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('date input', () {
    expect(parseDateInput('12/03/1990'), [1990, 3, 12]);
    expect(parseDateInput('1-1-2001'), [2001, 1, 1]);
    expect(parseDateInput('31/02/1990'), isNull);
    expect(parseDateInput('12/13/1990'), isNull);
    expect(parseDateInput('01/01/1799'), isNull);
  });

  test('time input', () {
    expect(parseTimeInput('22:45'), [22, 45, 0]);
    expect(parseTimeInput('7.05.09'), [7, 5, 9]);
    expect(parseTimeInput('24:00'), isNull);
  });

  test('offset input', () {
    expect(parseOffsetInput('5:30'), 5.5);
    expect(parseOffsetInput('+05:30'), 5.5);
    expect(parseOffsetInput('-4:51:00'), closeTo(-(4 + 51 / 60), 1e-9));
    expect(parseOffsetInput('5.5'), 5.5);
    expect(parseOffsetInput('−5'), -5);
    expect(parseOffsetInput('abc'), isNull);
  });

  test('formatting', () {
    expect(formatOffset(5.5), 'UTC+05:30');
    expect(formatOffset(5 + 53 / 60 + 20 / 3600), 'UTC+05:53:20');
    expect(formatOffset(-4), 'UTC−04:00');
    expect(formatSignedHms(-0.3), '−00:18:00');
    expect(formatDate(1990, 3, 12), '12 Mar 1990');
    expect(formatLatitude(27.15), '27°09′N');
    expect(formatLongitude(-74.006), '074°00′W');
  });
}
