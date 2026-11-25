import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/theme.dart';

import '../../app/services.dart';
import '../../core/format/formatters.dart';
import '../../l10n/l10n.dart';
import '../chart_view/presentation/tabs/table_widgets.dart';
import '../charts/domain/chart_entry.dart';
import '../settings/settings.dart';

/// Kundli matching between two saved charts: Ashtakoota, Mangal dosha and
/// the South Indian ten poruthams.
class MatchingPage extends StatefulWidget {
  const MatchingPage({super.key});

  @override
  State<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends State<MatchingPage> {
  List<ChartEntry>? _charts;
  ChartEntry? _boy, _girl;

  @override
  void initState() {
    super.initState();
    context.read<AppServices>().charts.watchAll().first.then((c) {
      if (!mounted) return;
      setState(() {
        _charts = c;
        _boy = c.where((x) => x.gender == 'male').firstOrNull;
        _girl = c.where((x) => x.gender == 'female').firstOrNull;
      });
    });
  }

  ChartAnalysis _analyse(ChartEntry e, AppSettings s) {
    final eph = context.read<AppServices>().ephemeris;
    return ChartAnalysis.of(
      RasiChart.calculate(eph, e.toBirthData(), s.calc),
      eph,
      sunriseMode: s.sunriseMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final charts = _charts;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.matching)),
      body: charts == null
          ? const Center(child: CircularProgressIndicator())
          : charts.length < 2
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(l10n.needTwoCharts, textAlign: TextAlign.center),
              ),
            )
          : BlocBuilder<SettingsCubit, AppSettings>(
              builder: (context, s) => ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  _picker(
                    context,
                    l10n.boy,
                    _boy,
                    charts,
                    (c) => setState(() => _boy = c),
                  ),
                  const SizedBox(height: 8),
                  _picker(
                    context,
                    l10n.girl,
                    _girl,
                    charts,
                    (c) => setState(() => _girl = c),
                  ),
                  const SizedBox(height: 12),
                  if (_boy != null && _girl != null)
                    ..._result(
                      context,
                      Ashtakoota.of(_analyse(_boy!, s), _analyse(_girl!, s)),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _picker(
    BuildContext context,
    String label,
    ChartEntry? value,
    List<ChartEntry> charts,
    ValueChanged<ChartEntry?> onChanged,
  ) {
    final t = context.terms;
    return DropdownButtonFormField<int>(
      key: ValueKey('$label-${value?.id}'),
      initialValue: value?.id,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      hint: Text(context.l10n.chooseChart),
      items: [
        for (final c in charts)
          DropdownMenuItem(
            value: c.id,
            child: Text(
              '${c.name} · ${formatDate(c.year, c.month, c.day, month: t.month)}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: (id) => onChanged(charts.firstWhere((c) => c.id == id)),
    );
  }

  List<Widget> _result(BuildContext context, Ashtakoota m) {
    final l10n = context.l10n;
    final t = context.terms;
    final theme = Theme.of(context);
    String fmt(double v) =>
        v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
    String side(Koota k, String v) => switch (k) {
      Koota.tara => t.nakshatra(
        Nakshatra.values.firstWhere((n) => n.label == v),
      ),
      Koota.grahaMaitri => t.graha(
        Graha.values.firstWhere((g) => g.label == v),
      ),
      Koota.bhakoot => t.rashi(Rashi.values.firstWhere((r) => r.label == v)),
      _ => t.avakhadaValue(v),
    };
    final total = m.total;
    final good = total >= 18;
    final notes = <String>[
      for (final (k, name) in [
        (Koota.nadi, l10n.nadiDosha),
        (Koota.bhakoot, l10n.bhakootDosha),
      ])
        if (m.kootas[k.index].points == 0)
          m.kootas[k.index].cancelled
              ? l10n.doshaCancelled(name)
              : l10n.doshaPresent(name),
    ];
    final p = poruthams(m);
    final goodCount = p.values.where((r) => r == PoruthamResult.good).length;
    String res(PoruthamResult r) => switch (r) {
      PoruthamResult.good => l10n.resultGood,
      PoruthamResult.average => l10n.resultAverage,
      PoruthamResult.bad => l10n.resultBad,
    };
    Color? resColor(PoruthamResult r) => switch (r) {
      PoruthamResult.good => context.look.good,
      PoruthamResult.bad => context.look.bad,
      _ => null,
    };
    final porRows = Porutham.values.toList();
    return [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                l10n.totalGunas(fmt(total)),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: good
                      ? context.look.good
                      : context.look.bad,
                ),
              ),
              const SizedBox(height: 4),
              Text(good ? l10n.verdictGood : l10n.verdictPoor),
              for (final n in notes)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    n,
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(l10n.ashtakoota, style: theme.textTheme.titleSmall),
      const SizedBox(height: 6),
      GridTable(
        header: [
          l10n.colKoota,
          l10n.boy,
          l10n.girl,
          l10n.colMax,
          l10n.colObtained,
        ],
        rows: [
          for (final k in m.kootas)
            [
              t.koota(k.koota),
              side(k.koota, k.boy),
              side(k.koota, k.girl),
              fmt(k.koota.max),
              fmt(k.points),
            ],
        ],
        highlight: (r, c) {
          if (c != 4) return null;
          final k = m.kootas[r];
          if (k.points == 0) return context.look.bad;
          if (k.points == k.koota.max) return context.look.good;
          return null;
        },
      ),
      const SizedBox(height: 16),
      Text(l10n.mangalTitle, style: theme.textTheme.titleSmall),
      const SizedBox(height: 6),
      GridTable(
        header: [l10n.boy, l10n.girl],
        rows: [
          [_mangal(context, m.boyMangal), _mangal(context, m.girlMangal)],
        ],
      ),
      const SizedBox(height: 4),
      Text(m.mangalCompatible ? l10n.mangalBoth : l10n.mangalOne),
      const SizedBox(height: 16),
      Text(
        '${l10n.poruthamTitle} · ${l10n.poruthamCount('$goodCount')}',
        style: theme.textTheme.titleSmall,
      ),
      const SizedBox(height: 6),
      GridTable(
        header: ['', l10n.colResult],
        rows: [
          for (final x in porRows) [t.porutham(x), res(p[x]!)],
        ],
        highlight: (r, c) => c == 1 ? resColor(p[porRows[r]]!) : null,
      ),
      const SizedBox(height: 4),
      Text(
        '${l10n.colRajju}: ${l10n.boy} ${t.rajju(rajjuOf(m.boy.nakshatra))} · '
        '${l10n.girl} ${t.rajju(rajjuOf(m.girl.nakshatra))}',
        style: theme.textTheme.bodySmall,
      ),
      const SizedBox(height: 12),
      Text(l10n.matchingNote, style: theme.textTheme.bodySmall),
    ];
  }

  String _mangal(BuildContext context, YogaResult y) {
    final l10n = context.l10n;
    if (!y.found) return l10n.absent;
    return y.cancelled ? l10n.cancelled : l10n.present;
  }
}
