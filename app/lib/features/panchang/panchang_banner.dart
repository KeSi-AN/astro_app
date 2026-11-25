import 'dart:math';

import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/theme.dart';
import '../../l10n/l10n.dart';

/// Almanac-style date banner: lunar day and month on the left with the
/// Moon's phase, the civil date on the right, and the day's notable yogas
/// and festivals underneath. Swipe or use the arrows to change the day.
class PanchangBanner extends StatelessWidget {
  const PanchangBanner({
    super.key,
    required this.day,
    required this.calc,
    required this.placeName,
    required this.notes,
    required this.onPrev,
    required this.onNext,
    required this.onPick,
  });

  final DayPanchang day;
  final PanchangCalc calc;
  final String placeName;

  /// Notable things of the day (yogas, festivals), shown in one line.
  final List<String> notes;
  final VoidCallback onPrev, onNext, onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    final look = context.look;
    final d = day;
    final tithi = d.tithis.first.index;
    // Day of the purnimanta month: Krishna paksha 1–15, then Shukla 16–30.
    final monthDay = (tithi + 14) % 30 + 1;
    final elongation = norm360(calc.moon(d.sunrise) - calc.sun(d.sunrise));
    final text = TextStyle(color: look.bannerText, fontSize: 14, height: 1.25);
    final accent = text.copyWith(color: look.bannerAccent, fontWeight: FontWeight.bold);

    return GestureDetector(
      onHorizontalDragEnd: (e) {
        final v = e.primaryVelocity ?? 0;
        if (v < -100) onNext();
        if (v > 100) onPrev();
      },
      onTap: onPick,
      child: Container(
        decoration: BoxDecoration(
          color: look.banner,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [BoxShadow(blurRadius: 3, color: Color(0x44000000))],
        ),
        padding: const EdgeInsets.fromLTRB(4, 10, 4, 8),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: look.bannerAccent),
                  onPressed: onPrev,
                  visualDensity: VisualDensity.compact,
                ),
                SizedBox(
                  width: 52,
                  height: 52,
                  child: CustomPaint(painter: _MoonPainter(elongation)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${monthDay.toString().padLeft(2, '0')}, '
                        '${t.lunarMonth(d.month.purnimanta)}',
                        style: accent.copyWith(fontSize: 17),
                      ),
                      Text('${t.paksha(tithi)}, ${t.tithi(tithi)}', style: text),
                      Text(l10n.vikramSamvatLine('${d.vikram}'), style: text),
                      Text(placeName, style: text.copyWith(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${d.date.day}',
                      style: accent.copyWith(fontSize: 34, height: 1.0),
                    ),
                    Text(
                      '${t.month(d.date.month)} ${d.date.year}',
                      style: text.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(t.weekday(d.weekday), style: text),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: look.bannerAccent),
                  onPressed: onNext,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            if (notes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                child: Text(
                  notes.join(', '),
                  style: text.copyWith(fontSize: 12.5),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The Moon's disc lit by [elongation] (0 = new, 180 = full); waxing lit
/// from the right, waning from the left.
class _MoonPainter extends CustomPainter {
  _MoonPainter(this.elongation);
  final double elongation;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.shortestSide / 2 - 1;
    final c = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFF2B2B2B));
    final k = cos(elongation * pi / 180); // 1 new … -1 full
    final waxing = elongation < 180;
    // Lit part: a half disc on the lit side plus/minus a half ellipse.
    final path = Path();
    final rect = Rect.fromCircle(center: c, radius: r);
    path.addArc(rect, -pi / 2, waxing ? pi : -pi);
    final ex = r * k.abs();
    final oval = Rect.fromCenter(center: c, width: 2 * ex, height: 2 * r);
    // Back from the bottom to the top along the terminator: it bulges
    // towards the lit side for a crescent (k > 0), away for a gibbous Moon.
    final sweep = waxing ? (k > 0 ? -pi : pi) : (k > 0 ? pi : -pi);
    final terminator = Path()..addArc(oval, pi / 2, sweep);
    path.extendWithPath(terminator, Offset.zero);
    path.close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFF2EFE6));
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0x55FFFFFF),
    );
  }

  @override
  bool shouldRepaint(_MoonPainter old) => old.elongation != elongation;
}
