import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../l10n/l10n.dart';
import '../../domain/report_rows.dart';
import 'table_widgets.dart';

enum _Section { ashtakavarga, shadbala, bhava }

/// Ashtakavarga (BAV, SAV, prastara), Shadbala with every component, and
/// Bhava bala.
class StrengthTab extends StatefulWidget {
  const StrengthTab({
    super.key,
    required this.analysis,
    required this.ephemeris,
  });
  final ChartAnalysis analysis;
  final Ephemeris ephemeris;

  @override
  State<StrengthTab> createState() => _StrengthTabState();
}

class _StrengthTabState extends State<StrengthTab>
    with AutomaticKeepAliveClientMixin {
  _Section _section = _Section.ashtakavarga;
  Graha _prastara = Graha.sun;
  late Ashtakavarga _av;
  late Shadbala _sb;
  ChartAnalysis? _for;

  @override
  bool get wantKeepAlive => true;

  void _compute() {
    if (_for == widget.analysis) return;
    _for = widget.analysis;
    _av = Ashtakavarga.of(widget.analysis.chart);
    _sb = Shadbala.of(widget.analysis, widget.ephemeris);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _compute();
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        SegmentedButton<_Section>(
          segments: [
            ButtonSegment(
              value: _Section.ashtakavarga,
              label: Text(l10n.ashtakavarga),
            ),
            ButtonSegment(value: _Section.shadbala, label: Text(l10n.shadbala)),
            ButtonSegment(value: _Section.bhava, label: Text(l10n.bhavaBala)),
          ],
          selected: {_section},
          onSelectionChanged: (v) => setState(() => _section = v.first),
        ),
        const SizedBox(height: 12),
        ...switch (_section) {
          _Section.ashtakavarga => _ashtakavarga(context),
          _Section.shadbala => _shadbala(context),
          _Section.bhava => _bhava(context),
        },
      ],
    );
  }

  List<Widget> _ashtakavarga(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    final theme = Theme.of(context);
    final heading = theme.textTheme.titleSmall;
    final sav = _av.sav;
    final lagna = widget.analysis.chart.lagna.rashi.index;
    Color? strong(int v) => v >= 28
        ? const Color(0xFF81C784)
        : (v < 25 ? const Color(0xFFE57373) : null);
    const contributors = [
      Graha.sun,
      Graha.moon,
      Graha.mars,
      Graha.mercury,
      Graha.jupiter,
      Graha.venus,
      Graha.saturn,
    ];
    final prastara = _av.prastara[_prastara]!;
    return [
      Text(l10n.bavTitle, style: heading),
      const SizedBox(height: 6),
      GridTable(
        header: ['', for (var s = 1; s <= 12; s++) '$s', l10n.colTotal],
        minColumnWidth: 30,
        rows: [
          for (final g in avGrahas)
            [
              t.grahaShort(g),
              for (final v in _av.bav(g)) '$v',
              '${_av.bavTotal(g)}',
            ],
          [l10n.savTitle, for (final v in sav) '$v', '337'],
        ],
        highlight: (r, c) => r == avGrahas.length && c >= 1 && c <= 12
            ? strong(sav[c - 1])
            : null,
      ),
      const SizedBox(height: 16),
      Text(l10n.savByHouse, style: heading),
      const SizedBox(height: 6),
      GridTable(
        header: [for (var h = 1; h <= 12; h++) '$h'],
        minColumnWidth: 30,
        rows: [
          [for (var h = 0; h < 12; h++) '${sav[(lagna + h) % 12]}'],
        ],
        highlight: (r, c) => strong(sav[(lagna + c) % 12]),
      ),
      const SizedBox(height: 6),
      Text(l10n.avNote, style: theme.textTheme.bodySmall),
      const SizedBox(height: 16),
      Text(l10n.prastaraTitle(t.graha(_prastara)), style: heading),
      const SizedBox(height: 6),
      Wrap(
        spacing: 6,
        children: [
          for (final g in avGrahas)
            ChoiceChip(
              label: Text(t.grahaShort(g)),
              selected: _prastara == g,
              onSelected: (_) => setState(() => _prastara = g),
            ),
        ],
      ),
      const SizedBox(height: 6),
      GridTable(
        header: [l10n.contributor, for (var s = 1; s <= 12; s++) '$s'],
        minColumnWidth: 26,
        rows: [
          for (var i = 0; i < 8; i++)
            [
              i < 7 ? t.grahaShort(contributors[i]) : t.lagnaShort,
              for (final v in prastara[i]) v == 1 ? '●' : '·',
            ],
          [l10n.colTotal, for (final v in _av.bav(_prastara)) '$v'],
        ],
      ),
    ];
  }

  List<Widget> _shadbala(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    final g = sevenGrahas;
    final s = _sb.grahas;
    final rows = shadbalaRows(l10n, _sb);
    final totalsFrom = rows.length - 5;
    return [
      GridTable(
        header: ['', for (final p in g) t.grahaShort(p)],
        rows: rows,
        minColumnWidth: 48,
        highlight: (r, c) {
          if (c == 0) return null;
          if (r == rows.length - 2) {
            return s[g[c - 1]]!.ratio >= 1
                ? const Color(0xFF81C784)
                : const Color(0xFFE57373);
          }
          if (r >= totalsFrom || rows[r][0].startsWith('=')) {
            return Theme.of(context).colorScheme.primary;
          }
          return null;
        },
      ),
      const SizedBox(height: 8),
      Text(l10n.shadbalaNote, style: Theme.of(context).textTheme.bodySmall),
    ];
  }

  List<Widget> _bhava(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    final ranks = _sb.bhavaRanks;
    final madhya = widget.analysis.chart.bhavas.madhya;
    String f(double v) => v.toStringAsFixed(1);
    return [
      GridTable(
        header: [
          l10n.colBhava,
          l10n.sign,
          l10n.bhavaLordStrength,
          l10n.bhavaDig,
          l10n.bhavaDrishti,
          l10n.totalRupas,
          l10n.strengthRank,
        ],
        rows: [
          for (final b in _sb.bhavas)
            [
              '${b.bhava}',
              t.rashiShort(Rashi.ofLongitude(madhya[b.bhava - 1])),
              f(b.lordStrength),
              f(b.dig),
              f(b.drishti),
              b.rupas.toStringAsFixed(2),
              '${ranks[b.bhava - 1]}',
            ],
        ],
      ),
      const SizedBox(height: 8),
      Text(l10n.bhavaNote, style: Theme.of(context).textTheme.bodySmall),
    ];
  }
}
