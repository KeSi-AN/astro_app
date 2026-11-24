import '../chart/rasi_chart.dart';
import '../ephemeris/ephemeris.dart';
import '../model/enums.dart';

enum SadeSatiKind { sadeSati, smallPanoti }

enum SadeSatiPhase { rising, peak, setting, none }

/// One continuous stay of Saturn in a sign that matters for the Moon:
/// 12th, 1st, 2nd (Sade Sati) or 4th, 8th (Small Panoti / Dhaiya).
class SaturnPeriod {
  const SaturnPeriod({
    required this.kind,
    required this.phase,
    required this.sign,
    required this.start,
    required this.end,
  });
  final SadeSatiKind kind;
  final SadeSatiPhase phase;
  final Rashi sign;

  /// Julian days (UT).
  final double start;
  final double end;

  bool contains(double jd) => jd >= start && jd < end;
}

/// Saturn's periods relative to the natal Moon sign, from the one running
/// at birth to [years] after birth. Retrograde re-entries give separate
/// periods, as in AstroSage's report.
List<SaturnPeriod> sadeSati(
  RasiChart chart,
  Ephemeris eph, {
  int years = 100,
}) {
  final moon = chart.grahas[Graha.moon]!.rashi.index;
  SadeSatiPhase? phaseFor(int sign) => switch ((sign - moon) % 12) {
        11 => SadeSatiPhase.rising,
        0 => SadeSatiPhase.peak,
        1 => SadeSatiPhase.setting,
        3 || 7 => SadeSatiPhase.none,
        _ => null,
      };
  int signAt(double jd) =>
      eph.position(jd, Graha.saturn, chart.settings).longitude ~/ 30 % 12;

  // Find every ingress between (birth − 3 years) and the end, by stepping
  // and bisecting to the minute.
  final from = chart.jdUt - 3 * 365.25;
  final to = chart.jdUt + years * 365.25;
  const step = 4.0;
  final changes = <(double, int)>[(from, signAt(from))];
  var prev = changes.first.$2;
  for (var t = from + step; t <= to; t += step) {
    final s = signAt(t);
    if (s == prev) continue;
    var lo = t - step, hi = t;
    for (var i = 0; i < 25; i++) {
      final mid = (lo + hi) / 2;
      if (signAt(mid) == prev) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    changes.add((hi, s));
    prev = s;
  }

  final out = <SaturnPeriod>[];
  for (var i = 0; i < changes.length; i++) {
    final (start, sign) = changes[i];
    final end = i + 1 < changes.length ? changes[i + 1].$1 : to;
    final phase = phaseFor(sign);
    if (phase == null || end < chart.jdUt) continue;
    out.add(SaturnPeriod(
      kind: phase == SadeSatiPhase.none
          ? SadeSatiKind.smallPanoti
          : SadeSatiKind.sadeSati,
      phase: phase,
      sign: Rashi.values[sign],
      start: start,
      end: end,
    ));
  }
  return out;
}
