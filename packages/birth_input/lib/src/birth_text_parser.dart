/// Pulls birth details out of free text, e.g. a WhatsApp message:
///
///   Name: Rahul Sharma
///   DOB 12/03/1990, 10:45 am
///   Place - Lucknow
///
/// Indian conventions are assumed: dates are day-first unless that is
/// impossible. Everything parsed is shown to the user to confirm, so the
/// parser prefers leaving a field empty over guessing wildly.
class ParsedBirth {
  ParsedBirth({
    this.name,
    this.gender,
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
    this.place,
    List<String>? notes,
  }) : notes = notes ?? [];

  String? name;
  String? gender; // 'male' | 'female'
  int? year, month, day;
  int? hour, minute, second;
  String? place;

  /// Things the user should double-check (ambiguous date order, missing AM/PM).
  final List<String> notes;

  bool get hasDate => year != null && month != null && day != null;
  bool get hasTime => hour != null && minute != null;
  bool get isEmpty =>
      name == null && gender == null && !hasDate && !hasTime && place == null;
}

class BirthTextParser {
  static const _months = {
    'jan': 1, 'january': 1, 'feb': 2, 'february': 2, 'mar': 3, 'march': 3,
    'apr': 4, 'april': 4, 'may': 5, 'jun': 6, 'june': 6, 'jul': 7, 'july': 7,
    'aug': 8, 'august': 8, 'sep': 9, 'sept': 9, 'september': 9, 'oct': 10,
    'october': 10, 'nov': 11, 'november': 11, 'dec': 12, 'december': 12,
  };

  static final _monthAlt = _months.keys.toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  static final _monthRe = _monthAlt.join('|');

  // Labels → field. Order matters: longer/more specific first.
  static final _labels = <(RegExp, String)>[
    (RegExp(r'^(?:full\s+)?name|^naam|^nam\b', caseSensitive: false), 'name'),
    (RegExp(r'^(?:gender|sex|ling)\b', caseSensitive: false), 'gender'),
    (RegExp(r'^(?:date\s+(?:and|&)\s+time\s+of\s+birth|birth\s+date\s+(?:and|&)\s+time|dob\s*(?:&|and)\s*tob)', caseSensitive: false), 'datetime'),
    (RegExp(r'^(?:place\s+of\s+birth|birth\s*place|pob|janm\s*sthan|janam\s*sthan|place|city|location|birth\s+city|born\s+(?:in|at))', caseSensitive: false), 'place'),
    (RegExp(r'^(?:time\s+of\s+birth|birth\s*time|tob|janm\s*samay|janam\s*samay|samay|time)', caseSensitive: false), 'time'),
    (RegExp(r'^(?:date\s+of\s+birth|birth\s*date|d\.?\s*o\.?\s*b\.?|janm\s*tithi|janam\s*tithi|janm\s*tarikh|date|born\s+on)', caseSensitive: false), 'date'),
  ];

