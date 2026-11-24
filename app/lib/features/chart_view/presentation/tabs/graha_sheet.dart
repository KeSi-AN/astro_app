import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme.dart';

Future<void> showGrahaSheet(BuildContext context, ChartAnalysis a, Graha g) {
  final info = a.grahas[g]!;
  final p = info.placement;
  final rows = <(String, String)>[
    ('Sign', '${p.rashi.label} (lord ${p.rashi.lord.label})'),
    ('Longitude', '${Dms.of(p.degreeInSign).degrees} ${p.rashi.short}'),
    ('Nakshatra', '${p.nakshatra.label}, pada ${p.pada}'),
    (
      'Star / sub / sub-sub lord',
      '${p.nakshatraLord.label} / ${info.subLord.label} / ${info.subSubLord.label}',
    ),
    ('House (whole sign)', '${p.house}'),
    ('Chalit bhava', '${info.chalitBhava}'),
    ('Navamsha', info.navamshaSign.label),
    if (info.dignity != null) ('Dignity', info.dignity!.label),
    ('Motion', p.isRetrograde ? 'Retrograde' : 'Direct'),
    ('Speed', '${p.speed.toStringAsFixed(4)}°/day'),
    if (info.combust) ('Combust', 'Yes'),
    if (info.vargottama) ('Vargottama', 'Yes'),
  ];
  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (context) {
      final style = tabular(Theme.of(context).textTheme.bodyMedium!);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(g.label, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              for (final (k, v) in rows)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 170,
                        child: Text(
                          k,
                          style: style.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
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
    },
  );
}
