import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import 'table_widgets.dart';

/// Sripati bhava (chalit) table: start (sandhi), madhya, end, occupants.
class BhavaTab extends StatelessWidget {
  const BhavaTab({super.key, required this.analysis});
  final ChartAnalysis analysis;

  String _lon(double v) =>
      '${Rashi.ofLongitude(v).short} ${Dms.of(norm360(v) % 30).degrees}';

  @override
  Widget build(BuildContext context) {
    final a = analysis;
    final b = a.chart.bhavas;
    final occupants = <int, List<String>>{};
    for (final g in Graha.values) {
      occupants.putIfAbsent(a.grahas[g]!.chalitBhava, () => []).add(g.short);
    }
    final kp = a.chart.kpCusps;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(
          'Bhava chalit (Sripati)',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        GridTable(
          header: const ['Bhava', 'Start (sandhi)', 'Madhya', 'End', 'Planets'],
          rows: [
            for (var i = 0; i < 12; i++)
              [
                '${i + 1}',
                _lon(b.sandhi[i]),
                _lon(b.madhya[i]),
                _lon(b.sandhi[(i + 1) % 12]),
                (occupants[i + 1] ?? const []).join(' '),
              ],
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Planets whose chalit bhava differs from their sign house:',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          [
            for (final g in Graha.values)
              if (a.grahas[g]!.chalitBhava != a.grahas[g]!.placement.house)
                '${g.label}: house ${a.grahas[g]!.placement.house} → bhava ${a.grahas[g]!.chalitBhava}',
          ].join('\n').ifEmpty('None'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (kp.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            'Placidus cusps (KP)',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          GridTable(
            header: const ['Cusp', 'Longitude', 'Star', 'Sub'],
            rows: [
              for (var i = 0; i < 12; i++)
                () {
                  final lords = kpLords(kp[i]);
                  return [
                    '${i + 1}',
                    _lon(kp[i]),
                    lords[0].short,
                    lords[1].short,
                  ];
                }(),
            ],
          ),
        ],
      ],
    );
  }
}

extension on String {
  String ifEmpty(String other) => isEmpty ? other : this;
}
