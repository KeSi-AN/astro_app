import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/router.dart';
import '../../../app/services.dart';
import '../../../core/format/formatters.dart';
import '../../../l10n/l10n.dart';
import '../../appointments/domain/appointment.dart';
import '../../appointments/presentation/appointment_format.dart';
import '../../appointments/presentation/appointment_tile.dart';
import '../../charts/domain/chart_entry.dart';
import '../domain/client.dart';

String relationLabel(AppLocalizations l10n, Relation r) => switch (r) {
  Relation.self => l10n.relSelf,
  Relation.spouse => l10n.relSpouse,
  Relation.son => l10n.relSon,
  Relation.daughter => l10n.relDaughter,
  Relation.father => l10n.relFather,
  Relation.mother => l10n.relMother,
  Relation.brother => l10n.relBrother,
  Relation.sister => l10n.relSister,
  Relation.other => l10n.relOther,
};

/// A client: contact, family charts, consultations (notes, fees), reports.
class ClientDetailPage extends StatelessWidget {
  const ClientDetailPage({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppServices>();
    return StreamBuilder<Client?>(
      stream: s.clients.watch(id),
      builder: (context, snap) {
        final c = snap.data;
        if (c == null) {
          return Scaffold(
            appBar: AppBar(),
            body: snap.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : Center(child: Text(context.l10n.clientNotFound)),
          );
        }
        return _Detail(client: c);
      },
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.client});
  final Client client;

  Future<void> _delete(BuildContext context) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteClientTitle),
        content: Text(l10n.deleteClientBody(client.name)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await context.read<AppServices>().clients.delete(client.id!);
    if (context.mounted) context.pop();
  }

  /// Digits for tel:/wa.me; a 10-digit Indian number gets +91.
  static String _digits(String phone) {
    final d = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (d.startsWith('+')) return d.substring(1);
    if (d.length == 10) return '91$d';
    if (d.length == 11 && d.startsWith('0')) return '91${d.substring(1)}';
    return d;
  }

