import 'package:birth_input/birth_input.dart';
import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../atlas/domain/place.dart';
import '../domain/chart_entry.dart';

class ChartRepository {
  ChartRepository(this._db, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  /// All charts, most recently edited first; [search] matches name or place.
  Stream<List<ChartEntry>> watchAll({String search = ''}) {
    final q = _db.select(_db.charts);
    final s = search.trim();
    if (s.isNotEmpty) {
      final like = '%${s.replaceAllMapped(RegExp(r'[\\%_]'), (m) => '\\${m[0]}')}%';
      q.where((c) =>
          c.name.like(like, escapeChar: '\\') |
          c.placeName.like(like, escapeChar: '\\'));
    }
    q.orderBy([(c) => OrderingTerm.desc(c.updatedAt)]);
    return q.watch().map((rows) => rows.map(_fromRow).toList());
  }

  Future<ChartEntry?> get(int id) async {
    final row = await (_db.select(_db.charts)..where((c) => c.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  /// Inserts or updates; returns the id.
  Future<int> save(ChartEntry e) async {
    final now = _clock();
    final companion = ChartsCompanion(
      name: Value(e.name.trim()),
      gender: Value(e.gender),
      year: Value(e.year), month: Value(e.month), day: Value(e.day),
      hour: Value(e.hour), minute: Value(e.minute), second: Value(e.second),
      placeName: Value(e.place.displayName),
      latitude: Value(e.place.latitude),
      longitude: Value(e.place.longitude),
      zoneName: Value(e.place.zoneName),
      country: Value(e.place.country),
      admin1: Value(e.place.admin1),
      timeBasis: Value(e.timeBasis.name),
      utcOffsetHours: Value(e.utcOffsetHours),
      dstHours: Value(e.dstHours),
      warTimeApplied: Value(e.warTimeApplied),
      maritalStatus: Value(e.maritalStatus),
      occupation: Value(e.occupation),
      notes: Value(e.notes),
      updatedAt: Value(now),
    );
    if (e.id == null) {
      return _db.into(_db.charts)
          .insert(companion.copyWith(createdAt: Value(now)));
    }
    await (_db.update(_db.charts)..where((c) => c.id.equals(e.id!)))
        .write(companion);
    return e.id!;
  }

  Future<int> duplicate(int id) async {
    final e = await get(id);
    if (e == null) throw StateError('Chart $id not found');
    return save(ChartEntry(
      name: '${e.name} (copy)', gender: e.gender,
      year: e.year, month: e.month, day: e.day,
      hour: e.hour, minute: e.minute, second: e.second,
      place: e.place, timeBasis: e.timeBasis,
      utcOffsetHours: e.utcOffsetHours, dstHours: e.dstHours,
      warTimeApplied: e.warTimeApplied, maritalStatus: e.maritalStatus,
      occupation: e.occupation, notes: e.notes,
    ));
  }

  Future<void> delete(int id) =>
      (_db.delete(_db.charts)..where((c) => c.id.equals(id))).go();

  ChartEntry _fromRow(Chart r) {
    // placeName is stored as "Name, State, Country"; keep the first part as
    // the place name for display in compact rows.
    final parts = r.placeName.split(', ');
    return ChartEntry(
      id: r.id,
      name: r.name,
      gender: r.gender,
      year: r.year, month: r.month, day: r.day,
      hour: r.hour, minute: r.minute, second: r.second,
      place: Place(
        name: parts.first,
        admin1: r.admin1,
        country: r.country,
        countryName: parts.length > 1 && parts.last != r.admin1 ? parts.last : '',
        latitude: r.latitude,
        longitude: r.longitude,
        zoneName: r.zoneName,
      ),
      timeBasis: TimeBasis.values.asNameMap()[r.timeBasis] ?? TimeBasis.manual,
      utcOffsetHours: r.utcOffsetHours,
      dstHours: r.dstHours,
      warTimeApplied: r.warTimeApplied,
      maritalStatus: r.maritalStatus,
      occupation: r.occupation,
      notes: r.notes,
      createdAt: r.createdAt,
      updatedAt: r.updatedAt,
    );
  }
}
