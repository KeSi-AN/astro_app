import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'pdf_text.dart';

/// Colours of the printed kundli: deep saffron and maroon on cream, which
/// print well in colour and stay readable in black and white.
abstract final class ReportColors {
  static const accent = PdfColor.fromInt(0xFF8C2F1B);
  static const accentLight = PdfColor.fromInt(0xFFF7E9DA);
  static const stripe = PdfColor.fromInt(0xFFFBF6F0);
  static const chartLine = PdfColor.fromInt(0xFFB5541C);
  static const rule = PdfColor.fromInt(0xFFD9B99B);
  static const muted = PdfColor.fromInt(0xFF7A6A5E);
  static const good = PdfColor.fromInt(0xFF2E7D32);
  static const bad = PdfColor.fromInt(0xFFC62828);
}

/// Usable width of an A4 page inside the report margins.
const contentWidth = 595.28 - 2 * 36;

/// Common building blocks for report pages.
class ReportKit {
  ReportKit(this.k);
  final PdfTextKit k;

  pw.Widget heading(String text) => pw.Container(
    margin: const pw.EdgeInsets.only(top: 4, bottom: 8),
    padding: const pw.EdgeInsets.only(bottom: 3),
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: ReportColors.chartLine, width: 1.2),
      ),
    ),
    child: k.text(text, size: 14, bold: true, color: ReportColors.accent),
  );

  pw.Widget subheading(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 8, bottom: 4),
    child: k.text(text, size: 10.5, bold: true, color: ReportColors.accent),
  );

  pw.Widget note(String text, {double width = contentWidth}) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 4),
    child: k.text(text, size: 7.5, color: ReportColors.muted, maxWidth: width),
  );

  /// A ruled table with a tinted header and striped rows.
  ///
  /// [widths] are fixed column widths in points (when a cell holds a long
  /// rasterised text, its column must be fixed so the text can wrap).
  pw.Widget table(
    List<String>? header,
    List<List<String>> rows, {
    List<double>? widths,
    double size = 8,
    PdfColor? Function(int row, int col)? color,
    bool Function(int row)? boldRow,
    List<pw.Alignment>? align,
  }) {
    final cols = header?.length ?? rows.first.length;
    pw.Widget cell(String s, int r, int c, {bool head = false}) {
      final w = widths?[c];
      return pw.Container(
        alignment: align?[c] ??
            (c == 0 ? pw.Alignment.centerLeft : pw.Alignment.center),
        padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        child: k.text(
          s,
          size: head ? size * 0.95 : size,
          bold: head || (boldRow?.call(r) ?? false),
          color: head
              ? ReportColors.accent
              : (color?.call(r, c) ?? PdfColors.black),
          maxWidth: w == null || k.isNative(s) ? null : w - 6,
        ),
      );
    }

    return pw.Table(
      border: const pw.TableBorder(
        top: pw.BorderSide(color: ReportColors.rule, width: 0.6),
        bottom: pw.BorderSide(color: ReportColors.rule, width: 0.6),
        left: pw.BorderSide(color: ReportColors.rule, width: 0.6),
        right: pw.BorderSide(color: ReportColors.rule, width: 0.6),
        horizontalInside: pw.BorderSide(color: ReportColors.rule, width: 0.3),
        verticalInside: pw.BorderSide(color: ReportColors.rule, width: 0.3),
      ),
      columnWidths: widths == null
          ? null
          : {
              for (var i = 0; i < cols; i++)
                i: pw.FixedColumnWidth(widths[i]),
            },
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        if (header != null)
          pw.TableRow(
          repeat: true,
          decoration: const pw.BoxDecoration(color: ReportColors.accentLight),
          children: [
            for (var c = 0; c < cols; c++) cell(header[c], -1, c, head: true),
          ],
        ),
        for (var r = 0; r < rows.length; r++)
          pw.TableRow(
            decoration: r.isOdd
                ? const pw.BoxDecoration(color: ReportColors.stripe)
                : null,
            children: [
              for (var c = 0; c < cols; c++) cell(rows[r][c], r, c),
            ],
          ),
      ],
    );
  }

  /// Two-column label/value table under a small title.
  pw.Widget keyValues(
    String title,
    List<(String, String)> rows, {
    double width = contentWidth,
    double labelWidth = 0.42,
  }) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      subheading(title),
      table(
        null,
        [
          for (final (a, b) in rows) [a, b],
        ],
        widths: [width * labelWidth, width * (1 - labelWidth)],
        align: const [pw.Alignment.centerLeft, pw.Alignment.centerLeft],
        color: (r, c) => c == 0 ? ReportColors.muted : null,
      ),
    ],
  );
}
