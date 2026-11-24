import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import 'table_widgets.dart';

class KarakasTab extends StatelessWidget {
  const KarakasTab({super.key, required this.analysis});
  final ChartAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final a = analysis;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(
          'Chara karakas · ${a.karakaScheme.label}',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        GridTable(
          header: const ['Karaka', 'Planet', 'Degree in sign'],
          rows: [
            for (final (k, g, d) in a.karakas)
              ['${k.label} (${k.short})', g.label, Dms.of(d).degrees],
          ],
        ),
        const SizedBox(height: 8),
        Text(
          a.karakaScheme == KarakaScheme.eight
              ? "Rahu's degree is counted backwards (30° − its degree)."
              : 'Change to the 8-karaka scheme (with Rahu) in Settings.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
