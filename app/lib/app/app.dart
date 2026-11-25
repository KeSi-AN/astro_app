import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import 'router.dart';
import 'services.dart';
import 'theme.dart';
import '../features/settings/settings.dart';
import '../l10n/l10n.dart';

class AstroApp extends StatefulWidget {
  const AstroApp({super.key, required this.services});

  /// Creates the services (database, atlas, ephemeris) once.
  final Future<AppServices> Function() services;

  /// Starts the app's services again (after a restore replaced the
  /// database): repositories, cubits and the router are rebuilt.
  static void restart(BuildContext context) =>
      context.findAncestorStateOfType<_AstroAppState>()?._restart();

  @override
  State<AstroApp> createState() => _AstroAppState();
}

class _AstroAppState extends State<AstroApp> {
  late Future<AppServices> _services = widget.services();
  var _router = buildRouter();
  var _generation = 0;

  void _restart() => setState(() {
    _services = widget.services();
    _router = buildRouter();
    _generation++;
  });

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
        // After a restart the old (closed) services must not be reused
        // while the new ones start.
        final services = snap.connectionState == ConnectionState.done
            ? snap.data
            : null;
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
          key: ValueKey(_generation),
          value: services,
          child: BlocProvider(
            create: (_) => SettingsCubit(services.settings),
            child: BlocBuilder<SettingsCubit, AppSettings>(
              buildWhen: (a, b) => a.language != b.language,
              builder: (context, s) => MaterialApp.router(
                title: 'Astro',
                theme: appTheme(),
                debugShowCheckedModeBanner: false,
                locale: s.locale,
                // material_ui's own delegates (Flutter's flutter_localizations ones
                // don't provide material_ui's MaterialLocalizations).
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  ...GlobalMaterialLocalizations.delegates,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: _router,
              ),
            ),
          ),
        );
      },
    );
  }
}
