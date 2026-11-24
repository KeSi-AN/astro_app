import 'package:birth_input/birth_input.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../app/services.dart';
import '../../../core/format/formatters.dart';
import '../../atlas/domain/place.dart';
import '../../atlas/presentation/place_search_page.dart';
import '../domain/chart_entry.dart';
import 'widgets/time_zone_panel.dart';

/// New chart (id == null) or edit an existing one.
class ChartFormPage extends StatefulWidget {
  const ChartFormPage({super.key, this.id});
  final int? id;

  @override
  State<ChartFormPage> createState() => _ChartFormPageState();
}

class _ChartFormPageState extends State<ChartFormPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _date = TextEditingController();
  final _time = TextEditingController();
  final _notes = TextEditingController();
  final _manualOffset = TextEditingController();
  final _manualDst = TextEditingController(text: '0');

  String? _gender;
  Place? _place;
  TimeBasis? _basis; // null = default for date/place
  bool? _warTime; // null = default (applied)
  String? _marital;
  String? _occupation;
  List<String> _pasteNotes = const [];
  bool _loading = false;
  bool _saving = false;
  DateTime? _createdAt;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _loading = true;
      _load(widget.id!);
    } else {
      final now = DateTime.now();
      _date.text = formatDateInput(now.year, now.month, now.day);
      _time.text = formatTime(now.hour, now.minute, now.second);
    }
  }

  Future<void> _load(int id) async {
    final e = await context.read<AppServices>().charts.get(id);
    if (!mounted || e == null) return;
    setState(() {
      _name.text = e.name;
      _gender = e.gender;
      _date.text = formatDateInput(e.year, e.month, e.day);
      _time.text = formatTime(e.hour, e.minute, e.second);
      _place = e.place;
      _basis = e.timeBasis;
      _warTime = e.warTimeApplied;
      if (e.timeBasis == TimeBasis.manual) {
        _manualOffset.text = formatOffset(e.utcOffsetHours).substring(3);
        _manualDst.text = e.dstHours.toString();
      }
      _marital = e.maritalStatus;
      _occupation = e.occupation;
      _notes.text = e.notes ?? '';
      _createdAt = e.createdAt;
      _loading = false;
    });
  }

  @override
  void dispose() {
    for (final c in [_name, _date, _time, _notes, _manualOffset, _manualDst]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Current time-zone resolution, or an error message.
  (TimeResolution?, String?) _resolve() {
    final p = _place;
    final d = parseDateInput(_date.text);
    final t = parseTimeInput(_time.text);
    if (p == null || d == null || t == null) return (null, null);
    double? manual;
    if (_basis == TimeBasis.manual) {
      manual = parseOffsetInput(_manualOffset.text);
      if (manual == null) return (null, 'Enter the UTC offset, e.g. 5:30');
    }
    try {
      return (
        TimeResolver.resolve(
          zoneName: p.zoneName, longitude: p.longitude, admin1: p.admin1,
          year: d[0], month: d[1], day: d[2],
          hour: t[0], minute: t[1], second: t[2],
          basis: _basis, manualOffsetHours: manual,
          manualDstHours: double.tryParse(_manualDst.text) ?? 0,
          applyWarTime: _warTime,
        ),
        null,
      );
    } catch (e) {
      return (null, 'Unknown time zone "${p.zoneName}". Use a manual offset.');
    }
  }

  Future<void> _pickPlace([String query = '']) async {
    final p = await Navigator.of(context).push<Place>(MaterialPageRoute(
      builder: (_) => PlaceSearchPage(initialQuery: query),
    ));
    if (p != null) {
      setState(() {
        _place = p;
        _basis = null;
        _warTime = null;
      });
    }
  }

  Future<void> _pickDate() async {
    final d = parseDateInput(_date.text);
    final picked = await showDatePicker(
      context: context,
      initialDate: d == null ? DateTime.now() : DateTime(d[0], d[1], d[2]),
      firstDate: DateTime(1800),
      lastDate: DateTime(2399, 12, 31),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) {
      setState(() => _date.text =
          formatDateInput(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _pickTime() async {
    final t = parseTimeInput(_time.text);
    final picked = await showTimePicker(
      context: context,
      initialTime: t == null
          ? TimeOfDay.now()
          : TimeOfDay(hour: t[0], minute: t[1]),
    );
    if (picked != null) {
      setState(() => _time.text = formatTime(picked.hour, picked.minute, 0));
    }
  }

  Future<void> _paste() async {
    final clip = (await Clipboard.getData(Clipboard.kTextPlain))?.text ?? '';
    if (!mounted) return;
    final text = await showDialog<String>(
      context: context,
      builder: (_) => _PasteDialog(initial: clip),
    );
    if (text == null || !mounted) return;
    final r = BirthTextParser.parse(text);
    if (r.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No birth details found in that text.')));
      return;
    }
    final notes = [...r.notes];
    setState(() {
      if (r.name != null) _name.text = r.name!;
      if (r.gender != null) _gender = r.gender;
      if (r.hasDate) _date.text = formatDateInput(r.year!, r.month!, r.day!);
      if (r.hasTime) _time.text = formatTime(r.hour!, r.minute!, r.second ?? 0);
    });
    if (!r.hasDate) notes.add('No date found: enter it below.');
    if (!r.hasTime) notes.add('No time found: enter it below.');
    if (r.place != null) {
      final first = r.place!.split(',').first.trim();
      final found = context.read<AppServices>().atlas.search(r.place!, limit: 5);
      final exact = found.where((p) => p.name.toLowerCase() == first.toLowerCase());
      if (exact.isNotEmpty) {
        setState(() {
          _place = exact.first;
          _basis = null;
          _warTime = null;
        });
        notes.add('Place matched to ${exact.first.displayName}. Tap the place to change it.');
      } else {
        notes.add('Place "${r.place}" needs choosing.');
        await _pickPlace(first);
      }
    }
    if (mounted) setState(() => _pasteNotes = notes);
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final (res, err) = _resolve();
    if (_place == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Choose the birth place.')));
      return;
    }
    if (res == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err ?? 'Check the time zone.')));
      return;
    }
    final d = parseDateInput(_date.text)!;
    final t = parseTimeInput(_time.text)!;
    final entry = ChartEntry(
      id: widget.id,
      name: _name.text.trim(),
      gender: _gender,
      year: d[0], month: d[1], day: d[2],
      hour: t[0], minute: t[1], second: t[2],
      place: _place!,
      timeBasis: res.basis,
      utcOffsetHours: res.standardOffsetHours,
      dstHours: res.dstHours,
      warTimeApplied: res.isWarTime ? (_warTime ?? true) : null,
      maritalStatus: _marital,
      occupation: _occupation,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      createdAt: _createdAt,
    );
    setState(() => _saving = true);
    final id = await context.read<AppServices>().charts.save(entry);
    if (!mounted) return;
    if (widget.id == null) {
      context.pushReplacement(Routes.chart(id));
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final (res, resErr) = _resolve();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'New chart' : 'Edit chart'),
        actions: [
          TextButton.icon(
            onPressed: _paste,
            icon: const Icon(Icons.content_paste),
            label: const Text('Paste details'),
          ),
        ],
      ),
      body: Form(
        key: _form,
        onChanged: () => setState(() {}),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            for (final n in _pasteNotes)
              _Banner(text: n, onClose: () => setState(() {
                    _pasteNotes = [..._pasteNotes]..remove(n);
                  })),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                  labelText: 'Name', prefixIcon: Icon(Icons.person_outline)),
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? 'Enter a name' : null,
            ),
            const SizedBox(height: 12),
            SegmentedButton<String?>(
              segments: const [
                ButtonSegment(value: 'male', label: Text('Male')),
                ButtonSegment(value: 'female', label: Text('Female')),
                ButtonSegment(value: null, label: Text('—')),
              ],
              selected: {_gender},
              onSelectionChanged: (s) => setState(() => _gender = s.first),
            ),
            const SizedBox(height: 12),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: TextFormField(
                  controller: _date,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: 'Date (DD/MM/YYYY)',
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: _pickDate),
                  ),
                  validator: (v) => parseDateInput(v ?? '') == null
                      ? 'DD/MM/YYYY, 1800–2399'
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: TextFormField(
                  controller: _time,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: 'Time (24h, HH:MM:SS)',
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.schedule), onPressed: _pickTime),
                  ),
                  validator: (v) =>
                      parseTimeInput(v ?? '') == null ? 'e.g. 22:45:10' : null,
                ),
              ),
            ]),
            const SizedBox(height: 12),
            _PlaceField(place: _place, onTap: () => _pickPlace()),
            if (_place != null) ...[
              const SizedBox(height: 12),
              TimeZonePanel(
                place: _place!,
                resolution: res,
                error: resErr,
                basis: _basis,
                manualOffset: _manualOffset,
                manualDst: _manualDst,
                onBasis: (b) => setState(() => _basis = b),
                onWarTime: (v) => setState(() => _warTime = v),
              ),
            ],
            const SizedBox(height: 20),
            Text('Optional', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _marital,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Marital status'),
                  items: [
                    for (final m in maritalStatuses)
                      DropdownMenuItem(value: m, child: Text(m)),
                  ],
                  onChanged: (v) => setState(() => _marital = v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _occupation,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Occupation'),
                  items: [
                    for (final o in occupations)
                      DropdownMenuItem(
                          value: o,
                          child: Text(o, overflow: TextOverflow.ellipsis)),
                  ],
                  onChanged: (v) => setState(() => _occupation = v),
                ),
              ),
            ]),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notes,
              minLines: 2,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saving ? null : _save,
        icon: const Icon(Icons.check),
        label: Text(widget.id == null ? 'Save & open' : 'Save'),
      ),
    );
  }
}

