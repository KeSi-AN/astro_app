import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/services.dart';
import '../../l10n/l10n.dart';
import '../appointments/presentation/appointments_page.dart';
import '../charts/presentation/chart_list_page.dart';
import '../clients/presentation/client_list_page.dart';

/// The three main lists: charts, clients and appointments.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _tab = 0;
  var _synced = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_synced) return;
    _synced = true;
    // Re-create pending reminders (after a restore, or an app update that
    // dropped them). Cheap: only future ones.
    final s = context.read<AppServices>();
    final l10n = context.l10n;
    unawaited(() async {
      for (final a in await s.appointments.upcomingForReminders(DateTime.now())) {
        await s.reminders.schedule(a, l10n);
      }
    }());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: const [ChartListPage(), ClientListPage(), AppointmentsPage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.blur_circular_outlined),
            selectedIcon: const Icon(Icons.blur_circular),
            label: l10n.chartsTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people),
            label: l10n.clients,
          ),
          NavigationDestination(
            icon: const Icon(Icons.event_note_outlined),
            selectedIcon: const Icon(Icons.event_note),
            label: l10n.appointments,
          ),
        ],
      ),
    );
  }
}
