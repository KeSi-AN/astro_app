import 'dart:ui';

import 'package:jyotish_core/jyotish_core.dart';

import '../domain/chart_plate.dart';

enum ChartStyle {
  north('North Indian'),
  south('South Indian'),
  east('East Indian');

  const ChartStyle(this.label);
  final String label;
}

/// One cell of a drawn chart: its outline, where its text goes and where
/// the sign/house number sits.
class CellGeometry {
  const CellGeometry({
    required this.polygon,
    required this.textBox,
    required this.numberAt,
    required this.house,
  });

  final List<Offset> polygon;

  /// Area for the planet labels.
  final Rect textBox;

  /// Centre of the small sign-number label (North) or null-ish corner.
  final Offset numberAt;
  final PlateHouse house;
}

/// A placed planet label, for drawing and for hit-testing taps.
class PlacedLabel {
  const PlacedLabel(this.rect, this.item, this.house);
  final Rect rect;
  final PlateItem item;
  final PlateHouse house;
}

/// Computes cell polygons for a [plate] drawn in [style] at [size].
/// Shared by the painter and the tap handler so they always agree.
List<CellGeometry> chartCells(ChartPlate plate, ChartStyle style, Size size) {
  final s = size.shortestSide;
  return switch (style) {
    ChartStyle.north => _north(plate, s),
    ChartStyle.south => _south(plate, s),
    ChartStyle.east => _east(plate, s),
  };
}

List<CellGeometry> _north(ChartPlate plate, double s) {
  final tl = Offset.zero,
      tr = Offset(s, 0),
      br = Offset(s, s),
      bl = Offset(0, s);
  final t = Offset(s / 2, 0),
      r = Offset(s, s / 2),
      b = Offset(s / 2, s),
      l = Offset(0, s / 2);
  final c = Offset(s / 2, s / 2);
  final p1 = Offset(s / 4, s / 4), p2 = Offset(3 * s / 4, s / 4);
  final p3 = Offset(3 * s / 4, 3 * s / 4), p4 = Offset(s / 4, 3 * s / 4);

  // Houses run anticlockwise from the top diamond.
  final polys = <List<Offset>>[
    [t, p2, c, p1], // 1
    [tl, t, p1], // 2
    [tl, p1, l], // 3
    [l, p1, c, p4], // 4
    [l, p4, bl], // 5
    [bl, p4, b], // 6
    [b, p4, c, p3], // 7
    [b, p3, br], // 8
    [br, p3, r], // 9
    [r, p3, c, p2], // 10
    [r, p2, tr], // 11
    [tr, p2, t], // 12
  ];
  // The sign number sits near the vertex pointing at the centre.
  final inner = <Offset>[c, p1, p1, c, p4, p4, c, p3, p3, c, p2, p2];
  return [
    for (var i = 0; i < 12; i++)
      () {
        final poly = polys[i];
        final cen = _centroid(poly);
        final diamond = poly.length == 4;
        final w = diamond ? s * 0.3 : s * 0.2;
        final h = diamond ? s * 0.26 : s * 0.16;
        final toInner = inner[i] - cen;
        final number = cen + toInner * (diamond ? 0.62 : 0.55);
        // Push triangle text away from the number, towards the outer edge.
        final textCentre = diamond
            ? cen - toInner * 0.12
            : cen - toInner * 0.22;
        return CellGeometry(
          polygon: poly,
          textBox: _fit(
            Rect.fromCenter(center: textCentre, width: w, height: h),
            s,
          ),
          numberAt: number,
          house: plate.houses[i],
        );
      }(),
  ];
}

List<CellGeometry> _south(ChartPlate plate, double s) {
  final q = s / 4;
  // Fixed sign cells (col, row), Pisces top-left, running clockwise.
  const cells = {
    Rashi.pisces: (0, 0),
    Rashi.aries: (1, 0),
    Rashi.taurus: (2, 0),
    Rashi.gemini: (3, 0),
    Rashi.cancer: (3, 1),
    Rashi.leo: (3, 2),
    Rashi.virgo: (3, 3),
    Rashi.libra: (2, 3),
    Rashi.scorpio: (1, 3),
    Rashi.sagittarius: (0, 3),
    Rashi.capricorn: (0, 2),
    Rashi.aquarius: (0, 1),
  };
  return [
    for (final h in plate.houses)
      () {
        final (cx, cy) = cells[h.sign]!;
        final rect = Rect.fromLTWH(cx * q, cy * q, q, q);
        return CellGeometry(
          polygon: [
            rect.topLeft,
            rect.topRight,
            rect.bottomRight,
            rect.bottomLeft,
          ],
          textBox: rect.deflate(q * 0.06).translate(0, q * 0.06),
          numberAt: rect.topRight + Offset(-q * 0.12, q * 0.12),
          house: h,
        );
      }(),
  ];
}

