import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart' as fp;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Text for the PDF.
///
/// The pdf package draws Latin text from an embedded font but cannot shape
/// Devanagari (no conjuncts, matras land in the wrong place). Any string
/// the embedded font cannot draw is therefore drawn by Flutter's own text
/// engine, which shapes it properly, and placed in the PDF as a
/// high-resolution image.
///
/// Images are made in a second pass: build the document once, which
/// records every such string, call [renderPending], then build it again.
class PdfTextKit {
  PdfTextKit({required ByteData regular, required ByteData bold})
    : regularFont = pw.Font.ttf(regular),
      boldFont = pw.Font.ttf(bold),
      _cmap = TtfParser(regular).charToGlyphIndexMap.keys.toSet();

  final pw.Font regularFont, boldFont;
  final Set<int> _cmap;

  /// Pixels per PDF point for rasterised text (4 ≈ 288 dpi).
  static const scale = 4.0;

  final _images = <_Key, _Raster>{};
  final _pending = <_Key>{};

  bool get hasPending => _pending.isNotEmpty;

  /// Number of strings drawn as images so far.
  int get rasterCount => _images.length;

  /// True when the embedded font can draw every character of [s].
  bool isNative(String s) =>
      s.runes.every((r) => r == 0x20 || r == 0x0A || _cmap.contains(r));

  pw.TextStyle style({
    double size = 9,
    bool bold = false,
    PdfColor color = PdfColors.black,
  }) => pw.TextStyle(
    font: bold ? boldFont : regularFont,
    fontBold: boldFont,
    fontSize: size,
    color: color,
  );

  /// [maxWidth] wraps long text (needed for rasterised paragraphs, which
  /// cannot be re-flowed by the PDF layout).
  pw.Widget text(
    String s, {
    double size = 9,
    bool bold = false,
    PdfColor color = PdfColors.black,
    double? maxWidth,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    if (s.isEmpty) return pw.SizedBox(height: size * 1.2);
    if (isNative(s)) {
      final t = pw.Text(
        s,
        style: style(size: size, bold: bold, color: color),
        textAlign: align,
      );
      return maxWidth == null ? t : pw.SizedBox(width: maxWidth, child: t);
    }
    final k = _Key(s, size, bold, color.toInt(), maxWidth, align);
    final r = _images[k];
    if (r == null) {
      _pending.add(k);
      return pw.SizedBox(width: size, height: size * 1.25);
    }
    return pw.Image(r.image, width: r.width, height: r.height);
  }

  /// Draws every string recorded since the last call.
  Future<void> renderPending() async {
    final keys = _pending.toList();
    _pending.clear();
    final results = await Future.wait(keys.map(_render));
    for (var i = 0; i < keys.length; i++) {
      _images[keys[i]] = results[i];
    }
  }

  Future<_Raster> _render(_Key k) async {
    final tp = fp.TextPainter(
      text: fp.TextSpan(
        text: k.text,
        style: fp.TextStyle(
          fontSize: k.size * scale,
          fontWeight: k.bold ? ui.FontWeight.w700 : ui.FontWeight.w400,
          color: ui.Color(k.color),
          height: 1.25,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
      textAlign: switch (k.align) {
        pw.TextAlign.center => ui.TextAlign.center,
        pw.TextAlign.right => ui.TextAlign.right,
        _ => ui.TextAlign.left,
      },
    )..layout(maxWidth: k.maxWidth == null ? double.infinity : k.maxWidth! * scale);
    final w = tp.width.ceil().clamp(1, 20000), h = tp.height.ceil().clamp(1, 20000);
    final rec = ui.PictureRecorder();
    tp.paint(ui.Canvas(rec), ui.Offset.zero);
    final img = await rec.endRecording().toImage(w, h);
    final bytes = await img.toByteData(format: ui.ImageByteFormat.rawStraightRgba);
    img.dispose();
    tp.dispose();
    return _Raster(
      pw.RawImage(bytes: bytes!.buffer.asUint8List(), width: w, height: h),
      w / scale,
      h / scale,
    );
  }
}

class _Raster {
  const _Raster(this.image, this.width, this.height);
  final pw.ImageProvider image;
  final double width, height;
}

class _Key {
  const _Key(this.text, this.size, this.bold, this.color, this.maxWidth, this.align);
  final String text;
  final double size;
  final bool bold;
  final int color;
  final double? maxWidth;
  final pw.TextAlign align;

  @override
  bool operator ==(Object o) =>
      o is _Key &&
      o.text == text &&
      o.size == size &&
      o.bold == bold &&
      o.color == color &&
      o.maxWidth == maxWidth &&
      o.align == align;

  @override
  int get hashCode => Object.hash(text, size, bold, color, maxWidth, align);
}
