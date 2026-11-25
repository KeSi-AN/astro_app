import 'dart:typed_data';

import 'package:jyotish_core/jyotish_core.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/format/formatters.dart';
import '../../l10n/l10n.dart';
import '../chart_view/domain/chart_plate.dart';
import '../chart_view/domain/report_rows.dart';
import '../chart_view/presentation/tabs/dasha_tab.dart' show dateOfJd;
import '../charts/domain/chart_entry.dart';
import '../settings/settings.dart';
import 'pdf_chart.dart';
import 'pdf_text.dart';
import 'report_style.dart';

/// Parts of the kundli the astrologer can include.
enum ReportSection {
  birth,
  charts,
  planets,
  friendship,
  vargas,
  dashas,
  ashtakavarga,
  shadbala,
  kp,
  yogas,
}

class KundliPdfInput {
  const KundliPdfInput({
    required this.entry,
    required this.analysis,
    required this.settings,
    required this.ephemeris,
    required this.l10n,
    required this.terms,
    required this.sections,
    required this.today,
    this.logo,
  });

  final ChartEntry entry;
  final ChartAnalysis analysis;
  final AppSettings settings;
  final Ephemeris ephemeris;
  final AppLocalizations l10n;
  final AstroTerms terms;
  final Set<ReportSection> sections;

  /// Used for "prepared on" and to mark running dashas.
  final DateTime today;
  final Uint8List? logo;
}

/// Builds the kundli. Hindi text is drawn by Flutter, so this runs on the
/// UI isolate; see [PdfTextKit].
Future<Uint8List> buildKundliPdf(KundliPdfInput input, PdfTextKit kit) async {
  final data = _Data(input);
  pw.Document make() {
    final doc = pw.Document(
      title: '${input.l10n.reportTitle} – ${input.entry.name}',
      author: input.settings.letterhead.name,
      creator: 'astro_app',
    );
    _Builder(input, data, kit).addTo(doc);
    return doc;
  }

  // Each pass may meet new strings (page numbers change once images
  // replace the placeholders), so repeat until none are missing.
  var bytes = await make().save();
  for (var pass = 0; kit.hasPending && pass < 4; pass++) {
    await kit.renderPending();
    bytes = await make().save();
  }
  return bytes;
}

/// Heavy calculations, done once for both passes.
class _Data {
  _Data(KundliPdfInput i) {
    final a = i.analysis, c = a.chart, s = i.settings;
    final moon = c.grahas[Graha.moon]!.longitude;
    final has = i.sections.contains;
    if (has(ReportSection.dashas)) {
      vim = VimshottariDasha(moonLongitude: moon, birthJd: c.jdUt, year: s.dashaYear);
      yogini = YoginiDasha(moonLongitude: moon, birthJd: c.jdUt, year: s.dashaYear);
      chara = CharaDasha(chart: c, birthJd: c.jdUt, year: s.dashaYear);
    }
    if (has(ReportSection.ashtakavarga)) av = Ashtakavarga.of(c);
    if (has(ReportSection.shadbala)) sb = Shadbala.of(a, i.ephemeris);
    if (has(ReportSection.kp)) {
      kp = KpChart.calculate(i.ephemeris, c.birth, ayanamsa: s.kpAyanamsa);
    }
    if (has(ReportSection.yogas)) {
      yogaList = yogas(a);
      sadeSatiList = sadeSati(c, i.ephemeris);
    }
  }

  VimshottariDasha? vim;
  YoginiDasha? yogini;
  CharaDasha? chara;
  Ashtakavarga? av;
  Shadbala? sb;
  KpChart? kp;
  List<YogaResult>? yogaList;
  List<SaturnPeriod>? sadeSatiList;
}

class _Builder {
  _Builder(this.i, this.d, this.k) : r = ReportKit(k);

  final KundliPdfInput i;
  final _Data d;
  final PdfTextKit k;
  final ReportKit r;

  AppLocalizations get l10n => i.l10n;
  AstroTerms get t => i.terms;
  ChartAnalysis get a => i.analysis;
  Letterhead get lh => i.settings.letterhead;
  double get _offset =>
      a.chart.birth.utcOffsetHours + a.chart.birth.dstHours;
  double get _now =>
      i.today.toUtc().millisecondsSinceEpoch / 86400000 + 2440587.5;