List<CellGeometry> _east(ChartPlate plate, double s) {
  final k = s / 3;
  Offset p(double x, double y) => Offset(x * k, y * k);
  // Fixed signs, Aries top-middle, anticlockwise. Corner cells are split by
  // the diagonal from the outer corner to the inner corner.
  final polys = <Rashi, List<Offset>>{
    Rashi.aries: [p(1, 0), p(2, 0), p(2, 1), p(1, 1)],
    Rashi.taurus: [p(0, 0), p(1, 0), p(1, 1)],
    Rashi.gemini: [p(0, 0), p(1, 1), p(0, 1)],
    Rashi.cancer: [p(0, 1), p(1, 1), p(1, 2), p(0, 2)],
    Rashi.leo: [p(0, 2), p(1, 2), p(0, 3)],
    Rashi.virgo: [p(1, 2), p(1, 3), p(0, 3)],
    Rashi.libra: [p(1, 2), p(2, 2), p(2, 3), p(1, 3)],
    Rashi.scorpio: [p(2, 2), p(3, 3), p(2, 3)],
    Rashi.sagittarius: [p(2, 2), p(3, 2), p(3, 3)],
    Rashi.capricorn: [p(2, 1), p(3, 1), p(3, 2), p(2, 2)],
    Rashi.aquarius: [p(2, 1), p(3, 0), p(3, 1)],
    Rashi.pisces: [p(2, 0), p(3, 0), p(2, 1)],
  };
  return [
    for (final h in plate.houses)
      () {
        final poly = polys[h.sign]!;
        final cen = _centroid(poly);
        final square = poly.length == 4;
        final bounds = _bounds(poly);
        if (square) {
          return CellGeometry(
            polygon: poly,
            textBox: Rect.fromCenter(
              center: cen,
              width: k * 0.9,
              height: k * 0.8,
            ),
            numberAt: bounds.topRight + Offset(-k * 0.1, k * 0.1),
            house: h,
          );
        }
        // Corner triangles: put the number in the right-angle corner and
        // the text between it and the diagonal, clear of both.
        final right = _rightAngleVertex(poly);
        final towardRight = right - cen;
        final dir = towardRight / towardRight.distance;
        return CellGeometry(
          polygon: poly,
          textBox: Rect.fromCenter(
            center: cen + towardRight * 0.25,
            width: k * 0.42,
            height: k * 0.42,
          ),
          numberAt: right - dir * (k * 0.12),
          house: h,
        );
      }(),
  ];
}

/// The vertex of a right triangle where the two legs meet.
Offset _rightAngleVertex(List<Offset> t) {
  for (var i = 0; i < 3; i++) {
    final v = t[i], a = t[(i + 1) % 3] - v, b = t[(i + 2) % 3] - v;
    if ((a.dx * b.dx + a.dy * b.dy).abs() < 1e-6) return v;
  }
  return _centroid(t);
}

/// Shifts [r] so it lies inside the 0..[s] square.
Rect _fit(Rect r, double s) {
  final dx = r.left < 0 ? -r.left : (r.right > s ? s - r.right : 0.0);
  final dy = r.top < 0 ? -r.top : (r.bottom > s ? s - r.bottom : 0.0);
  return r.shift(Offset(dx, dy));
}

Offset _centroid(List<Offset> pts) {
  var x = 0.0, y = 0.0;
  for (final p in pts) {
    x += p.dx;
    y += p.dy;
  }
  return Offset(x / pts.length, y / pts.length);
}

Rect _bounds(List<Offset> pts) {
  var r = Rect.fromPoints(pts.first, pts.first);
  for (final p in pts) {
    r = r.expandToInclude(Rect.fromPoints(p, p));
  }
  return r;
}

/// Ray-casting point-in-polygon test.
bool polygonContains(List<Offset> poly, Offset pt) {
  var inside = false;
  for (var i = 0, j = poly.length - 1; i < poly.length; j = i++) {
    final a = poly[i], b = poly[j];
    if ((a.dy > pt.dy) != (b.dy > pt.dy) &&
        pt.dx < (b.dx - a.dx) * (pt.dy - a.dy) / (b.dy - a.dy) + a.dx) {
      inside = !inside;
    }
  }
  return inside;
}