  static ParsedBirth parse(String text, {int? currentYear}) {
    final out = ParsedBirth();
    final nowYear = currentYear ?? DateTime.now().year;
    final leftovers = <String>[];

    for (var raw in text.split(RegExp(r'[\r\n]+'))) {
      raw = raw.trim();
      if (raw.isEmpty) continue;
      // Strip bullets, emoji and decorations at the start of a line.
      var line = raw.replaceFirst(RegExp(r'^[^A-Za-z0-9]+'), '');
      String? field;
      for (final (re, f) in _labels) {
        final m = re.firstMatch(line);
        if (m != null) {
          final rest = line.substring(m.end);
          // A label must be followed by a separator or end of line, or be
          // a "born in/on" phrase.
          if (rest.isEmpty || RegExp(r'^\s*[:\-–=.]|^\s+').hasMatch(rest)) {
            field = f;
            line = rest.replaceFirst(RegExp(r'^\s*[:\-–=.]*\s*'), '');
            break;
          }
        }
      }
      switch (field) {
        case 'name':
          out.name ??= _clean(line);
        case 'gender':
          out.gender ??= _gender(line);
        case 'place':
          out.place ??= _cleanPlace(line);
        case 'date':
        case 'time':
        case 'datetime':
          // "born on 12 March 1990 at 4 pm in Pune": the rest may hold a place.
          final rest = _takeDateTime(line, out, nowYear);
          if (_clean(rest) != null) leftovers.add(rest);
        default:
          leftovers.add(line);
      }
    }

    // Unlabelled text: pull out date/time/gender tokens, then treat words
    // before the date as the name and words after the time as the place.
    for (final line in leftovers) {
      final beforeDate = out.hasDate;
      final rest = _takeDateTime(line, out, nowYear, keepSplit: true);
      final g = _gender(rest);
      if (g != null) out.gender ??= g;
      final words = rest
          .replaceAll(RegExp(r'\b(?:male|female|boy|girl|m|f|son|daughter|born|on|at|in)\b',
              caseSensitive: false), ' ')
          .split('\u0000')
          .map(_clean)
          .where((s) => s != null && s.isNotEmpty)
          .cast<String>()
          .toList();
      if (words.isEmpty) continue;
      if (!beforeDate && out.hasDate && words.length >= 2) {
        out.name ??= words.first;
        out.place ??= _cleanPlace(words.last);
      } else if (!beforeDate && out.hasDate && rest.indexOf('\u0000') > 0 &&
          rest.indexOf(words.first) < rest.indexOf('\u0000')) {
        out.name ??= words.first;
      } else if (out.name == null && !out.hasDate && words.length == 1 &&
          leftovers.indexOf(line) == 0) {
        out.name = words.first;
      } else {
        out.place ??= _cleanPlace(words.last);
      }
    }
    return out;
  }

  /// Finds a date and a time in [s], stores them in [out] and returns the
  /// remaining text. With [keepSplit], removed spans become '\u0000' so the
  /// caller can tell text before and after them apart.
  static String _takeDateTime(String s, ParsedBirth out, int nowYear,
      {bool keepSplit = false}) {
    final gap = keepSplit ? '\u0000' : ' ';
    var rest = s;

    if (!out.hasDate) {
      final found = _findDate(rest, nowYear, out);
      if (found != null) {
        rest = rest.replaceRange(found.$1, found.$2, gap);
      }
    }
    if (!out.hasTime) {
      final found = _findTime(rest, out);
      if (found != null) {
        rest = rest.replaceRange(found.$1, found.$2, gap);
      }
    }
    return rest.trim();
  }

  static (int, int)? _findDate(String s, int nowYear, ParsedBirth out) {
    // 1990-03-12
    var m = RegExp(r'\b(\d{4})[-/.](\d{1,2})[-/.](\d{1,2})\b').firstMatch(s);
    if (m != null) {
      return _setDate(out, int.parse(m[1]!), int.parse(m[2]!),
              int.parse(m[3]!))
          ? (m.start, m.end)
          : null;
    }
    // 12/03/1990, 12-3-90, 12.03.1990
    m = RegExp(r'\b(\d{1,2})\s*[-/.]\s*(\d{1,2})\s*[-/.]\s*(\d{2}|\d{4})\b')
        .firstMatch(s);
    if (m != null) {
      var a = int.parse(m[1]!), b = int.parse(m[2]!);
      final y = _year(m[3]!, nowYear);
      if (a <= 12 && b > 12) {
        // Only month-first is possible.
        out.notes.add('Date read as month/day ($a/$b), since $b is not a valid month.');
        final t = a;
        a = b;
        b = t;
      } else if (a <= 12 && b <= 12 && a != b) {
        out.notes.add('Date read as day/month (Indian order). Check it isn\'t month/day.');
      }
      return _setDate(out, y, b, a) ? (m.start, m.end) : null;
    }
    // 12 March 1990, 12th Mar, 1990
    m = RegExp('\\b(\\d{1,2})(?:st|nd|rd|th)?[\\s\\-/.,]*($_monthRe)\\.?[\\s\\-/.,]*(\\d{4}|\\d{2})\\b',
            caseSensitive: false)
        .firstMatch(s);
    if (m != null) {
      return _setDate(out, _year(m[3]!, nowYear),
              _months[m[2]!.toLowerCase()]!, int.parse(m[1]!))
          ? (m.start, m.end)
          : null;
    }
    // March 12, 1990
    m = RegExp('\\b($_monthRe)\\.?\\s+(\\d{1,2})(?:st|nd|rd|th)?,?\\s+(\\d{4})\\b',
            caseSensitive: false)
        .firstMatch(s);
    if (m != null) {
      return _setDate(out, int.parse(m[3]!), _months[m[1]!.toLowerCase()]!,
              int.parse(m[2]!))
          ? (m.start, m.end)
          : null;
    }
    return null;
  }

