import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

import '../domain/place.dart';

/// Offline place search over the GeoNames atlas (assets/atlas/atlas.sqlite,
/// built by tools/atlas/build_atlas.py). Read-only.
class AtlasRepository {
  AtlasRepository._(this._db);

  final Database _db;
  late final PreparedStatement _byPrefix = _db.prepare('''
    SELECT p.name, a.admin2, a.admin1, a.country, c.name, p.lat, p.lon,
           t.name, p.pop
    FROM place p
    JOIN admin a ON a.id = p.admin
    JOIN tz t ON t.id = p.tz
    LEFT JOIN country c ON c.code = a.country
    WHERE p.name LIKE ? ESCAPE '\\'
    ORDER BY p.pop DESC, p.name
    LIMIT ?
  ''');

  /// Opens the atlas file at [path] (already copied out of the app bundle).
  static AtlasRepository open(String path) {
    if (!File(path).existsSync()) {
      throw StateError('Atlas not found at $path');
    }
    return AtlasRepository._(sqlite3.open(path, mode: OpenMode.readOnly));
  }

  /// Places whose name starts with the first comma-separated part of
  /// [query]; further parts ("Jaipur, Rajasthan") filter by district, state
  /// or country. Bigger places come first.
  List<Place> search(String query, {int limit = 40}) {
    final parts = query
        .split(',')
        .map((s) => s.trim().replaceAll(RegExp(r'\s+'), ' '))
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.isEmpty || parts.first.length < 2) return const [];
    final escaped = parts.first.replaceAllMapped(
      RegExp(r'[\\%_]'),
      (m) => '\\${m[0]}',
    );
    final filters = parts.skip(1).map((s) => s.toLowerCase()).toList();

    // Fetch extra rows when filtering, since the filter runs in Dart.
    final rows = _byPrefix.select([
      '$escaped%',
      filters.isEmpty ? limit : 2000,
    ]);
    final out = <Place>[];
    for (final r in rows) {
      final place = Place(
        name: r.columnAt(0) as String,
        admin2: r.columnAt(1) as String,
        admin1: r.columnAt(2) as String,
        country: r.columnAt(3) as String,
        countryName: (r.columnAt(4) as String?) ?? '',
        latitude: (r.columnAt(5) as int) / 1e4,
        longitude: (r.columnAt(6) as int) / 1e4,
        zoneName: r.columnAt(7) as String,
        population: r.columnAt(8) as int,
      );
      if (filters.isNotEmpty) {
        final hay =
            '${place.admin2} ${place.admin1} ${place.country} '
                    '${place.countryName}'
                .toLowerCase();
        if (!filters.every(hay.contains)) continue;
      }
      out.add(place);
      if (out.length >= limit) break;
    }
    return out;
  }

  void close() => _db.close();
}
