import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../app/services.dart';
import '../../../app/theme.dart';
import '../../../core/format/formatters.dart';
import '../../atlas/domain/place.dart';
import '../domain/chart_entry.dart';

/// Phase 1 chart view: birth details and the planets table. The full chart
/// screen (North/South/East charts, tabs) replaces this in Phase 2.
class ChartViewPage extends StatefulWidget {
  const ChartViewPage({super.key, required this.id});
  final int id;

  @override
  State<ChartViewPage> createState() => _ChartViewPageState();
}

class _ChartViewPageState extends State<ChartViewPage> {
  ChartEntry? _entry;
  RasiChart? _chart;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = context.read<AppServices>();
    try {
      final e = await s.charts.get(widget.id);
      if (e == null) throw StateError('Chart not found');
      final c = RasiChart.calculate(s.ephemeris, e.toBirthData());
      if (mounted) {
        setState(() {
          _entry = e;
          _chart = c;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = _entry, c = _chart;
    return Scaffold(
      appBar: AppBar(
        title: Text(e?.name ?? ''),
        actions: [
          if (e != null)
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                await context.push(Routes.editChart(e.id!));
                _load();
              },
            ),
        ],
      ),
      body: _error != null
          ? Center(child: Text('$_error'))
          : (e == null || c == null)
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    _BirthSummary(entry: e, chart: c),
                    const SizedBox(height: 16),
                    _PlanetTable(chart: c),
                  ],
                ),
    );
  }
}

class _BirthSummary extends StatelessWidget {
  const _BirthSummary({required this.entry, required this.chart});
  final ChartEntry entry;
  final RasiChart chart;

  @override
  Widget build(BuildContext context) {
    final e = entry;
    final b = e.toBirthData();
    final style = tabular(Theme.of(context).textTheme.bodyMedium!);
    final rows = <(String, String)>[
      ('Date', formatDate(e.year, e.month, e.day)),
      ('Time', formatTime(e.hour, e.minute, e.second)),
      ('Place', e.place.displayName),
      ('Coordinates',
          '${formatLatitude(e.place.latitude)} ${formatLongitude(e.place.longitude)}'),
      ('Time zone',
          '${formatOffset(e.utcOffsetHours)}${e.dstHours != 0 ? ' + ${e.dstHours}h ${e.warTimeApplied == true ? 'war time' : 'DST'}' : ''} (${e.timeBasis.name})'),
      ('LMT correction', formatSignedHms(b.longitude / 15 - e.utcOffsetHours - e.dstHours)),
      ('Ayanamsa', '${chart.settings.ayanamsa.label} ${Dms.of(chart.ayanamsa)}'),
    ];
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          for (final (k, v) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 120, child: Text(k, style: style.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant))),
                Expanded(child: Text(v, style: style)),
              ]),
            ),
        ]),
      ),
    );
  }
}

class _PlanetTable extends StatelessWidget {
  const _PlanetTable({required this.chart});
  final RasiChart chart;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, Placement)>[
      ('Lagna', chart.lagna),
      for (final g in Graha.values) (g.label, chart.grahas[g]!),
    ];
    final mono = tabular(Theme.of(context).textTheme.bodyMedium!);
    Widget cell(String t, {bool bold = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(t,
              style: bold ? mono.copyWith(fontWeight: FontWeight.bold) : mono),
        );
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.3),
        1: FlexColumnWidth(1.1),
        2: FlexColumnWidth(2.3),
        3: FlexColumnWidth(3.3),
      },
      children: [
        TableRow(children: [
          for (final h in ['Planet', 'Sign', 'Degree', 'Nakshatra']) cell(h, bold: true),
        ]),
        for (final (name, p) in rows)
          TableRow(children: [
            cell('$name${name != 'Lagna' && p.isRetrograde ? ' (R)' : ''}'),
            cell(p.rashi.short),
            cell(Dms.of(p.degreeInSign).degrees),
            cell('${p.nakshatra.label} ${p.pada}'),
          ]),
      ],
    );
  }
}
