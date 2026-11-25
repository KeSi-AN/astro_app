import 'package:material_ui/material_ui.dart';

import '../../../../app/theme.dart';

/// Compact, horizontally scrollable table with a bold header row.
class GridTable extends StatelessWidget {
  const GridTable({
    super.key,
    required this.header,
    required this.rows,
    this.minColumnWidth = 56,
    this.highlight,
  });

  final List<String> header;
  final List<List<String>> rows;
  final double minColumnWidth;

  /// Optional colour per cell (row, col) → null for default.
  final Color? Function(int row, int col)? highlight;

  @override
  Widget build(BuildContext context) {
    if (context.look.saffron) return _almanac(context);
    final theme = Theme.of(context);
    final style = tabular(theme.textTheme.bodyMedium!);
    final head = style.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.primary,
    );
    Widget cell(String t, TextStyle s, {Color? color}) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: Text(t, style: color == null ? s : s.copyWith(color: color)),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultColumnWidth: IntrinsicColumnWidth(flex: null),
        border: TableBorder(
          horizontalInside: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.4),
          ),
        ),
        children: [
          if (header.any((h) => h.isNotEmpty))
            TableRow(children: [for (final h in header) cell(h, head)]),
          for (var r = 0; r < rows.length; r++)
            TableRow(
              children: [
                for (var c = 0; c < rows[r].length; c++)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: c == 0 ? 0 : minColumnWidth,
                    ),
                    child: cell(
                      rows[r][c],
                      style,
                      color: highlight?.call(r, c),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

extension on GridTable {
  /// Almanac look: tinted header row, ruled and striped rows.
  Widget _almanac(BuildContext context) {
    final theme = Theme.of(context);
    final look = context.look;
    final style = tabular(theme.textTheme.bodyMedium!);
    final head = style.copyWith(fontWeight: FontWeight.bold, color: look.label);
    Widget cell(String t, TextStyle s, {Color? color, bool bold = false}) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: Text(
        t,
        style: s.copyWith(
          color: color ?? s.color,
          fontWeight: bold || color != null ? FontWeight.w600 : null,
        ),
      ),
    );
    return Container(
      decoration: BoxDecoration(
        color: look.cardBg,
        border: Border.all(color: look.rule),
        borderRadius: BorderRadius.circular(4),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          defaultColumnWidth: IntrinsicColumnWidth(flex: null),
          border: TableBorder(
            horizontalInside: BorderSide(color: look.rule, width: 0.6),
            verticalInside: BorderSide(color: look.rule.withValues(alpha: 0.5), width: 0.5),
          ),
          children: [
            if (header.any((h) => h.isNotEmpty))
              TableRow(
                decoration: BoxDecoration(color: look.sectionBg),
                children: [for (final h in header) cell(h, head)],
              ),
            for (var r = 0; r < rows.length; r++)
              TableRow(
                decoration: BoxDecoration(color: r.isOdd ? look.stripe : null),
                children: [
                  for (var c = 0; c < rows[r].length; c++)
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: c == 0 ? 0 : minColumnWidth),
                      child: cell(
                        rows[r][c],
                        c == 0 ? style.copyWith(color: look.label) : style,
                        color: highlight?.call(r, c),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// A titled card of label/value rows.
class KeyValueCard extends StatelessWidget {
  const KeyValueCard({super.key, required this.title, required this.rows});
  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = tabular(theme.textTheme.bodyMedium!);
    if (context.look.saffron) return _almanac(context, theme, style);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 6),
            for (final (k, v) in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        k,
                        style: style.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(child: Text(v, style: style)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Almanac look: a header band and ruled label | value rows.
  Widget _almanac(BuildContext context, ThemeData theme, TextStyle style) {
    final look = context.look;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: look.sectionBg,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 9),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6E1410),
              ),
            ),
          ),
          for (final (i, (k, v)) in rows.indexed)
            Container(
              decoration: BoxDecoration(
                border: i == 0 ? null : Border(top: BorderSide(color: look.rule, width: 0.6)),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 140,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                        child: Text(k, style: style.copyWith(color: look.label)),
                      ),
                    ),
                    VerticalDivider(width: 1, thickness: 0.6, color: look.rule),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
                        child: Text(v, style: style),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
