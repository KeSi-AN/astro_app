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

/// A titled card of label/value rows.
class KeyValueCard extends StatelessWidget {
  const KeyValueCard({super.key, required this.title, required this.rows});
  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = tabular(theme.textTheme.bodyMedium!);
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
}
