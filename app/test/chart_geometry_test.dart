import 'dart:ui';

import 'package:astro_app/features/chart_view/domain/chart_plate.dart';
import 'package:astro_app/features/chart_view/presentation/chart_geometry.dart';
import 'package:astro_app/features/chart_view/presentation/chart_painter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

ChartPlate plateFrom(Rashi asc, {int perHouse = 1}) => ChartPlate(
  title: 'Test',
  ascendantSign: asc,
  houses: [
    for (var h = 1; h <= 12; h++)
      PlateHouse(
        number: h,
        sign: Rashi.values[(asc.index + h - 1) % 12],
        items: [
          for (var i = 0; i < perHouse; i++)
            PlateItem(graha: Graha.values[i % 12], degree: 10),
        ],
      ),
  ],
);

double area(List<Offset> p) {
  var a = 0.0;
  for (var i = 0; i < p.length; i++) {
    final j = (i + 1) % p.length;
    a += p[i].dx * p[j].dy - p[j].dx * p[i].dy;
  }
  return a.abs() / 2;
}

void main() {
  const size = Size(300, 300);

  for (final style in ChartStyle.values) {
    test('$style: 12 cells tile the square and hold their text', () {
      final cells = chartCells(plateFrom(Rashi.cancer), style, size);
      expect(cells.length, 12);
      final total = cells.fold<double>(0, (s, c) => s + area(c.polygon));
      // North and East cover the whole square; South leaves the 2×2 centre.
      final expected = style == ChartStyle.south
          ? 300 * 300 * 0.75
          : 300.0 * 300;
      final expectedArea = style == ChartStyle.east
          ? 300 * 300 * 8 / 9
          : expected;
      expect(total, closeTo(expectedArea, 1));
      for (final c in cells) {
        expect(
          polygonContains(c.polygon, c.textBox.center),
          isTrue,
          reason: 'house ${c.house.number} text centre outside its cell',
        );
      }
    });

    test('$style: crowded houses keep labels inside the chart', () {
      final cells = chartCells(
        plateFrom(Rashi.aries, perHouse: 6),
        style,
        size,
      );
      for (final l in layoutLabels(cells, 300, style)) {
        expect(
          const Rect.fromLTWH(-1, -1, 302, 302).contains(l.rect.center),
          isTrue,
        );
      }
    });
  }

  test('North: house 1 is the top diamond, house 4 the left one', () {
    final cells = chartCells(plateFrom(Rashi.cancer), ChartStyle.north, size);
    expect(polygonContains(cells[0].polygon, const Offset(150, 75)), isTrue);
    expect(polygonContains(cells[3].polygon, const Offset(75, 150)), isTrue);
    expect(polygonContains(cells[6].polygon, const Offset(150, 225)), isTrue);
    expect(polygonContains(cells[9].polygon, const Offset(225, 150)), isTrue);
  });

  test('South: signs are fixed, Pisces top-left, Aries next', () {
    final cells = chartCells(plateFrom(Rashi.cancer), ChartStyle.south, size);
    Rect cellOf(Rashi r) {
      final c = cells.firstWhere((c) => c.house.sign == r);
      return Rect.fromPoints(c.polygon[0], c.polygon[2]);
    }

    expect(cellOf(Rashi.pisces).topLeft, Offset.zero);
    expect(cellOf(Rashi.aries).topLeft, const Offset(75, 0));
    expect(cellOf(Rashi.virgo).topLeft, const Offset(225, 225));
    expect(cellOf(Rashi.aquarius).topLeft, const Offset(0, 75));
  });

  test('East: Aries is top-middle, Libra bottom-middle', () {
    final cells = chartCells(plateFrom(Rashi.leo), ChartStyle.east, size);
    bool at(Rashi r, Offset p) =>
        polygonContains(cells.firstWhere((c) => c.house.sign == r).polygon, p);
    expect(at(Rashi.aries, const Offset(150, 50)), isTrue);
    expect(at(Rashi.libra, const Offset(150, 250)), isTrue);
    expect(at(Rashi.cancer, const Offset(50, 150)), isTrue);
    expect(at(Rashi.capricorn, const Offset(250, 150)), isTrue);
    expect(at(Rashi.taurus, const Offset(60, 20)), isTrue); // upper triangle
    expect(at(Rashi.gemini, const Offset(20, 60)), isTrue); // lower triangle
  });

  test('plate item labels carry AstroSage-style markers', () {
    const item = PlateItem(
      graha: Graha.saturn,
      degree: 3,
      retrograde: true,
      exalted: true,
    );
    expect(item.label, 'Sa*↑ 03');
    const lagna = PlateItem(graha: null, degree: 29);
    expect(lagna.label, 'As 29');
  });
}
