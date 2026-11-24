import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../l10n/l10n.dart';
import 'table_widgets.dart';

class KarakasTab extends StatelessWidget {
  const KarakasTab({super.key, required this.analysis});
  final ChartAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    final a = analysis;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(
          l10n.charaKarakasTitle(t.karakaScheme(a.karakaScheme)),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        GridTable(
          header: [l10n.colKaraka, l10n.colPlanet, l10n.colDegreeInSign],
          rows: [
            for (final (k, g, d) in a.karakas)
              [
                '${t.karaka(k)} (${t.karakaShort(k)})',
                t.graha(g),
                Dms.of(d).degrees,
              ],
          ],
        ),
        const SizedBox(height: 8),
        Text(
          a.karakaScheme == KarakaScheme.eight
              ? l10n.rahuBackwards
              : l10n.karakaSchemeHint,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
