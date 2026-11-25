import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../l10n/l10n.dart';
import '../../domain/report_rows.dart';
import '../../../charts/domain/chart_entry.dart';
import '../../../settings/settings.dart';
import 'table_widgets.dart';

/// Birth details, panchang at birth and the Avakhada chakra.
class DetailsTab extends StatelessWidget {
  const DetailsTab({
    super.key,
    required this.entry,
    required this.analysis,
    required this.settings,
  });

  final ChartEntry entry;
  final ChartAnalysis analysis;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(12),
    children: [
      for (final (title, rows) in detailsSections(
        context.l10n,
        context.terms,
        entry,
        analysis,
        settings,
      ))
        KeyValueCard(title: title, rows: rows),
    ],
  );
}
