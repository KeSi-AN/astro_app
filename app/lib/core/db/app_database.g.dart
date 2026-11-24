// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ChartsTable extends Charts with TableInfo<$ChartsTable, Chart> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
    'hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
    'minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _secondMeta = const VerificationMeta('second');
  @override
  late final GeneratedColumn<int> second = GeneratedColumn<int>(
    'second',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _placeNameMeta = const VerificationMeta(
    'placeName',
  );
  @override
  late final GeneratedColumn<String> placeName = GeneratedColumn<String>(
    'place_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _zoneNameMeta = const VerificationMeta(
    'zoneName',
  );
  @override
  late final GeneratedColumn<String> zoneName = GeneratedColumn<String>(
    'zone_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _admin1Meta = const VerificationMeta('admin1');
  @override
  late final GeneratedColumn<String> admin1 = GeneratedColumn<String>(
    'admin1',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _timeBasisMeta = const VerificationMeta(
    'timeBasis',
  );
  @override
  late final GeneratedColumn<String> timeBasis = GeneratedColumn<String>(
    'time_basis',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _utcOffsetHoursMeta = const VerificationMeta(
    'utcOffsetHours',
  );
  @override
  late final GeneratedColumn<double> utcOffsetHours = GeneratedColumn<double>(
    'utc_offset_hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dstHoursMeta = const VerificationMeta(
    'dstHours',
  );
  @override
  late final GeneratedColumn<double> dstHours = GeneratedColumn<double>(
    'dst_hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _warTimeAppliedMeta = const VerificationMeta(
    'warTimeApplied',
  );
  @override
  late final GeneratedColumn<bool> warTimeApplied = GeneratedColumn<bool>(
    'war_time_applied',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("war_time_applied" IN (0, 1))',
    ),
  );
  static const VerificationMeta _maritalStatusMeta = const VerificationMeta(
    'maritalStatus',
  );
  @override
  late final GeneratedColumn<String> maritalStatus = GeneratedColumn<String>(
    'marital_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occupationMeta = const VerificationMeta(
    'occupation',
  );
  @override
  late final GeneratedColumn<String> occupation = GeneratedColumn<String>(
    'occupation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    gender,
    year,
    month,
    day,
    hour,
    minute,
    second,
    placeName,
    latitude,
    longitude,
    zoneName,
    country,
    admin1,
    timeBasis,
    utcOffsetHours,
    dstHours,
    warTimeApplied,
    maritalStatus,
    occupation,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'charts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chart> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('hour')) {
      context.handle(
        _hourMeta,
        hour.isAcceptableOrUnknown(data['hour']!, _hourMeta),
      );
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(
        _minuteMeta,
        minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta),
      );
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    if (data.containsKey('second')) {
      context.handle(
        _secondMeta,
        second.isAcceptableOrUnknown(data['second']!, _secondMeta),
      );
    }
    if (data.containsKey('place_name')) {
      context.handle(
        _placeNameMeta,
        placeName.isAcceptableOrUnknown(data['place_name']!, _placeNameMeta),
      );
    } else if (isInserting) {
      context.missing(_placeNameMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('zone_name')) {
      context.handle(
        _zoneNameMeta,
        zoneName.isAcceptableOrUnknown(data['zone_name']!, _zoneNameMeta),
      );
    } else if (isInserting) {
      context.missing(_zoneNameMeta);
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('admin1')) {
      context.handle(
        _admin1Meta,
        admin1.isAcceptableOrUnknown(data['admin1']!, _admin1Meta),
      );
    }
    if (data.containsKey('time_basis')) {
      context.handle(
        _timeBasisMeta,
        timeBasis.isAcceptableOrUnknown(data['time_basis']!, _timeBasisMeta),
      );
    } else if (isInserting) {
      context.missing(_timeBasisMeta);
    }
    if (data.containsKey('utc_offset_hours')) {
      context.handle(
        _utcOffsetHoursMeta,
        utcOffsetHours.isAcceptableOrUnknown(
          data['utc_offset_hours']!,
          _utcOffsetHoursMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_utcOffsetHoursMeta);
    }
    if (data.containsKey('dst_hours')) {
      context.handle(
        _dstHoursMeta,
        dstHours.isAcceptableOrUnknown(data['dst_hours']!, _dstHoursMeta),
      );
    }
    if (data.containsKey('war_time_applied')) {
      context.handle(
        _warTimeAppliedMeta,
        warTimeApplied.isAcceptableOrUnknown(
          data['war_time_applied']!,
          _warTimeAppliedMeta,
        ),
      );
    }
    if (data.containsKey('marital_status')) {
      context.handle(
        _maritalStatusMeta,
        maritalStatus.isAcceptableOrUnknown(
          data['marital_status']!,
          _maritalStatusMeta,
        ),
      );
    }
    if (data.containsKey('occupation')) {
      context.handle(
        _occupationMeta,
        occupation.isAcceptableOrUnknown(data['occupation']!, _occupationMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chart map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chart(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      hour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hour'],
      )!,
      minute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute'],
      )!,
      second: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}second'],
      )!,
      placeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_name'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      zoneName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zone_name'],
      )!,
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      )!,
      admin1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}admin1'],
      )!,
      timeBasis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_basis'],
      )!,
      utcOffsetHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}utc_offset_hours'],
      )!,
      dstHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}dst_hours'],
      )!,
      warTimeApplied: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}war_time_applied'],
      ),
      maritalStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marital_status'],
      ),
      occupation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occupation'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ChartsTable createAlias(String alias) {
    return $ChartsTable(attachedDatabase, alias);
  }
}

