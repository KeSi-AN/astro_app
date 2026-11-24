import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../l10n/l10n.dart';
import 'table_widgets.dart';

/// Sripati bhava (chalit) table: start (sandhi), madhya, end, occupants.
class BhavaTab extends StatelessWidget {
  const BhavaTab({super.key, required this.analysis});
  final ChartAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    final a = analysis;
    final b = a.chart.bhavas;
    String lon(double v) =>
        '${t.rashiShort(Rashi.ofLongitude(v))} ${Dms.of(norm360(v) % 30).degrees}';
    final occupants = <int, List<String>>{};
    for (final g in Graha.values) {
      occupants
          .putIfAbsent(a.grahas[g]!.chalitBhava, () => [])
          .add(t.grahaShort(g));
    }
    final shifted = [
      for (final g in Graha.values)
        if (a.grahas[g]!.chalitBhava != a.grahas[g]!.placement.house)
          l10n.chalitShift(
            t.graha(g),
            '${a.grahas[g]!.placement.house}',
            '${a.grahas[g]!.chalitBhava}',
          ),
    ];
    final kp = a.chart.kpCusps;
    final heading = Theme.of(context).textTheme.titleSmall;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(l10n.bhavaTitle, style: heading),
        const SizedBox(height: 8),
        GridTable(
          header: [
            l10n.colBhava,
            l10n.colStart,
            l10n.colMadhya,
            l10n.colEnd,
            l10n.colPlanets,
          ],
          rows: [
            for (var i = 0; i < 12; i++)
              [
                '${i + 1}',
                lon(b.sandhi[i]),
                lon(b.madhya[i]),
                lon(b.sandhi[(i + 1) % 12]),
                (occupants[i + 1] ?? const []).join(' '),
              ],
          ],
        ),
        const SizedBox(height: 8),
        Text(l10n.chalitDiffers, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          shifted.isEmpty ? l10n.none : shifted.join('\n'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (kp.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(l10n.kpCuspsTitle, style: heading),
          const SizedBox(height: 8),
          GridTable(
            header: [
              l10n.colCusp,
              l10n.colLongitude,
              l10n.colStar,
              l10n.colSub,
            ],
            rows: [
              for (var i = 0; i < 12; i++)
                () {
                  final lords = kpLords(kp[i]);
                  return [
                    '${i + 1}',
                    lon(kp[i]),
                    t.grahaShort(lords[0]),
                    t.grahaShort(lords[1]),
                  ];
                }(),
            ],
          ),
        ],
      ],
    );
  }
}
