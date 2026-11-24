import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import 'table_widgets.dart';

/// Natural, temporal and five-fold (compound) relationships, rows = the
/// planet whose view is shown, columns = towards whom.
class FriendshipTab extends StatelessWidget {
  const FriendshipTab({super.key, required this.analysis});
  final ChartAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final a = analysis;
    List<List<String>> grid(Relation Function(Graha, Graha) rel) => [
      for (final r in sevenGrahas)
        [r.short, for (final c in sevenGrahas) r == c ? '—' : rel(r, c).short],
    ];
    Color? colour(String s) => switch (s) {
      'GF' => const Color(0xFF81C784),
      'F' => const Color(0xFFA5D6A7),
      'E' => const Color(0xFFEF9A9A),
      'GE' => const Color(0xFFE57373),
      _ => null,
    };
    Widget section(String title, List<List<String>> rows) => Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 6),
          GridTable(
            header: ['', for (final g in sevenGrahas) g.short],
            rows: rows,
            minColumnWidth: 40,
            highlight: (r, c) => c == 0 ? null : colour(rows[r][c]),
          ),
        ],
      ),
    );
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        section('Natural (permanent)', grid(a.natural)),
        section('Temporal (in this chart)', grid(a.temporal)),
        section('Five-fold (compound)', grid(a.compound)),
        Text(
          'GF great friend · F friend · N neutral · E enemy · GE great enemy',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
