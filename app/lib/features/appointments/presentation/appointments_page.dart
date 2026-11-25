import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';

import '../../../app/router.dart';
import '../../../app/services.dart';
import '../../../l10n/l10n.dart';
import '../domain/appointment.dart';
import 'appointment_format.dart';
import 'appointment_tile.dart';

enum _View { today, upcoming, past, unpaid }

/// Today's appointments and follow-ups, what's coming, what's past and
/// what's unpaid.
class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  _View _view = _View.today;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final repo = context.read<AppServices>().appointments;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    Widget list(Stream<List<Appointment>> s, {bool dates = true, String? empty}) =>
        StreamBuilder<List<Appointment>>(
          stream: s,
          builder: (context, snap) {
            final items = snap.data;
            if (items == null) return const Center(child: CircularProgressIndicator());
            if (items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(empty ?? l10n.noAppointments, textAlign: TextAlign.center),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.only(bottom: 96),
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, i) => AppointmentTile(appointment: items[i], showDate: dates),
            );
          },
        );

    final body = switch (_view) {
      _View.today => _Today(
        today: repo.watchBetween(today, tomorrow),
        followUps: repo.watchFollowUps(today, today.add(const Duration(days: 8))),
      ),
      _View.upcoming => list(
        repo.watchBetween(tomorrow, today.add(const Duration(days: 120))),
      ),
      _View.past => list(repo.watchBefore(today)),
      _View.unpaid => _Unpaid(stream: repo.watchUnpaid()),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appointments),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: SegmentedButton<_View>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: _View.today, label: Text(l10n.viewToday)),
                ButtonSegment(value: _View.upcoming, label: Text(l10n.viewUpcoming)),
                ButtonSegment(value: _View.past, label: Text(l10n.viewPast)),
                ButtonSegment(value: _View.unpaid, label: Text(l10n.viewUnpaid)),
              ],
              selected: {_view},
              onSelectionChanged: (v) => setState(() => _view = v.first),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'newAppointment',
        onPressed: () => context.push(Routes.newAppointment()),
        icon: const Icon(Icons.add),
        label: Text(l10n.newAppointment),
      ),
      body: body,
    );
  }
}

class _Today extends StatelessWidget {
  const _Today({required this.today, required this.followUps});
  final Stream<List<Appointment>> today;
  final Stream<List<Appointment>> followUps;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final heading = Theme.of(context).textTheme.titleSmall?.copyWith(
      color: Theme.of(context).colorScheme.primary,
    );
    return StreamBuilder<List<Appointment>>(
      stream: today,
      builder: (context, a) => StreamBuilder<List<Appointment>>(
        stream: followUps,
        builder: (context, f) {
          final appts = a.data, fols = f.data;
          if (appts == null || fols == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Text(
                  '${l10n.viewToday} · ${formatDay(context, DateTime.now())}',
                  style: heading,
                ),
              ),
              if (appts.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l10n.noAppointmentsToday),
                ),
              for (final x in appts) AppointmentTile(appointment: x),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(l10n.followUpsThisWeek, style: heading),
              ),
              if (fols.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l10n.noFollowUps),
                ),
              for (final x in fols) AppointmentTile(appointment: x, followUp: true),
            ],
          );
        },
      ),
    );
  }
}

class _Unpaid extends StatelessWidget {
  const _Unpaid({required this.stream});
  final Stream<List<Appointment>> stream;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return StreamBuilder<List<Appointment>>(
      stream: stream,
      builder: (context, snap) {
        final items = snap.data;
        if (items == null) return const Center(child: CircularProgressIndicator());
        final total = items.fold<double>(0, (s, a) => s + (a.fee ?? 0));
        return ListView(
          padding: const EdgeInsets.only(bottom: 96),
          children: [
            ListTile(
              title: Text(l10n.totalUnpaid),
              trailing: Text(
                formatMoney(total),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: total > 0 ? context.look.bad : null,
                ),
              ),
            ),
            const Divider(height: 1),
            if (items.isEmpty)
              Padding(padding: const EdgeInsets.all(32), child: Text(l10n.nothingUnpaid)),
            for (final x in items) AppointmentTile(appointment: x, showDate: true),
          ],
        );
      },
    );
  }
}
