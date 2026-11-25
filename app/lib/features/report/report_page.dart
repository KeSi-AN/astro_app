import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:printing/printing.dart';

import '../../app/router.dart';
import '../../app/services.dart';
import '../../l10n/l10n.dart';
import '../charts/domain/chart_entry.dart';
import '../settings/settings.dart';
import 'kundli_pdf.dart';
import 'pdf_text.dart';

/// Sections ticked last time (kept while the app runs).
Set<ReportSection> _lastSections = ReportSection.values.toSet();

String reportSectionLabel(AppLocalizations l10n, ReportSection s) =>
    switch (s) {
      ReportSection.birth => l10n.birthDetails,
      ReportSection.charts => l10n.reportCharts,
      ReportSection.planets => l10n.tabPlanets,
      ReportSection.friendship => l10n.tabFriendship,
      ReportSection.vargas => l10n.tabVargas,
      ReportSection.dashas => l10n.tabDasha,
      ReportSection.ashtakavarga => l10n.ashtakavargaShort,
      ReportSection.shadbala => l10n.shadbala,
      ReportSection.kp => l10n.tabKp,
      ReportSection.yogas => l10n.secYogas,
    };

/// Bottom sheet: pick sections and language, then open the preview.
Future<void> showReportOptions(
  BuildContext context, {
  required ChartEntry entry,
  required ChartAnalysis analysis,
  required AppSettings settings,
  required Ephemeris ephemeris,
}) async {
  final picked = await showModalBottomSheet<(Set<ReportSection>, String)>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _OptionsSheet(settings: settings),
  );
  if (picked == null || !context.mounted) return;
  _lastSections = picked.$1;
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => ReportPreviewPage(
        entry: entry,
        analysis: analysis,
        settings: settings,
        ephemeris: ephemeris,
        sections: picked.$1,
        languageCode: picked.$2,
      ),
    ),
  );
}

class _OptionsSheet extends StatefulWidget {
  const _OptionsSheet({required this.settings});
  final AppSettings settings;

  @override
  State<_OptionsSheet> createState() => _OptionsSheetState();
}

