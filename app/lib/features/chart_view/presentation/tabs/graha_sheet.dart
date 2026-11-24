import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme.dart';
import '../../../../l10n/l10n.dart';

Future<void> showGrahaSheet(BuildContext context, ChartAnalysis a, Graha g) {
  final l10n = context.l10n;
  final t = context.terms;
  final info = a.grahas[g]!;
  final p = info.placement;
  final rows = <(String, String)>[
    (l10n.sign, l10n.withLord(t.rashi(p.rashi), t.graha(p.rashi.lord))),
    (
      l10n.degreeInSignLabel,
      '${Dms.of(p.degreeInSign).degrees} ${t.rashiShort(p.rashi)}',
    ),
    (l10n.nakshatra, l10n.nakshatraPada(t.nakshatra(p.nakshatra), '${p.pada}')),
    (
      l10n.starSubLords,
      '${t.graha(p.nakshatraLord)} / ${t.graha(info.subLord)} / '
          '${t.graha(info.subSubLord)}',
    ),
    (l10n.houseWholeSign, '${p.house}'),
    (l10n.chalitBhava, '${info.chalitBhava}'),
    (l10n.navamsha, t.rashi(info.navamshaSign)),
    if (info.dignity != null) (l10n.dignity, t.dignity(info.dignity!)),
    (l10n.motion, p.isRetrograde ? l10n.retrograde : l10n.direct),
    (l10n.speed, l10n.speedValue(p.speed.toStringAsFixed(4))),
    if (info.combust) (l10n.combust, l10n.yes),
    if (info.vargottama) (l10n.vargottama, l10n.yes),
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
              Text(t.graha(g), style: Theme.of(context).textTheme.titleLarge),
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