  String date(double jd) {
    final x = dateOfJd(jd, _offset);
    return '${x.day.toString().padLeft(2, '0')}/'
        '${x.month.toString().padLeft(2, '0')}/${x.year}';
  }

  pw.ImageProvider? get _logo {
    if (i.logo == null) return null;
    try {
      return pw.MemoryImage(i.logo!);
    } catch (_) {
      return null; // unsupported image format: leave the logo out
    }
  }

  void addTo(pw.Document doc) {
    final theme = pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(36, 30, 36, 28),
      theme: pw.ThemeData.withFont(base: k.regularFont, bold: k.boldFont),
      buildBackground: (_) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Container(
          margin: const pw.EdgeInsets.all(14),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: ReportColors.rule, width: 0.8),
          ),
        ),
      ),
    );
    doc.addPage(pw.Page(pageTheme: theme, build: (_) => _cover()));
    final body = _body();
    if (body.isEmpty) return;
    doc.addPage(
      pw.MultiPage(
        pageTheme: theme,
        maxPages: 60,
        header: _header,
        footer: _footer,
        build: (_) => body,
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Page furniture

  pw.Widget _letterhead({required bool large}) {
    final logo = _logo;
    final lines = <pw.Widget>[
      if (lh.name.isNotEmpty)
        k.text(lh.name, size: large ? 20 : 10.5, bold: true, color: ReportColors.accent),
      if (lh.title.isNotEmpty)
        k.text(lh.title, size: large ? 11 : 7.5, color: ReportColors.muted),
    ];
    final contact = <pw.Widget>[
      if (lh.phone.isNotEmpty) k.text(lh.phone, size: large ? 10 : 7.5),
      if (lh.address.isNotEmpty)
        k.text(
          lh.address,
          size: large ? 9 : 7,
          color: ReportColors.muted,
          maxWidth: large ? 220 : 200,
          align: pw.TextAlign.right,
        ),
    ];
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        if (logo != null)
          pw.Padding(
            padding: const pw.EdgeInsets.only(right: 10),
            child: pw.Image(logo, width: large ? 64 : 26, height: large ? 64 : 26),
          ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: lines,
          ),
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: contact,
        ),
      ],
    );
  }

  pw.Widget _header(pw.Context context) => pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 10),
    padding: const pw.EdgeInsets.only(bottom: 4),
    decoration: const pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: ReportColors.rule, width: 0.8)),
    ),
    child: lh.isEmpty && i.logo == null
        ? pw.Row(
            children: [
              k.text(l10n.reportTitle, size: 9, bold: true, color: ReportColors.accent),
            ],
          )
        : _letterhead(large: false),
  );

  pw.Widget _footer(pw.Context context) => pw.Container(
    margin: const pw.EdgeInsets.only(top: 6),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        k.text('${i.entry.name} · ${l10n.reportTitle}', size: 7, color: ReportColors.muted),
        k.text(
          l10n.reportPage('${context.pageNumber}', '${context.pagesCount}'),
          size: 7,
          color: ReportColors.muted,
        ),
      ],
    ),
  );

  // -------------------------------------------------------------------------
  // Cover

  pw.Widget _cover() {
    final e = i.entry, c = a.chart;
    final moon = c.grahas[Graha.moon]!;
    final style = i.settings.chartStyle;
    final plate = buildPlate(a, PlateKind.lagna, outer: i.settings.showOuterPlanets);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        if (!lh.isEmpty || i.logo != null) ...[
          _letterhead(large: true),
          pw.SizedBox(height: 8),
          pw.Container(height: 1.2, color: ReportColors.chartLine),
          pw.SizedBox(height: 2),
          pw.Container(height: 0.5, color: ReportColors.chartLine),
        ],
        pw.SizedBox(height: 22),
        k.text(l10n.reportTitle, size: 28, bold: true, color: ReportColors.accent),
        pw.SizedBox(height: 10),
        k.text(e.name, size: 18, bold: true),
        pw.SizedBox(height: 8),
        k.text(
          '${formatDate(e.year, e.month, e.day, month: t.month)}  ·  '
          '${formatTime(e.hour, e.minute, e.second)}',
          size: 11,
        ),
        pw.SizedBox(height: 3),
        k.text(e.place.name, size: 11, color: ReportColors.muted),
        pw.SizedBox(height: 18),
        pdfChart(k, plate, style, t, size: 270, centreTitle: t.plateKind(PlateKind.lagna)),
        pw.SizedBox(height: 6),
        k.text(t.plateKind(PlateKind.lagna), size: 9, color: ReportColors.muted),
        pw.SizedBox(height: 16),
        k.text(
          '${l10n.lagna}: ${t.rashi(c.lagna.rashi)}   ·   '
          '${l10n.rashi}: ${t.rashi(moon.rashi)}   ·   '
          '${l10n.nakshatra}: ${t.nakshatra(moon.nakshatra)}-${moon.pada}',
          size: 10,
        ),
        pw.SizedBox(height: 10),
        _coverSummary(),
        pw.Spacer(),
        k.text(
          l10n.reportPreparedOn(
            formatDate(i.today.year, i.today.month, i.today.day, month: t.month),
          ),
          size: 8,
          color: ReportColors.muted,
        ),
      ],
    );
  }

  /// Panchang at birth and the main Avakhada points, side by side.
  pw.Widget _coverSummary() {
    final secs = detailsSections(l10n, t, i.entry, a, i.settings);
    final panchang = secs[1].$2.take(7).toList();
    final av = a.avakhada;
    final avRows = <(String, String)>[
      (l10n.varna, t.avakhadaValue(av.varna)),
      (l10n.yoni, t.avakhadaValue(av.yoni)),
      (l10n.gana, t.avakhadaValue(av.gana)),
      (l10n.nadi, t.avakhadaValue(av.nadi)),
      ...secs[2].$2.where((r) => r.$1 == l10n.nameSyllable || r.$1 == l10n.dashaBalance),
    ];
    const half = (contentWidth - 14) / 2;
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(width: half, child: r.keyValues(secs[1].$1, panchang, width: half)),
        pw.SizedBox(width: 14),
        pw.SizedBox(width: half, child: r.keyValues(secs[2].$1, avRows, width: half)),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Body

  List<pw.Widget> _body() {
    final out = <pw.Widget>[];
    void section(List<pw.Widget> w) {
      if (out.isNotEmpty) out.add(pw.NewPage());
      out.addAll(w);
    }

    for (final s in ReportSection.values) {
      if (!i.sections.contains(s)) continue;
      section(switch (s) {
        ReportSection.birth => _birth(),
        ReportSection.charts => _charts(),
        ReportSection.planets => _planets(),
        ReportSection.friendship => _friendship(),
        ReportSection.vargas => _vargas(),
        ReportSection.dashas => _dashas(),
        ReportSection.ashtakavarga => _ashtakavarga(),
        ReportSection.shadbala => _shadbala(),
        ReportSection.kp => _kp(),
        ReportSection.yogas => _yogas(),
      });
    }
    return out;
  }

  List<pw.Widget> _birth() {
    final secs = detailsSections(l10n, t, i.entry, a, i.settings);
    const half = (contentWidth - 14) / 2;
    return [
      r.heading(l10n.birthDetails),
      r.keyValues(secs[0].$1, secs[0].$2),
      pw.SizedBox(height: 6),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: half, child: r.keyValues(secs[1].$1, secs[1].$2, width: half, labelWidth: 0.45)),
          pw.SizedBox(width: 14),
          pw.SizedBox(width: half, child: r.keyValues(secs[2].$1, secs[2].$2, width: half, labelWidth: 0.45)),
        ],
      ),
    ];
  }

  pw.Widget _titledChart(ChartPlate plate, String title, double size) =>
      pw.Column(
        children: [
          k.text(title, size: 9, bold: true, color: ReportColors.accent),
          pw.SizedBox(height: 3),
          pdfChart(k, plate, i.settings.chartStyle, t, size: size, centreTitle: title),
        ],
      );

  List<pw.Widget> _charts() {
    final outer = i.settings.showOuterPlanets;
    const size = 250.0;
    pw.Widget c(PlateKind kind) =>
        _titledChart(buildPlate(a, kind, outer: outer), t.plateKind(kind), size);
    return [
      r.heading(l10n.reportCharts),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [c(PlateKind.lagna), c(PlateKind.moon)],
      ),
      pw.SizedBox(height: 14),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [c(PlateKind.navamsha), c(PlateKind.chalit)],
      ),
      r.note(l10n.planetsLegend),
    ];
  }

  List<pw.Widget> _planets() {
    final (header, rows) = planetTable(l10n, t, a);
    return [
      r.heading(l10n.tabPlanets),
      r.table(
        header,
        rows,
        widths: const [62, 44, 34, 52, 92, 36, 36, 104, 63],
        color: (row, col) {
          if (col != 7 || row == 0) return null;
          return switch (a.grahas[Graha.values[row - 1]]!.dignity) {
            Dignity.exalted || Dignity.moolatrikona || Dignity.own => ReportColors.good,
            Dignity.debilitated => ReportColors.bad,
            _ => null,
          };
        },
      ),
      r.note(l10n.planetsLegend),
      r.subheading(l10n.charaKarakasTitle(t.karakaScheme(a.karakaScheme))),
      r.table(
        [l10n.colKaraka, l10n.colPlanet, l10n.colDegree],
        [
          for (final (kk, g, deg) in a.karakas)
            ['${t.karaka(kk)} (${t.karakaShort(kk)})', t.graha(g), Dms.of(deg).degrees],
        ],
        widths: const [200, 150, 100],
      ),
    ];
  }

  List<pw.Widget> _friendship() {
    List<List<Relation?>> rel(Relation Function(Graha, Graha) f) => [
      for (final r in sevenGrahas)
        [for (final c in sevenGrahas) r == c ? null : f(r, c)],
    ];
    PdfColor? colour(Relation? r) => switch (r) {
      Relation.greatFriend || Relation.friend => ReportColors.good,
      Relation.enemy || Relation.greatEnemy => ReportColors.bad,
      _ => null,
    };
    pw.Widget grid(String title, List<List<Relation?>> g) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        r.subheading(title),
        r.table(
          ['', for (final p in sevenGrahas) t.grahaShort(p)],
          [
            for (var n = 0; n < 7; n++)
              [
                t.graha(sevenGrahas[n]),
                for (final x in g[n]) x == null ? '—' : t.relation(x),
              ],
          ],
          widths: [75, for (var n = 0; n < 7; n++) (contentWidth - 75) / 7],
          size: 7.5,
          boldRow: (_) => false,
          color: (row, col) => col == 0 ? null : colour(g[row][col - 1]),
        ),
      ],
    );
    return [
      r.heading(l10n.tabFriendship),
      grid(l10n.naturalTitle, rel(a.natural)),
      grid(l10n.temporalTitle, rel(a.temporal)),
      grid(l10n.compoundTitle, rel(a.compound)),
    ];
  }

  List<pw.Widget> _vargas() {
    final outer = i.settings.showOuterPlanets;
    const size = 162.0;
    final charts = [
      for (final v in Varga.values)
        _titledChart(buildVargaPlate(a, v, outer: outer), '${t.varga(v)} (${v.code})', size),
    ];
    return [
      r.heading(l10n.tabVargas),
      for (var n = 0; n < charts.length; n += 3)
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              for (var j = n; j < n + 3; j++)
                j < charts.length ? charts[j] : pw.SizedBox(width: size),
            ],
          ),
        ),
    ];
  }

  String _lordName(Object lord) => switch (lord) {
    Graha g => t.graha(g),
    Yogini y => '${t.yogini(y)} (${t.grahaShort(y.graha)})',
    Rashi s => t.rashi(s),
    _ => '$lord',
  };

  List<pw.Widget> _dashas() {
    final vim = d.vim! as DashaSystem<Object>;
    final now = _now;
    final path = vim.pathAt(now, depth: 3);
    const gap = 8.0;
    const w = (contentWidth - 2 * gap) / 3;
    pw.Widget block(DashaPeriod<Object> maha) {
      final subs = vim.subPeriods(maha);
      final running = subs.indexWhere((p) => p.contains(now));
      return pw.SizedBox(
        width: w,
        child: r.table(
          [_lordName(maha.lord), date(maha.start), date(maha.end)],
          [
            for (final p in subs) [_lordName(p.lord), date(p.start), date(p.end)],
          ],
          widths: const [w - 104, 52, 52],
          size: 7.5,
          boldRow: (row) => row == running,
          color: (row, col) => row == running ? ReportColors.accent : null,
        ),
      );
    }

    final mahas = vim.mahadashas;
    final yog = d.yogini! as DashaSystem<Object>;
    final yogMahas = yog.mahadashas.where((p) => p.start < a.chart.jdUt + 120 * 365.25).toList();
    final yogRunning = yogMahas.indexWhere((p) => p.contains(now));
    final chara = d.chara! as DashaSystem<Object>;
    final charaMahas = chara.mahadashas;
    final charaRunning = charaMahas.indexWhere((p) => p.contains(now));
    const half = (contentWidth - 14) / 2;

    return [
      r.heading(l10n.vimshottari),
      if (path.isNotEmpty)
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: k.text(
            l10n.reportRunning(
              path.map((p) => _lordName(p.lord)).join(' › '),
              date(path.last.end),
            ),
            size: 9,
            bold: true,
            color: ReportColors.accent,
          ),
        ),
      for (var n = 0; n < mahas.length; n += 3)
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: gap),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              for (var j = n; j < n + 3; j++)
                j < mahas.length ? block(mahas[j]) : pw.SizedBox(width: w),
            ],
          ),
        ),
      r.note('${l10n.dashaYearSetting}: ${t.dashaYear(i.settings.dashaYear)}'),
      pw.NewPage(),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: half,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                r.heading(l10n.yoginiDasha),
                r.table(
                  ['', l10n.colFrom, l10n.colTo],
                  [
                    for (final p in yogMahas) [_lordName(p.lord), date(p.start), date(p.end)],
                  ],
                  widths: const [half - 120, 60, 60],
                  size: 7.5,
                  boldRow: (row) => row == yogRunning,
                  color: (row, _) => row == yogRunning ? ReportColors.accent : null,
                ),
              ],
            ),
          ),
          pw.SizedBox(width: 14),
          pw.SizedBox(
            width: half,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                r.heading(l10n.charaDasha),
                r.table(
                  ['', l10n.colFrom, l10n.colTo],
                  [
                    for (final p in charaMahas) [_lordName(p.lord), date(p.start), date(p.end)],
                  ],
                  widths: const [half - 120, 60, 60],
                  size: 7.5,
                  boldRow: (row) => row == charaRunning,
                  color: (row, _) => row == charaRunning ? ReportColors.accent : null,
                ),
                r.note(
                  l10n.charaNote(d.chara!.forward ? l10n.forwards : l10n.backwards),
                  width: half,
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  List<pw.Widget> _ashtakavarga() {
    final av = d.av!;
    final sav = av.sav;
    final lagna = a.chart.lagna.rashi.index;
    PdfColor? strong(int v) =>
        v >= 28 ? ReportColors.good : (v < 25 ? ReportColors.bad : null);
    const contributors = [
      Graha.sun, Graha.moon, Graha.mars, Graha.mercury,
      Graha.jupiter, Graha.venus, Graha.saturn,
    ];
    final plate = buildPlate(a, PlateKind.lagna, outer: false);
    final savPlate = ChartPlate(
      title: plate.title,
      ascendantSign: plate.ascendantSign,
      houses: [for (final h in plate.houses) h.withBadge('${sav[h.sign.index]}')],
    );
    const half = (contentWidth - 14) / 2;
    pw.Widget prastara(Graha g) {
      final p = av.prastara[g]!;
      return pw.SizedBox(
        width: half,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            r.subheading(l10n.prastaraTitle(t.graha(g))),
            r.table(
              ['', for (var s = 1; s <= 12; s++) t.rashiShort(Rashi.values[s - 1])],
              [
                for (var n = 0; n < 8; n++)
                  [
                    n < 7 ? t.grahaShort(contributors[n]) : t.lagnaShort,
                    for (final v in p[n]) v == 1 ? '•' : '',
                  ],
                [l10n.colTotal, for (final v in av.bav(g)) '$v'],
              ],
              widths: [half - 12 * 19, for (var s = 0; s < 12; s++) 19],
              size: 6.5,
              boldRow: (row) => row == 8,
            ),
          ],
        ),
      );
    }

    return [
      r.heading(l10n.bavTitle),
      r.table(
        ['', for (var s = 1; s <= 12; s++) t.rashiShort(Rashi.values[s - 1]), l10n.colTotal],
        [
          for (final g in avGrahas)
            [t.grahaShort(g), for (final v in av.bav(g)) '$v', '${av.bavTotal(g)}'],
          [l10n.savTitle, for (final v in sav) '$v', '337'],
        ],
        widths: [60, for (var s = 0; s < 12; s++) 34.0, 55],
        boldRow: (row) => row == avGrahas.length,
        color: (row, col) => row == avGrahas.length && col >= 1 && col <= 12
            ? strong(sav[col - 1])
            : null,
      ),
      r.subheading(l10n.savByHouse),
      r.table(
        [for (var h = 1; h <= 12; h++) '$h'],
        [
          [for (var h = 0; h < 12; h++) '${sav[(lagna + h) % 12]}'],
        ],
        widths: [for (var h = 0; h < 12; h++) contentWidth / 12],
        color: (_, col) => strong(sav[(lagna + col) % 12]),
      ),
      r.note(l10n.avNote),
      pw.SizedBox(height: 10),
      pw.Center(child: _titledChart(savPlate, l10n.savTitle, 240)),
      pw.NewPage(),
      for (var n = 0; n < avGrahas.length; n += 2)
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              prastara(avGrahas[n]),
              if (n + 1 < avGrahas.length) prastara(avGrahas[n + 1]) else pw.SizedBox(width: half),
            ],
          ),
        ),
    ];
  }

  List<pw.Widget> _shadbala() {
    final sb = d.sb!;
    final rows = shadbalaRows(l10n, sb);
    final s = sb.grahas;
    final ranks = sb.bhavaRanks;
    final madhya = a.chart.bhavas.madhya;
    String f(double v) => v.toStringAsFixed(1);
    return [
      r.heading(l10n.shadbala),
      r.table(
        ['', for (final g in sevenGrahas) t.grahaShort(g)],
        rows,
        widths: [138, for (var n = 0; n < 7; n++) (contentWidth - 138) / 7],
        size: 7.5,
        boldRow: (row) => row >= rows.length - 5 || rows[row][0].startsWith('='),
        color: (row, col) {
          if (col == 0) return null;
          if (row == rows.length - 2) {
            return s[sevenGrahas[col - 1]]!.ratio >= 1 ? ReportColors.good : ReportColors.bad;
          }
          return null;
        },
      ),
      r.note(l10n.shadbalaNote),
      pw.SizedBox(height: 6),
      r.heading(l10n.bhavaBala),
      r.table(
        [
          l10n.colBhava,
          l10n.sign,
          l10n.bhavaLordStrength,
          l10n.bhavaDig,
          l10n.bhavaDrishti,
          l10n.totalRupas,
          l10n.strengthRank,
        ],
        [
          for (final b in sb.bhavas)
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
        widths: [for (var n = 0; n < 7; n++) contentWidth / 7],
        size: 7.5,
      ),
      r.note(l10n.bhavaNote),
    ];
  }

  List<pw.Widget> _kp() {
    final kp = d.kp!;
    String deg(double lon) =>
        '${t.rashiShort(Rashi.ofLongitude(lon))} ${Dms.of(norm360(lon) % 30).degrees}';
    List<String> lords(KpLords l) => [
      t.grahaShort(l.sign),
      t.grahaShort(l.star),
      t.grahaShort(l.sub),
      t.grahaShort(l.subSub),
    ];
    final lordHeader = [l10n.colSignLord, l10n.colStar, l10n.colSub, l10n.colSubSub];
    String houses(List<int> h) => h.join(', ');
    const half = (contentWidth - 14) / 2;
    return [
      r.heading(l10n.tabKp),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: half + 30,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                r.subheading(l10n.kpPlanets),
                r.table(
                  [l10n.colPlanet, l10n.colDegree, ...lordHeader, l10n.colHouse],
                  [
                    [t.lagna, deg(kp.cusps[0]), ...lords(kp.cuspLords(1)), '1'],
                    for (final g in kpGrahas)
                      [t.graha(g), deg(kp.planets[g]!), ...lords(kp.lordsOf(g)), '${kp.houseOf(kp.planets[g]!)}'],
                  ],
                  widths: [52, 60, 27, 27, 27, 27, half + 30 - 220],
                  size: 7.5,
                ),
              ],
            ),
          ),
          pw.SizedBox(width: 14),
          pw.SizedBox(
            width: half - 30,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                r.subheading(l10n.kpCusps),
                r.table(
                  [l10n.colCusp, l10n.colDegree, ...lordHeader],
                  [
                    for (var h = 1; h <= 12; h++) ['$h', deg(kp.cusps[h - 1]), ...lords(kp.cuspLords(h))],
                  ],
                  widths: [half - 30 - 168, 60, 27, 27, 27, 27],
                  size: 7.5,
                ),
              ],
            ),
          ),
        ],
      ),
      r.subheading(l10n.kpSignif),
      r.table(
        [l10n.colPlanet, l10n.colL1, l10n.colL2, l10n.colL3, l10n.colL4, l10n.colAllHouses],
        [
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
        widths: [50, 75, 75, 75, 75, contentWidth - 350],
        size: 7.5,
      ),
      r.note(l10n.kpSignifNote),
      r.subheading(l10n.houseSignificators),
      r.table(
        [l10n.colHouse, l10n.colSignificators],
        [
          for (var h = 1; h <= 12; h++)
            ['$h', kp.houseSignificators(h).map(t.grahaShort).join('  ')],
        ],
        widths: const [60, contentWidth - 60],
        size: 7.5,
        align: const [pw.Alignment.center, pw.Alignment.centerLeft],
      ),
      r.note('${l10n.kpAyanamsaSetting}: ${t.ayanamsa(i.settings.kpAyanamsa)}'),
    ];
  }

  List<pw.Widget> _yogas() {
    final ys = d.yogaList!;
    final shown = [
      ...ys.where((y) => y.isDosha),
      ...ys.where((y) => !y.isDosha && y.present),
    ];
    String status(YogaResult y) => y.present
        ? l10n.present
        : (y.cancelled ? l10n.cancelled : l10n.absent);
    PdfColor? statusColor(YogaResult y) => y.present
        ? (y.isDosha ? ReportColors.bad : ReportColors.good)
        : (y.cancelled ? ReportColors.accent : ReportColors.muted);
    const nameW = 120.0, statusW = 58.0;
    final ss = d.sadeSatiList!;
    final now = _now;
    final running = ss.indexWhere((p) => p.contains(now));
    String phase(SadeSatiPhase p) => switch (p) {
      SadeSatiPhase.rising => l10n.phaseRising,
      SadeSatiPhase.peak => l10n.phasePeak,
      SadeSatiPhase.setting => l10n.phaseSetting,
      SadeSatiPhase.none => '—',
    };
    return [
      r.heading(l10n.secYogas),
      r.table(
        [l10n.tabYogas, l10n.colResult, ''],
        [
          for (final y in shown)
            [
              t.yogaName(y.id),
              status(y),
              [t.yogaRule(y.id), yogaDetail(l10n, t, y)].where((s) => s.isNotEmpty).join('\n'),
            ],
        ],
        widths: const [nameW, statusW, contentWidth - nameW - statusW],
        size: 7.5,
        align: const [pw.Alignment.centerLeft, pw.Alignment.center, pw.Alignment.centerLeft],
        color: (row, col) => col == 1 ? statusColor(shown[row]) : null,
        boldRow: (row) => false,
      ),
      pw.SizedBox(height: 8),
      r.heading(l10n.secSadeSati),
      r.table(
        [l10n.colKind, l10n.sign, l10n.colFrom, l10n.colTo, l10n.colPhase],
        [
          for (final p in ss)
            [
              p.kind == SadeSatiKind.sadeSati ? l10n.sadeSatiKind : l10n.smallPanoti,
              t.rashi(p.sign),
              date(p.start),
              date(p.end),
              phase(p.phase),
            ],
        ],
        widths: [for (var n = 0; n < 5; n++) contentWidth / 5],
        size: 7.5,
        boldRow: (row) => row == running,
        color: (row, _) => row == running ? ReportColors.accent : null,
      ),
      r.note(l10n.sadeSatiNote),
    ];
  }
}
