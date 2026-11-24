/// Degrees/hours ↔ d°m′s″ helpers. Rounds to the nearest second (AstroSage
/// and JHora both round, not truncate).
class Dms {
  const Dms(this.negative, this.d, this.m, this.s);
  final bool negative;
  final int d, m, s;

  factory Dms.of(double value) {
    final neg = value < 0;
    var total = (value.abs() * 3600).round();
    final d = total ~/ 3600;
    total %= 3600;
    return Dms(neg, d, total ~/ 60, total % 60);
  }

  /// Seconds as a signed total, handy for comparisons in tests.
  int get totalSeconds => (negative ? -1 : 1) * (d * 3600 + m * 60 + s);

  static String _two(int v) => v.toString().padLeft(2, '0');

  /// 07°13′25″
  String get degrees => '${negative ? '-' : ''}${_two(d)}°${_two(m)}′${_two(s)}″';

  /// 23:21:37
  String get clock => '${negative ? '-' : ''}${_two(d)}:${_two(m)}:${_two(s)}';

  @override
  String toString() => degrees;
}

/// Parses "29°13'58\"", "29 13 58" or "29-13-58" into decimal degrees.
double parseDms(String text) {
  final parts = RegExp(r'\d+(\.\d+)?')
      .allMatches(text)
      .map((m) => double.parse(m.group(0)!))
      .toList();
  if (parts.isEmpty) throw FormatException('No numbers in "$text"');
  final d = parts[0], m = parts.length > 1 ? parts[1] : 0, s = parts.length > 2 ? parts[2] : 0;
  final v = d + m / 60 + s / 3600;
  return text.trim().startsWith('-') ? -v : v;
}
