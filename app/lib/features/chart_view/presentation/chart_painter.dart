import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../l10n/l10n.dart';
import '../domain/chart_plate.dart';
import 'chart_geometry.dart';

class ChartColors {
  const ChartColors({
    required this.line,
    required this.text,
    required this.number,
    required this.lagna,
    required this.malefic,
    required this.benefic,
    required this.background,
  });

  factory ChartColors.of(ThemeData t) => ChartColors(
    line: t.colorScheme.primary,
    text: t.colorScheme.onSurface,
    number: t.colorScheme.primary.withValues(alpha: 0.8),
    lagna: t.colorScheme.primary,
    malefic: const Color(0xFFE57373),
    benefic: const Color(0xFF81C784),
    background: t.colorScheme.surface,
  );

  final Color line, text, number, lagna, malefic, benefic, background;
}

/// Lays out the planet labels inside each cell: one or two columns of rows,
/// shrinking the font when a cell is crowded.
List<PlacedLabel> layoutLabels(
  List<CellGeometry> cells,
  double size,
  ChartStyle style,
) {
  final out = <PlacedLabel>[];
  for (final c in cells) {
    final items = c.house.items;
    if (items.isEmpty) continue;
    final box = c.textBox;
    final cols = items.length > 4 ? 2 : 1;
    final rows = (items.length / cols).ceil();
    final rowH = box.height / rows.clamp(2, 6);
    final colW = box.width / cols;
    final top = box.center.dy - rowH * rows / 2;
    for (var i = 0; i < items.length; i++) {
      final col = cols == 1 ? 0 : i % cols;
      final row = cols == 1 ? i : i ~/ cols;
      out.add(
        PlacedLabel(
          Rect.fromLTWH(box.left + col * colW, top + row * rowH, colW, rowH),
          items[i],
          c.house,
        ),
      );
    }
  }
  return out;
}

class ChartPainter extends CustomPainter {
  ChartPainter({
    required this.plate,
    required this.style,
    required this.colors,
    required this.terms,
    required this.title,
    this.selected,
  });

  final ChartPlate plate;
  final ChartStyle style;
  final ChartColors colors;
  final AstroTerms terms;
  final String title;
  final Graha? selected;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final cells = chartCells(plate, style, size);
    final line = Paint()
      ..color = colors.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    // Outline and cells.
    canvas.drawRect(Rect.fromLTWH(0, 0, s, s), line);
    for (final c in cells) {
      canvas.drawPath(Path()..addPolygon(c.polygon, true), line);
    }

    // South/East: mark the lagna cell with a diagonal and centre title.
    if (style != ChartStyle.north) {
      final lagnaCell = cells.firstWhere((c) => c.house.number == 1);
      final r = _bounds(lagnaCell.polygon);
      if (style == ChartStyle.south) {
        canvas.drawLine(
          r.topLeft,
          r.topLeft + Offset(r.width * 0.3, r.height * 0.3),
          line,
        );
      }
      final centre = style == ChartStyle.south
          ? Rect.fromLTWH(s / 4, s / 4, s / 2, s / 2)
          : Rect.fromLTWH(s / 3, s / 3, s / 3, s / 3);
      _text(
        canvas,
        title,
        centre.center,
        s * 0.04,
        colors.number,
        maxWidth: centre.width * 0.9,
      );
    }

    // Sign (North) numbers.
    final numSize = s * 0.032;
    for (final c in cells) {
      if (style == ChartStyle.north) {
        _text(
          canvas,
          '${c.house.sign.number}',
          c.numberAt,
          numSize,
          colors.number,
        );
      } else if (c.house.number != 1) {
        // Show house numbers small in fixed-sign styles.
        _text(
          canvas,
          '${c.house.number}',
          c.numberAt,
          numSize * 0.8,
          colors.number.withValues(alpha: 0.6),
        );
      }
    }

    // Planet labels.
    for (final l in layoutLabels(cells, s, style)) {
      final isLagna = l.item.graha == null;
      final crowded = l.rect.height < s * 0.045;
      final fs = (crowded ? l.rect.height * 0.85 : s * 0.037).clamp(7.0, 16.0);
      final color = isLagna ? colors.lagna : colors.text;
      if (selected != null && l.item.graha == selected) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(l.rect.deflate(1), const Radius.circular(4)),
          Paint()..color = colors.line.withValues(alpha: 0.25),
        );
      }
      _text(
        canvas,
        l.item.labelWith(
          l.item.graha == null
              ? terms.lagnaShort
              : terms.grahaShort(l.item.graha!),
        ),
        l.rect.center,
        fs.toDouble(),
        color,
        bold: isLagna,
        maxWidth: l.rect.width,
      );
    }
  }

  void _text(
    Canvas canvas,
    String text,
    Offset centre,
    double size,
    Color color, {
    bool bold = false,
    double? maxWidth,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 2,
      ellipsis: '…',
    )..layout(maxWidth: maxWidth ?? double.infinity);
    tp.paint(canvas, centre - Offset(tp.width / 2, tp.height / 2));
  }

  Rect _bounds(List<Offset> pts) {
    var r = Rect.fromPoints(pts.first, pts.first);
    for (final p in pts) {
      r = r.expandToInclude(Rect.fromPoints(p, p));
    }
    return r;
  }

  @override
  bool shouldRepaint(ChartPainter old) =>
      old.plate != plate ||
      old.style != style ||
      old.selected != selected ||
      old.title != title ||
      old.terms != terms ||
      old.colors.line != colors.line;
}

/// Square chart that reports taps on a planet (or a house).
class ChartWidget extends StatelessWidget {
  const ChartWidget({
    super.key,
    required this.plate,
    required this.style,
    this.selected,
    this.title,
    this.onGrahaTap,
  });

  final ChartPlate plate;
  final ChartStyle style;
  final Graha? selected;

  /// Shown in the centre of South/East charts; defaults to the plate title.
  final String? title;
  final void Function(Graha? graha, PlateHouse house)? onGrahaTap;

  @override
  Widget build(BuildContext context) {
    final colors = ChartColors.of(Theme.of(context));
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, box) {
          final size = Size.square(box.biggest.shortestSide);
          return GestureDetector(
            onTapUp: (d) {
              final cells = chartCells(plate, style, size);
              for (final l in layoutLabels(cells, size.width, style)) {
                if (l.rect.inflate(4).contains(d.localPosition)) {
                  onGrahaTap?.call(l.item.graha, l.house);
                  return;
                }
              }
              for (final c in cells) {
                if (polygonContains(c.polygon, d.localPosition)) {
                  onGrahaTap?.call(null, c.house);
                  return;
                }
              }
            },
            child: CustomPaint(
              size: size,
              painter: ChartPainter(
                plate: plate,
                style: style,
                colors: colors,
                terms: context.terms,
                title: title ?? plate.title,
                selected: selected,
              ),
            ),
          );
        },
      ),
    );
  }
}
