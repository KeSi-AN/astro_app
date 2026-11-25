import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme.dart';
import '../../../../l10n/l10n.dart';
import '../../../settings/settings.dart';

/// Dasha systems in the tab: the three AstroSage has, then Ashtottari and
/// the conditional nakshatra dashas.
sealed class DashaKind {
  const DashaKind();
  static const vimshottari = _Fixed('vimshottari');
  static const yogini = _Fixed('yogini');
  static const chara = _Fixed('chara');
  static final List<DashaKind> all = [
    vimshottari,
    yogini,
    chara,
    for (final k in NakshatraDashaKind.values) _Nak(k),
  ];
}

class _Fixed extends DashaKind {
  const _Fixed(this.id);
  final String id;
}

class _Nak extends DashaKind {
  const _Nak(this.kind);
  final NakshatraDashaKind kind;
  @override
  bool operator ==(Object o) => o is _Nak && o.kind == kind;
  @override
  int get hashCode => kind.hashCode;
}

/// Dasha timeline: mahadashas with the running period highlighted; tap to
/// open sub-periods (5 levels for Vimshottari, 3 for Yogini and Chara).
class DashaTab extends StatefulWidget {
  const DashaTab({super.key, required this.analysis, required this.settings});
  final ChartAnalysis analysis;
  final AppSettings settings;

  @override
  State<DashaTab> createState() => _DashaTabState();
}

/// JD (UT) ↔ civil time helpers.
double jdOf(DateTime utc) => utc.millisecondsSinceEpoch / 86400000 + 2440587.5;
DateTime dateOfJd(double jd, double offsetHours) =>
    DateTime.fromMillisecondsSinceEpoch(
      ((jd - 2440587.5) * 86400000 + offsetHours * 3600000).round(),
      isUtc: true,
    );

