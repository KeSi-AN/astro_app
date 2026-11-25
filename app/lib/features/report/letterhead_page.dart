import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';

import '../../l10n/l10n.dart';
import '../settings/settings.dart';

/// The astrologer's name, title, phone, address and logo for PDF kundlis.
class LetterheadPage extends StatefulWidget {
  const LetterheadPage({super.key});

  @override
  State<LetterheadPage> createState() => _LetterheadPageState();
}

class _LetterheadPageState extends State<LetterheadPage> {
  late final Letterhead _initial = context
      .read<SettingsCubit>()
      .state
      .letterhead;
  late final _name = TextEditingController(text: _initial.name);
  late final _title = TextEditingController(text: _initial.title);
  late final _phone = TextEditingController(text: _initial.phone);
  late final _address = TextEditingController(text: _initial.address);
  late String _logo = _initial.logoPath;

  @override
  void dispose() {
    for (final c in [_name, _title, _phone, _address]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final x = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (x == null) return;
    final dir = await getApplicationSupportDirectory();
    final ext = x.path.toLowerCase().endsWith('.png') ? 'png' : 'jpg';
    // A new name each time so the image cache never shows the old logo.
    final dest =
        '${dir.path}/letterhead_logo_${DateTime.now().millisecondsSinceEpoch}.$ext';
    await File(x.path).copy(dest);
    _deleteOld();
    setState(() => _logo = dest);
  }

  void _deleteOld() {
    if (_logo.isNotEmpty && _logo != _initial.logoPath) {
      try {
        File(_logo).deleteSync();
      } catch (_) {}
    }
  }

  Future<void> _save() async {
    final old = _initial.logoPath;
    await context.read<SettingsCubit>().update(
      (s) => s.copyWith(
        letterhead: Letterhead(
          name: _name.text.trim(),
          title: _title.text.trim(),
          phone: _phone.text.trim(),
          address: _address.text.trim(),
          logoPath: _logo,
        ),
      ),
    );
    if (old.isNotEmpty && old != _logo) {
      try {
        File(old).deleteSync();
      } catch (_) {}
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.saved)),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget field(TextEditingController c, String label, {int lines = 1, TextInputType? type}) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextField(
            controller: c,
            maxLines: lines,
            keyboardType: type,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
          ),
        );
    final hasLogo = _logo.isNotEmpty && File(_logo).existsSync();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.letterhead),
        actions: [
          TextButton(onPressed: _save, child: Text(l10n.saveAction)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.letterheadHint, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          field(_name, l10n.lhName),
          field(_title, l10n.lhTitle),
          field(_phone, l10n.lhPhone, type: TextInputType.phone),
          field(_address, l10n.lhAddress, lines: 3),
          Text(l10n.lhLogo, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: hasLogo
                    ? Image.file(File(_logo), fit: BoxFit.contain)
                    : const Icon(Icons.image_outlined),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton(onPressed: _pickLogo, child: Text(l10n.chooseLogo)),
                    if (hasLogo)
                      TextButton(
                        onPressed: () {
                          _deleteOld();
                          setState(() => _logo = '');
                        },
                        child: Text(l10n.removeLogo),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
