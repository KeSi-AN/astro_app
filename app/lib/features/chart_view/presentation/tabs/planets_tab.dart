import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../l10n/l10n.dart';
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
    final lagna = a.chart.lagna;
    String flags(GrahaInfo i) => [
      if (i.placement.isRetrograde) l10n.flagRetro,
      if (i.combust) l10n.flagCombust,
      if (i.vargottama) l10n.flagVargottama,
    ].join(' ');
    String nak(Placement p) => '${t.nakshatra(p.nakshatra)} ${p.pada}';
    final rows = <List<String>>[
      [
        t.lagna,
        '',
        t.rashiShort(lagna.rashi),
        Dms.of(lagna.degreeInSign).degrees,
        nak(lagna),
        t.grahaShort(lagna.nakshatraLord),
        t.grahaShort(a.lagnaSubLords[1]),
        '',
        t.rashiShort(a.lagnaNavamsha),
      ],
      for (final g in Graha.values)
        () {
          final i = a.grahas[g]!;
          final p = i.placement;
          return [
            t.graha(g),
            flags(i),
            t.rashiShort(p.rashi),
            Dms.of(p.degreeInSign).degrees,
            nak(p),
            t.grahaShort(p.nakshatraLord),
            t.grahaShort(i.subLord),
            i.dignity == null ? '' : t.dignity(i.dignity!),
            t.rashiShort(i.navamshaSign),
          ];
        }(),
    ];
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        GridTable(
          header: [
            l10n.colPlanet,
            '',
            l10n.sign,
            l10n.colDegree,
            l10n.colNakshatra,
            l10n.colStar,
            l10n.colSub,
            l10n.dignity,
            'D9',
          ],
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
