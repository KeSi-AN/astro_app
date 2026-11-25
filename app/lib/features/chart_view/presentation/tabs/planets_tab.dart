import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../l10n/l10n.dart';
import '../../domain/report_rows.dart';
import 'graha_sheet.dart';
import 'table_widgets.dart';

class PlanetsTab extends StatelessWidget {
  const PlanetsTab({super.key, required this.analysis});
  final ChartAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    final a = analysis;
    final (header, rows) = planetTable(l10n, t, a);
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        GridTable(
          header: header,
          rows: rows,
          highlight: (r, c) {
            if (c != 7 || r == 0) return null;
            final d = a.grahas[Graha.values[r - 1]]!.dignity;
            return switch (d) {
              Dignity.exalted ||
              Dignity.moolatrikona ||
              Dignity.own => const Color(0xFF81C784),
              Dignity.debilitated => const Color(0xFFE57373),
              _ => null,
            };
          },
        ),
        const SizedBox(height: 8),
        Text(l10n.planetsLegend, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final g in Graha.values)
              ActionChip(
                label: Text(t.graha(g)),
                onPressed: () => showGrahaSheet(context, a, g),
              ),
          ],
        ),
      ],
    );
  }
}
