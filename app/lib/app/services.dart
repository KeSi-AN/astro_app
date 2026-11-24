import 'package:jyotish_core/jyotish_core.dart';

import '../core/db/app_database.dart';
import '../features/atlas/data/atlas_repository.dart';
import '../features/charts/data/chart_repository.dart';
import '../features/settings/settings.dart';

/// Everything long-lived that screens need, created once at start-up.
class AppServices {
  AppServices({
    required this.db,
    required this.charts,
    required this.atlas,
    required this.ephemeris,
    required this.settings,
  });

  final AppDatabase db;
  final ChartRepository charts;
  final AtlasRepository atlas;
  final Ephemeris ephemeris;
  final SettingsRepository settings;
}