class _DashaTabState extends State<DashaTab>
    with AutomaticKeepAliveClientMixin {
  DashaKind _kind = DashaKind.vimshottari;
  late double _focus = jdOf(DateTime.now().toUtc());
  final _open = <String>{};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _openPathAt(_focus);
  }

  @override
  void didUpdateWidget(DashaTab old) {
    super.didUpdateWidget(old);
    if (old.analysis != widget.analysis) {
      _open.clear();
      _openPathAt(_focus);
    }
  }

  DashaSystem<Object> _system() {
    final c = widget.analysis.chart;
    final moon = c.grahas[Graha.moon]!.longitude;
    final year = widget.settings.dashaYear;
    return switch (_kind) {
      DashaKind.vimshottari => VimshottariDasha(
        moonLongitude: moon,
        birthJd: c.jdUt,
        year: year,
      ),
      DashaKind.yogini => YoginiDasha(
        moonLongitude: moon,
        birthJd: c.jdUt,
        year: year,
      ),
      DashaKind.chara => CharaDasha(chart: c, birthJd: c.jdUt, year: year),
      _Nak(:final kind) => NakshatraDasha(
        kind,
        moonLongitude: moon,
        birthJd: c.jdUt,
        year: year,
      ),
      _ => throw StateError('unknown dasha'),
    } as DashaSystem<Object>;
  }

  int get _depth => _kind == DashaKind.vimshottari ? 5 : 3;

  String _key(DashaPeriod<Object> p) =>
      '${p.level}:${p.start.toStringAsFixed(6)}';

  void _openPathAt(double jd) {
    final path = _system().pathAt(jd, depth: _depth);
    // Open all but the deepest level so the running period is visible.
    for (final p in path.take(_depth == 5 ? 3 : 2)) {
      _open.add(_key(p));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = context.l10n;
    final t = context.terms;
    final c = widget.analysis.chart;
    final offset = c.birth.utcOffsetHours + c.birth.dstHours;
    final sys = _system();
    final theme = Theme.of(context);
    final mono = tabular(theme.textTheme.bodyMedium!);

    String name(Object lord) => switch (lord) {
      Graha g => t.graha(g),
      Yogini y => '${t.yogini(y)} (${t.graha(y.graha)})',
      Rashi r => t.rashi(r),
      _ => '$lord',
    };
    String date(double jd) {
      final d = dateOfJd(jd, offset);
      return '${d.day.toString().padLeft(2, '0')}/'
          '${d.month.toString().padLeft(2, '0')}/${d.year}';
    }

    String age(double jd) =>
        jd < c.jdUt ? '—' : ((jd - c.jdUt) / 365.25).toStringAsFixed(1);

    final rows = <Widget>[];
    void add(List<DashaPeriod<Object>> periods) {
      for (final p in periods) {
        final running = p.contains(_focus);
        final key = _key(p);
        final canOpen = p.level < _depth;
        final open = _open.contains(key);
        rows.add(
          Material(
            color: running
                ? theme.colorScheme.primary.withValues(
                    alpha: 0.10 + 0.05 * p.level,
                  )
                : Colors.transparent,
            child: InkWell(
              onTap: canOpen
                  ? () => setState(
                      () => open ? _open.remove(key) : _open.add(key),
                    )
                  : null,
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.0 + 16 * (p.level - 1), 8, 8, 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: canOpen
                          ? Icon(
                              open ? Icons.expand_more : Icons.chevron_right,
                              size: 18,
                            )
                          : null,
                    ),
                    Expanded(
                      child: Text(
                        name(p.lord),
                        style: mono.copyWith(
                          fontWeight: running ? FontWeight.bold : null,
                          color: running ? theme.colorScheme.primary : null,
                        ),
                      ),
                    ),
                    Text('${date(p.start)} – ${date(p.end)}', style: mono),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 40,
                      child: Text(
                        age(p.start),
                        textAlign: TextAlign.end,
                        style: mono.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        if (open && canOpen) add(sys.subPeriods(p));
      }
    }

    add(sys.mahadashas);
    final path = sys.pathAt(_focus, depth: _depth);
    final p0 = widget.analysis.panchang;
    final dayBirth = p0.sunriseJd != null && p0.sunsetJd != null
        ? c.jdUt >= p0.sunriseJd! && c.jdUt < p0.sunsetJd!
        : null;
    final note = switch (_kind) {
      DashaKind.yogini => l10n.yoginiNote,
      DashaKind.chara => l10n.charaNote(
        (sys as CharaDasha).forward ? l10n.forwards : l10n.backwards,
      ),
      _Nak(:final kind) => () {
        final applies = nakshatraDashaApplies(kind, c, dayBirth: dayBirth);
        return '${t.nakshatraDashaRule(kind)} · ${switch (applies) {
          true => l10n.dashaApplies,
          false => l10n.dashaNotApplies,
          null => l10n.dashaApplyUnknown,
        }}';
      }(),
      _ => null,
    };
    String kindLabel(DashaKind k) => switch (k) {
      DashaKind.vimshottari => l10n.vimshottari,
      DashaKind.yogini => l10n.yoginiDasha,
      DashaKind.chara => l10n.charaDasha,
      _Nak(:final kind) => '${t.nakshatraDasha(kind)} (${kind.totalYears})',
      _ => '',
    };

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonFormField<DashaKind>(
            initialValue: _kind,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l10n.dashaSystem,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            items: [
              for (final k in DashaKind.all)
                DropdownMenuItem(value: k, child: Text(kindLabel(k))),
            ],
            onChanged: (v) => setState(() {
              _kind = v!;
              _open.clear();
              _openPathAt(_focus);
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.runningAt(date(_focus)),
                  style: theme.textTheme.titleSmall,
                ),
              ),
              TextButton(
                onPressed: () => setState(() {
                  _focus = jdOf(DateTime.now().toUtc());
                  _openPathAt(_focus);
                }),
                child: Text(l10n.today),
              ),
              TextButton(
                onPressed: () async {
                  final now = dateOfJd(_focus, offset);
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: dateOfJd(sys.mahadashas.first.start, offset),
                    lastDate: dateOfJd(sys.mahadashas.last.end - 1, offset),
                  );
                  if (picked == null) return;
                  setState(() {
                    _focus = jdOf(
                      DateTime.utc(
                        picked.year,
                        picked.month,
                        picked.day,
                        12,
                      ).subtract(Duration(minutes: (offset * 60).round())),
                    );
                    _open.clear();
                    _openPathAt(_focus);
                  });
                },
                child: Text(l10n.jumpToDate),
              ),
            ],
          ),
        ),
        // The running chain, e.g. "Venus / Moon / Rahu".
        if (path.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
            child: Text(
              [
                for (final p in path)
                  '${t.dashaLevel(p.level)}: ${name(p.lord)}',
              ].join(' · '),
              style: theme.textTheme.bodySmall,
            ),
          ),
        if (note != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
            child: Text(note, style: theme.textTheme.bodySmall),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(36, 8, 8, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(l10n.colLord, style: theme.textTheme.labelMedium),
              ),
              Text(
                '${l10n.colFrom} – ${l10n.colTo}',
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 40,
                child: Text(
                  l10n.colAge,
                  textAlign: TextAlign.end,
                  style: theme.textTheme.labelMedium,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        ...rows,
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(l10n.dashaHint, style: theme.textTheme.bodySmall),
        ),
      ],
    );
  }
}
