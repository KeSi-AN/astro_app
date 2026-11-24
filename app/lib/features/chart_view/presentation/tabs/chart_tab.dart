import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../l10n/l10n.dart';
import '../../../settings/settings.dart';
import '../../domain/chart_plate.dart';
import '../chart_geometry.dart';
import '../chart_painter.dart';
import 'graha_sheet.dart';

/// What the chart tab shows: lagna, Moon or chalit chart, or a varga.
sealed class ChartChoice {
  const ChartChoice();
}

class PlateChoice extends ChartChoice {
  const PlateChoice(this.kind);
  final PlateKind kind;
  @override
  bool operator ==(Object other) => other is PlateChoice && other.kind == kind;
  @override
  int get hashCode => kind.hashCode;
}

class VargaChoice extends ChartChoice {
  const VargaChoice(this.varga);
  final Varga varga;
  @override
  bool operator ==(Object other) =>
      other is VargaChoice && other.varga == varga;
  @override
  int get hashCode => varga.hashCode;
}

const chartChoices = <ChartChoice>[
  PlateChoice(PlateKind.lagna),
  PlateChoice(PlateKind.moon),
  PlateChoice(PlateKind.chalit),
  VargaChoice(Varga.d2),
  VargaChoice(Varga.d3),
  VargaChoice(Varga.d4),
  VargaChoice(Varga.d7),
  VargaChoice(Varga.d9),
  VargaChoice(Varga.d10),
  VargaChoice(Varga.d12),
  VargaChoice(Varga.d16),
  VargaChoice(Varga.d20),
  VargaChoice(Varga.d24),
  VargaChoice(Varga.d27),
  VargaChoice(Varga.d30),
  VargaChoice(Varga.d40),
  VargaChoice(Varga.d45),
  VargaChoice(Varga.d60),
];

class ChartTab extends StatefulWidget {
  const ChartTab({super.key, required this.analysis, required this.settings});
  final ChartAnalysis analysis;
  final AppSettings settings;

  @override
  State<ChartTab> createState() => _ChartTabState();
}

class _ChartTabState extends State<ChartTab>
    with AutomaticKeepAliveClientMixin {
  ChartChoice _choice = const PlateChoice(PlateKind.lagna);
  Graha? _selected;
  bool _showSav = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = context.l10n;
    final terms = context.terms;
    final s = widget.settings;
    final a = widget.analysis;
    final (plate, title, chalit) = switch (_choice) {
      PlateChoice(:final kind) => (
        buildPlate(a, kind, outer: s.showOuterPlanets),
        kind == PlateKind.chalit ? l10n.chalitTitle : terms.plateKind(kind),
        kind == PlateKind.chalit,
      ),
      VargaChoice(:final varga) => (
        buildVargaPlate(a, varga, outer: s.showOuterPlanets),
        '${terms.varga(varga)} (${varga.code})',
        false,
      ),
    };
    // SAV bindus per sign on sign-based D1 charts (Lagna/Moon).
    final savable =
        _choice == const PlateChoice(PlateKind.lagna) ||
        _choice == const PlateChoice(PlateKind.moon);
    var shown = plate;
    if (savable && _showSav) {
      final sav = Ashtakavarga.of(a.chart).sav;
      shown = ChartPlate(
        title: plate.title,
        ascendantSign: plate.ascendantSign,
        houses: [
          for (final h in plate.houses) h.withBadge('${sav[h.sign.index]}'),
        ],
      );
    }
    // Chalit houses don't map to fixed sign cells, so it is always drawn
    // in the house-based North Indian style.
    final style = chalit ? ChartStyle.north : s.chartStyle;
    final small = Theme.of(context).textTheme.bodySmall;

    String label(ChartChoice c) => switch (c) {
      PlateChoice(:final kind) => terms.plateKind(kind),
      VargaChoice(:final varga) => varga.code,
    };

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: chartChoices.length,
            separatorBuilder: (_, _) => const SizedBox(width: 6),
            itemBuilder: (context, i) {
              final c = chartChoices[i];
              return ChoiceChip(
                label: Text(label(c)),
                selected: _choice == c,
                onSelected: (_) => setState(() => _choice = c),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        ChartWidget(
          plate: shown,
          style: style,
          title: title,
          selected: _selected,
          onGrahaTap: (g, house) async {
            if (g == null) return;
            setState(() => _selected = g);
            await showGrahaSheet(context, a, g);
            if (mounted) setState(() => _selected = null);
          },
        ),
        const SizedBox(height: 8),
        Text(l10n.chartLegend, style: small),
        if (savable)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(l10n.showSavOnChart),
            value: _showSav,
            onChanged: (v) => setState(() => _showSav = v),
          ),
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
        if (chalit)
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
