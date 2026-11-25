import 'package:drift/drift.dart';

/// A saved birth chart: what was entered plus how its time was converted
/// to UT, so the chart can always be reproduced exactly.
class Charts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();

  /// 'male' | 'female' | null
  TextColumn get gender => text().nullable()();

  IntColumn get year => integer()();
  IntColumn get month => integer()();
  IntColumn get day => integer()();
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();
  IntColumn get second => integer().withDefault(const Constant(0))();

  /// Display name of the place, e.g. "Agra, Uttar Pradesh, India".
  TextColumn get placeName => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();

  /// IANA zone, e.g. "Asia/Kolkata".
  TextColumn get zoneName => text()();
  TextColumn get country => text().withDefault(const Constant(''))();
  TextColumn get admin1 => text().withDefault(const Constant(''))();

  /// birth_input TimeBasis name: zone | lmt | bombay | calcutta | manual
  TextColumn get timeBasis => text()();
  RealColumn get utcOffsetHours => real()();
  RealColumn get dstHours => real().withDefault(const Constant(0))();

  /// Only meaningful during India's war-time periods.
  BoolColumn get warTimeApplied => boolean().nullable()();

  TextColumn get maritalStatus => text().nullable()();
  TextColumn get occupation => text().nullable()();
  TextColumn get notes => text().nullable()();

  /// The client this chart belongs to (schema 3), and who it is to them:
  /// self | spouse | son | daughter | father | mother | brother | sister | other.
  IntColumn get clientId => integer().nullable().references(
    Clients,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get relation => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// A person who consults the astrologer; their family's charts link here.
@DataClassName('ClientRow')
class Clients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get city => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// A consultation: booked ahead (appointment) and, once held, its notes,
/// fee and follow-up.
@DataClassName('AppointmentRow')
class Appointments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clientId => integer().nullable().references(
    Clients,
    #id,
    onDelete: KeyAction.setNull,
  )();

  /// Who is coming when there is no client record, or the topic.
  TextColumn get title => text().withDefault(const Constant(''))();
  DateTimeColumn get startsAt => dateTime()();
  IntColumn get minutes => integer().withDefault(const Constant(30))();

  /// scheduled | done | cancelled | missed
  TextColumn get status => text().withDefault(const Constant('scheduled'))();

  /// What was discussed and advised.
  TextColumn get notes => text().withDefault(const Constant(''))();
  RealColumn get fee => real().nullable()();
  BoolColumn get paid => boolean().withDefault(const Constant(false))();

  /// Remind the astrologer to follow up on this day.
  DateTimeColumn get followUpOn => dateTime().nullable()();
  BoolColumn get remind => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// PDF kundlis shared or printed, per chart.
@DataClassName('ReportLogRow')
class ReportLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get chartId =>
      integer().references(Charts, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get at => dateTime()();

  /// share | print
  TextColumn get kind => text()();
  TextColumn get language => text()();
  IntColumn get pages => integer().withDefault(const Constant(0))();
}

/// Key/value app preferences (chart style, ayanamsa, …).
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
