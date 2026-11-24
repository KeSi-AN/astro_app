const _monthShort = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _two(int v) => v.toString().padLeft(2, '0');

/// 12 Mar 1990
String formatDate(int y, int m, int d) => '${_two(d)} ${_monthShort[m - 1]} $y';

/// 12/03/1990 (form field format)
String formatDateInput(int y, int m, int d) => '${_two(d)}/${_two(m)}/$y';

/// 10:45:00
String formatTime(int h, int m, int s) => '${_two(h)}:${_two(m)}:${_two(s)}';

/// UTC+05:30, UTC−04:51:00 (seconds only when non-zero)
String formatOffset(double hours) {
  final sign = hours < 0 ? '−' : '+';
  final total = (hours.abs() * 3600).round();
  final h = total ~/ 3600, m = total % 3600 ~/ 60, s = total % 60;
  return 'UTC$sign${_two(h)}:${_two(m)}${s == 0 ? '' : ':${_two(s)}'}';
}

/// Signed h:mm:ss for small corrections like LMT (−00:18:00).
String formatSignedHms(double hours) {
  final sign = hours < 0 ? '−' : '+';
  final total = (hours.abs() * 3600).round();
  return '$sign${_two(total ~/ 3600)}:${_two(total % 3600 ~/ 60)}:${_two(total % 60)}';
}

/// Parses "12/03/1990", "12-3-1990", "12.03.1990" → [y, m, d] (day first).
List<int>? parseDateInput(String s) {
  final m = RegExp(r'^\s*(\d{1,2})\s*[/\-.]\s*(\d{1,2})\s*[/\-.]\s*(\d{4})\s*$')
      .firstMatch(s);
  if (m == null) return null;
  final d = int.parse(m[1]!), mo = int.parse(m[2]!), y = int.parse(m[3]!);
  if (mo < 1 || mo > 12 || d < 1) return null;
  final dt = DateTime(y, mo, d);
  if (dt.month != mo || dt.day != d) return null;
  if (y < 1800 || y > 2399) return null; // ephemeris files cover 1800–2399
  return [y, mo, d];
}

/// Parses "10:45", "10:45:30", "7.05" (24-hour) → [h, m, s].
List<int>? parseTimeInput(String s) {
  final m = RegExp(r'^\s*(\d{1,2})\s*[:.]\s*(\d{1,2})(?:\s*[:.]\s*(\d{1,2}))?\s*$')
      .firstMatch(s);
  if (m == null) return null;
  final h = int.parse(m[1]!), mi = int.parse(m[2]!), se = int.parse(m[3] ?? '0');
  if (h > 23 || mi > 59 || se > 59) return null;
  return [h, mi, se];
}

/// Parses an offset like "5:30", "+5.5", "-4:51:00" → hours.
double? parseOffsetInput(String s) {
  final t = s.trim().replaceAll('−', '-');
  final m = RegExp(r'^([+-])?(\d{1,2})(?:[:.](\d{1,2}))?(?::(\d{1,2}))?$').firstMatch(t);
  if (m != null && (t.contains(':') || m[3] == null)) {
    final v = int.parse(m[2]!) + int.parse(m[3] ?? '0') / 60 + int.parse(m[4] ?? '0') / 3600;
    return m[1] == '-' ? -v : v;
  }
  final d = double.tryParse(t);
  return d;
}
