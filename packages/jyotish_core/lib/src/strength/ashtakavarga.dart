import '../chart/rasi_chart.dart';
import '../model/enums.dart';

/// Who contributes bindus: the seven grahas and the lagna.
enum AvContributor { sun, moon, mars, mercury, jupiter, venus, saturn, lagna }

/// The seven grahas that have an Ashtakavarga.
const avGrahas = [
  Graha.sun, Graha.moon, Graha.mars, Graha.mercury,
  Graha.jupiter, Graha.venus, Graha.saturn,
];

/// Benefic places (houses counted from each contributor) for each graha's
/// Bhinnashtakavarga, BPHS ch. 66 (Parashara). Order of the inner lists:
/// Sun, Moon, Mars, Mercury, Jupiter, Venus, Saturn, Lagna.
const _places = <Graha, List<List<int>>>{
  Graha.sun: [
    [1, 2, 4, 7, 8, 9, 10, 11], [3, 6, 10, 11], [1, 2, 4, 7, 8, 9, 10, 11],
    [3, 5, 6, 9, 10, 11, 12], [5, 6, 9, 11], [6, 7, 12],
    [1, 2, 4, 7, 8, 9, 10, 11], [3, 4, 6, 10, 11, 12],
  ],
  Graha.moon: [
    [3, 6, 7, 8, 10, 11], [1, 3, 6, 7, 10, 11], [2, 3, 5, 6, 9, 10, 11],
    [1, 3, 4, 5, 7, 8, 10, 11], [1, 4, 7, 8, 10, 11, 12],
    [3, 4, 5, 7, 9, 10, 11], [3, 5, 6, 11], [3, 6, 10, 11],
  ],
  Graha.mars: [
    [3, 5, 6, 10, 11], [3, 6, 11], [1, 2, 4, 7, 8, 10, 11], [3, 5, 6, 11],
    [6, 10, 11, 12], [6, 8, 11, 12], [1, 4, 7, 8, 9, 10, 11],
    [1, 3, 6, 10, 11],
  ],
  Graha.mercury: [
    [5, 6, 9, 11, 12], [2, 4, 6, 8, 10, 11], [1, 2, 4, 7, 8, 9, 10, 11],
    [1, 3, 5, 6, 9, 10, 11, 12], [6, 8, 11, 12], [1, 2, 3, 4, 5, 8, 9, 11],
    [1, 2, 4, 7, 8, 9, 10, 11], [1, 2, 4, 6, 8, 10, 11],
  ],
  Graha.jupiter: [
    [1, 2, 3, 4, 7, 8, 9, 10, 11], [2, 5, 7, 9, 11], [1, 2, 4, 7, 8, 10, 11],
    [1, 2, 4, 5, 6, 9, 10, 11], [1, 2, 3, 4, 7, 8, 10, 11],
    [2, 5, 6, 9, 10, 11], [3, 5, 6, 12], [1, 2, 4, 5, 6, 7, 9, 10, 11],
  ],
  Graha.venus: [
    [8, 11, 12], [1, 2, 3, 4, 5, 8, 9, 11, 12], [3, 5, 6, 9, 11, 12],
    [3, 5, 6, 9, 11], [5, 8, 9, 10, 11], [1, 2, 3, 4, 5, 8, 9, 10, 11],
    [3, 4, 5, 8, 9, 10, 11], [1, 2, 3, 4, 5, 8, 9, 11],
  ],
  Graha.saturn: [
    [1, 2, 4, 7, 8, 10, 11], [3, 6, 11], [3, 5, 6, 10, 11, 12],
    [6, 8, 9, 10, 11, 12], [5, 6, 11, 12], [6, 11, 12], [3, 5, 6, 11],
    [1, 3, 4, 6, 10, 11],
  ],
};

/// Bhinnashtakavarga, Sarvashtakavarga and the Prastara grid of a chart.
class Ashtakavarga {
  Ashtakavarga._(this.prastara);

  /// prastara[graha][contributor][signIndex] = 1 if the contributor gives
  /// a bindu to that sign in the graha's Ashtakavarga.
  final Map<Graha, List<List<int>>> prastara;

  /// Bindus per sign (index 0 = Aries) in [g]'s Bhinnashtakavarga.
  List<int> bav(Graha g) => [
        for (var s = 0; s < 12; s++)
          prastara[g]!.fold<int>(0, (sum, row) => sum + row[s]),
      ];

  /// Total bindus of [g] (fixed by the tables: Sun 48, Moon 49, …).
  int bavTotal(Graha g) => bav(g).fold(0, (a, b) => a + b);

  /// Sarvashtakavarga per sign (sum of the seven BAVs; total 337).
  List<int> get sav => [
        for (var s = 0; s < 12; s++)
          avGrahas.fold<int>(0, (sum, g) => sum + bav(g)[s]),
      ];

  static Ashtakavarga of(RasiChart chart) {
    final contributorSign = <int>[
      for (final g in avGrahas) chart.grahas[g]!.rashi.index,
      chart.lagna.rashi.index,
    ];
    final prastara = <Graha, List<List<int>>>{};
    for (final g in avGrahas) {
      final rows = <List<int>>[];
      for (var c = 0; c < 8; c++) {
        final row = List.filled(12, 0);
        for (final house in _places[g]![c]) {
          row[(contributorSign[c] + house - 1) % 12] = 1;
        }
        rows.add(row);
      }
      prastara[g] = rows;
    }
    return Ashtakavarga._(prastara);
  }
}
