import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../app/services.dart';
import '../../../l10n/l10n.dart';
import '../domain/client.dart';

class ClientFormPage extends StatefulWidget {
  const ClientFormPage({super.key, this.id});
  final int? id;

  @override
  State<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends State<ClientFormPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _city = TextEditingController();
  final _notes = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _loading = true;
      context.read<AppServices>().clients.get(widget.id!).then((c) {
        if (!mounted || c == null) return;
        setState(() {
          _name.text = c.name;
          _phone.text = c.phone;
          _city.text = c.city;
          _notes.text = c.notes;
          _loading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _phone, _city, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final id = await context.read<AppServices>().clients.save(
      Client(
        id: widget.id,
        name: _name.text,
        phone: _phone.text,
        city: _city.text,
        notes: _notes.text,
      ),
    );
    if (!mounted) return;
    if (widget.id == null) {
      context.pushReplacement(Routes.client(id));
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    InputDecoration deco(String label) =>
        InputDecoration(labelText: label, border: const OutlineInputBorder());
    const gap = SizedBox(height: 12);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? l10n.newClient : l10n.editClient),
        actions: [
          TextButton(onPressed: _loading ? null : _save, child: Text(l10n.saveAction)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _form,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _name,
                    autofocus: widget.id == null,
                    textCapitalization: TextCapitalization.words,
                    decoration: deco(l10n.name),
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ? l10n.nameRequired : null,
                  ),
                  gap,
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: deco(l10n.lhPhone),
                  ),
                  gap,
                  TextFormField(
                    controller: _city,
                    textCapitalization: TextCapitalization.words,
                    decoration: deco(l10n.city),
                  ),
                  gap,
                  TextFormField(
                    controller: _notes,
                    minLines: 3,
                    maxLines: 10,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: deco(l10n.clientNotes),
                  ),
                ],
              ),
            ),
    );
  }
}
