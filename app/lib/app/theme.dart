import 'package:material_ui/material_ui.dart';

const _gold = Color(0xFFD4A017);

ThemeData appTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: _gold,
    brightness: Brightness.dark,
  ).copyWith(primary: _gold);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      isDense: true,
    ),
  );
}

/// Tabular figures so degrees and times line up in tables.
TextStyle tabular(TextStyle s) =>
    s.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
