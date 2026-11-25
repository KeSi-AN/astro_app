import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../charts/data/chart_repository.dart';
import '../domain/client.dart';

/// Clients, the family charts linked to them and the reports sent.
class ClientRepository {
  ClientRepository(this._db, this._charts, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final ChartRepository _charts;
  final DateTime Function() _clock;

  static String _like(String s) =>
      '%${s.replaceAllMapped(RegExp(r'[\\%_]'), (m) => '\\${m[0]}')}%';

  /// Clients, most recently changed first. [search] matches the name,
  /// phone, city and notes, and also the notes of their consultations and
  /// the names/notes of their family charts.
  Stream<List<ClientSummary>> watchAll({String search = ''}) {
    final s = search.trim();
    final like = _like(s);
    return _db
        .customSelect(
          '''
SELECT c.*,
  (SELECT COUNT(*) FROM charts h WHERE h.client_id = c.id) AS n_charts,
  (SELECT MIN(a.starts_at) FROM appointments a
     WHERE a.client_id = c.id AND a.status = 'scheduled' AND a.starts_at >= ?1) AS next_at,
  (SELECT COALESCE(SUM(a.fee), 0) FROM appointments a
     WHERE a.client_id = c.id AND a.paid = 0 AND a.fee > 0
       AND a.status <> 'cancelled') AS unpaid
FROM clients c
WHERE ?2 = '' OR c.name LIKE ?3 ESCAPE '\\' OR c.phone LIKE ?3 ESCAPE '\\'
   OR c.city LIKE ?3 ESCAPE '\\' OR c.notes LIKE ?3 ESCAPE '\\'
   OR EXISTS (SELECT 1 FROM appointments a WHERE a.client_id = c.id
              AND (a.notes LIKE ?3 ESCAPE '\\' OR a.title LIKE ?3 ESCAPE '\\'))
   OR EXISTS (SELECT 1 FROM charts h WHERE h.client_id = c.id
              AND (h.name LIKE ?3 ESCAPE '\\' OR h.notes LIKE ?3 ESCAPE '\\'))
ORDER BY c.updated_at DESC
''',
          variables: [
            Variable.withDateTime(_clock()),
            Variable.withString(s),
            Variable.withString(like),
          ],
          readsFrom: {_db.clients, _db.charts, _db.appointments},
        )
        .watch()
        .map(
          (rows) => [
            for (final r in rows)
              ClientSummary(
                client: _client(_db.clients.map(r.data)),
                charts: r.read<int>('n_charts'),
                nextAppointment: r.readNullable<DateTime>('next_at'),
                unpaid: r.read<double>('unpaid'),
              ),
          ],
        );
  }

  Future<Client?> get(int id) async {
    final row = await (_db.select(
      _db.clients,
    )..where((c) => c.id.equals(id))).getSingleOrNull();
    return row == null ? null : _client(row);
  }

  Stream<Client?> watch(int id) =>
      (_db.select(_db.clients)..where((c) => c.id.equals(id)))
          .watchSingleOrNull()
          .map((r) => r == null ? null : _client(r));

  /// Inserts or updates; returns the id.
  Future<int> save(Client c) async {
    final now = _clock();
    final companion = ClientsCompanion(
      name: Value(c.name.trim()),
      phone: Value(c.phone.trim()),
      city: Value(c.city.trim()),
      notes: Value(c.notes.trim()),
      updatedAt: Value(now),
    );
    if (c.id == null) {
      return _db
          .into(_db.clients)
          .insert(companion.copyWith(createdAt: Value(now)));
    }
    await (_db.update(
      _db.clients,
    )..where((x) => x.id.equals(c.id!))).write(companion);
    return c.id!;
  }

  /// Deletes the client. Their charts and consultations stay, unlinked.
  Future<void> delete(int id) =>
      (_db.delete(_db.clients)..where((c) => c.id.equals(id))).go();

  /// Charts linked to the client, "self" first.
  Stream<List<FamilyChart>> watchFamily(int clientId) =>
      (_db.select(_db.charts)
            ..where((c) => c.clientId.equals(clientId))
            ..orderBy([(c) => OrderingTerm.asc(c.createdAt)]))
          .watch()
          .map((rows) {
            final out = [
              for (final r in rows)
                FamilyChart(
                  _charts.fromRow(r),
                  Relation.values.asNameMap()[r.relation] ?? Relation.other,
                ),
            ];
            out.sort((a, b) => a.relation.index.compareTo(b.relation.index));
            return out;
          });

  Future<void> link(int chartId, int clientId, Relation relation) async {
    await (_db.update(_db.charts)..where((c) => c.id.equals(chartId))).write(
      ChartsCompanion(clientId: Value(clientId), relation: Value(relation.name)),
    );
    await _touch(clientId);
  }

  Future<void> unlink(int chartId) =>
      (_db.update(_db.charts)..where((c) => c.id.equals(chartId))).write(
        const ChartsCompanion(clientId: Value(null), relation: Value(null)),
      );

  /// The client a chart belongs to, if any.
  Future<Client?> clientOfChart(int chartId) async {
    final row = await (_db.select(
      _db.charts,
    )..where((c) => c.id.equals(chartId))).getSingleOrNull();
    final id = row?.clientId;
    return id == null ? null : get(id);
  }

  Future<void> logReport({
    required int chartId,
    required String kind,
    required String language,
    required int pages,
  }) async {
    await _db
        .into(_db.reportLog)
        .insert(
          ReportLogCompanion.insert(
            chartId: chartId,
            at: _clock(),
            kind: kind,
            language: language,
            pages: Value(pages),
          ),
        );
  }

  /// Reports for the client's charts, newest first.
  Stream<List<ReportSent>> watchReports(int clientId) {
    final q = _db.select(_db.reportLog).join([
      innerJoin(_db.charts, _db.charts.id.equalsExp(_db.reportLog.chartId)),
    ])
      ..where(_db.charts.clientId.equals(clientId))
      ..orderBy([OrderingTerm.desc(_db.reportLog.at)]);
    return q.watch().map(
      (rows) => [
        for (final r in rows)
          () {
            final log = r.readTable(_db.reportLog);
            return ReportSent(
              chartId: log.chartId,
              chartName: r.readTable(_db.charts).name,
              at: log.at,
              kind: log.kind,
              language: log.language,
              pages: log.pages,
            );
          }(),
      ],
    );
  }

  Future<void> _touch(int clientId) =>
      (_db.update(_db.clients)..where((c) => c.id.equals(clientId))).write(
        ClientsCompanion(updatedAt: Value(_clock())),
      );

  Client _client(ClientRow r) => Client(
    id: r.id,
    name: r.name,
    phone: r.phone,
    city: r.city,
    notes: r.notes,
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
  );
}
