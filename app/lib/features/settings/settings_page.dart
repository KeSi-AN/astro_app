import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../chart_view/presentation/chart_geometry.dart';
import '../../app/router.dart';
import '../../l10n/l10n.dart';
import 'settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, s) {
          final cubit = context.read<SettingsCubit>();
          return ListView(
            children: [
              _Header(l10n.display),
              _Choice<AppLanguage>(
                title: l10n.language,
                value: s.language,
                values: AppLanguage.values,
                // Language names are shown in their own script.
                label: (v) => switch (v) {
                  AppLanguage.system => l10n.languageSystem,
                  AppLanguage.english => 'English',
                  AppLanguage.hindi => 'हिंदी',
                },
                onChanged: (v) => cubit.update((s) => s.copyWith(language: v)),
              ),
              _Choice<ChartStyle>(
                title: l10n.chartStyle,
                value: s.chartStyle,
                values: ChartStyle.values,
                label: t.chartStyle,
                onChanged: (v) =>
                    cubit.update((s) => s.copyWith(chartStyle: v)),
              ),
              SwitchListTile(
                title: Text(l10n.showOuterPlanets),
                value: s.showOuterPlanets,
                onChanged: (v) =>
                    cubit.update((s) => s.copyWith(showOuterPlanets: v)),
              ),
              ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: Text(l10n.letterhead),
                subtitle: Text(
                  s.letterhead.isEmpty
                      ? l10n.letterheadHint
                      : [s.letterhead.name, s.letterhead.phone]
                            .where((x) => x.isNotEmpty)
                            .join(' · '),
                ),
                onTap: () => context.push(Routes.letterhead),
              ),
              _Header(l10n.calculation),
              _Choice<Ayanamsa>(
                title: l10n.ayanamsa,
                value: s.ayanamsa,
                values: Ayanamsa.values
                    .where((a) => a != Ayanamsa.user)
                    .toList(),
                label: t.ayanamsa,
                onChanged: (v) => cubit.update((s) => s.copyWith(ayanamsa: v)),
              ),
              _Choice<NodeType>(
                title: l10n.rahuKetu,
                value: s.nodeType,
                values: NodeType.values,
                label: t.nodeType,
                onChanged: (v) => cubit.update((s) => s.copyWith(nodeType: v)),
              ),
              _Choice<SunriseMode>(
                title: l10n.sunrise,
                value: s.sunriseMode,
                values: SunriseMode.values,
                label: t.sunriseMode,
                onChanged: (v) =>
                    cubit.update((s) => s.copyWith(sunriseMode: v)),
              ),
              _Choice<KarakaScheme>(
                title: l10n.charaKarakas,
                value: s.karakaScheme,
                values: KarakaScheme.values,
                label: t.karakaScheme,
                onChanged: (v) =>
                    cubit.update((s) => s.copyWith(karakaScheme: v)),
              ),
              _Choice<Ayanamsa>(
                title: l10n.kpAyanamsaSetting,
                value: s.kpAyanamsa,
                values: Ayanamsa.values
                    .where((a) => a != Ayanamsa.user)
                    .toList(),
                label: t.ayanamsa,
                onChanged: (v) =>
                    cubit.update((s) => s.copyWith(kpAyanamsa: v)),
              ),
              _Choice<DashaYear>(
                title: l10n.dashaYearSetting,
                value: s.dashaYear,
                values: DashaYear.values,
                label: t.dashaYear,
                onChanged: (v) => cubit.update((s) => s.copyWith(dashaYear: v)),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.settingsFootnote,
                  style: const TextStyle(fontSize: 12),
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
