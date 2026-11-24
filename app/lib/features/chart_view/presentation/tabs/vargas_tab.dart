import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../l10n/l10n.dart';
import '../../../settings/settings.dart';
import '../../domain/chart_plate.dart';
import '../chart_painter.dart';
import 'table_widgets.dart';

/// Shodashvarga table: the sign (1–12) of the lagna and each graha in all
/// sixteen vargas, plus a quick way to open any varga chart.
class VargasTab extends StatelessWidget {
  const VargasTab({super.key, required this.analysis, required this.settings});
  final ChartAnalysis analysis;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    final c = analysis.chart;
    final grahas = Graha.values.where((g) => !g.isOuter).toList();
    final rows = <List<String>>[
      [
        t.lagna,
        for (final v in Varga.values)
          '${vargaSign(c.lagna.longitude, v).number}',
      ],
      for (final g in grahas)
        [
          t.graha(g),
          for (final v in Varga.values)
            '${vargaSign(c.grahas[g]!.longitude, v).number}',
        ],
    ];
    final d1 = [c.lagna.rashi, for (final g in grahas) c.grahas[g]!.rashi];
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(
          l10n.vargaTableTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        GridTable(
          header: ['', for (final v in Varga.values) v.code],
          rows: rows,
          minColumnWidth: 36,
          // Same sign as in D1 (vargottama in that varga) is highlighted.
          highlight: (r, col) => col > 1 && rows[r][col] == '${d1[r].number}'
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
        const SizedBox(height: 8),
        Text(l10n.vargaTableNote, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final v in Varga.values)
              ActionChip(
                label: Text('${v.code} ${t.varga(v)}'),
                onPressed: () => _open(context, v),
              ),
          ],
        ),
      ],
    );
  }

  void _open(BuildContext context, Varga v) {
    final t = context.terms;
    final title = '${t.varga(v)} (${v.code})';
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              ChartWidget(
                plate: buildVargaPlate(
                  analysis,
                  v,
                  outer: settings.showOuterPlanets,
                ),
                style: settings.chartStyle,
                title: title,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
