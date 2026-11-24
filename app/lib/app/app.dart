import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import 'router.dart';
import 'services.dart';
import 'theme.dart';

class AstroApp extends StatefulWidget {
  const AstroApp({super.key, required this.services});

  /// Creates the services (database, atlas, ephemeris) once.
  final Future<AppServices> Function() services;

  @override
  State<AstroApp> createState() => _AstroAppState();
}

class _AstroAppState extends State<AstroApp> {
  late final Future<AppServices> _services = widget.services();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppServices>(
      future: _services,
      builder: (context, snap) {
        if (snap.hasError) {
          return MaterialApp(
            theme: appTheme(),
            home: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Could not start: ${snap.error}'),
                ),
              ),
            ),
          );
        }
        final services = snap.data;
        if (services == null) {
          return MaterialApp(
            theme: appTheme(),
            debugShowCheckedModeBanner: false,
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        return RepositoryProvider.value(
          value: services,
          child: MaterialApp.router(
            title: 'Astro',
            theme: appTheme(),
            debugShowCheckedModeBanner: false,
            routerConfig: buildRouter(),
          ),
        );
      },
    );
  }
}