class Chart extends DataClass implements Insertable<Chart> {
  final int id;
  final String name;

  /// 'male' | 'female' | null
  final String? gender;
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int second;

  /// Display name of the place, e.g. "Agra, Uttar Pradesh, India".
  final String placeName;
  final double latitude;
  final double longitude;

  /// IANA zone, e.g. "Asia/Kolkata".
  final String zoneName;
  final String country;
  final String admin1;

  /// birth_input TimeBasis name: zone | lmt | bombay | calcutta | manual
  final String timeBasis;
  final double utcOffsetHours;
  final double dstHours;

  /// Only meaningful during India's war-time periods.
  final bool? warTimeApplied;
  final String? maritalStatus;
  final String? occupation;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Chart({
    required this.id,
    required this.name,
    this.gender,
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
    required this.placeName,
    required this.latitude,
    required this.longitude,
    required this.zoneName,
    required this.country,
    required this.admin1,
    required this.timeBasis,
    required this.utcOffsetHours,
    required this.dstHours,
    this.warTimeApplied,
    this.maritalStatus,
    this.occupation,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['day'] = Variable<int>(day);
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    map['second'] = Variable<int>(second);
    map['place_name'] = Variable<String>(placeName);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['zone_name'] = Variable<String>(zoneName);
    map['country'] = Variable<String>(country);
    map['admin1'] = Variable<String>(admin1);
    map['time_basis'] = Variable<String>(timeBasis);
    map['utc_offset_hours'] = Variable<double>(utcOffsetHours);
    map['dst_hours'] = Variable<double>(dstHours);
    if (!nullToAbsent || warTimeApplied != null) {
      map['war_time_applied'] = Variable<bool>(warTimeApplied);
    }
    if (!nullToAbsent || maritalStatus != null) {
      map['marital_status'] = Variable<String>(maritalStatus);
    }
    if (!nullToAbsent || occupation != null) {
      map['occupation'] = Variable<String>(occupation);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ChartsCompanion toCompanion(bool nullToAbsent) {
    return ChartsCompanion(
      id: Value(id),
      name: Value(name),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      year: Value(year),
      month: Value(month),
      day: Value(day),
      hour: Value(hour),
      minute: Value(minute),
      second: Value(second),
      placeName: Value(placeName),
      latitude: Value(latitude),
      longitude: Value(longitude),
      zoneName: Value(zoneName),
      country: Value(country),
      admin1: Value(admin1),
      timeBasis: Value(timeBasis),
      utcOffsetHours: Value(utcOffsetHours),
      dstHours: Value(dstHours),
      warTimeApplied: warTimeApplied == null && nullToAbsent
          ? const Value.absent()
          : Value(warTimeApplied),
      maritalStatus: maritalStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(maritalStatus),
      occupation: occupation == null && nullToAbsent
          ? const Value.absent()
          : Value(occupation),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Chart.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chart(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      gender: serializer.fromJson<String?>(json['gender']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      day: serializer.fromJson<int>(json['day']),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
      second: serializer.fromJson<int>(json['second']),
      placeName: serializer.fromJson<String>(json['placeName']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      zoneName: serializer.fromJson<String>(json['zoneName']),
      country: serializer.fromJson<String>(json['country']),
      admin1: serializer.fromJson<String>(json['admin1']),
      timeBasis: serializer.fromJson<String>(json['timeBasis']),
      utcOffsetHours: serializer.fromJson<double>(json['utcOffsetHours']),
      dstHours: serializer.fromJson<double>(json['dstHours']),
      warTimeApplied: serializer.fromJson<bool?>(json['warTimeApplied']),
      maritalStatus: serializer.fromJson<String?>(json['maritalStatus']),
      occupation: serializer.fromJson<String?>(json['occupation']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'gender': serializer.toJson<String?>(gender),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'day': serializer.toJson<int>(day),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
      'second': serializer.toJson<int>(second),
      'placeName': serializer.toJson<String>(placeName),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'zoneName': serializer.toJson<String>(zoneName),
      'country': serializer.toJson<String>(country),
      'admin1': serializer.toJson<String>(admin1),
      'timeBasis': serializer.toJson<String>(timeBasis),
      'utcOffsetHours': serializer.toJson<double>(utcOffsetHours),
      'dstHours': serializer.toJson<double>(dstHours),
      'warTimeApplied': serializer.toJson<bool?>(warTimeApplied),
      'maritalStatus': serializer.toJson<String?>(maritalStatus),
      'occupation': serializer.toJson<String?>(occupation),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Chart copyWith({
    int? id,
    String? name,
    Value<String?> gender = const Value.absent(),
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    String? placeName,
    double? latitude,
    double? longitude,
    String? zoneName,
    String? country,
    String? admin1,
    String? timeBasis,
    double? utcOffsetHours,
    double? dstHours,
    Value<bool?> warTimeApplied = const Value.absent(),
    Value<String?> maritalStatus = const Value.absent(),
    Value<String?> occupation = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Chart(
    id: id ?? this.id,
    name: name ?? this.name,
    gender: gender.present ? gender.value : this.gender,
    year: year ?? this.year,
    month: month ?? this.month,
    day: day ?? this.day,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
    second: second ?? this.second,
    placeName: placeName ?? this.placeName,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    zoneName: zoneName ?? this.zoneName,
    country: country ?? this.country,
    admin1: admin1 ?? this.admin1,
    timeBasis: timeBasis ?? this.timeBasis,
    utcOffsetHours: utcOffsetHours ?? this.utcOffsetHours,
    dstHours: dstHours ?? this.dstHours,
    warTimeApplied: warTimeApplied.present
        ? warTimeApplied.value
        : this.warTimeApplied,
    maritalStatus: maritalStatus.present
        ? maritalStatus.value
        : this.maritalStatus,
    occupation: occupation.present ? occupation.value : this.occupation,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Chart copyWithCompanion(ChartsCompanion data) {
    return Chart(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      gender: data.gender.present ? data.gender.value : this.gender,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      day: data.day.present ? data.day.value : this.day,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
      second: data.second.present ? data.second.value : this.second,
      placeName: data.placeName.present ? data.placeName.value : this.placeName,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      zoneName: data.zoneName.present ? data.zoneName.value : this.zoneName,
      country: data.country.present ? data.country.value : this.country,
      admin1: data.admin1.present ? data.admin1.value : this.admin1,
      timeBasis: data.timeBasis.present ? data.timeBasis.value : this.timeBasis,
      utcOffsetHours: data.utcOffsetHours.present
          ? data.utcOffsetHours.value
          : this.utcOffsetHours,
      dstHours: data.dstHours.present ? data.dstHours.value : this.dstHours,
      warTimeApplied: data.warTimeApplied.present
          ? data.warTimeApplied.value
          : this.warTimeApplied,
      maritalStatus: data.maritalStatus.present
          ? data.maritalStatus.value
          : this.maritalStatus,
      occupation: data.occupation.present
          ? data.occupation.value
          : this.occupation,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chart(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('day: $day, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('second: $second, ')
          ..write('placeName: $placeName, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('zoneName: $zoneName, ')
          ..write('country: $country, ')
          ..write('admin1: $admin1, ')
          ..write('timeBasis: $timeBasis, ')
          ..write('utcOffsetHours: $utcOffsetHours, ')
          ..write('dstHours: $dstHours, ')
          ..write('warTimeApplied: $warTimeApplied, ')
          ..write('maritalStatus: $maritalStatus, ')
          ..write('occupation: $occupation, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    gender,
    year,
    month,
    day,
    hour,
    minute,
    second,
    placeName,
    latitude,
    longitude,
    zoneName,
    country,
    admin1,
    timeBasis,
    utcOffsetHours,
    dstHours,
    warTimeApplied,
    maritalStatus,
    occupation,
    notes,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chart &&
          other.id == this.id &&
          other.name == this.name &&
          other.gender == this.gender &&
          other.year == this.year &&
          other.month == this.month &&
          other.day == this.day &&
          other.hour == this.hour &&
          other.minute == this.minute &&
          other.second == this.second &&
          other.placeName == this.placeName &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.zoneName == this.zoneName &&
          other.country == this.country &&
          other.admin1 == this.admin1 &&
          other.timeBasis == this.timeBasis &&
          other.utcOffsetHours == this.utcOffsetHours &&
          other.dstHours == this.dstHours &&
          other.warTimeApplied == this.warTimeApplied &&
          other.maritalStatus == this.maritalStatus &&
          other.occupation == this.occupation &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ChartsCompanion extends UpdateCompanion<Chart> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> gender;
  final Value<int> year;
  final Value<int> month;
  final Value<int> day;
  final Value<int> hour;
  final Value<int> minute;
  final Value<int> second;
  final Value<String> placeName;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String> zoneName;
  final Value<String> country;
  final Value<String> admin1;
  final Value<String> timeBasis;
  final Value<double> utcOffsetHours;
  final Value<double> dstHours;
  final Value<bool?> warTimeApplied;
  final Value<String?> maritalStatus;
  final Value<String?> occupation;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ChartsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.gender = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.day = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
    this.second = const Value.absent(),
    this.placeName = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.zoneName = const Value.absent(),
    this.country = const Value.absent(),
    this.admin1 = const Value.absent(),
    this.timeBasis = const Value.absent(),
    this.utcOffsetHours = const Value.absent(),
    this.dstHours = const Value.absent(),
    this.warTimeApplied = const Value.absent(),
    this.maritalStatus = const Value.absent(),
    this.occupation = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ChartsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.gender = const Value.absent(),
    required int year,
    required int month,
    required int day,
    required int hour,
    required int minute,
    this.second = const Value.absent(),
    required String placeName,
    required double latitude,
    required double longitude,
    required String zoneName,
    this.country = const Value.absent(),
    this.admin1 = const Value.absent(),
    required String timeBasis,
    required double utcOffsetHours,
    this.dstHours = const Value.absent(),
    this.warTimeApplied = const Value.absent(),
    this.maritalStatus = const Value.absent(),
    this.occupation = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       year = Value(year),
       month = Value(month),
       day = Value(day),
       hour = Value(hour),
       minute = Value(minute),
       placeName = Value(placeName),
       latitude = Value(latitude),
       longitude = Value(longitude),
       zoneName = Value(zoneName),
       timeBasis = Value(timeBasis),
       utcOffsetHours = Value(utcOffsetHours),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Chart> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? gender,
    Expression<int>? year,
    Expression<int>? month,
    Expression<int>? day,
    Expression<int>? hour,
    Expression<int>? minute,
    Expression<int>? second,
    Expression<String>? placeName,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? zoneName,
    Expression<String>? country,
    Expression<String>? admin1,
    Expression<String>? timeBasis,
    Expression<double>? utcOffsetHours,
    Expression<double>? dstHours,
    Expression<bool>? warTimeApplied,
    Expression<String>? maritalStatus,
    Expression<String>? occupation,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (gender != null) 'gender': gender,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (day != null) 'day': day,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
      if (second != null) 'second': second,
      if (placeName != null) 'place_name': placeName,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (zoneName != null) 'zone_name': zoneName,
      if (country != null) 'country': country,
      if (admin1 != null) 'admin1': admin1,
      if (timeBasis != null) 'time_basis': timeBasis,
      if (utcOffsetHours != null) 'utc_offset_hours': utcOffsetHours,
      if (dstHours != null) 'dst_hours': dstHours,
      if (warTimeApplied != null) 'war_time_applied': warTimeApplied,
      if (maritalStatus != null) 'marital_status': maritalStatus,
      if (occupation != null) 'occupation': occupation,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ChartsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? gender,
    Value<int>? year,
    Value<int>? month,
    Value<int>? day,
    Value<int>? hour,
    Value<int>? minute,
    Value<int>? second,
    Value<String>? placeName,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<String>? zoneName,
    Value<String>? country,
    Value<String>? admin1,
    Value<String>? timeBasis,
    Value<double>? utcOffsetHours,
    Value<double>? dstHours,
    Value<bool?>? warTimeApplied,
    Value<String?>? maritalStatus,
    Value<String?>? occupation,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ChartsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      second: second ?? this.second,
      placeName: placeName ?? this.placeName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      zoneName: zoneName ?? this.zoneName,
      country: country ?? this.country,
      admin1: admin1 ?? this.admin1,
      timeBasis: timeBasis ?? this.timeBasis,
      utcOffsetHours: utcOffsetHours ?? this.utcOffsetHours,
      dstHours: dstHours ?? this.dstHours,
      warTimeApplied: warTimeApplied ?? this.warTimeApplied,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      occupation: occupation ?? this.occupation,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    if (second.present) {
      map['second'] = Variable<int>(second.value);
    }
    if (placeName.present) {
      map['place_name'] = Variable<String>(placeName.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (zoneName.present) {
      map['zone_name'] = Variable<String>(zoneName.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (admin1.present) {
      map['admin1'] = Variable<String>(admin1.value);
    }
    if (timeBasis.present) {
      map['time_basis'] = Variable<String>(timeBasis.value);
    }
    if (utcOffsetHours.present) {
      map['utc_offset_hours'] = Variable<double>(utcOffsetHours.value);
    }
    if (dstHours.present) {
      map['dst_hours'] = Variable<double>(dstHours.value);
    }
    if (warTimeApplied.present) {
      map['war_time_applied'] = Variable<bool>(warTimeApplied.value);
    }
    if (maritalStatus.present) {
      map['marital_status'] = Variable<String>(maritalStatus.value);
    }
    if (occupation.present) {
      map['occupation'] = Variable<String>(occupation.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChartsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('day: $day, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('second: $second, ')
          ..write('placeName: $placeName, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('zoneName: $zoneName, ')
          ..write('country: $country, ')
          ..write('admin1: $admin1, ')
          ..write('timeBasis: $timeBasis, ')
          ..write('utcOffsetHours: $utcOffsetHours, ')
          ..write('dstHours: $dstHours, ')
          ..write('warTimeApplied: $warTimeApplied, ')
          ..write('maritalStatus: $maritalStatus, ')
          ..write('occupation: $occupation, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ChartsTable charts = $ChartsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [charts, settings];
}

typedef $$ChartsTableCreateCompanionBuilder = ChartsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> gender,
  required int year,
  required int month,
  required int day,
  required int hour,
  required int minute,
  Value<int> second,
  required String placeName,
  required double latitude,
  required double longitude,
  required String zoneName,
  Value<String> country,
  Value<String> admin1,
  required String timeBasis,
  required double utcOffsetHours,
  Value<double> dstHours,
  Value<bool?> warTimeApplied,
  Value<String?> maritalStatus,
  Value<String?> occupation,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$ChartsTableUpdateCompanionBuilder = ChartsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> gender,
  Value<int> year,
  Value<int> month,
  Value<int> day,
  Value<int> hour,
  Value<int> minute,
  Value<int> second,
  Value<String> placeName,
  Value<double> latitude,
  Value<double> longitude,
  Value<String> zoneName,
  Value<String> country,
  Value<String> admin1,
  Value<String> timeBasis,
  Value<double> utcOffsetHours,
  Value<double> dstHours,
  Value<bool?> warTimeApplied,
  Value<String?> maritalStatus,
  Value<String?> occupation,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$ChartsTableFilterComposer
    extends Composer<_$AppDatabase, $ChartsTable> {
  $$ChartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get second => $composableBuilder(
    column: $table.second,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zoneName => $composableBuilder(
    column: $table.zoneName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get admin1 => $composableBuilder(
    column: $table.admin1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeBasis => $composableBuilder(
    column: $table.timeBasis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get utcOffsetHours => $composableBuilder(
    column: $table.utcOffsetHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dstHours => $composableBuilder(
    column: $table.dstHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get warTimeApplied => $composableBuilder(
    column: $table.warTimeApplied,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get maritalStatus => $composableBuilder(
    column: $table.maritalStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChartsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChartsTable> {
  $$ChartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get second => $composableBuilder(
    column: $table.second,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zoneName => $composableBuilder(
    column: $table.zoneName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get admin1 => $composableBuilder(
    column: $table.admin1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeBasis => $composableBuilder(
    column: $table.timeBasis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get utcOffsetHours => $composableBuilder(
    column: $table.utcOffsetHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dstHours => $composableBuilder(
    column: $table.dstHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get warTimeApplied => $composableBuilder(
    column: $table.warTimeApplied,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get maritalStatus => $composableBuilder(
    column: $table.maritalStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChartsTable> {
  $$ChartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  GeneratedColumn<int> get second =>
      $composableBuilder(column: $table.second, builder: (column) => column);

  GeneratedColumn<String> get placeName =>
      $composableBuilder(column: $table.placeName, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get zoneName =>
      $composableBuilder(column: $table.zoneName, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get admin1 =>
      $composableBuilder(column: $table.admin1, builder: (column) => column);

  GeneratedColumn<String> get timeBasis =>
      $composableBuilder(column: $table.timeBasis, builder: (column) => column);

  GeneratedColumn<double> get utcOffsetHours => $composableBuilder(
    column: $table.utcOffsetHours,
    builder: (column) => column,
  );

  GeneratedColumn<double> get dstHours =>
      $composableBuilder(column: $table.dstHours, builder: (column) => column);

  GeneratedColumn<bool> get warTimeApplied => $composableBuilder(
    column: $table.warTimeApplied,
    builder: (column) => column,
  );

  GeneratedColumn<String> get maritalStatus => $composableBuilder(
    column: $table.maritalStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ChartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChartsTable,
          Chart,
          $$ChartsTableFilterComposer,
          $$ChartsTableOrderingComposer,
          $$ChartsTableAnnotationComposer,
          $$ChartsTableCreateCompanionBuilder,
          $$ChartsTableUpdateCompanionBuilder,
          (Chart, BaseReferences<_$AppDatabase, $ChartsTable, Chart>),
          Chart,
          PrefetchHooks Function()
        > {
  $$ChartsTableTableManager(_$AppDatabase db, $ChartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int> day = const Value.absent(),
                Value<int> hour = const Value.absent(),
                Value<int> minute = const Value.absent(),
                Value<int> second = const Value.absent(),
                Value<String> placeName = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<String> zoneName = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<String> admin1 = const Value.absent(),
                Value<String> timeBasis = const Value.absent(),
                Value<double> utcOffsetHours = const Value.absent(),
                Value<double> dstHours = const Value.absent(),
                Value<bool?> warTimeApplied = const Value.absent(),
                Value<String?> maritalStatus = const Value.absent(),
                Value<String?> occupation = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ChartsCompanion(
                id: id,
                name: name,
                gender: gender,
                year: year,
                month: month,
                day: day,
                hour: hour,
                minute: minute,
                second: second,
                placeName: placeName,
                latitude: latitude,
                longitude: longitude,
                zoneName: zoneName,
                country: country,
                admin1: admin1,
                timeBasis: timeBasis,
                utcOffsetHours: utcOffsetHours,
                dstHours: dstHours,
                warTimeApplied: warTimeApplied,
                maritalStatus: maritalStatus,
                occupation: occupation,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> gender = const Value.absent(),
                required int year,
                required int month,
                required int day,
                required int hour,
                required int minute,
                Value<int> second = const Value.absent(),
                required String placeName,
                required double latitude,
                required double longitude,
                required String zoneName,
                Value<String> country = const Value.absent(),
                Value<String> admin1 = const Value.absent(),
                required String timeBasis,
                required double utcOffsetHours,
                Value<double> dstHours = const Value.absent(),
                Value<bool?> warTimeApplied = const Value.absent(),
                Value<String?> maritalStatus = const Value.absent(),
                Value<String?> occupation = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ChartsCompanion.insert(
                id: id,
                name: name,
                gender: gender,
                year: year,
                month: month,
                day: day,
                hour: hour,
                minute: minute,
                second: second,
                placeName: placeName,
                latitude: latitude,
                longitude: longitude,
                zoneName: zoneName,
                country: country,
                admin1: admin1,
                timeBasis: timeBasis,
                utcOffsetHours: utcOffsetHours,
                dstHours: dstHours,
                warTimeApplied: warTimeApplied,
                maritalStatus: maritalStatus,
                occupation: occupation,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChartsTable, Chart>(table),
                  BaseReferences<_$AppDatabase, $ChartsTable, Chart>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChartsTable,
      Chart,
      $$ChartsTableFilterComposer,
      $$ChartsTableOrderingComposer,
      $$ChartsTableAnnotationComposer,
      $$ChartsTableCreateCompanionBuilder,
      $$ChartsTableUpdateCompanionBuilder,
      (Chart, BaseReferences<_$AppDatabase, $ChartsTable, Chart>),
      Chart,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ChartsTableTableManager get charts =>
      $$ChartsTableTableManager(_db, _db.charts);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
