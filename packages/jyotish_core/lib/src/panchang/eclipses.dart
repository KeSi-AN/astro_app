import 'dart:math';

import '../ephemeris/ephemeris.dart';
import 'day_panchang.dart';

/// An eclipse at a place, with its sutak (the period before it when food
/// and worship are avoided).
class EclipseAtPlace {
  const EclipseAtPlace(this.event, {this.sutakStart, this.sutakKidsStart});

  final EclipseEvent event;

  /// 4 prahar (12 h) before a solar eclipse, 3 prahar (9 h) before a lunar
  /// one, counted from its start (for a Moon rising eclipsed, from the
  /// start of the umbral phase, not moonrise). Null when there is no sutak
  /// (not visible, or penumbral only).
  final double? sutakStart;

  /// For children, the old and the sick: from the last sunrise (solar) or
  /// sunset (lunar) before the eclipse, if later than [sutakStart].
  final double? sutakKidsStart;

  /// When the place starts and stops seeing it (null if not visible).
  double? get visibleStart {
    final e = event;
    if (!e.visible) return null;
    final b = e.kind == EclipseKind.lunar && e.type == EclipseType.penumbral
        ? e.penumbralBegin
        : e.begin;
    return e.bodyRise != null && b != null ? max(b, e.bodyRise!) : b;
  }

  double? get visibleEnd {
    final e = event;
    if (!e.visible) return null;
    final b = e.kind == EclipseKind.lunar && e.type == EclipseType.penumbral
        ? e.penumbralEnd
        : e.end;
    return e.bodySet != null && b != null ? min(b, e.bodySet!) : b;
  }

  /// Sutak lasts until the eclipse ends.
  double? get sutakEnd => sutakStart == null ? null : visibleEnd;
}

/// Solar and lunar eclipses with maximum in [from, to), in time order.
List<EclipseAtPlace> eclipsesBetween(
  Ephemeris eph,
  PanchangPlace place,
  double from,
  double to,
) {
  final out = <EclipseAtPlace>[];
  for (final kind in EclipseKind.values) {
    var jd = from - 0.5;
    while (true) {
      final e = eph.nextEclipse(kind, jd, place.latitude, place.longitude);
      if (e.maximum >= to) break;
      jd = e.maximum + 10;
      if (e.maximum < from) continue;
      out.add(_withSutak(eph, place, e));
    }
  }
  out.sort((a, b) => a.event.maximum.compareTo(b.event.maximum));
  return out;
}

EclipseAtPlace _withSutak(Ephemeris eph, PanchangPlace place, EclipseEvent e) {
  final at = EclipseAtPlace(e);
  final start = e.begin;
  final sutakApplies = e.visible && e.type != EclipseType.penumbral && start != null;
  if (!sutakApplies) return at;
  final solar = e.kind == EclipseKind.solar;
  final sutak = start - (solar ? 12 : 9) / 24;
  // Last sunrise (solar) or sunset (lunar) at or before the start.
  double? last;
  var t = start - 1.05;
  while (true) {
    final ev = eph.sunEvent(t, place.latitude, place.longitude, rise: solar);
    if (ev == null || ev > start + 1e-6) break;
    last = ev;
    t = ev + 0.01;
  }
  return EclipseAtPlace(
    e,
    sutakStart: sutak,
    sutakKidsStart: last == null ? sutak : max(sutak, last),
  );
}
