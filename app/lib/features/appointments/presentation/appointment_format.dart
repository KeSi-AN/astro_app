import 'package:material_ui/material_ui.dart';

import '../../../core/format/formatters.dart';
import '../../../l10n/l10n.dart';
import '../domain/appointment.dart';

/// "₹500" or "₹1,250.50".
String formatMoney(double v) {
  final whole = v == v.roundToDouble();
  final s = whole ? v.round().toString() : v.toStringAsFixed(2);
  final parts = s.split('.');
  final digits = parts[0];
  // Indian grouping: 12,34,567
  final buf = StringBuffer();
  final n = digits.length;
  for (var i = 0; i < n; i++) {
    buf.write(digits[i]);
    final left = n - i - 1;
    if (left > 0 && (left == 3 || (left > 3 && (left - 3) % 2 == 0))) {
      buf.write(',');
    }
  }
  return '₹$buf${parts.length > 1 ? '.${parts[1]}' : ''}';
}

String formatClock(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

String formatDay(BuildContext context, DateTime d) =>
    formatDate(d.year, d.month, d.day, month: context.terms.month);

String statusLabel(AppLocalizations l10n, AppointmentStatus s) => switch (s) {
  AppointmentStatus.scheduled => l10n.statusScheduled,
  AppointmentStatus.done => l10n.statusDone,
  AppointmentStatus.cancelled => l10n.statusCancelled,
  AppointmentStatus.missed => l10n.statusMissed,
};

Color statusColor(ThemeData t, AppointmentStatus s) => switch (s) {
  AppointmentStatus.scheduled => t.colorScheme.primary,
  AppointmentStatus.done => const Color(0xFF81C784),
  AppointmentStatus.cancelled => t.colorScheme.outline,
  AppointmentStatus.missed => const Color(0xFFE57373),
};
