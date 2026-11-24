import 'package:jyotish_core/jyotish_core.dart';

/// What a chart drawing shows: 12 houses, the sign in each, and the
/// grahas (with markers) placed in them. Style-independent.
class ChartPlate {
  const ChartPlate({
    required this.title,
    required this.ascendantSign,
    required this.houses,
  });

  final String title;

  /// Sign in house 1.
  final Rashi ascendantSign;

  /// Index 0 = house 1.
  final List<PlateHouse> houses;

  /// The house that holds [sign].
  PlateHouse houseOfSign(Rashi sign) =>
      houses.firstWhere((h) => h.sign == sign);
}

class PlateHouse {
  const PlateHouse({
    required this.number,
    required this.sign,
    required this.items,
  });
  final int number; // 1..12
  final Rashi sign;
  final List<PlateItem> items;
}

class PlateItem {
  const PlateItem({
    required this.graha,
    required this.degree,
    this.retrograde = false,
    this.combust = false,
    this.vargottama = false,
    this.exalted = false,
    this.debilitated = false,
  });

  /// null = the lagna marker.
  final Graha? graha;

  /// Whole degrees shown next to the name.
  final int degree;
  final bool retrograde, combust, vargottama, exalted, debilitated;

  String get name => graha?.short ?? 'As';

  /// AstroSage-style suffixes: * retrograde, ^ combust, ◻ vargottama,
  /// ↑ exalted, ↓ debilitated.
  String get markers => [
    if (retrograde) '*',
    if (combust) '^',
    if (vargottama) '◻',
    if (exalted) '↑',
    if (debilitated) '↓',
  ].join();

  String get label => labelWith(name);

  /// Label with a (localised) planet abbreviation.
  String labelWith(String abbreviation) =>
      '$abbreviation$markers ${degree.toString().padLeft(2, '0')}';
}

enum PlateKind {
  lagna('Lagna'),
  moon('Moon'),
  navamsha('Navamsha'),
  chalit('Chalit');

  const PlateKind(this.label);
  final String label;
}

/// Grahas drawn on charts (outer planets optional, as in AstroSage).
List<Graha> plateGrahas({bool outer = true}) =>
    Graha.values.where((g) => outer || !g.isOuter).toList();

ChartPlate buildPlate(ChartAnalysis a, PlateKind kind, {bool outer = true}) {
  final chart = a.chart;
  PlateItem item(Graha g, {int? degree}) {
    final info = a.grahas[g]!;
    final p = info.placement;
    return PlateItem(
      graha: g,
      degree: degree ?? p.degreeInSign.floor(),
      retrograde: p.isRetrograde,
      combust: info.combust,
      vargottama: info.vargottama,
      exalted: info.exalted,
      debilitated: info.debilitated,
    );
  }

  final grahas = plateGrahas(outer: outer);
  switch (kind) {
    case PlateKind.lagna:
    case PlateKind.moon:
      final asc = kind == PlateKind.lagna
          ? chart.lagna.rashi
          : chart.grahas[Graha.moon]!.rashi;
      final bySign = <Rashi, List<PlateItem>>{};
      if (kind == PlateKind.lagna) {
        bySign
            .putIfAbsent(chart.lagna.rashi, () => [])
            .add(
              PlateItem(
                graha: null,
                degree: chart.lagna.degreeInSign.floor(),
                vargottama: a.lagnaVargottama,
              ),
            );
      }
      for (final g in grahas) {
        bySign.putIfAbsent(chart.grahas[g]!.rashi, () => []).add(item(g));
      }
      return _plate(kind.label, asc, (sign) => bySign[sign] ?? const []);

    case PlateKind.navamsha:
      final asc = a.lagnaNavamsha;
      final bySign = <Rashi, List<PlateItem>>{
        asc: [
          PlateItem(
            graha: null,
            degree: vargaDegree(chart.lagna.longitude, Varga.d9).floor(),
            vargottama: a.lagnaVargottama,
          ),
        ],
      };
      for (final g in grahas) {
        final info = a.grahas[g]!;
        bySign
            .putIfAbsent(info.navamshaSign, () => [])
            .add(
              item(
                g,
                degree: vargaDegree(info.placement.longitude, Varga.d9).floor(),
              ),
            );
      }
      return _plate('Navamsha (D9)', asc, (s) => bySign[s] ?? const []);

    case PlateKind.chalit:
      // Bhava n holds the planets whose longitude falls in its sandhi range;
      // the sign shown is that of the bhava madhya.
      final madhya = chart.bhavas.madhya;
      final byBhava = <int, List<PlateItem>>{
        chart.bhavas.bhavaOf(chart.lagna.longitude): [
          PlateItem(graha: null, degree: chart.lagna.degreeInSign.floor()),
        ],
      };
      for (final g in grahas) {
        byBhava.putIfAbsent(a.grahas[g]!.chalitBhava, () => []).add(item(g));
      }
      return ChartPlate(
        title: 'Chalit (Sripati)',
        ascendantSign: Rashi.ofLongitude(madhya[0]),
        houses: [
          for (var h = 1; h <= 12; h++)
            PlateHouse(
              number: h,
              sign: Rashi.ofLongitude(madhya[h - 1]),
              items: byBhava[h] ?? const [],
            ),
        ],
      );
  }
}

ChartPlate _plate(
  String title,
  Rashi asc,
  List<PlateItem> Function(Rashi) items,
) => ChartPlate(
  title: title,
  ascendantSign: asc,
  houses: [
    for (var h = 1; h <= 12; h++)
      PlateHouse(
        number: h,
        sign: Rashi.values[(asc.index + h - 1) % 12],
        items: items(Rashi.values[(asc.index + h - 1) % 12]),
      ),
  ],
);