class _OptionsSheetState extends State<_OptionsSheet> {
  late final _sections = {..._lastSections};
  late String _lang = Localizations.localeOf(context).languageCode == 'hi'
      ? 'hi'
      : 'en';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.pdfKundli, style: theme.textTheme.titleLarge),
              if (widget.settings.letterhead.isEmpty)
                Card(
                  margin: const EdgeInsets.only(top: 12),
                  child: ListTile(
                    leading: const Icon(Icons.badge_outlined),
                    title: Text(l10n.letterheadMissing),
                    onTap: () {
                      Navigator.pop(context);
                      context.push(Routes.letterhead);
                    },
                  ),
                ),
              const SizedBox(height: 12),
              Text(l10n.reportInclude, style: theme.textTheme.titleSmall),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final s in ReportSection.values)
                    FilterChip(
                      label: Text(reportSectionLabel(l10n, s)),
                      selected: _sections.contains(s),
                      onSelected: (v) => setState(
                        () => v ? _sections.add(s) : _sections.remove(s),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(l10n.reportLanguage, style: theme.textTheme.titleSmall),
              const SizedBox(height: 6),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'hi', label: Text('हिंदी')),
                  ButtonSegment(value: 'en', label: Text('English')),
                ],
                selected: {_lang},
                onSelectionChanged: (v) => setState(() => _lang = v.first),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: Text(l10n.makePdf),
                  onPressed: () => Navigator.pop(context, (_sections, _lang)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Makes the PDF, shows its pages, and offers Share and Print.
class ReportPreviewPage extends StatefulWidget {
  const ReportPreviewPage({
    super.key,
    required this.entry,
    required this.analysis,
    required this.settings,
    required this.ephemeris,
    required this.sections,
    required this.languageCode,
  });

  final ChartEntry entry;
  final ChartAnalysis analysis;
  final AppSettings settings;
  final Ephemeris ephemeris;
  final Set<ReportSection> sections;
  final String languageCode;

  @override
  State<ReportPreviewPage> createState() => _ReportPreviewPageState();
}

class _ReportPreviewPageState extends State<ReportPreviewPage> {
  Uint8List? _pdf;
  Object? _error;
  Duration? _took;
  final _pages = <Uint8List>[];
  int? _pageCount;

  String get _fileName {
    final safe = widget.entry.name.replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), '_');
    return '${safe.isEmpty ? 'kundli' : safe}_kundli.pdf';
  }

  /// Records the report on the chart (shown on its client's page).
  Future<void> _log(String kind) async {
    final id = widget.entry.id;
    if (id == null) return;
    await context.read<AppServices>().clients.logReport(
      chartId: id,
      kind: kind,
      language: widget.languageCode,
      pages: _pageCount ?? _pages.length,
    );
  }

  Future<void> _share(Uint8List pdf) async {
    final sent = await Printing.sharePdf(bytes: pdf, filename: _fileName);
    if (sent) await _log('share');
  }

  @override
  void initState() {
    super.initState();
    // Let the first frame (with the progress indicator) show first.
    WidgetsBinding.instance.addPostFrameCallback((_) => _make());
  }

  Future<void> _make() async {
    try {
      final sw = Stopwatch()..start();
      final locale = Locale(widget.languageCode);
      final kit = PdfTextKit(
        regular: await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
        bold: await rootBundle.load('assets/fonts/Roboto-Bold.ttf'),
      );
      final logoPath = widget.settings.letterhead.logoPath;
      final logo = logoPath.isNotEmpty && File(logoPath).existsSync()
          ? await File(logoPath).readAsBytes()
          : null;
      final bytes = await buildKundliPdf(
        KundliPdfInput(
          entry: widget.entry,
          analysis: widget.analysis,
          settings: widget.settings,
          ephemeris: widget.ephemeris,
          l10n: lookupAppLocalizations(locale),
          terms: AstroTerms.forLocale(locale),
          sections: widget.sections,
          today: DateTime.now(),
          logo: logo,
        ),
        kit,
      );
      sw.stop();
      if (!mounted) return;
      setState(() {
        _pdf = bytes;
        _took = sw.elapsed;
      });
      var n = 0;
      await for (final page in Printing.raster(bytes, dpi: 110)) {
        final png = await page.toPng();
        n++;
        if (!mounted) return;
        setState(() => _pages.add(png));
      }
      if (mounted) setState(() => _pageCount = n);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pdf = _pdf;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pdfKundli),
        actions: [
          if (pdf != null) ...[
            IconButton(
              tooltip: l10n.printPdf,
              icon: const Icon(Icons.print_outlined),
              onPressed: () async {
                final done = await Printing.layoutPdf(
                  name: _fileName,
                  onLayout: (_) async => pdf,
                );
                if (done) await _log('print');
              },
            ),
            IconButton(
              tooltip: l10n.sharePdf,
              icon: const Icon(Icons.share_outlined),
              onPressed: () => _share(pdf),
            ),
          ],
        ],
      ),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.reportFailed('$_error')),
              ),
            )
          : pdf == null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(l10n.makingPdf),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    l10n.reportReady(
                      '${_pageCount ?? '…'}',
                      (_took!.inMilliseconds / 1000).toStringAsFixed(1),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  child: InteractiveViewer(
                    maxScale: 4,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                      itemCount: _pages.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, n) => DecoratedBox(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(blurRadius: 4, color: Color(0x40000000)),
                          ],
                        ),
                        // Rasterised pages are transparent where the PDF has no fill.
                        child: ColoredBox(
                          color: Colors.white,
                          child: Image.memory(_pages[n], fit: BoxFit.fitWidth),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: pdf == null
          ? null
          : FloatingActionButton.extended(
              icon: const Icon(Icons.share),
              label: Text(l10n.sharePdf),
              onPressed: () => _share(pdf),
            ),
    );
  }
}
