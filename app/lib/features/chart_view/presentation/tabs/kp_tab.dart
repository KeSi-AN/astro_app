import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../l10n/l10n.dart';
import '../../../settings/settings.dart';
import 'table_widgets.dart';

enum _Kp { planets, cusps, signif, nadi, fourStep, cil, ruling, horary }

/// KP system: planet and cusp lords, significations, house significators,
/// ruling planets (birth and now) and horary (1–249).
class KpTab extends StatefulWidget {
  const KpTab({
    super.key,
    required this.analysis,
    required this.settings,
    required this.ephemeris,
  });
  final ChartAnalysis analysis;
  final AppSettings settings;
  final Ephemeris ephemeris;

  @override
  State<KpTab> createState() => _KpTabState();
}

class _KpTabState extends State<KpTab> with AutomaticKeepAliveClientMixin {
  _Kp _section = _Kp.planets;
  KpChart? _kp;
  Object? _key;
  late DateTime _now = DateTime.now().toUtc();
  final _horaryText = TextEditingController();
  KpChart? _horary;
  int? _horaryNumber;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _horaryText.dispose();
    super.dispose();
  }

  KpChart get kp {
    final key = (widget.analysis, widget.settings.kpAyanamsa);
    if (_kp == null || _key != key) {
      _key = key;
      _kp = KpChart.calculate(
        widget.ephemeris,
        widget.analysis.chart.birth,
        ayanamsa: widget.settings.kpAyanamsa,
      );
      _horary = null;
    }
    return _kp!;
  }

  /// "Now" at the birth place, using the chart's own UTC offset.
  BirthData _nowAtPlace() {
    final b = widget.analysis.chart.birth;
    final off = b.utcOffsetHours + b.dstHours;
    final l = _now.add(Duration(minutes: (off * 60).round()));
    return BirthData(
      year: l.year,
      month: l.month,
      day: l.day,
      hour: l.hour,
      minute: l.minute,
      second: l.second,
      latitude: b.latitude,
      longitude: b.longitude,
      utcOffsetHours: b.utcOffsetHours,
      dstHours: b.dstHours,
    );
  }

  Graha _dayLord(BirthData b) {
    final c = RasiChart.calculate(widget.ephemeris, b);
    return BirthPanchang.of(c, widget.ephemeris).varaLord;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final (s, label) in [
              (_Kp.planets, l10n.kpPlanets),
              (_Kp.cusps, l10n.kpCusps),
              (_Kp.signif, l10n.kpSignif),
              (_Kp.nadi, l10n.kpNadi),
              (_Kp.fourStep, l10n.kp4Step),
              (_Kp.cil, l10n.kpCil),
              (_Kp.ruling, l10n.kpRuling),
              (_Kp.horary, l10n.kpHorary),
            ])
              ChoiceChip(
                label: Text(label),
                selected: _section == s,
                onSelected: (_) => setState(() => _section = s),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${l10n.kpAyanamsaSetting}: ${context.terms.ayanamsa(widget.settings.kpAyanamsa)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 10),
        ...switch (_section) {
          _Kp.planets => _planets(context, kp),
          _Kp.cusps => _cusps(context, kp),
          _Kp.signif => _signif(context, kp),
          _Kp.nadi => _nadi(context, kp),
          _Kp.fourStep => _fourStep(context, kp),
          _Kp.cil => _cil(context, kp),
          _Kp.ruling => _ruling(context),
          _Kp.horary => _horaryView(context),
        },
      ],
    );
  }

  String _deg(double lon) {
    final t = context.terms;
    return '${t.rashiShort(Rashi.ofLongitude(lon))} ${Dms.of(norm360(lon) % 30).degrees}';
  }

  List<String> _lordCells(KpLords l) {
    final t = context.terms;
    return [
      t.grahaShort(l.sign),
      t.grahaShort(l.star),
      t.grahaShort(l.sub),
      t.grahaShort(l.subSub),
    ];
  }

  List<String> get _lordHeader {
    final l10n = context.l10n;
    return [l10n.colSignLord, l10n.colStar, l10n.colSub, l10n.colSubSub];
  }

  List<Widget> _planets(BuildContext context, KpChart kp) {
    final l10n = context.l10n;
    final t = context.terms;
    return [
      GridTable(
        header: [l10n.colPlanet, l10n.colDegree, ..._lordHeader, l10n.colHouse],
        rows: [
          [t.lagna, _deg(kp.cusps[0]), ..._lordCells(kp.cuspLords(1)), '1'],
          for (final g in kpGrahas)
            [
              t.graha(g),
              _deg(kp.planets[g]!),
              ..._lordCells(kp.lordsOf(g)),
              '${kp.houseOf(kp.planets[g]!)}',
            ],
        ],
      ),
    ];
  }

  List<Widget> _cusps(BuildContext context, KpChart kp, {KpChart? of}) {
    final l10n = context.l10n;
    final k = of ?? kp;
    return [
      GridTable(
        header: [l10n.colCusp, l10n.colDegree, ..._lordHeader],
        rows: [
          for (var h = 1; h <= 12; h++)
            ['$h', _deg(k.cusps[h - 1]), ..._lordCells(k.cuspLords(h))],
        ],
      ),
    ];
  }

  List<Widget> _signif(BuildContext context, KpChart kp) {
    final l10n = context.l10n;
    final t = context.terms;
    String houses(List<int> h) => h.join(', ');
    return [
      GridTable(
        header: [
          l10n.colPlanet,
          l10n.colL1,
          l10n.colL2,
          l10n.colL3,
          l10n.colL4,
          l10n.colAllHouses,
        ],
        rows: [
          for (final g in kpGrahas)
            () {
              final s = kp.signification(g);
              return [
                '${t.grahaShort(g)}${kp.isSelfSignifying(g) ? '+' : ''}',
                houses(s.starLordOccupies),
                houses(s.occupies),
                houses(s.starLordOwns),
                houses(s.owns),
                houses(s.all),
              ];
            }(),
        ],
      ),
      const SizedBox(height: 6),
      Text(l10n.kpSignifNote, style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 16),
      Text(
        l10n.houseSignificators,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      const SizedBox(height: 6),
      GridTable(
        header: [l10n.colHouse, l10n.colSignificators],
        rows: [
          for (var h = 1; h <= 12; h++)
            ['$h', kp.houseSignificators(h).map(t.grahaShort).join('  ')],
        ],
      ),
    ];
  }

  List<Widget> _rulingTable(RulingPlanets rp) {
    final l10n = context.l10n;
    final t = context.terms;
    final labels = {
      'dayLord': l10n.rpDayLord,
      'ascSignLord': l10n.rpAscSign,
      'ascStarLord': l10n.rpAscStar,
      'ascSubLord': l10n.rpAscSub,
      'moonSignLord': l10n.rpMoonSign,
      'moonStarLord': l10n.rpMoonStar,
      'moonSubLord': l10n.rpMoonSub,
    };
    return [
      GridTable(
        header: const ['', ''],
        rows: [
          for (final (k, g) in rp.rows) [labels[k]!, t.graha(g)],
        ],
      ),
    ];
  }

  List<Widget> _ruling(BuildContext context) {
    final l10n = context.l10n;
    final heading = Theme.of(context).textTheme.titleSmall;
    final birth = kp.rulingPlanets(widget.analysis.panchang.varaLord);
    final nowB = _nowAtPlace();
    final nowKp = KpChart.calculate(
      widget.ephemeris,
      nowB,
      ayanamsa: widget.settings.kpAyanamsa,
    );
    final nowRp = nowKp.rulingPlanets(_dayLord(nowB));
    return [
      Text(l10n.rpAtBirth, style: heading),
      const SizedBox(height: 6),
      ..._rulingTable(birth),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: Text(
              '${l10n.rpNow}  ${nowB.hour.toString().padLeft(2, '0')}:'
              '${nowB.minute.toString().padLeft(2, '0')}',
              style: heading,
            ),
          ),
          TextButton.icon(
            onPressed: () => setState(() => _now = DateTime.now().toUtc()),
            icon: const Icon(Icons.refresh),
            label: Text(l10n.refresh),
          ),
        ],
      ),
      ..._rulingTable(nowRp),
    ];
  }

  List<Widget> _horaryView(BuildContext context) {
    final l10n = context.l10n;
    final h = _horary;
    return [
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _horaryText,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.horaryNumber),
              onSubmitted: (_) => _castHorary(),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(onPressed: _castHorary, child: Text(l10n.horaryCast)),
        ],
      ),
      const SizedBox(height: 6),
      Text(l10n.horaryHint, style: Theme.of(context).textTheme.bodySmall),
      if (h != null) ...[
        const SizedBox(height: 12),
        Text(
          '#$_horaryNumber · ${l10n.horaryAsc(_deg(h.cusps[0]))}',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 6),
        ..._cusps(context, kp, of: h),
        const SizedBox(height: 12),
        ..._rulingTable(h.rulingPlanets(_dayLord(_nowAtPlace()))),
        const SizedBox(height: 12),
        ..._signif(context, h),
      ],
    ];
  }

  List<Widget> _nadi(BuildContext context, KpChart kp) {
    final l10n = context.l10n;
    final t = context.terms;
    String row(Graha g) => '${t.grahaShort(g)}  ${kp.nadi(g).join(', ')}';
    return [
      GridTable(
        header: [l10n.rowPlanet, l10n.rowStarLord, l10n.rowSubLord],
        rows: [
          for (final g in kpGrahas)
            [row(g), row(kp.lordsOf(g).star), row(kp.lordsOf(g).sub)],
        ],
      ),
      const SizedBox(height: 6),
      Text(l10n.nadiNote, style: Theme.of(context).textTheme.bodySmall),
    ];
  }

  List<Widget> _fourStep(BuildContext context, KpChart kp) {
    final l10n = context.l10n;
    final t = context.terms;
    final labels = [
      l10n.rowPlanet,
      l10n.rowStarLord,
      l10n.rowSubLord,
      l10n.rowSubStar,
    ];
    return [
      for (final g in kpGrahas)
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (i, (lord, houses)) in kp.fourStep(g).indexed)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '${i + 1}. ${labels[i]}: ${t.graha(lord)} — '
                      '${houses.isEmpty ? '—' : houses.join(', ')}',
                      style: i == 0
                          ? Theme.of(context).textTheme.titleSmall
                          : null,
                    ),
                  ),
              ],
            ),
          ),
        ),
      Text(l10n.fourStepNote, style: Theme.of(context).textTheme.bodySmall),
    ];
  }

  List<Widget> _cil(BuildContext context, KpChart kp) {
    final l10n = context.l10n;
    final t = context.terms;
    return [
      GridTable(
        header: [l10n.colCusp, l10n.colSub, l10n.colT1, l10n.colT3, l10n.colT4],
        rows: [
          for (var h = 1; h <= 12; h++)
            () {
              final c = kp.cilSub(h);
              return [
                '$h',
                t.grahaShort(c.subLord),
                c.t1.join(','),
                c.t3.isEmpty ? '—' : c.t3.join(','),
                '${c.t4}',
              ];
            }(),
        ],
      ),
      const SizedBox(height: 6),
      Text(l10n.cilNote, style: Theme.of(context).textTheme.bodySmall),
    ];
  }

  void _castHorary() {
    final n = int.tryParse(_horaryText.text.trim());
    if (n == null || n < 1 || n > 249) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.invalidHorary)));
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _now = DateTime.now().toUtc();
      _horaryNumber = n;
      _horary = KpChart.horary(
        widget.ephemeris,
        _nowAtPlace(),
        n,
        ayanamsa: widget.settings.kpAyanamsa,
      );
    });
  }
}
