import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/services.dart';
import '../../../l10n/l10n.dart';
import '../../clients/domain/client.dart';
import '../domain/appointment.dart';
import 'appointment_format.dart';

/// Book a consultation, or fill in one that was held: notes, fee,
/// paid, follow-up.
class AppointmentFormPage extends StatefulWidget {
  const AppointmentFormPage({super.key, this.id, this.clientId});

  final int? id;

  /// Preselected client (new appointments from a client's page).
  final int? clientId;

  @override
  State<AppointmentFormPage> createState() => _AppointmentFormPageState();
}

class _AppointmentFormPageState extends State<AppointmentFormPage> {
  final _title = TextEditingController();
  final _notes = TextEditingController();
  final _fee = TextEditingController();
  List<ClientSummary> _clients = const [];
  int? _clientId;
  late DateTime _start;
  int _minutes = 30;
  AppointmentStatus _status = AppointmentStatus.scheduled;
  bool _paid = false;
  DateTime? _followUp;
  bool _remind = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Next half hour.
    final m = now.minute < 30 ? 30 : 60;
    _start = DateTime(now.year, now.month, now.day, now.hour).add(Duration(minutes: m));
    _clientId = widget.clientId;
    _load();
  }

  Future<void> _load() async {
    final s = context.read<AppServices>();
    final clients = await s.clients.watchAll().first;
    final a = widget.id == null ? null : await s.appointments.get(widget.id!);
    if (!mounted) return;
    setState(() {
      _clients = clients;
      if (a != null) {
        _clientId = a.clientId;
        _title.text = a.title;
        _notes.text = a.notes;
        _fee.text = a.fee == null ? '' : _plain(a.fee!);
        _start = a.startsAt;
        _minutes = a.minutes;
        _status = a.status;
        _paid = a.paid;
        _followUp = a.followUpOn;
        _remind = a.remind;
      }
      _loading = false;
    });
  }

  static String _plain(double v) =>
      v == v.roundToDouble() ? v.round().toString() : v.toString();

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    _fee.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _start,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) {
      setState(() => _start = DateTime(d.year, d.month, d.day, _start.hour, _start.minute));
    }
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_start),
    );
    if (t != null) {
      setState(() => _start = DateTime(_start.year, _start.month, _start.day, t.hour, t.minute));
    }
  }

  Future<void> _pickFollowUp() async {
    final base = _followUp ?? _start.add(const Duration(days: 30));
    final d = await showDatePicker(
      context: context,
      initialDate: base,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _followUp = d);
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    if (_clientId == null && _title.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.needClientOrName)));
      return;
    }
    final s = context.read<AppServices>();
    final fee = double.tryParse(_fee.text.trim());
    final a = Appointment(
      id: widget.id,
      clientId: _clientId,
      title: _title.text,
      startsAt: _start,
      minutes: _minutes,
      status: _status,
      notes: _notes.text,
      fee: fee,
      paid: fee != null && fee > 0 && _paid,
      followUpOn: _followUp,
      remind: _remind,
    );
    final id = await s.appointments.save(a);
    final saved = await s.appointments.get(id);
    if (saved != null) await s.reminders.schedule(saved, l10n);
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAppointmentTitle),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final s = context.read<AppServices>();
    await s.reminders.cancel(widget.id!);
    await s.appointments.delete(widget.id!);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    const gap = SizedBox(height: 12);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? l10n.newAppointment : l10n.editAppointment),
        actions: [
          if (widget.id != null)
            IconButton(
              tooltip: l10n.delete,
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
          TextButton(onPressed: _loading ? null : _save, child: Text(l10n.saveAction)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<int?>(
                  initialValue: _clientId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l10n.client,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.noClient)),
                    for (final c in _clients)
                      DropdownMenuItem(
                        value: c.client.id,
                        child: Text(
                          [c.client.name, if (c.client.phone.isNotEmpty) c.client.phone].join(' · '),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: (v) => setState(() => _clientId = v),
                ),
                gap,
                TextField(
                  controller: _title,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: _clientId == null ? l10n.walkInName : l10n.topic,
                    border: const OutlineInputBorder(),
                  ),
                ),
                gap,
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text(formatDay(context, _start)),
                        onPressed: _pickDate,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.schedule, size: 18),
                        label: Text(formatClock(_start)),
                        onPressed: _pickTime,
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _minutes,
                      items: [
                        for (final m in const [15, 30, 45, 60, 90, 120])
                          DropdownMenuItem(value: m, child: Text(l10n.minutesShort('$m'))),
                      ],
                      onChanged: (m) => setState(() => _minutes = m!),
                    ),
                  ],
                ),
                gap,
                SegmentedButton<AppointmentStatus>(
                  showSelectedIcon: false,
                  segments: [
                    for (final s in AppointmentStatus.values)
                      ButtonSegment(value: s, label: Text(statusLabel(l10n, s))),
                  ],
                  selected: {_status},
                  onSelectionChanged: (v) => setState(() => _status = v.first),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.remindMe),
                  subtitle: Text(l10n.remindMeHint),
                  value: _remind,
                  onChanged: (v) => setState(() => _remind = v),
                ),
                const Divider(),
                Text(l10n.sessionNotes, style: theme.textTheme.titleSmall),
                const SizedBox(height: 6),
                TextField(
                  controller: _notes,
                  minLines: 4,
                  maxLines: 12,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: l10n.sessionNotesHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                gap,
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _fee,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        decoration: InputDecoration(
                          labelText: l10n.fee,
                          prefixText: '₹ ',
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilterChip(
                      label: Text(l10n.paid),
                      selected: _paid,
                      onSelected: (double.tryParse(_fee.text) ?? 0) > 0
                          ? (v) => setState(() => _paid = v)
                          : null,
                    ),
                  ],
                ),
                gap,
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.replay),
                  title: Text(l10n.followUpOn),
                  subtitle: Text(_followUp == null ? l10n.none : formatDay(context, _followUp!)),
                  onTap: _pickFollowUp,
                  trailing: _followUp == null
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => _followUp = null),
                        ),
                ),
              ],
            ),
    );
  }
}
