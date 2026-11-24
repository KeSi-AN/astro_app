import 'dart:convert';
import 'dart:io';

import 'package:jyotish_core/jyotish_core.dart';

/// Loads Swiss Ephemeris on the PC for tests.
///
/// Needs `native/sweph.dll`, built once by `tools/build_sweph_dll.bat`.
/// Data files are read from the sweph package in the pub cache and copied
/// into a temp folder (never written into the cache).
Future<Ephemeris> loadTestEphemeris() async {
  final dll = File('native/sweph.dll');
  if (!dll.existsSync()) {
    throw StateError(
        'native/sweph.dll missing: run tools\\build_sweph_dll.bat first');
  }
  final config = jsonDecode(
          File('.dart_tool/package_config.json').readAsStringSync())
      as Map<String, dynamic>;
  final sweph = (config['packages'] as List)
      .cast<Map<String, dynamic>>()
      .firstWhere((p) => p['name'] == 'sweph');
  final root = Uri.parse('${sweph['rootUri']}/');
  final dataDir = Directory.fromUri(root.resolve('assets/ephe/'));

  final tmp = Directory('${Directory.systemTemp.path}/jyotish_core_ephe')
    ..createSync(recursive: true);
  return SwephEphemeris.init(
    epheDir: tmp.path,
    modulePath: dll.absolute.path,
    loadAsset: (f) => File('${dataDir.path}/$f').readAsBytes(),
  );
}

/// Golden fixtures live in astro_app/tools/golden.
List<Map<String, dynamic>> loadGoldenCharts() {
  final dir = Directory('../../tools/golden');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json')).toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  return [
    for (final f in files)
      jsonDecode(f.readAsStringSync()) as Map<String, dynamic>,
  ];
}

/// "27N09" → 27.15, "078E00" → 78.0, "033S52" → -33.8667
double parseCoordinate(String v) {
  final m = RegExp(r'^(\d+)([NSEW])(\d+)$').firstMatch(v.trim());
  if (m == null) throw FormatException('Bad coordinate "$v"');
  final x = int.parse(m[1]!) + int.parse(m[3]!) / 60;
  return (m[2] == 'S' || m[2] == 'W') ? -x : x;
}

BirthData birthFromGolden(Map<String, dynamic> g) {
  final b = g['birth'] as Map<String, dynamic>;
  final d = (b['date'] as String).split('-').map(int.parse).toList();
  final t = (b['time'] as String).split(':').map(int.parse).toList();
  return BirthData(
    year: d[0], month: d[1], day: d[2],
    hour: t[0], minute: t[1], second: t.length > 2 ? t[2] : 0,
    latitude: parseCoordinate(b['latitude'] as String),
    longitude: parseCoordinate(b['longitude'] as String),
    utcOffsetHours: (b['utcOffsetHours'] as num).toDouble(),
    dstHours: (b['dstHours'] as num? ?? 0).toDouble(),
    placeName: b['place'] as String? ?? '',
  );
}
