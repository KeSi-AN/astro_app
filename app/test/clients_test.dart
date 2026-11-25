import 'dart:io';

import 'package:astro_app/core/db/app_database.dart';
import 'package:astro_app/features/appointments/data/appointment_repository.dart';
import 'package:astro_app/features/appointments/data/reminders.dart';
import 'package:astro_app/features/appointments/domain/appointment.dart';
import 'package:astro_app/features/appointments/presentation/appointment_format.dart';
import 'package:astro_app/features/backup/backup_service.dart';
import 'package:astro_app/features/charts/data/chart_repository.dart';
import 'package:astro_app/features/clients/data/client_repository.dart';
import 'package:astro_app/features/clients/domain/client.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

import 'chart_repository_test.dart' show entry;

void main() {
  late AppDatabase db;
  late ChartRepository charts;
  late ClientRepository clients;
  late AppointmentRepository appts;
  final now = DateTime(2026, 11, 25, 12);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    charts = ChartRepository(db, clock: () => now);
    clients = ClientRepository(db, charts, clock: () => now);
    appts = AppointmentRepository(db, clock: () => now);
  });
  tearDown(() => db.close());

  test('schema 2 database upgrades to 3 and keeps its charts', () async {
    final dir = await Directory.systemTemp.createTemp('astro_mig');
    final file = File('${dir.path}/old.sqlite');
    final raw = sqlite3.open(file.path);
    for (final sql in File('test/fixtures/v2_schema.sql').readAsLinesSync()) {
      if (sql.trim().isNotEmpty) raw.execute(sql);
    }
    raw.execute(
      "INSERT INTO charts (name, year, month, day, hour, minute, place_name, latitude, "
      "longitude, zone_name, time_basis, utc_offset_hours, created_at, updated_at) "
      "VALUES ('Old', 1990, 1, 1, 0, 0, 'Agra', 27.15, 78.0, 'Asia/Kolkata', 'zone', 5.5, 0, 0)",
    );
    raw.execute('PRAGMA user_version = 2');
    raw.close();

    final upgraded = AppDatabase(NativeDatabase(file));
    final repo = ChartRepository(upgraded);
    final cRepo = ClientRepository(upgraded, repo);
    final list = await repo.watchAll().first;
    expect(list.single.name, 'Old');
    final clientId = await cRepo.save(const Client(name: 'Old client'));
    await cRepo.link(list.single.id!, clientId, Relation.self);
    expect((await cRepo.watchFamily(clientId).first).single.chart.name, 'Old');
    await upgraded.close();
    await dir.delete(recursive: true);
  });

  test('family charts: link, relation order, unlink; deleting a client keeps charts', () async {
    final c = await clients.save(const Client(name: 'Ramesh Gupta', phone: '98765 43210'));
    final son = await charts.save(entry('Aarav'));
    final self = await charts.save(entry('Ramesh'));
    await clients.link(son, c, Relation.son);
    await clients.link(self, c, Relation.self);
    final fam = await clients.watchFamily(c).first;
    expect(fam.map((f) => f.chart.name), ['Ramesh', 'Aarav']);
    expect((await clients.clientOfChart(son))!.name, 'Ramesh Gupta');

    await clients.unlink(son);
    expect((await clients.watchFamily(c).first).length, 1);

    await clients.delete(c);
    expect((await charts.watchAll().first).length, 2);
    expect(await clients.clientOfChart(self), isNull);
  });

  test('client search reaches consultation and chart notes; summary counts', () async {
    final a = await clients.save(const Client(name: 'Sunita', city: 'Mathura'));
    final b = await clients.save(const Client(name: 'Vikram'));
    await clients.link(await charts.save(entry('Sunita')), a, Relation.self);
    await appts.save(Appointment(
      clientId: b,
      startsAt: now.subtract(const Duration(days: 3)),
      status: AppointmentStatus.done,
      notes: 'Asked about marriage; advised Shani remedy',
      fee: 500,
    ));
    await appts.save(Appointment(clientId: a, startsAt: now.add(const Duration(days: 2))));

    Future<List<String>> names(String q) async =>
        [for (final s in await clients.watchAll(search: q).first) s.client.name];
    expect(await names('shani'), ['Vikram']);
    expect(await names('mathura'), ['Sunita']);
    expect(await names(''), hasLength(2));

    final all = await clients.watchAll().first;
    final sunita = all.firstWhere((s) => s.client.name == 'Sunita');
    final vikram = all.firstWhere((s) => s.client.name == 'Vikram');
    expect(sunita.charts, 1);
    expect(sunita.nextAppointment, now.add(const Duration(days: 2)));
    expect(vikram.unpaid, 500);
  });

  test('appointments: today, unpaid, follow-ups, mark paid', () async {
    final day = DateTime(2026, 11, 25);
    final id = await appts.save(Appointment(
      title: 'Walk-in Mr Verma',
      startsAt: DateTime(2026, 11, 25, 17, 30),
      fee: 1100,
      followUpOn: DateTime(2026, 11, 28),
    ));
    await appts.save(Appointment(title: 'Tomorrow', startsAt: DateTime(2026, 11, 26, 10)));
    await appts.save(Appointment(
      title: 'Cancelled',
      startsAt: DateTime(2026, 11, 25, 9),
      fee: 300,
      status: AppointmentStatus.cancelled,
    ));

    final today = await appts.watchBetween(day, day.add(const Duration(days: 1))).first;
    expect(today.map((a) => a.title), ['Cancelled', 'Walk-in Mr Verma']);
    expect((await appts.watchUnpaid().first).map((a) => a.title), ['Walk-in Mr Verma']);
    expect(
      (await appts.watchFollowUps(day, day.add(const Duration(days: 8))).first).single.id,
      id,
    );
    final a = (await appts.get(id))!;
    await appts.save(a.copyWith(paid: true, status: AppointmentStatus.done));
    expect(await appts.watchUnpaid().first, isEmpty);
  });

  test('reminder times: 30 min before, follow-up at 10:00, only future ones', () {
    final a = Appointment(
      id: 7,
      startsAt: DateTime(2026, 11, 25, 17, 30),
      followUpOn: DateTime(2026, 12, 1),
    );
    final t = reminderTimes(a, DateTime(2026, 11, 25, 12));
    expect(t, [
      (14, DateTime(2026, 11, 25, 17), false),
      (15, DateTime(2026, 12, 1, 10), true),
    ]);
    // Past start → only the follow-up; done appointments get no start reminder.
    expect(reminderTimes(a, DateTime(2026, 11, 25, 17, 10)).length, 1);
    expect(reminderTimes(a.copyWith(status: AppointmentStatus.done), DateTime(2026, 11, 25, 12)).length, 1);
    expect(reminderTimes(Appointment(startsAt: DateTime(2027)), DateTime(2026)), isEmpty);
  });

  test('money in Indian grouping', () {
    expect(formatMoney(500), '₹500');
    expect(formatMoney(1250), '₹1,250');
    expect(formatMoney(1234567), '₹12,34,567');
    expect(formatMoney(99.5), '₹99.50');
  });

  test('backup round trip: data and logo come back, logo path re-pointed', () async {
    final root = await Directory.systemTemp.createTemp('astro_backup');
    Directory sub(String n) => Directory('${root.path}/$n')..createSync(recursive: true);
    final phoneA = sub('a'), phoneB = sub('b'), temp = sub('tmp');

    final fileA = File('${phoneA.path}/astro.sqlite');
    final dbA = AppDatabase(NativeDatabase(fileA));
    final logo = File('${phoneA.path}/${BackupService.logoFolder}/logo.png')
      ..createSync(recursive: true)
      ..writeAsBytesSync([1, 2, 3]);
    await dbA.customStatement(
      "INSERT INTO settings (key, value) VALUES ('lhLogo', ?)",
      [logo.path],
    );
    final cA = ClientRepository(dbA, ChartRepository(dbA));
    final cid = await cA.save(const Client(name: 'Backup Test'));
    await cA.link(await ChartRepository(dbA).save(entry('Chart B')), cid, Relation.self);
    final zip = await BackupService(
      dbA,
      databaseFile: () async => fileA,
      storageDir: () async => phoneA,
      tempDir: () async => temp,
    ).create();
    await dbA.close();

    final fileB = File('${phoneB.path}/astro.sqlite');
    final dbB = AppDatabase(NativeDatabase(fileB));
    await ChartRepository(dbB).save(entry('Will be replaced'));
    final serviceB = BackupService(
      dbB,
      databaseFile: () async => fileB,
      storageDir: () async => phoneB,
      tempDir: () async => temp,
    );
    final bytes = File(zip).readAsBytesSync();
    final info = await serviceB.inspect(bytes);
    expect((info.charts, info.clients), (1, 1));
    await serviceB.restore(bytes);

    final dbB2 = AppDatabase(NativeDatabase(fileB));
    final names = [for (final c in await ChartRepository(dbB2).watchAll().first) c.name];
    expect(names, ['Chart B']);
    final lh = await dbB2
        .customSelect("SELECT value FROM settings WHERE key = 'lhLogo'")
        .getSingle();
    final newLogo = lh.read<String>('value');
    expect(newLogo.startsWith(phoneB.path), isTrue);
    expect(File(newLogo).readAsBytesSync(), [1, 2, 3]);
    await dbB2.close();
    await expectLater(serviceB.inspect(File(fileB.path).readAsBytesSync()), throwsA(isA<InvalidBackupException>()));
    await root.delete(recursive: true);
  });
}
