import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../app/services.dart';
import '../../../l10n/l10n.dart';
import '../../appointments/presentation/appointment_format.dart';
import '../domain/client.dart';

/// Clients, searchable by name, phone, city and any note (theirs, their
/// consultations' and their family charts').
class ClientListPage extends StatefulWidget {
  const ClientListPage({super.key});

  @override
  State<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  String _query = '';
  Timer? _debounce;
  late Stream<List<ClientSummary>> _stream = _watch();

  Stream<List<ClientSummary>> _watch() =>
      context.read<AppServices>().clients.watchAll(search: _query);

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.clients),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.searchClients,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (q) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 250), () {
                  if (!mounted) return;
                  setState(() {
                    _query = q;
                    _stream = _watch();
                  });
                });
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'newClient',
        onPressed: () => context.push(Routes.newClient),
        icon: const Icon(Icons.person_add_alt),
        label: Text(l10n.newClient),
      ),
      body: StreamBuilder<List<ClientSummary>>(
        stream: _stream,
        builder: (context, snap) {
          final items = snap.data;
          if (items == null) return const Center(child: CircularProgressIndicator());
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  _query.isEmpty ? l10n.noClientsYet : l10n.noClientMatches(_query),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) => _ClientTile(summary: items[i]),
          );
        },
      ),
    );
  }
}

class _ClientTile extends StatelessWidget {
  const _ClientTile({required this.summary});
  final ClientSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = summary.client;
    final next = summary.nextAppointment;
    return ListTile(
      leading: CircleAvatar(
        child: Text(c.name.isEmpty ? '?' : c.name.characters.first.toUpperCase()),
      ),
      title: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        [
          if (c.phone.isNotEmpty) c.phone,
          if (c.city.isNotEmpty) c.city,
          l10n.chartCount('${summary.charts}'),
        ].join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (next != null)
            Text(
              '${formatDay(context, next)} ${formatClock(next)}',
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary),
            ),
          if (summary.unpaid > 0)
            Text(
              l10n.dueAmount(formatMoney(summary.unpaid)),
              style: const TextStyle(fontSize: 12, color: Color(0xFFE57373)),
            ),
        ],
      ),
      onTap: () => context.push(Routes.client(c.id!)),
    );
  }
}
