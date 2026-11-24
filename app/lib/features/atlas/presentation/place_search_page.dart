import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/services.dart';
import '../../../l10n/l10n.dart';
import '../domain/place.dart';

/// Full-screen place search. Pops with the chosen [Place], or a manual one.
class PlaceSearchPage extends StatefulWidget {
  const PlaceSearchPage({super.key, this.initialQuery = ''});
  final String initialQuery;

  @override
  State<PlaceSearchPage> createState() => _PlaceSearchPageState();
}

class _PlaceSearchPageState extends State<PlaceSearchPage> {
  late final _controller = TextEditingController(text: widget.initialQuery);
  List<Place> _results = const [];

  @override
  void initState() {
    super.initState();
    _search(widget.initialQuery);
  }

  void _search(String q) {
    setState(() => _results = context.read<AppServices>().atlas.search(q));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: context.l10n.placeSearchHint,
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onChanged: _search,
        ),
        actions: [
          IconButton(
            tooltip: context.l10n.clear,
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              _search('');
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          for (final p in _results)
            ListTile(
              title: Text(p.name),
              subtitle: Text(
                '${p.detail}\n${formatLatitude(p.latitude)} '
                '${formatLongitude(p.longitude)} · ${p.zoneName}',
              ),
              isThreeLine: true,
              onTap: () => Navigator.pop(context, p),
            ),
          if (_controller.text.trim().length >= 2 && _results.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                // Devanagari input can't match the Latin-script atlas.
                RegExp('[ऀ-ॿ]').hasMatch(_controller.text)
                    ? context.l10n.placeSearchLatin
                    : context.l10n.noPlaceFound,
              ),
            ),
          ListTile(
            leading: const Icon(Icons.edit_location_alt_outlined),
            title: Text(context.l10n.enterCoordinates),
            onTap: () async {
              final p = await showDialog<Place>(
                context: context,
                builder: (_) =>
                    _ManualPlaceDialog(name: _controller.text.trim()),
              );
              if (p != null && context.mounted) Navigator.pop(context, p);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              context.l10n.geonamesCredit,
              style: const TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _ManualPlaceDialog extends StatefulWidget {
  const _ManualPlaceDialog({required this.name});
  final String name;

  @override
  State<_ManualPlaceDialog> createState() => _ManualPlaceDialogState();
}

class _ManualPlaceDialogState extends State<_ManualPlaceDialog> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.name);
  final _lat = TextEditingController();
  final _lon = TextEditingController();
  final _zone = TextEditingController(text: 'Asia/Kolkata');

  static double? _parse(String s, String pos, String neg) {
    // Accepts 27.15, -74.0, 27N09, 27°09'N, 078E00
    final t = s.trim().toUpperCase();
    final dec = double.tryParse(t);
    if (dec != null) return dec;
    final m = RegExp(
      '^(\\d{1,3})\\s*[°\\s]?\\s*([$pos$neg])?\\s*(\\d{1,2})?\\s*[\'′]?\\s*([$pos$neg])?\$',
    ).firstMatch(t);
    if (m == null) return null;
    final hemi = m[2] ?? m[4];
    if (hemi == null) return null;
    final v = int.parse(m[1]!) + int.parse(m[3] ?? '0') / 60;
    return hemi == neg ? -v : v;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.placeByCoordinates),
      content: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                decoration: InputDecoration(labelText: context.l10n.placeName),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? context.l10n.required : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lat,
                decoration: InputDecoration(
                  labelText: context.l10n.latitude,
                  hintText: '27.15 or 27N09',
                ),
                validator: (v) {
                  final x = _parse(v ?? '', 'N', 'S');
                  return x == null || x.abs() > 90
                      ? context.l10n.latError
                      : null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lon,
                decoration: InputDecoration(
                  labelText: context.l10n.longitudeGeo,
                  hintText: '78.00 or 078E00',
                ),
                validator: (v) {
                  final x = _parse(v ?? '', 'E', 'W');
                  return x == null || x.abs() > 180
                      ? context.l10n.lonError
                      : null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _zone,
                decoration: InputDecoration(
                  labelText: context.l10n.timeZone,
                  hintText: 'Asia/Kolkata',
                ),
                validator: (v) =>
                    (v ?? '').contains('/') ? null : context.l10n.zoneError,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (!_form.currentState!.validate()) return;
            Navigator.pop(
              context,
              Place(
                name: _name.text.trim(),
                latitude: _parse(_lat.text, 'N', 'S')!,
                longitude: _parse(_lon.text, 'E', 'W')!,
                zoneName: _zone.text.trim(),
              ),
            );
          },
          child: Text(context.l10n.use),
        ),
      ],
    );
  }
}
