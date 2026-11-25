import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/format/formatters.dart';
import '../../../../l10n/l10n.dart';
import '../../../settings/settings.dart';
import '../../domain/chart_plate.dart';
import '../chart_painter.dart';
import 'dasha_tab.dart' show dateOfJd, jdOf;
import 'table_widgets.dart';

enum _Step { day, month, year }

/// Transits on the natal chart with a date scrubber, gochara from the
/// Moon with vedha and Ashtakavarga bindus, and a transit search.
class TransitTab extends StatefulWidget {
  const TransitTab({
    super.key,
    required this.analysis,
    required this.settings,
    required this.ephemeris,
  });
  final ChartAnalysis analysis;
  final AppSettings settings;
  final Ephemeris ephemeris;

  @override
  State<TransitTab> createState() => _TransitTabState();
}

class _TransitTabState extends State<TransitTab>
    with AutomaticKeepAliveClientMixin {
  late double _jd = jdOf(DateTime.now().toUtc());
  _Step _step = _Step.month;

  // Search
  Graha _searchPlanet = Graha.saturn;
  String _searchTarget = 'signs'; // 'signs' | 'lagna' | graha name
  int _searchYears = 5;
  List<TransitEvent>? _events;

  @override
  bool get wantKeepAlive => true;

  double get _offset =>
      widget.analysis.chart.birth.utcOffsetHours +
      widget.analysis.chart.birth.dstHours;

  void _move(int dir) {
    final d = dateOfJd(_jd, _offset);
    final next = switch (_step) {
      _Step.day => d.add(Duration(days: dir)),
      _Step.month => DateTime.utc(
        d.year,
        d.month + dir,
        d.day,
        d.hour,
        d.minute,
      ),
      _Step.year => DateTime.utc(
        d.year + dir,
        d.month,
        d.day,
        d.hour,
        d.minute,
      ),
    };
    setState(
      () =>
          _jd = jdOf(next.subtract(Duration(minutes: (_offset * 60).round()))),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = context.l10n;
    final t = context.terms;
    final a = widget.analysis;
    final tc = TransitChart.at(widget.ephemeris, a.chart, _jd);
    final date = dateOfJd(_jd, _offset);
    final dateText = formatDate(
      date.year,
      date.month,
      date.day,
      month: t.month,
    );

    // Natal plate plus transiting planets in the same houses.
    final natal = buildPlate(a, PlateKind.lagna, outer: false);
    final combined = ChartPlate(
      title: l10n.transitChartTitle,
      ascendantSign: natal.ascendantSign,
      houses: [
        for (final h in natal.houses)
          PlateHouse(
            number: h.number,
            sign: h.sign,
            items: [
              ...h.items,
              for (final g in transitGrahas)
                if (tc.infos[g]!.rashi == h.sign)
                  PlateItem(
                    graha: g,
                    degree: (norm360(tc.positions[g]!) % 30).floor(),
                    retrograde: tc.infos[g]!.retrograde,
                    transit: true,
                  ),
            ],
          ),
      ],
    );

    String gochara(TransitInfo i) => switch (i.gochara) {
      GocharaResult.good => l10n.gocharaGood,
      GocharaResult.goodButVedha => l10n.gocharaVedha(t.graha(i.vedhaBy!)),
      GocharaResult.bad => l10n.gocharaBad,
    };
    Color? gocharaColor(TransitInfo i) => switch (i.gochara) {
      GocharaResult.good => const Color(0xFF81C784),
      GocharaResult.goodButVedha => Theme.of(context).colorScheme.primary,
      GocharaResult.bad => const Color(0xFFE57373),
    };

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _move(-1),
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final p = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(1800),
                    lastDate: DateTime(2399, 12, 31),
                  );
                  if (p == null) return;
                  setState(
                    () => _jd = jdOf(
                      DateTime.utc(
                        p.year,
                        p.month,
                        p.day,
                        12,
                      ).subtract(Duration(minutes: (_offset * 60).round())),
                    ),
                  );
                },
                child: Text(
                  l10n.transitOn(dateText),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => _move(1),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SegmentedButton<_Step>(
              segments: [
                ButtonSegment(value: _Step.day, label: Text(l10n.stepDay)),
                ButtonSegment(value: _Step.month, label: Text(l10n.stepMonth)),
                ButtonSegment(value: _Step.year, label: Text(l10n.stepYear)),
              ],
              selected: {_step},
              onSelectionChanged: (v) => setState(() => _step = v.first),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () =>
                  setState(() => _jd = jdOf(DateTime.now().toUtc())),
              child: Text(l10n.today),
            ),
          ],
        ),
        // Drag horizontally on the chart to move through time.
        GestureDetector(
          onHorizontalDragEnd: (d) {
            final v = d.primaryVelocity ?? 0;
            if (v.abs() > 100) _move(v < 0 ? 1 : -1);
          },
          child: ChartWidget(
            plate: combined,
            style: widget.settings.chartStyle,
            title: l10n.transitChartTitle,
          ),
        ),
        const SizedBox(height: 4),
        Text(l10n.transitNote, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        GridTable(
          header: [
            l10n.colPlanet,
            l10n.sign,
            l10n.colDegree,
            l10n.colFromLagna,
            l10n.colFromMoon,
            l10n.colSav,
            l10n.colBav,
            l10n.colGochara,
          ],
          rows: [
            for (final g in transitGrahas)
              () {
                final i = tc.infos[g]!;
                return [
                  '${t.graha(g)}${i.retrograde ? ' ${l10n.retroMark}' : ''}',
                  t.rashiShort(i.rashi),
                  Dms.of(norm360(i.longitude) % 30).degrees,
                  '${i.houseFromLagna}',
                  '${i.houseFromMoon}',
                  '${i.savBindus}',
                  i.bavBindus?.toString() ?? '—',
                  gochara(i),
                ];
              }(),
          ],
          highlight: (r, c) {
            final i = tc.infos[transitGrahas[r]]!;
            if (c == 7) return gocharaColor(i);
            if (c == 5) {
              return i.savBindus >= 28
                  ? const Color(0xFF81C784)
                  : (i.savBindus < 25 ? const Color(0xFFE57373) : null);
            }
            return null;
          },
        ),
        const SizedBox(height: 6),
        Text(l10n.gocharaNote, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 20),
        ..._search(context),
      ],
    );
  }

  List<Widget> _search(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    final natal = widget.analysis.chart;
    final targets = <(String, String)>[
      ('signs', l10n.targetSigns),
      ('lagna', l10n.targetLagna),
      for (final g in transitGrahas.where((g) => g != Graha.ketu))
        (g.name, l10n.targetNatal(t.graha(g))),
    ];
    String when(double jd) {
      final d = dateOfJd(jd, _offset);
      return formatDate(d.year, d.month, d.day, month: t.month);
    }

    return [
      Text(l10n.transitSearch, style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<Graha>(
              initialValue: _searchPlanet,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.searchPlanet),
              items: [
                for (final g in transitGrahas)
                  DropdownMenuItem(value: g, child: Text(t.graha(g))),
              ],
              onChanged: (g) => setState(() {
                _searchPlanet = g!;
                _events = null;
              }),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: _searchTarget,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.searchTarget),
              items: [
                for (final (v, label) in targets)
                  DropdownMenuItem(
                    value: v,
                    child: Text(label, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (v) => setState(() {
                _searchTarget = v!;
                _events = null;
              }),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          DropdownButton<int>(
            value: _searchYears,
            items: [
              for (final n in [1, 2, 5, 10, 30])
                DropdownMenuItem(value: n, child: Text(l10n.searchYears('$n'))),
            ],
            onChanged: (n) => setState(() {
              _searchYears = n!;
              _events = null;
            }),
          ),
          const Spacer(),
          FilledButton(
            onPressed: () {
              final eph = widget.ephemeris;
              final from = _jd, to = _jd + _searchYears * 365.25;
              final s = natal.settings;
              setState(() {
                _events = _searchTarget == 'signs'
                    ? signIngresses(eph, _searchPlanet, from, to, settings: s)
                    : findCrossings(
                        eph,
                        _searchPlanet,
                        _searchTarget == 'lagna'
                            ? natal.lagna.longitude
                            : natal
                                  .grahas[Graha.values.byName(_searchTarget)]!
                                  .longitude,
                        from,
                        to,
                        settings: s,
                      );
              });
            },
            child: Text(l10n.searchRun),
          ),
        ],
      ),
      if (_events != null)
        if (_events!.isEmpty)
          Padding(padding: const EdgeInsets.all(8), child: Text(l10n.noEvents))
        else
          for (final e in _events!)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Text(when(e.jdUt)),
              title: Text(
                '${t.graha(e.graha)} ${e.retrograde ? l10n.retroMark : ''} '
                '${e.description.startsWith('sign:') ? l10n.eventEnters(t.rashi(Rashi.values[int.parse(e.description.substring(5))])) : l10n.eventOver}',
              ),
              trailing: TextButton(
                onPressed: () => setState(() => _jd = e.jdUt),
                child: Text(l10n.goToDate),
              ),
            ),
    ];
  }
}
