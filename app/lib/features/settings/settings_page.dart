import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../chart_view/presentation/chart_geometry.dart';
import 'settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, s) {
          final cubit = context.read<SettingsCubit>();
          return ListView(
            children: [
              const _Header('Display'),
              _Choice<ChartStyle>(
                title: 'Chart style',
                value: s.chartStyle,
                values: ChartStyle.values,
                label: (v) => v.label,
                onChanged: (v) =>
                    cubit.update((s) => s.copyWith(chartStyle: v)),
              ),
              SwitchListTile(
                title: const Text('Show Uranus, Neptune, Pluto'),
                value: s.showOuterPlanets,
                onChanged: (v) =>
                    cubit.update((s) => s.copyWith(showOuterPlanets: v)),
              ),
              const _Header('Calculation'),
              _Choice<Ayanamsa>(
                title: 'Ayanamsa',
                value: s.ayanamsa,
                values: Ayanamsa.values
                    .where((a) => a != Ayanamsa.user)
                    .toList(),
                label: (v) => v.label,
                onChanged: (v) => cubit.update((s) => s.copyWith(ayanamsa: v)),
              ),
              _Choice<NodeType>(
                title: 'Rahu / Ketu',
                value: s.nodeType,
                values: NodeType.values,
                label: (v) =>
                    v == NodeType.meanNode ? 'Mean node' : 'True node',
                onChanged: (v) => cubit.update((s) => s.copyWith(nodeType: v)),
              ),
              _Choice<SunriseMode>(
                title: 'Sunrise',
                value: s.sunriseMode,
                values: SunriseMode.values,
                label: (v) => v.label,
                onChanged: (v) =>
                    cubit.update((s) => s.copyWith(sunriseMode: v)),
              ),
              _Choice<KarakaScheme>(
                title: 'Chara karakas',
                value: s.karakaScheme,
                values: KarakaScheme.values,
                label: (v) => v.label,
                onChanged: (v) =>
                    cubit.update((s) => s.copyWith(karakaScheme: v)),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Defaults match AstroSage: Lahiri, mean node, upper-limb '
                  'sunrise. Planet positions come from Swiss Ephemeris '
                  '(Astrodienst, AGPL). Place data © GeoNames, CC BY 4.0.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
    child: Text(
      text,
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
    ),
  );
}

class _Choice<T> extends StatelessWidget {
  const _Choice({
    required this.title,
    required this.value,
    required this.values,
    required this.label,
    required this.onChanged,
  });

  final String title;
  final T value;
  final List<T> values;
  final String Function(T) label;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(label(value)),
      onTap: () async {
        final picked = await showDialog<T>(
          context: context,
          builder: (context) => SimpleDialog(
            title: Text(title),
            children: [
              RadioGroup<T>(
                groupValue: value,
                onChanged: (v) => Navigator.pop(context, v),
                child: Column(
                  children: [
                    for (final v in values)
                      RadioListTile<T>(value: v, title: Text(label(v))),
                  ],
                ),
              ),
            ],
          ),
        );
        if (picked != null) onChanged(picked);
      },
    );
  }
}