  static bool _setDate(ParsedBirth out, int y, int mo, int d) {
    if (mo < 1 || mo > 12 || d < 1 || d > 31) return false;
    final dt = DateTime(y, mo, d);
    if (dt.month != mo) return false; // e.g. 31/02
    out
      ..year = y
      ..month = mo
      ..day = d;
    return true;
  }

  static int _year(String s, int nowYear) {
    final v = int.parse(s);
    if (s.length == 4) return v;
    final century = nowYear ~/ 100 * 100;
    return century + v > nowYear ? century - 100 + v : century + v;
  }

  // am/pm words incl. common Hindi transliterations.
  static const _pm = r'p\.?\s*m\.?|pm|evening|night|afternoon|shaam|sham|raat|rat|dopahar|dopehar';
  static const _am = r'a\.?\s*m\.?|am|morning|subah|subha|savere|sawere|early\s+morning';

  static (int, int)? _findTime(String s, ParsedBirth out) {
    final re = RegExp(
      '(?:\\b($_am|$_pm)\\b\\s*)?' // prefix: "subah 5:30"
      r'\b(\d{1,2})(?:\s*[:.]\s*(\d{2}))?(?:\s*[:.]\s*(\d{2}))?'
      '\\s*(?:hrs?|hours|baje|bje)?\\s*'
      '(?:\\b($_am|$_pm)\\b)?',
      caseSensitive: false,
    );
    for (final m in re.allMatches(s)) {
      final hasMinutes = m[3] != null;
      final mer = (m[5] ?? m[1])?.toLowerCase();
      if (!hasMinutes && mer == null) continue; // a bare number isn't a time
      var h = int.parse(m[2]!);
      final mi = int.parse(m[3] ?? '0');
      final se = int.parse(m[4] ?? '0');
      if (h > 23 || mi > 59 || se > 59) continue;
      if (mer != null) {
        final pm = RegExp('^(?:$_pm)\$', caseSensitive: false).hasMatch(mer);
        if (h > 12) {
          // "14:30 pm": the 24-hour value wins.
        } else if (pm) {
          // "raat 1 baje" / "night 2:00" means after midnight.
          final lateNight = RegExp(r'^(?:night|raat|rat)$').hasMatch(mer) && h <= 4;
          h = lateNight ? h % 12 : h % 12 + 12;
          if (lateNight) {
            out.notes.add('"$mer $h" read as ${h.toString().padLeft(2, '0')}:'
                '${mi.toString().padLeft(2, '0')} after midnight. Check the date.');
          }
        } else {
          h = h % 12;
        }
      } else if (h <= 12) {
        out.notes.add('No AM/PM given: time read as 24-hour (${h.toString().padLeft(2, '0')}:'
            '${mi.toString().padLeft(2, '0')}).');
      }
      out
        ..hour = h
        ..minute = mi
        ..second = se;
      return (m.start, m.end);
    }
    return null;
  }

  static String? _gender(String s) {
    final t = s.toLowerCase();
    if (RegExp(r'\b(?:female|girl|f|daughter|stri|ladki|mahila)\b').hasMatch(t)) {
      return 'female';
    }
    if (RegExp(r'\b(?:male|boy|m|son|purush|ladka)\b').hasMatch(t)) {
      return 'male';
    }
    return null;
  }

  static String? _clean(String? s) {
    if (s == null) return null;
    final v = s
        .replaceAll(RegExp(r'[\u0000*_~"“”]'), ' ')
        .replaceAll(RegExp(r'^[\s,;:.\-–|]+|[\s,;:.\-–|]+$'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return v.isEmpty ? null : v;
  }

  static String? _cleanPlace(String? s) {
    final v = _clean(s);
    if (v == null) return null;
    // "Lucknow, UP, India" → keep as typed; the atlas search uses the first part.
    return v;
  }
}
