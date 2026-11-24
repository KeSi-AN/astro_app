import 'dart:convert';
import 'dart:io';

import 'package:astro_app/features/chart_view/domain/chart_plate.dart';
import 'package:astro_app/features/chart_view/presentation/chart_geometry.dart';
import 'package:astro_app/features/charts/domain/chart_entry.dart';
import 'package:astro_app/l10n/astro_terms.dart';
import 'package:birth_input/birth_input.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jyotish_core/jyotish_core.dart';

final _devanagari = RegExp('[ऀ-ॿ]');

void main() {
  test('every English string has a Hindi translation', () {
    Map<String, dynamic> load(String f) =>
        jsonDecode(File('lib/l10n/$f').readAsStringSync()) as Map<String, dynamic>;
    final en = load('app_en.arb'), hi = load('app_hi.arb');
    final keys = en.keys.where((k) => !k.startsWith('@')).toSet();
    final missing = keys.where((k) => !hi.containsKey(k)).toList();
    expect(missing, isEmpty, reason: 'missing in app_hi.arb');
    // Placeholders must survive translation.
    for (final k in keys) {
      final ph = RegExp(r'\{(\w+)\}').allMatches(en[k] as String).map((m) => m[1]).toSet();
      final phHi = RegExp(r'\{(\w+)\}').allMatches(hi[k] as String).map((m) => m[1]).toSet();
      expect(phHi, ph, reason: 'placeholders of $k');
    }
  });

  group('Hindi astrology terms', () {
    const t = HindiTerms();
    void hindi(String s, String what) =>
        expect(_devanagari.hasMatch(s), isTrue, reason: '$what → "$s"');

    test('all enums have Hindi names', () {
      for (final g in Graha.values) {
        hindi(t.graha(g), '$g');
        hindi(t.grahaShort(g), '$g short');
      }
      for (final r in Rashi.values) {
        hindi(t.rashi(r), '$r');
      }
      for (final n in Nakshatra.values) {
        hindi(t.nakshatra(n), '$n');
        for (var p = 1; p <= 4; p++) {
          hindi(t.nameSyllable(n, p), '$n pada $p');
        }
      }
      for (var i = 1; i <= 30; i++) {
        hindi(t.tithi(i), 'tithi $i');
      }
      for (var i = 1; i <= 27; i++) {
        hindi(t.yoga(i), 'yoga $i');
      }
      for (var i = 1; i <= 60; i++) {
        hindi(t.karana(i), 'karana $i');
      }
      for (var i = 1; i <= 7; i++) {
        hindi(t.weekday(i), 'weekday $i');
      }
      for (final v in Dignity.values) {
        hindi(t.dignity(v), '$v');
      }
      for (final v in Relation.values) {
        hindi(t.relation(v), '$v');
        hindi(t.relationShort(v), '$v short');
      }
      for (final v in Karaka.values) {
        hindi(t.karaka(v), '$v');
      }
      for (final v in Ayanamsa.values) {
        hindi(t.ayanamsa(v), '$v');
      }
      for (final v in TimeBasis.values) {
        hindi(t.timeBasis(v), '$v');
      }
      for (final v in ChartStyle.values) {
        hindi(t.chartStyle(v), '$v');
      }
      for (final v in PlateKind.values) {
        hindi(t.plateKind(v), '$v');
      }
      for (final v in Varga.values) {
        hindi(t.varga(v), '$v');
      }
      for (final v in Yogini.values) {
        hindi(t.yogini(v), '$v');
      }
      for (var l = 1; l <= 5; l++) {
        hindi(t.dashaLevel(l), 'dasha level $l');
      }
      for (final v in DashaYear.values) {
        hindi(t.dashaYear(v), '$v');
      }
      for (var m = 1; m <= 12; m++) {
        hindi(t.month(m), 'month $m');
      }
      for (final m in maritalStatuses) {
        hindi(t.maritalStatus(m), m);
      }
      for (final o in occupations) {
        hindi(t.occupation(o), o);
      }
    });

    test('every Avakhada value the engine can produce is translated', () {
      const values = [
        'Brahmin', 'Kshatriya', 'Vaishya', 'Shudra',
        'Chatushpada', 'Manava', 'Jalachara', 'Vanachara', 'Keeta',
        'Horse', 'Elephant', 'Sheep', 'Serpent', 'Dog', 'Cat', 'Rat', 'Cow',
        'Buffalo', 'Tiger', 'Deer', 'Monkey', 'Mongoose', 'Lion',
        'Deva', 'Manushya', 'Rakshasa', 'Adi', 'Madhya', 'Antya',
        'Fire', 'Earth', 'Air', 'Water', 'Gold', 'Silver', 'Copper', 'Iron',
      ];
      for (final v in values) {
        hindi(t.avakhadaValue(v), v);
      }
    });

    test('chart abbreviations stay short', () {
      for (final g in Graha.values) {
        expect(t.grahaShort(g).runes.length, lessThanOrEqualTo(4), reason: '$g');
      }
      expect(t.lagnaShort, 'ल');
    });
  });
}
