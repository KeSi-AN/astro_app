import 'package:material_ui/material_ui.dart';

/// The app's two looks: a warm cream-and-saffron almanac look (default)
/// and the original dark one.
enum UiLook { saffron, night }

const _gold = Color(0xFFD4A017);

/// Colours the widgets use beyond the Material scheme.
class AppLook extends ThemeExtension<AppLook> {
  const AppLook({
    required this.saffron,
    required this.good,
    required this.bad,
    required this.goodSoft,
    required this.badSoft,
    required this.sectionBg,
    required this.cardBg,
    required this.label,
    required this.rule,
    required this.stripe,
    required this.banner,
    required this.bannerText,
    required this.bannerAccent,
    required this.chartLine,
  });

  /// True for the almanac look (cards with header bands, ruled rows).
  final bool saffron;
  final Color good, bad, goodSoft, badSoft;

  /// Header band of a section card, and the card body.
  final Color sectionBg, cardBg;

  /// Row labels (left column of a section).
  final Color label;

  /// Lines between rows, and every other row's tint.
  final Color rule, stripe;

  /// The date banner on the Panchang screen.
  final Color banner, bannerText, bannerAccent;
  final Color chartLine;

  static const saffronLook = AppLook(
    saffron: true,
    good: Color(0xFF2E7D32),
    bad: Color(0xFFC62828),
    goodSoft: Color(0xFF558B2F),
    badSoft: Color(0xFFD84315),
    sectionBg: Color(0xFFF6C86C),
    cardBg: Color(0xFFFFE3A3),
    label: Color(0xFFAD1F1A),
    rule: Color(0xFFD9A54A),
    stripe: Color(0xFFFFEBBB),
    banner: Color(0xFF7D7816),
    bannerText: Color(0xFFFFFFFF),
    bannerAccent: Color(0xFFF6D27A),
    chartLine: Color(0xFFB5541C),
  );

  static const nightLook = AppLook(
    saffron: false,
    good: Color(0xFF81C784),
    bad: Color(0xFFE57373),
    goodSoft: Color(0xFFA5D6A7),
    badSoft: Color(0xFFEF9A9A),
    sectionBg: Color(0xFF2A2418),
    cardBg: Color(0xFF1E1A12),
    label: Color(0xFFB8AE9C),
    rule: Color(0x55B8AE9C),
    stripe: Color(0x00000000),
    banner: Color(0xFF3A3215),
    bannerText: Color(0xFFFFFFFF),
    bannerAccent: _gold,
    chartLine: _gold,
  );

  @override
  AppLook copyWith() => this;

  @override
  AppLook lerp(AppLook? other, double t) => t < 0.5 ? this : (other ?? this);
}

extension LookContext on BuildContext {
  AppLook get look => Theme.of(this).extension<AppLook>() ?? AppLook.nightLook;
}

ThemeData appTheme([UiLook look = UiLook.saffron]) =>
    look == UiLook.night ? _night() : _saffron();

ThemeData _night() {
  final scheme = ColorScheme.fromSeed(
    seedColor: _gold,
    brightness: Brightness.dark,
  ).copyWith(primary: _gold);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    extensions: const [AppLook.nightLook],
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      isDense: true,
    ),
  );
}

ThemeData _saffron() {
  const red = Color(0xFFB3261E);
  const maroon = Color(0xFF8E1C17);
  const cream = Color(0xFFFFF2CF);
  const brown = Color(0xFF3B2412);
  const look = AppLook.saffronLook;
  final scheme = ColorScheme.fromSeed(seedColor: red, brightness: Brightness.light).copyWith(
    primary: red,
    onPrimary: Colors.white,
    secondary: const Color(0xFFB5541C),
    surface: cream,
    onSurface: brown,
    onSurfaceVariant: const Color(0xFF7A5A33),
    surfaceContainerLowest: cream,
    surfaceContainerLow: look.cardBg,
    surfaceContainer: look.cardBg,
    surfaceContainerHigh: look.cardBg,
    surfaceContainerHighest: look.sectionBg,
    outline: look.rule,
    outlineVariant: look.rule,
    primaryContainer: look.sectionBg,
    onPrimaryContainer: maroon,
    secondaryContainer: look.sectionBg,
    onSecondaryContainer: maroon,
  );
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    extensions: const [look],
    scaffoldBackgroundColor: cream,
    dividerColor: look.rule,
    appBarTheme: const AppBarTheme(
      backgroundColor: red,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w500),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: Color(0xFFFFD9A0),
      indicatorColor: Color(0xFFF6D27A),
      dividerColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: look.cardBg,
      surfaceTintColor: Colors.transparent,
      elevation: 1.5,
      shadowColor: const Color(0x55704010),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: maroon,
      indicatorColor: look.sectionBg,
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(color: s.contains(WidgetState.selected) ? maroon : const Color(0xFFFFE3A3)),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => TextStyle(
          color: const Color(0xFFFFE3A3),
          fontSize: 12,
          fontWeight: s.contains(WidgetState.selected) ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: red,
      foregroundColor: Colors.white,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: look.cardBg,
      selectedColor: red,
      secondarySelectedColor: red,
      checkmarkColor: Colors.white,
      labelStyle: const TextStyle(color: brown),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      side: BorderSide(color: look.rule),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? red : look.cardBg,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Colors.white : brown,
        ),
        side: WidgetStatePropertyAll(BorderSide(color: look.rule)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(backgroundColor: red, foregroundColor: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(),
      isDense: true,
      filled: true,
      fillColor: const Color(0xFFFFF8E6),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: look.rule)),
    ),
    listTileTheme: const ListTileThemeData(iconColor: maroon),
    dialogTheme: const DialogThemeData(backgroundColor: cream),
  );
}

/// Tabular figures so degrees and times line up in tables.
TextStyle tabular(TextStyle s) =>
    s.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
