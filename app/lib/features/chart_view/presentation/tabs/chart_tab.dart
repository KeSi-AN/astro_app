import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

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
    final s = widget.settings;
    final plate = buildPlate(widget.analysis, _kind, outer: s.showOuterPlanets);
    // Chalit houses don't map to fixed sign cells, so it is always drawn
    // in the house-based North Indian style.
    final style = _kind == PlateKind.chalit ? ChartStyle.north : s.chartStyle;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Wrap(
          spacing: 8,
          children: [
            for (final k in PlateKind.values)
              ChoiceChip(
                label: Text(k.label),
                selected: _kind == k,
                onSelected: (_) => setState(() => _kind = k),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ChartWidget(
          plate: plate,
          style: style,
          selected: _selected,
          onGrahaTap: (g, house) async {
            if (g == null) return;
            setState(() => _selected = g);
            await showGrahaSheet(context, widget.analysis, g);
            if (mounted) setState(() => _selected = null);
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                '* retrograde  ^ combust  ◻ vargottama  ↑ exalted  ↓ debilitated',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SegmentedButton<ChartStyle>(
          segments: [
            for (final st in ChartStyle.values)
              ButtonSegment(value: st, label: Text(st.label.split(' ').first)),
          ],
          selected: {s.chartStyle},
          onSelectionChanged: (v) => context.read<SettingsCubit>().update(
            (s) => s.copyWith(chartStyle: v.first),
          ),
        ),
        if (_kind == PlateKind.chalit)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Chalit is always shown North Indian (house-based).',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        const SizedBox(height: 8),
        Text(
          'Tap a planet for details.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