  Future<void> _linkExisting(BuildContext context) async {
    final l10n = context.l10n;
    final s = context.read<AppServices>();
    final all = await s.charts.watchAll().first;
    final linked = (await s.clients.watchFamily(client.id!).first)
        .map((f) => f.chart.id)
        .toSet();
    if (!context.mounted) return;
    final chart = await showDialog<ChartEntry>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.linkChart),
        children: [
          for (final c in all.where((c) => !linked.contains(c.id)))
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, c),
              child: Text(
                '${c.name} · ${formatDate(c.year, c.month, c.day, month: context.terms.month)}',
              ),
            ),
        ],
      ),
    );
    if (chart == null || !context.mounted) return;
    final rel = await _pickRelation(context);
    if (rel == null) return;
    await s.clients.link(chart.id!, client.id!, rel);
  }

  static Future<Relation?> _pickRelation(BuildContext context, [Relation? current]) {
    final l10n = context.l10n;
    return showDialog<Relation>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.relationTitle),
        children: [
          for (final r in Relation.values)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, r),
              child: Text(
                relationLabel(l10n, r),
                style: TextStyle(fontWeight: r == current ? FontWeight.bold : null),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _newChart(BuildContext context, bool hasSelf) async {
    final rel = hasSelf ? await _pickRelation(context) : Relation.self;
    if (rel == null || !context.mounted) return;
    await context.push(Routes.newChartFor(client.id!, rel.name));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final s = context.read<AppServices>();
    final c = client;
    final heading = theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary);
    Widget section(String title, {Widget? action}) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 8, 4),
      child: Row(
        children: [
          Expanded(child: Text(title, style: heading)),
          ?action,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(c.name),
        actions: [
          IconButton(
            tooltip: l10n.edit,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(Routes.editClient(c.id!)),
          ),
          IconButton(
            tooltip: l10n.delete,
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'clientAppointment',
        icon: const Icon(Icons.event),
        label: Text(l10n.newAppointment),
        onPressed: () => context.push(Routes.newAppointment(clientId: c.id)),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          if (c.phone.isNotEmpty || c.city.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.phone_outlined),
              title: Text(c.phone.isEmpty ? '—' : c.phone),
              subtitle: c.city.isEmpty ? null : Text(c.city),
              trailing: c.phone.isEmpty
                  ? null
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: l10n.call,
                          icon: const Icon(Icons.call),
                          onPressed: () => launchUrl(Uri.parse('tel:${c.phone.replaceAll(' ', '')}')),
                        ),
                        IconButton(
                          tooltip: 'WhatsApp',
                          icon: const Icon(Icons.chat_outlined),
                          onPressed: () => launchUrl(
                            Uri.parse('https://wa.me/${_digits(c.phone)}'),
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                      ],
                    ),
            ),
          if (c.notes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Text(c.notes, style: theme.textTheme.bodyMedium),
            ),

          // Family charts
          StreamBuilder<List<FamilyChart>>(
            stream: s.clients.watchFamily(c.id!),
            builder: (context, snap) {
              final fam = snap.data ?? const [];
              final hasSelf = fam.any((f) => f.relation == Relation.self);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  section(
                    l10n.familyCharts,
                    action: PopupMenuButton<bool>(
                      icon: const Icon(Icons.add),
                      onSelected: (isNew) =>
                          isNew ? _newChart(context, hasSelf) : _linkExisting(context),
                      itemBuilder: (_) => [
                        PopupMenuItem(value: true, child: Text(l10n.newChartForClient)),
                        PopupMenuItem(value: false, child: Text(l10n.linkChart)),
                      ],
                    ),
                  ),
                  if (fam.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(l10n.noFamilyCharts),
                    ),
                  for (final f in fam)
                    ListTile(
                      leading: Chip(
                        label: Text(relationLabel(l10n, f.relation)),
                        visualDensity: VisualDensity.compact,
                      ),
                      title: Text(f.chart.name),
                      subtitle: Text(
                        '${formatDate(f.chart.year, f.chart.month, f.chart.day, month: context.terms.month)}'
                        ' · ${formatTime(f.chart.hour, f.chart.minute, f.chart.second)}'
                        ' · ${f.chart.place.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => context.push(Routes.chart(f.chart.id!)),
                      trailing: PopupMenuButton<int>(
                        onSelected: (v) async {
                          if (v == 0) {
                            final r = await _pickRelation(context, f.relation);
                            if (r != null) await s.clients.link(f.chart.id!, c.id!, r);
                          } else {
                            await s.clients.unlink(f.chart.id!);
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(value: 0, child: Text(l10n.changeRelation)),
                          PopupMenuItem(value: 1, child: Text(l10n.unlinkChart)),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),

          // Consultations
          StreamBuilder<List<Appointment>>(
            stream: s.appointments.watchForClient(c.id!),
            builder: (context, snap) {
              final list = snap.data ?? const [];
              final due = list
                  .where((a) => a.unpaid && a.status != AppointmentStatus.cancelled)
                  .fold<double>(0, (t, a) => t + a.fee!);
              final paid = list
                  .where((a) => a.paid)
                  .fold<double>(0, (t, a) => t + (a.fee ?? 0));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  section(l10n.consultations),
                  if (paid > 0 || due > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        [
                          if (paid > 0) l10n.paidTotal(formatMoney(paid)),
                          if (due > 0) l10n.dueAmount(formatMoney(due)),
                        ].join(' · '),
                        style: TextStyle(
                          color: due > 0 ? const Color(0xFFE57373) : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  if (list.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(l10n.noConsultations),
                    ),
                  for (final a in list)
                    AppointmentTile(appointment: a, showDate: true, showWho: false),
                ],
              );
            },
          ),

          // Reports sent
          StreamBuilder<List<ReportSent>>(
            stream: s.clients.watchReports(c.id!),
            builder: (context, snap) {
              final list = snap.data ?? const [];
              if (list.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  section(l10n.reportsSent),
                  for (final r in list)
                    ListTile(
                      dense: true,
                      leading: Icon(r.kind == 'print' ? Icons.print_outlined : Icons.share_outlined),
                      title: Text(r.chartName),
                      subtitle: Text(
                        '${formatDay(context, r.at)} ${formatClock(r.at)} · '
                        '${r.language == 'hi' ? 'हिंदी' : 'English'} · '
                        '${l10n.pagesCount('${r.pages}')}',
                      ),
                      onTap: () => context.push(Routes.chart(r.chartId)),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
