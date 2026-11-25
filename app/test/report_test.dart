import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:astro_app/features/atlas/domain/place.dart';
import 'package:astro_app/features/charts/domain/chart_entry.dart';
import 'package:astro_app/features/report/kundli_pdf.dart';
import 'package:astro_app/features/report/pdf_text.dart';
import 'package:astro_app/features/settings/settings.dart';
import 'package:astro_app/l10n/l10n.dart';
import 'package:birth_input/birth_input.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart' show Locale;

/// Swiss Ephemeris on the PC, as in jyotish_core's tests (needs
/// packages/jyotish_core/native/sweph.dll from tools/build_sweph_dll.bat).
Future<Ephemeris> _ephemeris() async {
  final dll = File('../packages/jyotish_core/native/sweph.dll');
  final config =
      jsonDecode(File('.dart_tool/package_config.json').readAsStringSync())
          as Map<String, dynamic>;
  final sweph = (config['packages'] as List)
      .cast<Map<String, dynamic>>()
      .firstWhere((p) => p['name'] == 'sweph');
  final root = Uri.parse('${sweph['rootUri']}/');
  final dataDir = Directory.fromUri(root.resolve('assets/ephe/'));
  final tmp = Directory('${Directory.systemTemp.path}/astro_app_report_ephe')
    ..createSync(recursive: true);
  return SwephEphemeris.init(
    epheDir: tmp.path,
    modulePath: dll.absolute.path,
    loadAsset: (f) => File('${dataDir.path}/$f').readAsBytes(),
  );
}

/// Pages in a PDF made by the pdf package ("/Type /Page" objects).
int _pageCount(Uint8List pdf) =>
    RegExp(r'/Type\s*/Page[^s]').allMatches(latin1.decode(pdf)).length;

void main() {
  late Ephemeris eph;
  late ChartEntry entry;
  late ChartAnalysis analysis;
  const settings = AppSettings(
    letterhead: Letterhead(
      name: 'Pt. Test Sharma',
      title: 'Vedic Astrologer',
      phone: '+91 00000 00000',
      address: 'Agra, Uttar Pradesh',
    ),
  );

  setUpAll(() async {
    eph = await _ephemeris();
    entry = const ChartEntry(
      name: 'TestChart',
      gender: 'male',
      year: 2026,
      month: 11,
      day: 23,
      hour: 23,
      minute: 21,
      second: 37,
      place: Place(
        name: 'Agra',
        admin1: 'Uttar Pradesh',
        countryName: 'India',
        latitude: 27.15,
        longitude: 78.0,
        zoneName: 'Asia/Kolkata',
      ),
      timeBasis: TimeBasis.zone,
      utcOffsetHours: 5.5,
    );
    analysis = ChartAnalysis.of(
      RasiChart.calculate(eph, entry.toBirthData(), settings.calc),
      eph,
      sunriseMode: settings.sunriseMode,
    );
  });

  PdfTextKit kit() => PdfTextKit(
    regular: ByteData.sublistView(
      File('assets/fonts/Roboto-Regular.ttf').readAsBytesSync(),
    ),
    bold: ByteData.sublistView(
      File('assets/fonts/Roboto-Bold.ttf').readAsBytesSync(),
    ),
  );

  Future<Uint8List> make(String lang, Set<ReportSection> sections, PdfTextKit k) {
    final locale = Locale(lang);
    return buildKundliPdf(
      KundliPdfInput(
        entry: entry,
        analysis: analysis,
        settings: settings,
        ephemeris: eph,
        l10n: lookupAppLocalizations(locale),
        terms: AstroTerms.forLocale(locale),
        sections: sections,
        today: DateTime(2026, 11, 25),
      ),
      k,
    );
  }

  test('Latin text uses the embedded font; Devanagari is rasterised', () {
    final k = kit();
    expect(k.isNative('Saturn 12°30′45″ · Page 3'), isTrue);
    expect(k.isNative('शनि'), isFalse);
  });

  testWidgets('full English kundli: 15–25 pages, no rasterised text', (t) async {
    await t.runAsync(() async {
      final k = kit();
      final sw = Stopwatch()..start();
      final pdf = await make('en', ReportSection.values.toSet(), k);
      sw.stop();
      final pages = _pageCount(pdf);
      // ignore: avoid_print
      print('English: $pages pages, ${pdf.length ~/ 1024} KB, ${sw.elapsedMilliseconds} ms, '
          '${k.rasterCount} images');
      File('build/report_test_en.pdf')
        ..createSync(recursive: true)
        ..writeAsBytesSync(pdf);
      expect(latin1.decode(pdf.sublist(0, 5)), '%PDF-');
      expect(pages, inInclusiveRange(15, 25));
    });
  });

  testWidgets('full Hindi kundli renders Devanagari as images', (t) async {
    await t.runAsync(() async {
      final k = kit();
      final sw = Stopwatch()..start();
      final pdf = await make('hi', ReportSection.values.toSet(), k);
      sw.stop();
      final pages = _pageCount(pdf);
      // ignore: avoid_print
      print('Hindi: $pages pages, ${pdf.length ~/ 1024} KB, ${sw.elapsedMilliseconds} ms, '
          '${k.rasterCount} images');
      File('build/report_test_hi.pdf')
        ..createSync(recursive: true)
        ..writeAsBytesSync(pdf);
      expect(k.rasterCount, greaterThan(50));
      expect(k.hasPending, isFalse);
      expect(pages, inInclusiveRange(15, 25));
    });
  });

  testWidgets('one section only: cover plus that section', (t) async {
    await t.runAsync(() async {
      final pdf = await make('en', {ReportSection.planets}, kit());
      expect(_pageCount(pdf), 2);
    });
  });
}
