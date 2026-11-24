import 'package:birth_input/birth_input.dart';
import 'package:test/test.dart';

ParsedBirth p(String s) => BirthTextParser.parse(s, currentYear: 2026);

void expectBirth(ParsedBirth r,
    {String? name, String? gender, List<int>? date, List<int>? time, String? place}) {
  if (name != null) expect(r.name, name, reason: 'name');
  if (gender != null) expect(r.gender, gender, reason: 'gender');
  if (date != null) expect([r.year, r.month, r.day], date, reason: 'date');
  if (time != null) expect([r.hour, r.minute, r.second], time, reason: 'time');
  if (place != null) expect(r.place, place, reason: 'place');
}

void main() {
  test('labelled WhatsApp message', () {
    expectBirth(p('''
Name: Rahul Sharma
DOB: 12/03/1990
Time: 10:45 am
Place - Lucknow
Gender: Male'''),
        name: 'Rahul Sharma', gender: 'male',
        date: [1990, 3, 12], time: [10, 45, 0], place: 'Lucknow');
  });

  test('labels with emoji, bullets and pm', () {
    expectBirth(p('''
👤 Name - Priya Verma
📅 Date of Birth: 5th August 1994
⏰ Birth time: 7.20 PM
📍 Place of birth: Jaipur, Rajasthan'''),
        name: 'Priya Verma', date: [1994, 8, 5], time: [19, 20, 0],
        place: 'Jaipur, Rajasthan');
  });

  test('date and time on one labelled line', () {
    expectBirth(p('DOB & TOB: 23-11-1985 23:21:37\nPOB: Agra'),
        date: [1985, 11, 23], time: [23, 21, 37], place: 'Agra');
  });

  test('single unlabelled line', () {
    expectBirth(p('Amit Kumar 12/03/1990 10:45 am Patna'),
        name: 'Amit Kumar', date: [1990, 3, 12], time: [10, 45, 0], place: 'Patna');
  });

  test('unlabelled lines', () {
    expectBirth(p('Sunita\n14-02-1978\n6:05 am\nBhopal'),
        name: 'Sunita', date: [1978, 2, 14], time: [6, 5, 0], place: 'Bhopal');
  });

  test('month-name formats', () {
    expectBirth(p('born on March 12, 1990 at 4:10 pm in Pune'),
        date: [1990, 3, 12], time: [16, 10, 0], place: 'Pune');
    expectBirth(p('DOB 1 Jan 2001'), date: [2001, 1, 1]);
    expectBirth(p('DOB 31-dec-99'), date: [1999, 12, 31]);
  });

  test('ISO date and 24-hour time', () {
    expectBirth(p('1990-03-12 22:45'), date: [1990, 3, 12], time: [22, 45, 0]);
  });

  test('two-digit years pivot on the current year', () {
    expectBirth(p('DOB 12/03/90'), date: [1990, 3, 12]);
    expectBirth(p('DOB 12/03/05'), date: [2005, 3, 12]);
  });

  test('day-first, with a note when ambiguous', () {
    final r = p('DOB 04/05/1990');
    expectBirth(r, date: [1990, 5, 4]);
    expect(r.notes.single.kind, ParseNoteKind.dayFirstDate);
  });

  test('switches to month-first only when day-first is impossible', () {
    final r = p('DOB 03/25/1990');
    expectBirth(r, date: [1990, 3, 25]);
    expect(r.notes.single.kind, ParseNoteKind.monthFirstDate);
  });

  test('rejects impossible dates', () {
    expect(p('DOB 31/02/1990').hasDate, isFalse);
  });

  test('Hindi transliterated time words', () {
    expectBirth(p('janm samay subah 5:30'), time: [5, 30, 0]);
    expectBirth(p('samay shaam 6 baje'), time: [18, 0, 0]);
    final r = p('time raat 1:15');
    expectBirth(r, time: [1, 15, 0]);
    expect(r.notes.single.kind, ParseNoteKind.afterMidnight);
    expectBirth(p('time raat 10:15'), time: [22, 15, 0]);
  });

  test('12 am and 12 pm', () {
    expectBirth(p('time 12:10 am'), time: [0, 10, 0]);
    expectBirth(p('time 12:10 pm'), time: [12, 10, 0]);
  });

  test('time without am/pm gets a note', () {
    final r = p('TOB 7:15');
    expectBirth(r, time: [7, 15, 0]);
    expect(r.notes.single.kind, ParseNoteKind.noAmPm);
  });

  test('a bare number is not a time', () {
    expect(p('Flat 12, Sector 5').hasTime, isFalse);
  });

  test('gender words', () {
    expect(p('Gender: F').gender, 'female');
    expect(p('Sex - boy').gender, 'male');
  });

  test('empty or unrelated text', () {
    expect(p('').isEmpty, isTrue);
    expect(p('   \n  ').isEmpty, isTrue);
  });

  group('Hindi input', () {
    test('labelled Hindi message', () {
      expectBirth(p('''
नाम: राहुल शर्मा
जन्म तिथि: 12/03/1990
जन्म समय: सुबह 10:45
जन्म स्थान: Lucknow
लिंग: पुरुष'''),
          name: 'राहुल शर्मा', gender: 'male', date: [1990, 3, 12],
          time: [10, 45, 0], place: 'Lucknow');
    });

    test('Devanagari digits and बजकर/मिनट', () {
      expectBirth(p('जन्म तिथि १२/०३/१९९० समय शाम ६ बजकर ५ मिनट'),
          date: [1990, 3, 12], time: [18, 5, 0]);
    });

    test('Hindi month names and रात', () {
      expectBirth(p('दिनांक 5 अगस्त 1994, रात 1:15'),
          date: [1994, 8, 5], time: [1, 15, 0]);
      expectBirth(p('समय रात 10 बजे'), time: [22, 0, 0]);
    });

    test('female in Hindi', () {
      expect(p('लिंग: स्त्री').gender, 'female');
    });
  });
}
