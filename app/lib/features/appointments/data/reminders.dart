import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../l10n/l10n.dart';
import '../domain/appointment.dart';

/// Reminder times for an appointment: [before] its start, and 10:00 on its
/// follow-up day. Only times after [now] are returned.
List<(int id, DateTime at, bool followUp)> reminderTimes(
  Appointment a,
  DateTime now, {
  Duration before = const Duration(minutes: 30),
}) {
  if (a.id == null || !a.remind) return const [];
  final out = <(int, DateTime, bool)>[];
  final start = a.startsAt.subtract(before);
  if (a.status == AppointmentStatus.scheduled && start.isAfter(now)) {
    out.add((a.id! * 2, start, false));
  }
  final f = a.followUpOn;
  if (f != null) {
    final at = DateTime(f.year, f.month, f.day, 10);
    if (at.isAfter(now)) out.add((a.id! * 2 + 1, at, true));
  }
  return out;
}

/// Schedules appointment and follow-up reminders as Android notifications.
///
/// Exact alarms (USE_EXACT_ALARM) so a "30 minutes before" reminder isn't
/// late; if the phone refuses them, inexact ones (up to an hour late). The
/// notification permission is asked the first time a reminder is set.
class Reminders {
  Reminders({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;
  bool _asked = false;

  static const _channel = 'appointments';

  Future<AndroidFlutterLocalNotificationsPlugin?> _android() async {
    if (!_ready) {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
      );
      _ready = true;
    }
    return _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
  }

  /// Replaces the reminders of [a] (call after every save).
  Future<void> schedule(Appointment a, AppLocalizations l10n) async {
    try {
      final android = await _android();
      if (a.id == null) return;
      await cancel(a.id!);
      final times = reminderTimes(a, DateTime.now());
      if (times.isEmpty) return;
      if (!_asked) {
        _asked = true;
        await android?.requestNotificationsPermission();
      }
      final exact = await android?.canScheduleExactNotifications() ?? false;
      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channel,
          l10n.remindersChannel,
          importance: Importance.high,
          priority: Priority.high,
        ),
      );
      String two(int n) => n.toString().padLeft(2, '0');
      for (final (id, at, followUp) in times) {
        await _plugin.zonedSchedule(
          id: id,
          scheduledDate: tz.TZDateTime.from(at, tz.UTC),
          notificationDetails: details,
          androidScheduleMode: exact
              ? AndroidScheduleMode.exactAllowWhileIdle
              : AndroidScheduleMode.inexactAllowWhileIdle,
          title: followUp
              ? l10n.followUpReminder(a.who)
              : l10n.appointmentReminder(a.who),
          body: followUp
              ? (a.notes.isEmpty ? null : a.notes)
              : '${two(a.startsAt.hour)}:${two(a.startsAt.minute)}'
                    '${a.title.isNotEmpty && a.clientName != null ? ' · ${a.title}' : ''}',
        );
      }
    } on Object {
      // Reminders are a convenience: never let them break saving.
    }
  }

  Future<void> cancel(int appointmentId) async {
    try {
      await _android();
      await _plugin.cancel(id: appointmentId * 2);
      await _plugin.cancel(id: appointmentId * 2 + 1);
    } on Object {
      // Nothing scheduled, or no plugin (tests).
    }
  }
}
