import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../app/services.dart';
import '../../../l10n/l10n.dart';
import '../domain/appointment.dart';
import 'appointment_format.dart';

enum _Quick { done, paid, cancel, missed }

/// One consultation in a list: time (or date), who, status, fee and the
/// start of the notes. The menu marks it done, paid, cancelled or missed.
class AppointmentTile extends StatelessWidget {
  const AppointmentTile({
    super.key,
    required this.appointment,
    this.showDate = false,
    this.showWho = true,
    this.followUp = false,
  });

  final Appointment appointment;
  final bool showDate;
  final bool showWho;

  /// Shown in a follow-ups list: the date is the follow-up day.
  final bool followUp;

  Future<void> _quick(BuildContext context, _Quick q) async {
    final s = context.read<AppServices>();
    final a = appointment;
    final next = switch (q) {
      _Quick.done => a.copyWith(status: AppointmentStatus.done),
      _Quick.paid => a.copyWith(paid: true),
      _Quick.cancel => a.copyWith(status: AppointmentStatus.cancelled),
      _Quick.missed => a.copyWith(status: AppointmentStatus.missed),
    };
    await s.appointments.save(next);
    if (context.mounted) await s.reminders.schedule(next, context.l10n);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final a = appointment;
    final when = followUp
        ? formatDay(context, a.followUpOn!)
        : showDate
        ? '${formatDay(context, a.startsAt)} · ${formatClock(a.startsAt)}'
        : formatClock(a.startsAt);
    final fee = a.fee;
    final lines = <String>[
      [
        when,
        if (!showWho && a.title.isNotEmpty) a.title,
        if (showWho && a.clientName != null && a.title.isNotEmpty) a.title,
      ].join(' · '),
      if (a.notes.isNotEmpty) a.notes.replaceAll('\n', ' '),
    ];
    return ListTile(
      onTap: () => context.push(Routes.appointment(a.id!)),
      leading: CircleAvatar(
        backgroundColor: statusColor(theme, a.status).withValues(alpha: 0.2),
        child: Icon(
          followUp ? Icons.replay : Icons.event,
          color: statusColor(theme, a.status),
        ),
      ),
      title: Text(
        showWho ? (a.who.isEmpty ? '—' : a.who) : statusLabel(l10n, a.status),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(lines.join('\n'), maxLines: 2, overflow: TextOverflow.ellipsis),
      isThreeLine: a.notes.isNotEmpty,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (showWho)
                Text(
                  statusLabel(l10n, a.status),
                  style: TextStyle(color: statusColor(theme, a.status), fontSize: 12),
                ),
              if (fee != null && fee > 0)
                Text(
                  '${formatMoney(fee)}${a.paid ? ' ✓' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: a.paid ? const Color(0xFF81C784) : const Color(0xFFE57373),
                  ),
                ),
            ],
          ),
          PopupMenuButton<_Quick>(
            onSelected: (q) => _quick(context, q),
            itemBuilder: (_) => [
              if (a.status != AppointmentStatus.done)
                PopupMenuItem(value: _Quick.done, child: Text(l10n.markDone)),
              if (a.unpaid)
                PopupMenuItem(value: _Quick.paid, child: Text(l10n.markPaid)),
              if (a.status == AppointmentStatus.scheduled) ...[
                PopupMenuItem(value: _Quick.missed, child: Text(l10n.markMissed)),
                PopupMenuItem(value: _Quick.cancel, child: Text(l10n.markCancelled)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
