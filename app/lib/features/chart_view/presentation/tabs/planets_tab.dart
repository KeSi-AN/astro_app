import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import 'graha_sheet.dart';
import 'table_widgets.dart';

class PlanetsTab extends StatelessWidget {
  const PlanetsTab({super.key, required this.analysis});
  final ChartAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final a = analysis;
    final lagna = a.chart.lagna;
    String flags(GrahaInfo i) => [
      if (i.placement.isRetrograde) 'R',
      if (i.combust) 'C',
      if (i.vargottama) 'V',
    ].join(' ');
    final rows = <List<String>>[
      [
        'Lagna',
        '',
        lagna.rashi.short,
        Dms.of(lagna.degreeInSign).degrees,
        '${lagna.nakshatra.label} ${lagna.pada}',
        lagna.nakshatraLord.short,
        a.lagnaSubLords[1].short,
        '',
        a.lagnaNavamsha.short,
      ],
      for (final g in Graha.values)
        () {
          final i = a.grahas[g]!;
          final p = i.placement;
          return [
            g.label,
            flags(i),
            p.rashi.short,
            Dms.of(p.degreeInSign).degrees,
            '${p.nakshatra.label} ${p.pada}',
            p.nakshatraLord.short,
            i.subLord.short,
            i.dignity?.label ?? '',
            i.navamshaSign.short,
          ];
        }(),
    ];
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        GridTable(
          header: const [
            'Planet',
            '',
            'Sign',
            'Degree',
            'Nakshatra',
            'Star',
            'Sub',
            'Dignity',
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
        Text(
          'R retrograde · C combust · V vargottama. Dignity uses the '
          'compound (five-fold) relationship with the sign lord.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final g in Graha.values)
              ActionChip(
                label: Text(g.label),
                onPressed: () => showGrahaSheet(context, a, g),
              ),
          ],
        ),
      ],
    );
  }
}
