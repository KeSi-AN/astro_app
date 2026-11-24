import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../app/services.dart';
import '../../charts/domain/chart_entry.dart';
import '../../settings/settings.dart';
import 'tabs/bhava_tab.dart';
import 'tabs/chart_tab.dart';
import 'tabs/details_tab.dart';
import 'tabs/friendship_tab.dart';
import 'tabs/karakas_tab.dart';
import 'tabs/planets_tab.dart';

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
      if (e == null) throw StateError('Chart not found');
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

  static const _tabs = [
    'Chart',
    'Planets',
    'Bhava',
    'Details',
    'Friendship',
    'Karakas',
  ];

  @override
  Widget build(BuildContext context) {
    final e = _entry;
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(e?.name ?? ''),
          actions: [
            if (e != null)
              IconButton(
                tooltip: 'Edit birth details',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async {
                  await context.push(Routes.editChart(e.id!));
                  _load();
                },
              ),
            IconButton(
              tooltip: 'Settings',
              icon: const Icon(Icons.tune),
              onPressed: () => context.push(Routes.settings),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [for (final t in _tabs) Tab(text: t)],
          ),
        ),
        body: _error != null
            ? Center(child: Text('$_error'))
            : e == null
            ? const Center(child: CircularProgressIndicator())
            : BlocBuilder<SettingsCubit, AppSettings>(
                builder: (context, s) {
                  final a = _analyse(e, s);
                  return TabBarView(
                    children: [
                      ChartTab(analysis: a, settings: s),
                      PlanetsTab(analysis: a),
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
