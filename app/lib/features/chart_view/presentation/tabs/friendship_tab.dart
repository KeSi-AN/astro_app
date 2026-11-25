import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme.dart';

import '../../../../l10n/l10n.dart';
import 'table_widgets.dart';

/// Natural, temporal and five-fold (compound) relationships, rows = the
/// planet whose view is shown, columns = towards whom.
class FriendshipTab extends StatelessWidget {
  const FriendshipTab({super.key, required this.analysis});
  final ChartAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    final a = analysis;
    // Colour by relation, not by the (language-dependent) text.
    List<List<Relation?>> rel(Relation Function(Graha, Graha) f) => [
      for (final r in sevenGrahas)
        [for (final c in sevenGrahas) r == c ? null : f(r, c)],
    ];
    Color? colour(Relation? r) => switch (r) {
      Relation.greatFriend => context.look.good,
      Relation.friend => context.look.goodSoft,
      Relation.enemy => context.look.badSoft,
      Relation.greatEnemy => context.look.bad,
      _ => null,
    };
    Widget section(String title, List<List<Relation?>> grid) {
      final rows = [
        for (var i = 0; i < 7; i++)
          [
            t.grahaShort(sevenGrahas[i]),
            for (final r in grid[i]) r == null ? '—' : t.relationShort(r),
          ],
      ];
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            GridTable(
              header: ['', for (final g in sevenGrahas) t.grahaShort(g)],
              rows: rows,
              minColumnWidth: 40,
              highlight: (r, c) => c == 0 ? null : colour(grid[r][c - 1]),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        section(l10n.naturalTitle, rel(a.natural)),
        section(l10n.temporalTitle, rel(a.temporal)),
        section(l10n.compoundTitle, rel(a.compound)),
        Text(
          l10n.friendshipLegend,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
