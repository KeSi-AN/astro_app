import 'package:birth_input/birth_input.dart';
import 'package:flutter/services.dart';
import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'app/services.dart';
import 'core/db/app_database.dart';
import 'features/atlas/data/atlas_installer.dart';
import 'features/atlas/data/atlas_repository.dart';
import 'features/charts/data/chart_repository.dart';
import 'features/settings/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AstroApp(services: _start));
}

Future<AppServices> _start() async {
  TimeResolver.ensureInitialized();
  final support = await getApplicationSupportDirectory();
  final results = await Future.wait([
    SwephEphemeris.init(
      epheDir: '${support.path}/ephe',
      loadAsset: (f) async =>
          (await rootBundle.load('packages/sweph/assets/ephe/$f')).buffer
              .asUint8List(),
    ),
    installAtlas(),
  ]);
  final db = AppDatabase();
  return AppServices(
    db: db,
    charts: ChartRepository(db),
    atlas: AtlasRepository.open(results[1] as String),
    ephemeris: results[0] as Ephemeris,
    settings: SettingsRepository(db),
  );
}
