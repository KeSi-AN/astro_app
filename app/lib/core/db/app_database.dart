import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Charts, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'astro'));

  @override
  int get schemaVersion => 2;

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
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(settings);
    },
  );
}
