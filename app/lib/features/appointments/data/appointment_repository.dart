import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../domain/appointment.dart';

/// Consultations, with the client's name read alongside.
class AppointmentRepository {
  AppointmentRepository(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  JoinedSelectStatement<HasResultSet, dynamic> _joined() =>
      _db.select(_db.appointments).join([
        leftOuterJoin(
          _db.clients,
          _db.clients.id.equalsExp(_db.appointments.clientId),
        ),
      ]);

  List<Appointment> _map(List<TypedResult> rows) => [
    for (final r in rows)
      _fromRow(r.readTable(_db.appointments), r.readTableOrNull(_db.clients)?.name),
  ];

  /// Appointments starting in [from, to), earliest first.
  Stream<List<Appointment>> watchBetween(DateTime from, DateTime to) {
    final a = _db.appointments;
    final q = _joined()
      ..where(a.startsAt.isBiggerOrEqualValue(from) & a.startsAt.isSmallerThanValue(to))
      ..orderBy([OrderingTerm.asc(a.startsAt)]);
    return q.watch().map(_map);
  }

  /// Past appointments before [before], newest first.
  Stream<List<Appointment>> watchBefore(DateTime before, {int limit = 200}) {
    final a = _db.appointments;
    final q = _joined()
      ..where(a.startsAt.isSmallerThanValue(before))
      ..orderBy([OrderingTerm.desc(a.startsAt)])
      ..limit(limit);
    return q.watch().map(_map);
  }

  /// Follow-ups due in [from, to), by date.
  Stream<List<Appointment>> watchFollowUps(DateTime from, DateTime to) {
    final a = _db.appointments;
    final q = _joined()
      ..where(a.followUpOn.isBiggerOrEqualValue(from) & a.followUpOn.isSmallerThanValue(to))
      ..orderBy([OrderingTerm.asc(a.followUpOn)]);
    return q.watch().map(_map);
  }

  /// A client's consultations, newest first.
  Stream<List<Appointment>> watchForClient(int clientId) {
    final a = _db.appointments;
    final q = _joined()
      ..where(a.clientId.equals(clientId))
      ..orderBy([OrderingTerm.desc(a.startsAt)]);
    return q.watch().map(_map);
  }

  /// Held consultations with a fee not yet paid, oldest first.
  Stream<List<Appointment>> watchUnpaid() {
    final a = _db.appointments;
    final q = _joined()
      ..where(
        a.paid.equals(false) &
            a.fee.isBiggerThanValue(0) &
            a.status.equals(AppointmentStatus.cancelled.name).not(),
      )
      ..orderBy([OrderingTerm.asc(a.startsAt)]);
    return q.watch().map(_map);
  }

  Future<Appointment?> get(int id) async {
    final q = _joined()..where(_db.appointments.id.equals(id));
    final rows = await q.get();
    return rows.isEmpty ? null : _map(rows).single;
  }

  /// All appointments that may still need a reminder (from [from] on).
  Future<List<Appointment>> upcomingForReminders(DateTime from) async {
    final a = _db.appointments;
    final q = _joined()
      ..where(
        a.remind.equals(true) &
            (a.startsAt.isBiggerOrEqualValue(from) |
                a.followUpOn.isBiggerOrEqualValue(from)),
      );
    return _map(await q.get());
  }

  /// Inserts or updates; returns the id.
  Future<int> save(Appointment x) async {
    final now = _clock();
    final c = AppointmentsCompanion(
      clientId: Value(x.clientId),
      title: Value(x.title.trim()),
      startsAt: Value(x.startsAt),
      minutes: Value(x.minutes),
      status: Value(x.status.name),
      notes: Value(x.notes.trim()),
      fee: Value(x.fee),
      paid: Value(x.paid),
      followUpOn: Value(x.followUpOn),
      remind: Value(x.remind),
      updatedAt: Value(now),
    );
    final int id;
    if (x.id == null) {
      id = await _db.into(_db.appointments).insert(c.copyWith(createdAt: Value(now)));
    } else {
      await (_db.update(_db.appointments)..where((a) => a.id.equals(x.id!))).write(c);
      id = x.id!;
    }
    // Seeing a client counts as activity for the client list order.
    if (x.clientId != null) {
      await (_db.update(_db.clients)..where((k) => k.id.equals(x.clientId!)))
          .write(ClientsCompanion(updatedAt: Value(now)));
    }
    return id;
  }

  Future<void> delete(int id) =>
      (_db.delete(_db.appointments)..where((a) => a.id.equals(id))).go();

  Appointment _fromRow(AppointmentRow r, String? clientName) => Appointment(
    id: r.id,
    clientId: r.clientId,
    clientName: clientName,
    title: r.title,
    startsAt: r.startsAt,
    minutes: r.minutes,
    status:
        AppointmentStatus.values.asNameMap()[r.status] ??
        AppointmentStatus.scheduled,
    notes: r.notes,
    fee: r.fee,
    paid: r.paid,
    followUpOn: r.followUpOn,
    remind: r.remind,
  );
}