class _PlaceField extends StatelessWidget {
  const _PlaceField({required this.place, required this.onTap});
  final Place? place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = place;
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Birth place',
          prefixIcon: Icon(Icons.place_outlined),
          suffixIcon: Icon(Icons.search),
        ),
        isEmpty: p == null,
        child: p == null
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.displayName),
                  Text(
                    '${formatLatitude(p.latitude)}  ${formatLongitude(p.longitude)}  ·  ${p.zoneName}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.text, required this.onClose});
  final String text;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        dense: true,
        leading: const Icon(Icons.info_outline),
        title: Text(text),
        trailing: IconButton(icon: const Icon(Icons.close), onPressed: onClose),
      ),
    );
  }
}

class _PasteDialog extends StatefulWidget {
  const _PasteDialog({required this.initial});
  final String initial;

  @override
  State<_PasteDialog> createState() => _PasteDialogState();
}

class _PasteDialogState extends State<_PasteDialog> {
  late final _text = TextEditingController(text: widget.initial);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Paste birth details'),
      content: SizedBox(
        width: double.maxFinite,
        child: TextField(
          controller: _text,
          minLines: 6,
          maxLines: 12,
          autofocus: widget.initial.isEmpty,
          decoration: const InputDecoration(
            hintText: 'e.g.\nName: Rahul Sharma\nDOB 12/03/1990, 10:45 am\nPlace: Lucknow',
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
            onPressed: () => Navigator.pop(context, _text.text),
            child: const Text('Fill form')),
      ],
    );
  }
}
