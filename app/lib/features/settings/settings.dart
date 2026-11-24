import 'dart:async';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jyotish_core/jyotish_core.dart';

import '../../core/db/app_database.dart';
import '../chart_view/presentation/chart_geometry.dart';

/// Calculation and display preferences. Defaults match AstroSage, which
/// the astrologer is used to (see DIVERGENCES.md).
class AppSettings extends Equatable {
  const AppSettings({
    this.chartStyle = ChartStyle.north,
    this.ayanamsa = Ayanamsa.lahiri,
    this.nodeType = NodeType.meanNode,
    this.sunriseMode = SunriseMode.upperLimb,
    this.karakaScheme = KarakaScheme.seven,
    this.showOuterPlanets = true,
  });

  final ChartStyle chartStyle;
  final Ayanamsa ayanamsa;
  final NodeType nodeType;
  final SunriseMode sunriseMode;
  final KarakaScheme karakaScheme;
  final bool showOuterPlanets;

  CalcSettings get calc => CalcSettings(ayanamsa: ayanamsa, nodeType: nodeType);

  AppSettings copyWith({
    ChartStyle? chartStyle,
    Ayanamsa? ayanamsa,
    NodeType? nodeType,
    SunriseMode? sunriseMode,
    KarakaScheme? karakaScheme,
    bool? showOuterPlanets,
  }) => AppSettings(
    chartStyle: chartStyle ?? this.chartStyle,
    ayanamsa: ayanamsa ?? this.ayanamsa,
    nodeType: nodeType ?? this.nodeType,
    sunriseMode: sunriseMode ?? this.sunriseMode,
    karakaScheme: karakaScheme ?? this.karakaScheme,
    showOuterPlanets: showOuterPlanets ?? this.showOuterPlanets,
  );

  Map<String, String> toMap() => {
    'chartStyle': chartStyle.name,
    'ayanamsa': ayanamsa.name,
    'nodeType': nodeType.name,
    'sunriseMode': sunriseMode.name,
    'karakaScheme': karakaScheme.name,
    'showOuterPlanets': '$showOuterPlanets',
  };

  static AppSettings fromMap(Map<String, String> m) {
    T pick<T extends Enum>(List<T> values, String key, T fallback) =>
        values.asNameMap()[m[key]] ?? fallback;
    const d = AppSettings();
    return AppSettings(
      chartStyle: pick(ChartStyle.values, 'chartStyle', d.chartStyle),
      // User-defined ayanamsa needs extra values the settings screen doesn't
      // collect yet, so it never comes back from storage.
      ayanamsa: pick(
        Ayanamsa.values.where((a) => a != Ayanamsa.user).toList(),
        'ayanamsa',
        d.ayanamsa,
      ),
      nodeType: pick(NodeType.values, 'nodeType', d.nodeType),
      sunriseMode: pick(SunriseMode.values, 'sunriseMode', d.sunriseMode),
      karakaScheme: pick(KarakaScheme.values, 'karakaScheme', d.karakaScheme),
      showOuterPlanets: m['showOuterPlanets'] != 'false',
    );
  }

  @override
  List<Object?> get props => [
    chartStyle,
    ayanamsa,
    nodeType,
    sunriseMode,
    karakaScheme,
    showOuterPlanets,
  ];
}

class SettingsRepository {
  SettingsRepository(this._db);
  final AppDatabase _db;

  Stream<AppSettings> watch() => _db
      .select(_db.settings)
      .watch()
      .map(
        (rows) => AppSettings.fromMap({for (final r in rows) r.key: r.value}),
      );

  Future<void> save(AppSettings s) => _db.batch((b) {
    b.insertAllOnConflictUpdate(_db.settings, [
      for (final e in s.toMap().entries)
        SettingsCompanion(key: Value(e.key), value: Value(e.value)),
    ]);
  });
}

class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit(this._repo) : super(const AppSettings()) {
    _sub = _repo.watch().listen(emit);
  }

  final SettingsRepository _repo;
  late final StreamSubscription<AppSettings> _sub;

  Future<void> update(AppSettings Function(AppSettings) change) =>
      _repo.save(change(state));

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
