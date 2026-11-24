import 'package:birth_input/birth_input.dart';
import 'package:equatable/equatable.dart';
import 'package:jyotish_core/jyotish_core.dart';

import '../../atlas/domain/place.dart';

/// A saved (or about-to-be-saved) birth chart.
class ChartEntry extends Equatable {
  const ChartEntry({
    this.id,
    required this.name,
    this.gender,
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    this.second = 0,
    required this.place,
    required this.timeBasis,
    required this.utcOffsetHours,
    this.dstHours = 0,
    this.warTimeApplied,
    this.maritalStatus,
    this.occupation,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String name;
  final String? gender;
  final int year, month, day, hour, minute, second;
  final Place place;
  final TimeBasis timeBasis;
  final double utcOffsetHours;
  final double dstHours;
  final bool? warTimeApplied;
  final String? maritalStatus;
  final String? occupation;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BirthData toBirthData() => BirthData(
        year: year, month: month, day: day,
        hour: hour, minute: minute, second: second,
        latitude: place.latitude, longitude: place.longitude,
        utcOffsetHours: utcOffsetHours, dstHours: dstHours,
        placeName: place.name,
      );

  ChartEntry copyWith({int? id, String? name, DateTime? updatedAt}) =>
      ChartEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        gender: gender,
        year: year, month: month, day: day,
        hour: hour, minute: minute, second: second,
        place: place,
        timeBasis: timeBasis,
        utcOffsetHours: utcOffsetHours,
        dstHours: dstHours,
        warTimeApplied: warTimeApplied,
        maritalStatus: maritalStatus,
        occupation: occupation,
        notes: notes,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  List<Object?> get props => [
        id, name, gender, year, month, day, hour, minute, second, place,
        timeBasis, utcOffsetHours, dstHours, warTimeApplied, maritalStatus,
        occupation, notes,
      ];
}

const maritalStatuses = ['Single', 'Married', 'Divorced', 'Widowed', 'Separated'];
const occupations = [
  'Student', 'Private job', 'Government job', 'Business', 'Self-employed',
  'Professional (doctor, lawyer, CA…)', 'Homemaker', 'Retired', 'Unemployed',
  'Other',
];
