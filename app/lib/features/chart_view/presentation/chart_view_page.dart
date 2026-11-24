import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../app/services.dart';
import '../../charts/domain/chart_entry.dart';
import '../../../l10n/l10n.dart';
import '../../settings/settings.dart';
import 'tabs/bhava_tab.dart';
import 'tabs/chart_tab.dart';
import 'tabs/dasha_tab.dart';
import 'tabs/details_tab.dart';
import 'tabs/friendship_tab.dart';
import 'tabs/karakas_tab.dart';
import 'tabs/kp_tab.dart';
import 'tabs/planets_tab.dart';
import 'tabs/strength_tab.dart';
import 'tabs/vargas_tab.dart';

/// A saved chart with its analysis, recomputed when settings change.
class ChartViewPage extends StatefulWidget {
  const ChartViewPage({super.key, required this.id});
  final int id;

  @override
  State<ChartViewPage> createState() => _ChartViewPageState();
}

class _ChartViewPageState extends State<ChartViewPage> {
  ChartEntry? _entry;
  Object? _error;

  // Cache the analysis per settings so tab switches don't recompute.
  AppSettings? _for;
  ChartAnalysis? _analysis;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final e = await context.read<AppServices>().charts.get(widget.id);
      if (e == null) throw StateError('not found');
      if (mounted) {
        setState(() {
          _entry = e;
          _analysis = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  ChartAnalysis _analyse(ChartEntry e, AppSettings s) {
    if (_analysis != null && _for == s) return _analysis!;
    final eph = context.read<AppServices>().ephemeris;
    final chart = RasiChart.calculate(eph, e.toBirthData(), s.calc);
    _for = s;
    return _analysis = ChartAnalysis.of(
      chart,
      eph,
      sunriseMode: s.sunriseMode,
      karakaScheme: s.karakaScheme,
    );
  }

  @override
  Widget build(BuildContext context) {
    final e = _entry;
    return DefaultTabController(
      length: 10,
      child: Scaffold(
        appBar: AppBar(
          title: Text(e?.name ?? ''),
          actions: [
            if (e != null)
              IconButton(
                tooltip: context.l10n.editBirthDetails,
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async {
                  await context.push(Routes.editChart(e.id!));
                  _load();
                },
              ),
            IconButton(
              tooltip: context.l10n.settings,
              icon: const Icon(Icons.tune),
              onPressed: () => context.push(Routes.settings),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: context.l10n.tabChart),
              Tab(text: context.l10n.tabPlanets),
              Tab(text: context.l10n.tabDasha),
              Tab(text: context.l10n.tabVargas),
              Tab(text: context.l10n.tabStrength),
              Tab(text: context.l10n.tabKp),
              Tab(text: context.l10n.tabBhava),
              Tab(text: context.l10n.tabDetails),
              Tab(text: context.l10n.tabFriendship),
              Tab(text: context.l10n.tabKarakas),
            ],
          ),
        ),
        body: _error != null
            ? Center(child: Text(context.l10n.chartNotFound))
            : e == null
            ? const Center(child: CircularProgressIndicator())
            : BlocBuilder<SettingsCubit, AppSettings>(
                builder: (context, s) {
                  final a = _analyse(e, s);
                  return TabBarView(
                    children: [
                      ChartTab(analysis: a, settings: s),
                      PlanetsTab(analysis: a),
                      DashaTab(analysis: a, settings: s),
                      VargasTab(analysis: a, settings: s),
                      StrengthTab(
                        analysis: a,
                        ephemeris: context.read<AppServices>().ephemeris,
                      ),
                      KpTab(
                        analysis: a,
                        settings: s,
                        ephemeris: context.read<AppServices>().ephemeris,
                      ),
                      BhavaTab(analysis: a),
                      DetailsTab(entry: e, analysis: a, settings: s),
                      FriendshipTab(analysis: a),
                      KarakasTab(analysis: a),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
