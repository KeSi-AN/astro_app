import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Charts, Settings, Clients, Appointments, ReportLog])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'astro'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement(
        'CREATE INDEX charts_updated ON charts(updated_at DESC)',
      );
      await customStatement(
        'CREATE INDEX charts_name ON charts(name COLLATE NOCASE)',
      );
      await _indexesV3();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(settings);
      if (from < 3) {
        await m.createTable(clients);
        await m.createTable(appointments);
        await m.createTable(reportLog);
        await m.addColumn(charts, charts.clientId);
        await m.addColumn(charts, charts.relation);
        await _indexesV3();
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _indexesV3() async {
    for (final sql in [
      'CREATE INDEX charts_client ON charts(client_id)',
      'CREATE INDEX clients_name ON clients(name COLLATE NOCASE)',
      'CREATE INDEX appointments_starts ON appointments(starts_at)',
      'CREATE INDEX appointments_client ON appointments(client_id)',
      'CREATE INDEX report_log_chart ON report_log(chart_id)',
    ]) {
      await customStatement(sql);
    }
  }

  /// The database file (drift_flutter keeps it in the documents folder).
  static Future<File> file() async => File(
    p.join((await getApplicationDocumentsDirectory()).path, 'astro.sqlite'),
  );
}
