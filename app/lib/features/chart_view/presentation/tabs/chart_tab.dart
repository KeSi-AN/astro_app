import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../l10n/l10n.dart';
import '../../../settings/settings.dart';
import '../../domain/chart_plate.dart';
import '../chart_geometry.dart';
import '../chart_painter.dart';
import 'graha_sheet.dart';

class ChartTab extends StatefulWidget {
  const ChartTab({super.key, required this.analysis, required this.settings});
  final ChartAnalysis analysis;
  final AppSettings settings;

  @override
  State<ChartTab> createState() => _ChartTabState();
}

class _ChartTabState extends State<ChartTab>
    with AutomaticKeepAliveClientMixin {
  PlateKind _kind = PlateKind.lagna;
  Graha? _selected;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = context.l10n;
    final terms = context.terms;
    final s = widget.settings;
    final plate = buildPlate(widget.analysis, _kind, outer: s.showOuterPlanets);
    // Chalit houses don't map to fixed sign cells, so it is always drawn
    // in the house-based North Indian style.
    final style = _kind == PlateKind.chalit ? ChartStyle.north : s.chartStyle;
    final title = switch (_kind) {
      PlateKind.navamsha => l10n.navamshaTitle,
      PlateKind.chalit => l10n.chalitTitle,
      _ => terms.plateKind(_kind),
    };
    final small = Theme.of(context).textTheme.bodySmall;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Wrap(
          spacing: 8,
          children: [
            for (final k in PlateKind.values)
              ChoiceChip(
                label: Text(terms.plateKind(k)),
                selected: _kind == k,
                onSelected: (_) => setState(() => _kind = k),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ChartWidget(
          plate: plate,
          style: style,
          title: title,
          selected: _selected,
          onGrahaTap: (g, house) async {
            if (g == null) return;
            setState(() => _selected = g);
            await showGrahaSheet(context, widget.analysis, g);
            if (mounted) setState(() => _selected = null);
          },
        ),
        const SizedBox(height: 8),
        Text(l10n.chartLegend, style: small),
        const SizedBox(height: 12),
        SegmentedButton<ChartStyle>(
          segments: [
            for (final st in ChartStyle.values)
              ButtonSegment(
                value: st,
                label: Text(terms.chartStyle(st).split(' ').first),
              ),
          ],
          selected: {s.chartStyle},
          onSelectionChanged: (v) => context.read<SettingsCubit>().update(
            (s) => s.copyWith(chartStyle: v.first),
          ),
        ),
        if (_kind == PlateKind.chalit)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(l10n.chalitNorthOnly, style: small),
          ),
        const SizedBox(height: 8),
        Text(l10n.tapPlanet, style: small),
      ],
    );
  }
}
