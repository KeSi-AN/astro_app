// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClientsTable extends Clients with TableInfo<$ClientsTable, ClientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
    phone,
    city,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClientRow> instance, {
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
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
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
  ClientRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClientRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
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
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }
}

class ClientRow extends DataClass implements Insertable<ClientRow> {
  final int id;
  final String name;
  final String phone;
  final String city;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ClientRow({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['city'] = Variable<String>(city);
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      city: Value(city),
      notes: Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ClientRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClientRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      city: serializer.fromJson<String>(json['city']),
      notes: serializer.fromJson<String>(json['notes']),
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
      'phone': serializer.toJson<String>(phone),
      'city': serializer.toJson<String>(city),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ClientRow copyWith({
    int? id,
    String? name,
    String? phone,
    String? city,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ClientRow(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    city: city ?? this.city,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ClientRow copyWithCompanion(ClientsCompanion data) {
    return ClientRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      city: data.city.present ? data.city.value : this.city,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClientRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('city: $city, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, phone, city, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClientRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.city == this.city &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ClientsCompanion extends UpdateCompanion<ClientRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> city;
  final Value<String> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.city = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ClientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.city = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ClientRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? city,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (city != null) 'city': city,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ClientsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? phone,
    Value<String>? city,
    Value<String>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ClientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      city: city ?? this.city,
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
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
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
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('city: $city, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

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
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
    'client_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clients (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _relationMeta = const VerificationMeta(
    'relation',
  );
  @override
  late final GeneratedColumn<String> relation = GeneratedColumn<String>(
    'relation',
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
    clientId,
    relation,
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
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    }
    if (data.containsKey('relation')) {
      context.handle(
        _relationMeta,
        relation.isAcceptableOrUnknown(data['relation']!, _relationMeta),
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
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}client_id'],
      ),
      relation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relation'],
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

  /// The client this chart belongs to (schema 3), and who it is to them:
  /// self | spouse | son | daughter | father | mother | brother | sister | other.
  final int? clientId;
  final String? relation;
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
    this.clientId,
    this.relation,
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
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<int>(clientId);
    }
    if (!nullToAbsent || relation != null) {
      map['relation'] = Variable<String>(relation);
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
      clientId: clientId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientId),
      relation: relation == null && nullToAbsent
          ? const Value.absent()
          : Value(relation),
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
      clientId: serializer.fromJson<int?>(json['clientId']),
      relation: serializer.fromJson<String?>(json['relation']),
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
      'clientId': serializer.toJson<int?>(clientId),
      'relation': serializer.toJson<String?>(relation),
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
    Value<int?> clientId = const Value.absent(),
    Value<String?> relation = const Value.absent(),
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
    clientId: clientId.present ? clientId.value : this.clientId,
    relation: relation.present ? relation.value : this.relation,
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
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      relation: data.relation.present ? data.relation.value : this.relation,
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
          ..write('clientId: $clientId, ')
          ..write('relation: $relation, ')
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
    clientId,
    relation,
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
          other.clientId == this.clientId &&
          other.relation == this.relation &&
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
  final Value<int?> clientId;
  final Value<String?> relation;
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
    this.clientId = const Value.absent(),
    this.relation = const Value.absent(),
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
    this.clientId = const Value.absent(),
    this.relation = const Value.absent(),
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
    Expression<int>? clientId,
    Expression<String>? relation,
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
      if (clientId != null) 'client_id': clientId,
      if (relation != null) 'relation': relation,
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
    Value<int?>? clientId,
    Value<String?>? relation,
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
      clientId: clientId ?? this.clientId,
      relation: relation ?? this.relation,
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
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (relation.present) {
      map['relation'] = Variable<String>(relation.value);
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
          ..write('clientId: $clientId, ')
          ..write('relation: $relation, ')
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

class $AppointmentsTable extends Appointments
    with TableInfo<$AppointmentsTable, AppointmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppointmentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
    'client_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clients (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _startsAtMeta = const VerificationMeta(
    'startsAt',
  );
  @override
  late final GeneratedColumn<DateTime> startsAt = GeneratedColumn<DateTime>(
    'starts_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('scheduled'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _feeMeta = const VerificationMeta('fee');
  @override
  late final GeneratedColumn<double> fee = GeneratedColumn<double>(
    'fee',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paidMeta = const VerificationMeta('paid');
  @override
  late final GeneratedColumn<bool> paid = GeneratedColumn<bool>(
    'paid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("paid" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _followUpOnMeta = const VerificationMeta(
    'followUpOn',
  );
  @override
  late final GeneratedColumn<DateTime> followUpOn = GeneratedColumn<DateTime>(
    'follow_up_on',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remindMeta = const VerificationMeta('remind');
  @override
  late final GeneratedColumn<bool> remind = GeneratedColumn<bool>(
    'remind',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("remind" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    clientId,
    title,
    startsAt,
    minutes,
    status,
    notes,
    fee,
    paid,
    followUpOn,
    remind,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appointments';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppointmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('starts_at')) {
      context.handle(
        _startsAtMeta,
        startsAt.isAcceptableOrUnknown(data['starts_at']!, _startsAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startsAtMeta);
    }
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('fee')) {
      context.handle(
        _feeMeta,
        fee.isAcceptableOrUnknown(data['fee']!, _feeMeta),
      );
    }
    if (data.containsKey('paid')) {
      context.handle(
        _paidMeta,
        paid.isAcceptableOrUnknown(data['paid']!, _paidMeta),
      );
    }
    if (data.containsKey('follow_up_on')) {
      context.handle(
        _followUpOnMeta,
        followUpOn.isAcceptableOrUnknown(
          data['follow_up_on']!,
          _followUpOnMeta,
        ),
      );
    }
    if (data.containsKey('remind')) {
      context.handle(
        _remindMeta,
        remind.isAcceptableOrUnknown(data['remind']!, _remindMeta),
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
  AppointmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppointmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}client_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      startsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}starts_at'],
      )!,
      minutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      fee: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fee'],
      ),
      paid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}paid'],
      )!,
      followUpOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}follow_up_on'],
      ),
      remind: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}remind'],
      )!,
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
  $AppointmentsTable createAlias(String alias) {
    return $AppointmentsTable(attachedDatabase, alias);
  }
}

class AppointmentRow extends DataClass implements Insertable<AppointmentRow> {
  final int id;
  final int? clientId;

  /// Who is coming when there is no client record, or the topic.
  final String title;
  final DateTime startsAt;
  final int minutes;

  /// scheduled | done | cancelled | missed
  final String status;

  /// What was discussed and advised.
  final String notes;
  final double? fee;
  final bool paid;

  /// Remind the astrologer to follow up on this day.
  final DateTime? followUpOn;
  final bool remind;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AppointmentRow({
    required this.id,
    this.clientId,
    required this.title,
    required this.startsAt,
    required this.minutes,
    required this.status,
    required this.notes,
    this.fee,
    required this.paid,
    this.followUpOn,
    required this.remind,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<int>(clientId);
    }
    map['title'] = Variable<String>(title);
    map['starts_at'] = Variable<DateTime>(startsAt);
    map['minutes'] = Variable<int>(minutes);
    map['status'] = Variable<String>(status);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || fee != null) {
      map['fee'] = Variable<double>(fee);
    }
    map['paid'] = Variable<bool>(paid);
    if (!nullToAbsent || followUpOn != null) {
      map['follow_up_on'] = Variable<DateTime>(followUpOn);
    }
    map['remind'] = Variable<bool>(remind);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppointmentsCompanion toCompanion(bool nullToAbsent) {
    return AppointmentsCompanion(
      id: Value(id),
      clientId: clientId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientId),
      title: Value(title),
      startsAt: Value(startsAt),
      minutes: Value(minutes),
      status: Value(status),
      notes: Value(notes),
      fee: fee == null && nullToAbsent ? const Value.absent() : Value(fee),
      paid: Value(paid),
      followUpOn: followUpOn == null && nullToAbsent
          ? const Value.absent()
          : Value(followUpOn),
      remind: Value(remind),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppointmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppointmentRow(
      id: serializer.fromJson<int>(json['id']),
      clientId: serializer.fromJson<int?>(json['clientId']),
      title: serializer.fromJson<String>(json['title']),
      startsAt: serializer.fromJson<DateTime>(json['startsAt']),
      minutes: serializer.fromJson<int>(json['minutes']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String>(json['notes']),
      fee: serializer.fromJson<double?>(json['fee']),
      paid: serializer.fromJson<bool>(json['paid']),
      followUpOn: serializer.fromJson<DateTime?>(json['followUpOn']),
      remind: serializer.fromJson<bool>(json['remind']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientId': serializer.toJson<int?>(clientId),
      'title': serializer.toJson<String>(title),
      'startsAt': serializer.toJson<DateTime>(startsAt),
      'minutes': serializer.toJson<int>(minutes),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String>(notes),
      'fee': serializer.toJson<double?>(fee),
      'paid': serializer.toJson<bool>(paid),
      'followUpOn': serializer.toJson<DateTime?>(followUpOn),
      'remind': serializer.toJson<bool>(remind),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppointmentRow copyWith({
    int? id,
    Value<int?> clientId = const Value.absent(),
    String? title,
    DateTime? startsAt,
    int? minutes,
    String? status,
    String? notes,
    Value<double?> fee = const Value.absent(),
    bool? paid,
    Value<DateTime?> followUpOn = const Value.absent(),
    bool? remind,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AppointmentRow(
    id: id ?? this.id,
    clientId: clientId.present ? clientId.value : this.clientId,
    title: title ?? this.title,
    startsAt: startsAt ?? this.startsAt,
    minutes: minutes ?? this.minutes,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    fee: fee.present ? fee.value : this.fee,
    paid: paid ?? this.paid,
    followUpOn: followUpOn.present ? followUpOn.value : this.followUpOn,
    remind: remind ?? this.remind,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppointmentRow copyWithCompanion(AppointmentsCompanion data) {
    return AppointmentRow(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      title: data.title.present ? data.title.value : this.title,
      startsAt: data.startsAt.present ? data.startsAt.value : this.startsAt,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      fee: data.fee.present ? data.fee.value : this.fee,
      paid: data.paid.present ? data.paid.value : this.paid,
      followUpOn: data.followUpOn.present
          ? data.followUpOn.value
          : this.followUpOn,
      remind: data.remind.present ? data.remind.value : this.remind,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentRow(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('title: $title, ')
          ..write('startsAt: $startsAt, ')
          ..write('minutes: $minutes, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('fee: $fee, ')
          ..write('paid: $paid, ')
          ..write('followUpOn: $followUpOn, ')
          ..write('remind: $remind, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientId,
    title,
    startsAt,
    minutes,
    status,
    notes,
    fee,
    paid,
    followUpOn,
    remind,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppointmentRow &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.title == this.title &&
          other.startsAt == this.startsAt &&
          other.minutes == this.minutes &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.fee == this.fee &&
          other.paid == this.paid &&
          other.followUpOn == this.followUpOn &&
          other.remind == this.remind &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AppointmentsCompanion extends UpdateCompanion<AppointmentRow> {
  final Value<int> id;
  final Value<int?> clientId;
  final Value<String> title;
  final Value<DateTime> startsAt;
  final Value<int> minutes;
  final Value<String> status;
  final Value<String> notes;
  final Value<double?> fee;
  final Value<bool> paid;
  final Value<DateTime?> followUpOn;
  final Value<bool> remind;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AppointmentsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.title = const Value.absent(),
    this.startsAt = const Value.absent(),
    this.minutes = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.fee = const Value.absent(),
    this.paid = const Value.absent(),
    this.followUpOn = const Value.absent(),
    this.remind = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppointmentsCompanion.insert({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.title = const Value.absent(),
    required DateTime startsAt,
    this.minutes = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.fee = const Value.absent(),
    this.paid = const Value.absent(),
    this.followUpOn = const Value.absent(),
    this.remind = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : startsAt = Value(startsAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AppointmentRow> custom({
    Expression<int>? id,
    Expression<int>? clientId,
    Expression<String>? title,
    Expression<DateTime>? startsAt,
    Expression<int>? minutes,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<double>? fee,
    Expression<bool>? paid,
    Expression<DateTime>? followUpOn,
    Expression<bool>? remind,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (title != null) 'title': title,
      if (startsAt != null) 'starts_at': startsAt,
      if (minutes != null) 'minutes': minutes,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (fee != null) 'fee': fee,
      if (paid != null) 'paid': paid,
      if (followUpOn != null) 'follow_up_on': followUpOn,
      if (remind != null) 'remind': remind,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppointmentsCompanion copyWith({
    Value<int>? id,
    Value<int?>? clientId,
    Value<String>? title,
    Value<DateTime>? startsAt,
    Value<int>? minutes,
    Value<String>? status,
    Value<String>? notes,
    Value<double?>? fee,
    Value<bool>? paid,
    Value<DateTime?>? followUpOn,
    Value<bool>? remind,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return AppointmentsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      title: title ?? this.title,
      startsAt: startsAt ?? this.startsAt,
      minutes: minutes ?? this.minutes,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      fee: fee ?? this.fee,
      paid: paid ?? this.paid,
      followUpOn: followUpOn ?? this.followUpOn,
      remind: remind ?? this.remind,
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
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startsAt.present) {
      map['starts_at'] = Variable<DateTime>(startsAt.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (fee.present) {
      map['fee'] = Variable<double>(fee.value);
    }
    if (paid.present) {
      map['paid'] = Variable<bool>(paid.value);
    }
    if (followUpOn.present) {
      map['follow_up_on'] = Variable<DateTime>(followUpOn.value);
    }
    if (remind.present) {
      map['remind'] = Variable<bool>(remind.value);
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
    return (StringBuffer('AppointmentsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('title: $title, ')
          ..write('startsAt: $startsAt, ')
          ..write('minutes: $minutes, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('fee: $fee, ')
          ..write('paid: $paid, ')
          ..write('followUpOn: $followUpOn, ')
          ..write('remind: $remind, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ReportLogTable extends ReportLog
    with TableInfo<$ReportLogTable, ReportLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportLogTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _chartIdMeta = const VerificationMeta(
    'chartId',
  );
  @override
  late final GeneratedColumn<int> chartId = GeneratedColumn<int>(
    'chart_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES charts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pagesMeta = const VerificationMeta('pages');
  @override
  late final GeneratedColumn<int> pages = GeneratedColumn<int>(
    'pages',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chartId,
    at,
    kind,
    language,
    pages,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'report_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReportLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chart_id')) {
      context.handle(
        _chartIdMeta,
        chartId.isAcceptableOrUnknown(data['chart_id']!, _chartIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chartIdMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('pages')) {
      context.handle(
        _pagesMeta,
        pages.isAcceptableOrUnknown(data['pages']!, _pagesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReportLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      chartId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chart_id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      pages: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pages'],
      )!,
    );
  }

  @override
  $ReportLogTable createAlias(String alias) {
    return $ReportLogTable(attachedDatabase, alias);
  }
}

class ReportLogRow extends DataClass implements Insertable<ReportLogRow> {
  final int id;
  final int chartId;
  final DateTime at;

  /// share | print
  final String kind;
  final String language;
  final int pages;
  const ReportLogRow({
    required this.id,
    required this.chartId,
    required this.at,
    required this.kind,
    required this.language,
    required this.pages,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chart_id'] = Variable<int>(chartId);
    map['at'] = Variable<DateTime>(at);
    map['kind'] = Variable<String>(kind);
    map['language'] = Variable<String>(language);
    map['pages'] = Variable<int>(pages);
    return map;
  }

  ReportLogCompanion toCompanion(bool nullToAbsent) {
    return ReportLogCompanion(
      id: Value(id),
      chartId: Value(chartId),
      at: Value(at),
      kind: Value(kind),
      language: Value(language),
      pages: Value(pages),
    );
  }

  factory ReportLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportLogRow(
      id: serializer.fromJson<int>(json['id']),
      chartId: serializer.fromJson<int>(json['chartId']),
      at: serializer.fromJson<DateTime>(json['at']),
      kind: serializer.fromJson<String>(json['kind']),
      language: serializer.fromJson<String>(json['language']),
      pages: serializer.fromJson<int>(json['pages']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chartId': serializer.toJson<int>(chartId),
      'at': serializer.toJson<DateTime>(at),
      'kind': serializer.toJson<String>(kind),
      'language': serializer.toJson<String>(language),
      'pages': serializer.toJson<int>(pages),
    };
  }

  ReportLogRow copyWith({
    int? id,
    int? chartId,
    DateTime? at,
    String? kind,
    String? language,
    int? pages,
  }) => ReportLogRow(
    id: id ?? this.id,
    chartId: chartId ?? this.chartId,
    at: at ?? this.at,
    kind: kind ?? this.kind,
    language: language ?? this.language,
    pages: pages ?? this.pages,
  );
  ReportLogRow copyWithCompanion(ReportLogCompanion data) {
    return ReportLogRow(
      id: data.id.present ? data.id.value : this.id,
      chartId: data.chartId.present ? data.chartId.value : this.chartId,
      at: data.at.present ? data.at.value : this.at,
      kind: data.kind.present ? data.kind.value : this.kind,
      language: data.language.present ? data.language.value : this.language,
      pages: data.pages.present ? data.pages.value : this.pages,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportLogRow(')
          ..write('id: $id, ')
          ..write('chartId: $chartId, ')
          ..write('at: $at, ')
          ..write('kind: $kind, ')
          ..write('language: $language, ')
          ..write('pages: $pages')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, chartId, at, kind, language, pages);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportLogRow &&
          other.id == this.id &&
          other.chartId == this.chartId &&
          other.at == this.at &&
          other.kind == this.kind &&
          other.language == this.language &&
          other.pages == this.pages);
}

class ReportLogCompanion extends UpdateCompanion<ReportLogRow> {
  final Value<int> id;
  final Value<int> chartId;
  final Value<DateTime> at;
  final Value<String> kind;
  final Value<String> language;
  final Value<int> pages;
  const ReportLogCompanion({
    this.id = const Value.absent(),
    this.chartId = const Value.absent(),
    this.at = const Value.absent(),
    this.kind = const Value.absent(),
    this.language = const Value.absent(),
    this.pages = const Value.absent(),
  });
  ReportLogCompanion.insert({
    this.id = const Value.absent(),
    required int chartId,
    required DateTime at,
    required String kind,
    required String language,
    this.pages = const Value.absent(),
  }) : chartId = Value(chartId),
       at = Value(at),
       kind = Value(kind),
       language = Value(language);
  static Insertable<ReportLogRow> custom({
    Expression<int>? id,
    Expression<int>? chartId,
    Expression<DateTime>? at,
    Expression<String>? kind,
    Expression<String>? language,
    Expression<int>? pages,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chartId != null) 'chart_id': chartId,
      if (at != null) 'at': at,
      if (kind != null) 'kind': kind,
      if (language != null) 'language': language,
      if (pages != null) 'pages': pages,
    });
  }

  ReportLogCompanion copyWith({
    Value<int>? id,
    Value<int>? chartId,
    Value<DateTime>? at,
    Value<String>? kind,
    Value<String>? language,
    Value<int>? pages,
  }) {
    return ReportLogCompanion(
      id: id ?? this.id,
      chartId: chartId ?? this.chartId,
      at: at ?? this.at,
      kind: kind ?? this.kind,
      language: language ?? this.language,
      pages: pages ?? this.pages,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chartId.present) {
      map['chart_id'] = Variable<int>(chartId.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (pages.present) {
      map['pages'] = Variable<int>(pages.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportLogCompanion(')
          ..write('id: $id, ')
          ..write('chartId: $chartId, ')
          ..write('at: $at, ')
          ..write('kind: $kind, ')
          ..write('language: $language, ')
          ..write('pages: $pages')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientsTable clients = $ClientsTable(this);
  late final $ChartsTable charts = $ChartsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $AppointmentsTable appointments = $AppointmentsTable(this);
  late final $ReportLogTable reportLog = $ReportLogTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clients,
    charts,
    settings,
    appointments,
    reportLog,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'clients',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('charts', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'clients',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('appointments', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'charts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('report_log', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ClientsTableCreateCompanionBuilder = ClientsCompanion Function({
  Value<int> id,
  required String name,
  Value<String> phone,
  Value<String> city,
  Value<String> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$ClientsTableUpdateCompanionBuilder = ClientsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> phone,
  Value<String> city,
  Value<String> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ClientsTableReferences
    extends BaseReferences<_$AppDatabase, $ClientsTable, ClientRow> {
  $$ClientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChartsTable, List<Chart>> _chartsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.charts,
    aliasName: 'clients__id__charts__client_id',
  );

  $$ChartsTableProcessedTableManager get chartsRefs {
    final manager = $$ChartsTableTableManager(
      $_db,
      $_db.charts,
    ).filter((f) => f.clientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chartsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AppointmentsTable, List<AppointmentRow>>
  _appointmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.appointments,
    aliasName: 'clients__id__appointments__client_id',
  );

  $$AppointmentsTableProcessedTableManager get appointmentsRefs {
    final manager = $$AppointmentsTableTableManager(
      $_db,
      $_db.appointments,
    ).filter((f) => f.clientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_appointmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
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

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
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

  Expression<bool> chartsRefs(
    Expression<bool> Function($$ChartsTableFilterComposer f) f,
  ) {
    final $$ChartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.charts,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartsTableFilterComposer(
            $db: $db,
            $table: $db.charts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> appointmentsRefs(
    Expression<bool> Function($$AppointmentsTableFilterComposer f) f,
  ) {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
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

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
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

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
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

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> chartsRefs<T extends Object>(
    Expression<T> Function($$ChartsTableAnnotationComposer a) f,
  ) {
    final $$ChartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.charts,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartsTableAnnotationComposer(
            $db: $db,
            $table: $db.charts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> appointmentsRefs<T extends Object>(
    Expression<T> Function($$AppointmentsTableAnnotationComposer a) f,
  ) {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientsTable,
          ClientRow,
          $$ClientsTableFilterComposer,
          $$ClientsTableOrderingComposer,
          $$ClientsTableAnnotationComposer,
          $$ClientsTableCreateCompanionBuilder,
          $$ClientsTableUpdateCompanionBuilder,
          (ClientRow, $$ClientsTableReferences),
          ClientRow,
          PrefetchHooks Function({bool chartsRefs, bool appointmentsRefs})
        > {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ClientsCompanion(
                id: id,
                name: name,
                phone: phone,
                city: city,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> phone = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ClientsCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                city: city,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ClientsTable, ClientRow>(table),
                  $$ClientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({chartsRefs = false, appointmentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (chartsRefs) db.charts,
                    if (appointmentsRefs) db.appointments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (chartsRefs)
                        await $_getPrefetchedDataByColumns<
                          ClientRow,
                          $ClientsTable,
                          Chart,
                          $ChartsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ClientsTableReferences
                              ._chartsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientsTableReferences(
                                db,
                                table,
                                p0,
                              ).chartsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'client_id',
                          typedResults: items,
                        ),
                      if (appointmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          ClientRow,
                          $ClientsTable,
                          AppointmentRow,
                          $AppointmentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ClientsTableReferences
                              ._appointmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientsTableReferences(
                                db,
                                table,
                                p0,
                              ).appointmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'client_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ClientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientsTable,
      ClientRow,
      $$ClientsTableFilterComposer,
      $$ClientsTableOrderingComposer,
      $$ClientsTableAnnotationComposer,
      $$ClientsTableCreateCompanionBuilder,
      $$ClientsTableUpdateCompanionBuilder,
      (ClientRow, $$ClientsTableReferences),
      ClientRow,
      PrefetchHooks Function({bool chartsRefs, bool appointmentsRefs})
    >;
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
  Value<int?> clientId,
  Value<String?> relation,
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
  Value<int?> clientId,
  Value<String?> relation,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ChartsTableReferences
    extends BaseReferences<_$AppDatabase, $ChartsTable, Chart> {
  $$ChartsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _clientIdTable(_$AppDatabase db) =>
      db.clients.createAlias('charts__client_id__clients__id');

  $$ClientsTableProcessedTableManager? get clientId {
    final $_column = $_itemColumn<int>('client_id');
    if ($_column == null) return null;
    final manager = $$ClientsTableTableManager(
      $_db,
      $_db.clients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReportLogTable, List<ReportLogRow>>
  _reportLogRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reportLog,
    aliasName: 'charts__id__report_log__chart_id',
  );

  $$ReportLogTableProcessedTableManager get reportLogRefs {
    final manager = $$ReportLogTableTableManager(
      $_db,
      $_db.reportLog,
    ).filter((f) => f.chartId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_reportLogRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<String> get relation => $composableBuilder(
    column: $table.relation,
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

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableFilterComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> reportLogRefs(
    Expression<bool> Function($$ReportLogTableFilterComposer f) f,
  ) {
    final $$ReportLogTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reportLog,
      getReferencedColumn: (t) => t.chartId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportLogTableFilterComposer(
            $db: $db,
            $table: $db.reportLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<String> get relation => $composableBuilder(
    column: $table.relation,
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

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableOrderingComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  GeneratedColumn<String> get relation =>
      $composableBuilder(column: $table.relation, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableAnnotationComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> reportLogRefs<T extends Object>(
    Expression<T> Function($$ReportLogTableAnnotationComposer a) f,
  ) {
    final $$ReportLogTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reportLog,
      getReferencedColumn: (t) => t.chartId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportLogTableAnnotationComposer(
            $db: $db,
            $table: $db.reportLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (Chart, $$ChartsTableReferences),
          Chart,
          PrefetchHooks Function({bool clientId, bool reportLogRefs})
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
                Value<int?> clientId = const Value.absent(),
                Value<String?> relation = const Value.absent(),
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
                clientId: clientId,
                relation: relation,
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
                Value<int?> clientId = const Value.absent(),
                Value<String?> relation = const Value.absent(),
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
                clientId: clientId,
                relation: relation,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChartsTable, Chart>(table),
                  $$ChartsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientId = false, reportLogRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (reportLogRefs) db.reportLog],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clientId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.clientId,
                        referencedTable: $$ChartsTableReferences._clientIdTable(
                          db,
                        ),
                        referencedColumn: $$ChartsTableReferences
                            ._clientIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reportLogRefs)
                    await $_getPrefetchedDataByColumns<
                      Chart,
                      $ChartsTable,
                      ReportLogRow,
                      $ReportLogTable
                    >(
                      currentTable: table,
                      referencedTable: $$ChartsTableReferences
                          ._reportLogRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ChartsTableReferences(db, table, p0).reportLogRefs,
                      currentColumn: 'id',
                      referencedColumn: 'chart_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (Chart, $$ChartsTableReferences),
      Chart,
      PrefetchHooks Function({bool clientId, bool reportLogRefs})
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
typedef $$AppointmentsTableCreateCompanionBuilder =
    AppointmentsCompanion Function({
      Value<int> id,
      Value<int?> clientId,
      Value<String> title,
      required DateTime startsAt,
      Value<int> minutes,
      Value<String> status,
      Value<String> notes,
      Value<double?> fee,
      Value<bool> paid,
      Value<DateTime?> followUpOn,
      Value<bool> remind,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$AppointmentsTableUpdateCompanionBuilder =
    AppointmentsCompanion Function({
      Value<int> id,
      Value<int?> clientId,
      Value<String> title,
      Value<DateTime> startsAt,
      Value<int> minutes,
      Value<String> status,
      Value<String> notes,
      Value<double?> fee,
      Value<bool> paid,
      Value<DateTime?> followUpOn,
      Value<bool> remind,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$AppointmentsTableReferences
    extends BaseReferences<_$AppDatabase, $AppointmentsTable, AppointmentRow> {
  $$AppointmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _clientIdTable(_$AppDatabase db) =>
      db.clients.createAlias('appointments__client_id__clients__id');

  $$ClientsTableProcessedTableManager? get clientId {
    final $_column = $_itemColumn<int>('client_id');
    if ($_column == null) return null;
    final manager = $$ClientsTableTableManager(
      $_db,
      $_db.clients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AppointmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fee => $composableBuilder(
    column: $table.fee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get followUpOn => $composableBuilder(
    column: $table.followUpOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get remind => $composableBuilder(
    column: $table.remind,
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

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableFilterComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fee => $composableBuilder(
    column: $table.fee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get followUpOn => $composableBuilder(
    column: $table.followUpOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get remind => $composableBuilder(
    column: $table.remind,
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

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableOrderingComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get startsAt =>
      $composableBuilder(column: $table.startsAt, builder: (column) => column);

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get fee =>
      $composableBuilder(column: $table.fee, builder: (column) => column);

  GeneratedColumn<bool> get paid =>
      $composableBuilder(column: $table.paid, builder: (column) => column);

  GeneratedColumn<DateTime> get followUpOn => $composableBuilder(
    column: $table.followUpOn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get remind =>
      $composableBuilder(column: $table.remind, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableAnnotationComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppointmentsTable,
          AppointmentRow,
          $$AppointmentsTableFilterComposer,
          $$AppointmentsTableOrderingComposer,
          $$AppointmentsTableAnnotationComposer,
          $$AppointmentsTableCreateCompanionBuilder,
          $$AppointmentsTableUpdateCompanionBuilder,
          (AppointmentRow, $$AppointmentsTableReferences),
          AppointmentRow,
          PrefetchHooks Function({bool clientId})
        > {
  $$AppointmentsTableTableManager(_$AppDatabase db, $AppointmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppointmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppointmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppointmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> clientId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> startsAt = const Value.absent(),
                Value<int> minutes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<double?> fee = const Value.absent(),
                Value<bool> paid = const Value.absent(),
                Value<DateTime?> followUpOn = const Value.absent(),
                Value<bool> remind = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AppointmentsCompanion(
                id: id,
                clientId: clientId,
                title: title,
                startsAt: startsAt,
                minutes: minutes,
                status: status,
                notes: notes,
                fee: fee,
                paid: paid,
                followUpOn: followUpOn,
                remind: remind,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> clientId = const Value.absent(),
                Value<String> title = const Value.absent(),
                required DateTime startsAt,
                Value<int> minutes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<double?> fee = const Value.absent(),
                Value<bool> paid = const Value.absent(),
                Value<DateTime?> followUpOn = const Value.absent(),
                Value<bool> remind = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => AppointmentsCompanion.insert(
                id: id,
                clientId: clientId,
                title: title,
                startsAt: startsAt,
                minutes: minutes,
                status: status,
                notes: notes,
                fee: fee,
                paid: paid,
                followUpOn: followUpOn,
                remind: remind,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppointmentsTable, AppointmentRow>(table),
                  $$AppointmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clientId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.clientId,
                        referencedTable: $$AppointmentsTableReferences
                            ._clientIdTable(db),
                        referencedColumn: $$AppointmentsTableReferences
                            ._clientIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AppointmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppointmentsTable,
      AppointmentRow,
      $$AppointmentsTableFilterComposer,
      $$AppointmentsTableOrderingComposer,
      $$AppointmentsTableAnnotationComposer,
      $$AppointmentsTableCreateCompanionBuilder,
      $$AppointmentsTableUpdateCompanionBuilder,
      (AppointmentRow, $$AppointmentsTableReferences),
      AppointmentRow,
      PrefetchHooks Function({bool clientId})
    >;
typedef $$ReportLogTableCreateCompanionBuilder = ReportLogCompanion Function({
  Value<int> id,
  required int chartId,
  required DateTime at,
  required String kind,
  required String language,
  Value<int> pages,
});
typedef $$ReportLogTableUpdateCompanionBuilder = ReportLogCompanion Function({
  Value<int> id,
  Value<int> chartId,
  Value<DateTime> at,
  Value<String> kind,
  Value<String> language,
  Value<int> pages,
});

final class $$ReportLogTableReferences
    extends BaseReferences<_$AppDatabase, $ReportLogTable, ReportLogRow> {
  $$ReportLogTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChartsTable _chartIdTable(_$AppDatabase db) =>
      db.charts.createAlias('report_log__chart_id__charts__id');

  $$ChartsTableProcessedTableManager get chartId {
    final $_column = $_itemColumn<int>('chart_id')!;

    final manager = $$ChartsTableTableManager(
      $_db,
      $_db.charts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chartIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReportLogTableFilterComposer
    extends Composer<_$AppDatabase, $ReportLogTable> {
  $$ReportLogTableFilterComposer({
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

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pages => $composableBuilder(
    column: $table.pages,
    builder: (column) => ColumnFilters(column),
  );

  $$ChartsTableFilterComposer get chartId {
    final $$ChartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chartId,
      referencedTable: $db.charts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartsTableFilterComposer(
            $db: $db,
            $table: $db.charts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportLogTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportLogTable> {
  $$ReportLogTableOrderingComposer({
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

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pages => $composableBuilder(
    column: $table.pages,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChartsTableOrderingComposer get chartId {
    final $$ChartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chartId,
      referencedTable: $db.charts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartsTableOrderingComposer(
            $db: $db,
            $table: $db.charts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportLogTable> {
  $$ReportLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<int> get pages =>
      $composableBuilder(column: $table.pages, builder: (column) => column);

  $$ChartsTableAnnotationComposer get chartId {
    final $$ChartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chartId,
      referencedTable: $db.charts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartsTableAnnotationComposer(
            $db: $db,
            $table: $db.charts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReportLogTable,
          ReportLogRow,
          $$ReportLogTableFilterComposer,
          $$ReportLogTableOrderingComposer,
          $$ReportLogTableAnnotationComposer,
          $$ReportLogTableCreateCompanionBuilder,
          $$ReportLogTableUpdateCompanionBuilder,
          (ReportLogRow, $$ReportLogTableReferences),
          ReportLogRow,
          PrefetchHooks Function({bool chartId})
        > {
  $$ReportLogTableTableManager(_$AppDatabase db, $ReportLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> chartId = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<int> pages = const Value.absent(),
              }) => ReportLogCompanion(
                id: id,
                chartId: chartId,
                at: at,
                kind: kind,
                language: language,
                pages: pages,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int chartId,
                required DateTime at,
                required String kind,
                required String language,
                Value<int> pages = const Value.absent(),
              }) => ReportLogCompanion.insert(
                id: id,
                chartId: chartId,
                at: at,
                kind: kind,
                language: language,
                pages: pages,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReportLogTable, ReportLogRow>(table),
                  $$ReportLogTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chartId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (chartId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.chartId,
                        referencedTable: $$ReportLogTableReferences
                            ._chartIdTable(db),
                        referencedColumn: $$ReportLogTableReferences
                            ._chartIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReportLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReportLogTable,
      ReportLogRow,
      $$ReportLogTableFilterComposer,
      $$ReportLogTableOrderingComposer,
      $$ReportLogTableAnnotationComposer,
      $$ReportLogTableCreateCompanionBuilder,
      $$ReportLogTableUpdateCompanionBuilder,
      (ReportLogRow, $$ReportLogTableReferences),
      ReportLogRow,
      PrefetchHooks Function({bool chartId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$ChartsTableTableManager get charts =>
      $$ChartsTableTableManager(_db, _db.charts);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$AppointmentsTableTableManager get appointments =>
      $$AppointmentsTableTableManager(_db, _db.appointments);
  $$ReportLogTableTableManager get reportLog =>
      $$ReportLogTableTableManager(_db, _db.reportLog);
}
