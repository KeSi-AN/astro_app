import 'dart:ui' as ui;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../l10n/astro_terms.dart';
import '../chart_view/domain/chart_plate.dart';
import '../chart_view/presentation/chart_geometry.dart';
import '../chart_view/presentation/chart_painter.dart' show layoutLabels;
import 'pdf_text.dart';
import 'report_style.dart';

/// A chart plate drawn as vector lines, using the same cell geometry and
/// label layout as the screen.
pw.Widget pdfChart(
  PdfTextKit k,
  ChartPlate plate,
  ChartStyle style,
  AstroTerms terms, {
  required double size,
  String? centreTitle,
}) {
  final s = size;
  final cells = chartCells(plate, style, ui.Size(s, s));
  final labels = layoutLabels(cells, s, style);
  final north = style == ChartStyle.north;

  pw.Widget at(ui.Offset c, double w, double h, pw.Widget child) =>
      pw.Positioned(
        left: c.dx - w / 2,
        top: c.dy - h / 2,
        child: pw.SizedBox(
          width: w,
          height: h,
          child: pw.Center(
            child: pw.FittedBox(fit: pw.BoxFit.scaleDown, child: child),
          ),
        ),
      );

  final numSize = s * 0.032;
  final children = <pw.Widget>[
    pw.CustomPaint(
      size: PdfPoint(s, s),
      painter: (canvas, _) {
        canvas
          ..setStrokeColor(ReportColors.chartLine)
          ..setLineWidth(0.8)
          ..setLineJoin(PdfLineJoin.round);
        canvas.drawRect(0, 0, s, s);
        for (final c in cells) {
          final p = c.polygon;
          canvas.moveTo(p.first.dx, s - p.first.dy);
          for (final q in p.skip(1)) {
            canvas.lineTo(q.dx, s - q.dy);
          }
          canvas.closePath();
        }
        if (style == ChartStyle.south) {
          final r = _bounds(cells.firstWhere((c) => c.house.number == 1).polygon);
          canvas
            ..moveTo(r.left, s - r.top)
            ..lineTo(r.left + r.width * 0.3, s - (r.top + r.height * 0.3));
        }
        canvas.strokePath();
      },
    ),
  ];

  if (!north && centreTitle != null) {
    final centre = style == ChartStyle.south
        ? ui.Rect.fromLTWH(s / 4, s / 4, s / 2, s / 2)
        : ui.Rect.fromLTWH(s / 3, s / 3, s / 3, s / 3);
    children.add(
      at(
        centre.center,
        centre.width * 0.9,
        centre.height * 0.5,
        k.text(
          centreTitle,
          size: s * 0.04,
          color: ReportColors.accent,
          bold: true,
          align: pw.TextAlign.center,
        ),
      ),
    );
  }

  // Sign (North) or house (South/East) numbers, with an optional badge.
  for (final c in cells) {
    final badge = c.house.badge;
    if (!north && c.house.number == 1 && badge == null) continue;
    final n = north ? '${c.house.sign.number}' : '${c.house.number}';
    final text = badge == null
        ? n
        : (!north && c.house.number == 1 ? badge : '$n · $badge');
    children.add(
      at(
        c.numberAt,
        s * 0.16,
        s * 0.06,
        k.text(
          text,
          size: north ? numSize : numSize * 0.8,
          bold: badge != null,
          color: badge != null ? ReportColors.accent : ReportColors.muted,
        ),
      ),
    );
  }

  for (final l in labels) {
    final isLagna = l.item.graha == null;
    final crowded = l.rect.height < s * 0.045;
    final fs = (crowded ? l.rect.height * 0.8 : s * 0.036).clamp(4.5, 12.0);
    final label = l.item.labelWith(
      isLagna ? terms.lagnaShort : terms.grahaShort(l.item.graha!),
    );
    children.add(
      at(
        l.rect.center,
        l.rect.width,
        l.rect.height,
        k.text(
          label,
          size: fs.toDouble(),
          bold: isLagna,
          color: isLagna ? ReportColors.accent : PdfColors.black,
        ),
      ),
    );
  }

  return pw.SizedBox(
    width: s,
    height: s,
    child: pw.Stack(overflow: pw.Overflow.visible, children: children),
  );
}

ui.Rect _bounds(List<ui.Offset> pts) {
  var r = ui.Rect.fromPoints(pts.first, pts.first);
  for (final p in pts) {
    r = r.expandToInclude(ui.Rect.fromPoints(p, p));
  }
  return r;
}
