import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme.dart';
import '../../../../l10n/l10n.dart';
import 'dasha_tab.dart' show dateOfJd, jdOf;
import 'table_widgets.dart';

enum _Sec { yogas, sadeSati, avastha, upagraha, arudha, navatara }

/// Yogas and doshas, Sade Sati, avasthas, upagrahas, arudhas, navatara.
class YogasTab extends StatefulWidget {
  const YogasTab({super.key, required this.analysis, required this.ephemeris});
  final ChartAnalysis analysis;
  final Ephemeris ephemeris;

  @override
  State<YogasTab> createState() => _YogasTabState();
}

class _YogasTabState extends State<YogasTab>
    with AutomaticKeepAliveClientMixin {
  _Sec _sec = _Sec.yogas;
  bool _showAbsent = false;
  ChartAnalysis? _for;
  late List<YogaResult> _yogas;
  List<SaturnPeriod>? _sadeSati;

  @override
  bool get wantKeepAlive => true;

  void _compute() {
    if (_for == widget.analysis) return;
    _for = widget.analysis;
    _yogas = yogas(widget.analysis);
    _sadeSati = null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _compute();
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final (s, label) in [
              (_Sec.yogas, l10n.secYogas),
              (_Sec.sadeSati, l10n.secSadeSati),
              (_Sec.avastha, l10n.secAvastha),
              (_Sec.upagraha, l10n.secUpagraha),
              (_Sec.arudha, l10n.secArudha),
              (_Sec.navatara, l10n.secNavatara),
            ])
              ChoiceChip(
                label: Text(label),
                selected: _sec == s,
                onSelected: (_) => setState(() => _sec = s),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...switch (_sec) {
          _Sec.yogas => _yogaList(context),
          _Sec.sadeSati => _sadeSatiView(context),
          _Sec.avastha => _avastha(context),
          _Sec.upagraha => _upagraha(context),
          _Sec.arudha => _arudha(context),
          _Sec.navatara => _navatara(context),
        },
      ],
    );
  }

  String _detail(YogaResult y) {
    final l10n = context.l10n;
    final t = context.terms;
    final parts = <String>[];
    for (final (k, v) in y.detail) {
      switch (k) {
        case 'lagna' || 'moon' || 'venus':
          final ref = switch (k) {
            'lagna' => l10n.refLagna,
            'moon' => l10n.refMoon,
            _ => l10n.refVenus,
          };
          parts.add(l10n.mangalFrom(ref, v));
        case 'marsStrong':
          parts.add(l10n.cancelMarsStrong);
        case 'withJupiter':
          parts.add(l10n.cancelWithJupiter);
        case 'withMoon':
          parts.add(l10n.cancelWithMoon);
        case 'signException':
          parts.add(l10n.cancelSignException(v));
        case 'type':
          if (y.found) parts.add(l10n.kaalSarpType(v));
      }
    }
    if (y.planets.isNotEmpty && y.found && y.id != 'mangal') {
      parts.add(y.planets.map(t.graha).join(', '));
    }
    return parts.join(' · ');
  }

  List<Widget> _yogaList(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    final theme = Theme.of(context);
    final shown = [
      ..._yogas.where((y) => y.isDosha),
      ..._yogas.where((y) => !y.isDosha && (y.present || _showAbsent)),
    ];
    Widget badge(YogaResult y) {
      final (text, color) = y.present
          ? (
              l10n.present,
              y.isDosha ? const Color(0xFFE57373) : const Color(0xFF81C784),
            )
          : y.cancelled
          ? (l10n.cancelled, theme.colorScheme.primary)
          : (l10n.absent, theme.colorScheme.onSurfaceVariant);
      return Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      );
    }

    return [
      for (final y in shown)
        Card(
          margin: const EdgeInsets.only(bottom: 6),
          child: ListTile(
            dense: true,
            title: Text(t.yogaName(y.id)),
            subtitle: Text(
              [
                t.yogaRule(y.id),
                _detail(y),
              ].where((s) => s.isNotEmpty).join('\n'),
            ),
            trailing: badge(y),
          ),
        ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.showAbsent),
        value: _showAbsent,
        onChanged: (v) => setState(() => _showAbsent = v),
      ),
    ];
  }

  List<Widget> _sadeSatiView(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    final c = widget.analysis.chart;
    final ss = _sadeSati ??= sadeSati(c, widget.ephemeris);
    final off = c.birth.utcOffsetHours + c.birth.dstHours;
    final now = jdOf(DateTime.now().toUtc());
    String d(double jd) {
      final x = dateOfJd(jd, off);
      return '${x.day.toString().padLeft(2, '0')}/'
          '${x.month.toString().padLeft(2, '0')}/${x.year}';
    }

    String phase(SadeSatiPhase p) => switch (p) {
      SadeSatiPhase.rising => l10n.phaseRising,
      SadeSatiPhase.peak => l10n.phasePeak,
      SadeSatiPhase.setting => l10n.phaseSetting,
      SadeSatiPhase.none => '—',
    };
    final running = ss.indexWhere((p) => p.contains(now));
    return [
      GridTable(
        header: [
          l10n.colKind,
          l10n.sign,
          l10n.colFrom,
          l10n.colTo,
          l10n.colPhase,
        ],
        rows: [
          for (final p in ss)
            [
              p.kind == SadeSatiKind.sadeSati
                  ? l10n.sadeSatiKind
                  : l10n.smallPanoti,
              t.rashi(p.sign),
              d(p.start),
              d(p.end),
              phase(p.phase),
            ],
        ],
        highlight: (r, col) =>
            r == running ? Theme.of(context).colorScheme.primary : null,
      ),
      const SizedBox(height: 6),
      if (running >= 0)
        Text(
          '● ${l10n.runningNow}',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      Text(l10n.sadeSatiNote, style: Theme.of(context).textTheme.bodySmall),
    ];
  }

  List<Widget> _avastha(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    final a = widget.analysis;
    const g7 = [
      Graha.sun,
      Graha.moon,
      Graha.mars,
      Graha.mercury,
      Graha.jupiter,
      Graha.venus,
      Graha.saturn,
    ];
    return [
      GridTable(
        header: [
          l10n.colPlanet,
          l10n.colBaladi,
          l10n.colJagratadi,
          l10n.colDeeptadi,
        ],
        rows: [
          for (final g in g7)
            [
              t.graha(g),
              t.baladi(baladi(a.chart.grahas[g]!.longitude)),
              t.jagratadi(jagratadi(a.chart.grahas[g]!.longitude)),
              t.deeptadi(deeptadi(a.grahas[g]!)),
            ],
        ],
      ),
      const SizedBox(height: 6),
      Text(l10n.avasthaNote, style: Theme.of(context).textTheme.bodySmall),
    ];
  }

  List<Widget> _upagraha(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    final u = upagrahas(widget.analysis, widget.ephemeris);
    return [
      GridTable(
        header: [l10n.colPlanet, l10n.sign, l10n.colDegree, l10n.colNakshatra],
        rows: [
          for (final e in u.entries)
            [
              t.upagraha(e.key),
              t.rashi(Rashi.ofLongitude(e.value)),
              Dms.of(norm360(e.value) % 30).degrees,
              '${t.nakshatra(Nakshatra.ofLongitude(e.value))} '
                  '${Nakshatra.padaOf(e.value)}',
            ],
        ],
      ),
      const SizedBox(height: 6),
      Text(l10n.upagrahaNote, style: Theme.of(context).textTheme.bodySmall),
    ];
  }

  List<Widget> _arudha(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    final ar = arudhas(widget.analysis.chart);
    final lagna = widget.analysis.chart.lagna.rashi.index;
    return [
      GridTable(
        header: ['', l10n.sign, l10n.colHouse],
        rows: [
          for (var i = 0; i < 12; i++)
            [
              i == 0 ? 'A1 (AL)' : (i == 11 ? 'A12 (UL)' : 'A${i + 1}'),
              t.rashi(ar[i]),
              '${(ar[i].index - lagna) % 12 + 1}',
            ],
        ],
      ),
      const SizedBox(height: 6),
      Text(l10n.arudhaNote, style: Theme.of(context).textTheme.bodySmall),
    ];
  }

  List<Widget> _navatara(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    final janma = widget.analysis.chart.grahas[Graha.moon]!.nakshatra;
    final n = navatara(janma);
    final style = tabular(Theme.of(context).textTheme.bodyMedium!);
    return [
      GridTable(
        header: [
          l10n.colTara,
          l10n.colCycle('1'),
          l10n.colCycle('2'),
          l10n.colCycle('3'),
          l10n.colLord,
        ],
        rows: [
          for (var i = 0; i < 9; i++)
            [
              t.navatara(i),
              for (final x in n[i]) t.nakshatra(x),
              t.graha(n[i][0].lord),
            ],
        ],
      ),
      Text('', style: style),
    ];
  }
}
