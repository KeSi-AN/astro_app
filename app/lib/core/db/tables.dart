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

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Key/value app preferences (chart style, ayanamsa, …).
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
