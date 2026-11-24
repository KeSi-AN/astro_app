import '../ephemeris/ephemeris.dart';
import '../model/enums.dart';
import '../panchang/birth_panchang.dart';
import '../rules/avakhada.dart';
import '../rules/dignity.dart';
import '../rules/karakas.dart';
import '../rules/relationships.dart';
import '../rules/vimshottari.dart';
import '../varga/varga.dart';
import 'rasi_chart.dart';

/// Per-graha facts shown in the planets table and on the chart.
class GrahaInfo {
  const GrahaInfo({
    required this.graha,
    required this.placement,
    required this.dignity,
    required this.combust,
    required this.vargottama,
    required this.navamshaSign,
    required this.subLord,
    required this.subSubLord,
    required this.chalitBhava,
  });

  final Graha graha;
  final Placement placement;
  final Dignity? dignity;
  final bool combust;
  final bool vargottama;
  final Rashi navamshaSign;
  final Graha subLord;
  final Graha subSubLord;

  /// Bhava (1..12) in the Sripati chalit chart.
  final int chalitBhava;

  bool get exalted => dignity == Dignity.exalted;
  bool get debilitated => dignity == Dignity.debilitated;
}

/// Everything derived from a [RasiChart] for the Phase 2 screens.
class ChartAnalysis {
  ChartAnalysis._({
    required this.chart,
    required this.grahas,
    required this.lagnaNavamsha,
    required this.lagnaSubLords,
    required this.panchang,
    required this.avakhada,
    required this.karakas,
    required this.karakaScheme,
  });

  final RasiChart chart;
  final Map<Graha, GrahaInfo> grahas;
  final Rashi lagnaNavamsha;
  final List<Graha> lagnaSubLords;
  final BirthPanchang panchang;
  final Avakhada avakhada;
  final List<(Karaka, Graha, double)> karakas;
  final KarakaScheme karakaScheme;

  bool get lagnaVargottama => lagnaNavamsha == chart.lagna.rashi;

  /// Natural relationship of [a] towards [b] (seven grahas only).
  Relation natural(Graha a, Graha b) => naturalRelation(a, b);

  /// Temporal relationship of [a] towards [b] in this chart.
  Relation temporal(Graha a, Graha b) =>
      temporalRelation(chart.grahas[a]!.rashi, chart.grahas[b]!.rashi);

  /// Compound (panchadha) relationship of [a] towards [b] in this chart.
  Relation compound(Graha a, Graha b) =>
      compoundRelation(natural(a, b), temporal(a, b));

  static ChartAnalysis of(
    RasiChart chart,
    Ephemeris eph, {
    SunriseMode sunriseMode = SunriseMode.upperLimb,
    KarakaScheme karakaScheme = KarakaScheme.seven,
  }) {
    final sunLon = chart.grahas[Graha.sun]!.longitude;
    final infos = <Graha, GrahaInfo>{};
    for (final g in Graha.values) {
      final p = chart.grahas[g]!;
      final nav = vargaSign(p.longitude, Varga.d9);
      final orb = combustionOrb(g, retrograde: p.isRetrograde);
      final lords = kpLords(p.longitude);
      infos[g] = GrahaInfo(
        graha: g,
        placement: p,
        dignity: dignityOf(g, p.longitude, compoundTo: (lord) {
          if (lord == g) return Relation.friend;
          return compoundRelation(naturalRelation(g, lord),
              temporalRelation(p.rashi, chart.grahas[lord]!.rashi));
        }),
        combust: orb != null && separation(p.longitude, sunLon) <= orb,
        vargottama: nav == p.rashi,
        navamshaSign: nav,
        subLord: lords[1],
        subSubLord: lords[2],
        chalitBhava: chart.bhavas.bhavaOf(p.longitude),
      );
    }
    return ChartAnalysis._(
      chart: chart,
      grahas: infos,
      lagnaNavamsha: vargaSign(chart.lagna.longitude, Varga.d9),
      lagnaSubLords: kpLords(chart.lagna.longitude),
      panchang: BirthPanchang.of(chart, eph, mode: sunriseMode),
      avakhada: Avakhada.of(chart),
      karakas: charaKarakas(chart, karakaScheme),
      karakaScheme: karakaScheme,
    );
  }
}
