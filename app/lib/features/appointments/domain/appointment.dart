import 'package:equatable/equatable.dart';

enum AppointmentStatus { scheduled, done, cancelled, missed }

/// A consultation: booked ahead, then filled in with notes, fee and a
/// follow-up date once held.
class Appointment extends Equatable {
  const Appointment({
    this.id,
    this.clientId,
    this.clientName,
    this.title = '',
    required this.startsAt,
    this.minutes = 30,
    this.status = AppointmentStatus.scheduled,
    this.notes = '',
    this.fee,
    this.paid = false,
    this.followUpOn,
    this.remind = true,
  });

  final int? id;
  final int? clientId;

  /// Read with the row (not stored here).
  final String? clientName;

  /// Name of a walk-in without a client record, or the topic.
  final String title;
  final DateTime startsAt;
  final int minutes;
  final AppointmentStatus status;
  final String notes;
  final double? fee;
  final bool paid;
  final DateTime? followUpOn;
  final bool remind;

  DateTime get endsAt => startsAt.add(Duration(minutes: minutes));

  /// What to show as "who": the client, else the title.
  String get who => clientName ?? title;

  bool get unpaid => (fee ?? 0) > 0 && !paid;

  Appointment copyWith({
    int? id,
    AppointmentStatus? status,
    bool? paid,
  }) => Appointment(
    id: id ?? this.id,
    clientId: clientId,
    clientName: clientName,
    title: title,
    startsAt: startsAt,
    minutes: minutes,
    status: status ?? this.status,
    notes: notes,
    fee: fee,
    paid: paid ?? this.paid,
    followUpOn: followUpOn,
    remind: remind,
  );

  @override
  List<Object?> get props => [
    id,
    clientId,
    clientName,
    title,
    startsAt,
    minutes,
    status,
    notes,
    fee,
    paid,
    followUpOn,
    remind,
  ];
}
