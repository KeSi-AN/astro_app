import '../chart/chart_analysis.dart';
import '../model/enums.dart';
import '../rules/dignity.dart';

/// A yoga or dosha check. [present] after any cancellation; [found] before.
class YogaResult {
  const YogaResult({
    required this.id,
    required this.found,
    bool cancelled = false,
    this.planets = const [],
    this.detail = const [],
    this.source = '',
    this.isDosha = false,
  }) : cancelled = found && cancelled;

  /// Stable key, e.g. 'gajakesari', 'mangal'. The app translates it.
  final String id;
  final bool found;

  /// Only meaningful when [found]: the yoga formed but is cancelled.
  final bool cancelled;
  final List<Graha> planets;

  /// Machine-readable reasons (keys + values) the app turns into text.
  final List<(String, String)> detail;
  final String source;
  final bool isDosha;

  bool get present => found && !cancelled;
}

const _kendra = {1, 4, 7, 10};
const _trikona = {1, 5, 9};
const _sevenGrahas = [
  Graha.sun, Graha.moon, Graha.mars, Graha.mercury,
  Graha.jupiter, Graha.venus, Graha.saturn,
];

/// All yoga and dosha checks for a chart, in a fixed order.
List<YogaResult> yogas(ChartAnalysis a) {
  final c = a.chart;
  final lagna = c.lagna.rashi.index;
  Rashi sign(Graha g) => c.grahas[g]!.rashi;

  /// Whole-sign house of [g] counted from [from] (sign index).
  int houseFrom(Graha g, int from) => (sign(g).index - from) % 12 + 1;
  int house(Graha g) => houseFrom(g, lagna);
  Graha lordOf(int h) => Rashi.values[(lagna + h - 1) % 12].lord;
  bool sameSign(Graha x, Graha y) => sign(x) == sign(y);
  bool ownOrExalted(Graha g) {
    final d = a.grahas[g]!.dignity;
    return d == Dignity.own || d == Dignity.moolatrikona || d == Dignity.exalted;
  }

  /// Conjunction, mutual 7th, or exchange of signs.
  bool related(Graha x, Graha y) {
    if (x == y) return false;
    if (sameSign(x, y)) return true;
    if ((sign(x).index - sign(y).index) % 12 == 6) return true;
    return sign(x).lord == y && sign(y).lord == x;
  }

  final moon = sign(Graha.moon).index;
  final sun = sign(Graha.sun).index;
  final out = <YogaResult>[];

  // ---- Pancha Mahapurusha (BPHS ch. 75) ---------------------------------
  for (final (id, g) in [
    ('ruchaka', Graha.mars), ('bhadra', Graha.mercury),
    ('hamsa', Graha.jupiter), ('malavya', Graha.venus),
    ('shasha', Graha.saturn),
  ]) {
    out.add(YogaResult(
      id: id,
      found: ownOrExalted(g) && _kendra.contains(house(g)),
      planets: [g],
      detail: [('house', '${house(g)}')],
      source: 'BPHS 75',
    ));
  }

  // ---- Moon yogas ---------------------------------------------------------
  final ju = houseFrom(Graha.jupiter, moon);
  out.add(YogaResult(
    id: 'gajakesari',
    found: _kendra.contains(ju),
    planets: const [Graha.jupiter, Graha.moon],
    detail: [('houseFromMoon', '$ju')],
    source: 'Phaladeepika 6',
  ));
  final notSunNodes = [
    Graha.mars, Graha.mercury, Graha.jupiter, Graha.venus, Graha.saturn,
  ];
  final in2 = [for (final g in notSunNodes) if (houseFrom(g, moon) == 2) g];
  final in12 = [for (final g in notSunNodes) if (houseFrom(g, moon) == 12) g];
  out.add(YogaResult(
    id: 'sunapha', found: in2.isNotEmpty && in12.isEmpty, planets: in2,
    source: 'BPHS 37'));
  out.add(YogaResult(
    id: 'anapha', found: in12.isNotEmpty && in2.isEmpty, planets: in12,
    source: 'BPHS 37'));
  out.add(YogaResult(
    id: 'durudhara', found: in2.isNotEmpty && in12.isNotEmpty,
    planets: [...in2, ...in12], source: 'BPHS 37'));
  final kemaCancel = [
    for (final g in notSunNodes)
      if (_kendra.contains(houseFrom(g, moon)) || _kendra.contains(house(g))) g,
  ];
  out.add(YogaResult(
    id: 'kemadruma',
    found: in2.isEmpty && in12.isEmpty,
    cancelled: kemaCancel.isNotEmpty,
    planets: kemaCancel,
    source: 'BPHS 37',
    isDosha: true,
  ));
  out.add(YogaResult(
    id: 'chandraMangala',
    found: sameSign(Graha.moon, Graha.mars) ||
        (sign(Graha.moon).index - sign(Graha.mars).index) % 12 == 6,
    planets: const [Graha.moon, Graha.mars],
    source: 'Phaladeepika 6',
  ));
  final adhi = [
    for (final g in [Graha.mercury, Graha.jupiter, Graha.venus])
      if ({6, 7, 8}.contains(houseFrom(g, moon))) g,
  ];
  out.add(YogaResult(
    id: 'adhi', found: adhi.length == 3, planets: adhi, source: 'BPHS 37'));

  // ---- Sun yogas ----------------------------------------------------------
  final notMoonNodes = [
    Graha.mars, Graha.mercury, Graha.jupiter, Graha.venus, Graha.saturn,
  ];
  final s2 = [for (final g in notMoonNodes) if (houseFrom(g, sun) == 2) g];
  final s12 = [for (final g in notMoonNodes) if (houseFrom(g, sun) == 12) g];
  out.add(YogaResult(
    id: 'vesi', found: s2.isNotEmpty && s12.isEmpty, planets: s2,
    source: 'BPHS 38'));
  out.add(YogaResult(
    id: 'vosi', found: s12.isNotEmpty && s2.isEmpty, planets: s12,
    source: 'BPHS 38'));
  out.add(YogaResult(
    id: 'ubhayachari', found: s2.isNotEmpty && s12.isNotEmpty,
    planets: [...s2, ...s12], source: 'BPHS 38'));
  out.add(YogaResult(
    id: 'budhaditya',
    found: sameSign(Graha.sun, Graha.mercury),
    planets: const [Graha.sun, Graha.mercury],
    source: 'Phaladeepika 6',
  ));

  // ---- Other named yogas --------------------------------------------------
  final amala = [
    for (final g in [Graha.mercury, Graha.jupiter, Graha.venus])
      if (house(g) == 10 || houseFrom(g, moon) == 10) g,
  ];
  out.add(YogaResult(
    id: 'amala', found: amala.isNotEmpty, planets: amala,
    source: 'Phaladeepika 6'));

  final saraswatiPlaces = {..._kendra, ..._trikona, 2};
  final jDig = a.grahas[Graha.jupiter]!.dignity;
  out.add(YogaResult(
    id: 'saraswati',
    found: [Graha.jupiter, Graha.venus, Graha.mercury]
            .every((g) => saraswatiPlaces.contains(house(g))) &&
        jDig != null &&
        jDig.index <= Dignity.friend.index,
    planets: const [Graha.jupiter, Graha.venus, Graha.mercury],
    source: 'Phaladeepika 6',
  ));

  // Parvata (BPHS 35): lords of lagna and 12th in mutual kendras.
  final l1 = lordOf(1), l12 = lordOf(12);
  out.add(YogaResult(
    id: 'parvata',
    found: _kendra.contains((sign(l12).index - sign(l1).index) % 12 + 1),
    planets: [l1, l12],
    source: 'BPHS 35',
  ));
  // Kahala (BPHS 35): lords of 4th and 9th in mutual kendras.
  final l4 = lordOf(4), l9 = lordOf(9);
  out.add(YogaResult(
    id: 'kahala',
    found: l4 != l9 &&
        _kendra.contains((sign(l9).index - sign(l4).index) % 12 + 1),
    planets: [l4, l9],
    source: 'BPHS 35',
  ));

  // Parashari Raja yoga (BPHS 39): a kendra lord related to a trikona lord,
  // or one planet (not the lagna lord) ruling both.
  final kendraLords = {for (final h in [4, 7, 10]) lordOf(h)};
  final trikonaLords = {for (final h in [5, 9]) lordOf(h)};
  final raja = <Graha>{};
  for (final k in kendraLords) {
    for (final t in trikonaLords) {
      if (k == t && k != l1) raja.add(k);
      if (related(k, t)) raja.addAll([k, t]);
    }
  }
  out.add(YogaResult(
    id: 'raja', found: raja.isNotEmpty, planets: raja.toList(),
    source: 'BPHS 39'));

  // Dhana yoga (BPHS 41): lords of 1, 2, 5, 9, 11 related to one another.
  final wealthLords = [for (final h in [1, 2, 5, 9, 11]) lordOf(h)];
  final dhana = <Graha>{};
  for (var i = 0; i < wealthLords.length; i++) {
    for (var j = i + 1; j < wealthLords.length; j++) {
      if (related(wealthLords[i], wealthLords[j])) {
        dhana.addAll([wealthLords[i], wealthLords[j]]);
      }
    }
  }
  out.add(YogaResult(
    id: 'dhana', found: dhana.isNotEmpty, planets: dhana.toList(),
    source: 'BPHS 41'));

  // Viparita Raja (lords of 6, 8, 12 in dusthanas).
  for (final (id, h) in [('harsha', 6), ('sarala', 8), ('vimala', 12)]) {
    final l = lordOf(h);
    out.add(YogaResult(
      id: id,
      found: {6, 8, 12}.contains(house(l)),
      planets: [l],
      detail: [('house', '${house(l)}')],
      source: 'Phaladeepika 6',
    ));
  }

  // Neecha bhanga: a debilitated planet whose debilitation-sign lord or
  // exaltation-sign lord is in a kendra from lagna or Moon.
  final nb = <Graha>[];
  for (final g in _sevenGrahas) {
    if (a.grahas[g]!.dignity != Dignity.debilitated) continue;
    final dLord = sign(g).lord;
    final eLord = exaltation[g]!.$1.lord;
    bool inKendra(Graha x) =>
        _kendra.contains(house(x)) || _kendra.contains(houseFrom(x, moon));
    if (inKendra(dLord) || inKendra(eLord)) nb.add(g);
  }
  out.add(YogaResult(
    id: 'neechaBhanga', found: nb.isNotEmpty, planets: nb,
    source: 'Phaladeepika 7'));

  // ---- Doshas -----------------------------------------------------------
  out.add(_mangal(a));
  out.add(_kaalSarp(a));
  out.add(YogaResult(
    id: 'guruChandala',
    found: sameSign(Graha.jupiter, Graha.rahu) ||
        sameSign(Graha.jupiter, Graha.ketu),
    planets: const [Graha.jupiter],
    isDosha: true,
  ));
  final grahan = [
    for (final g in [Graha.sun, Graha.moon])
      if (sameSign(g, Graha.rahu) || sameSign(g, Graha.ketu)) g,
  ];
  out.add(YogaResult(
    id: 'grahan', found: grahan.isNotEmpty, planets: grahan, isDosha: true));
  final shakata = houseFrom(Graha.moon, sign(Graha.jupiter).index);
  out.add(YogaResult(
    id: 'shakata',
    found: {6, 8, 12}.contains(shakata),
    cancelled: _kendra.contains(houseFrom(Graha.moon, lagna)),
    planets: const [Graha.moon, Graha.jupiter],
    isDosha: true,
    source: 'Phaladeepika 6',
  ));
  return out;
}

/// Mangal (Kuja) dosha: Mars in 1, 2, 4, 7, 8 or 12 counted from the
/// lagna, Moon or Venus, with the common cancellations.
YogaResult _mangal(ChartAnalysis a) {
  final c = a.chart;
  final mars = c.grahas[Graha.mars]!.rashi;
  final from = <(String, int)>[
    ('lagna', c.lagna.rashi.index),
    ('moon', c.grahas[Graha.moon]!.rashi.index),
    ('venus', c.grahas[Graha.venus]!.rashi.index),
  ];
  final hits = <(String, String)>[];
  for (final (name, s) in from) {
    final h = (mars.index - s) % 12 + 1;
    if (const {1, 2, 4, 7, 8, 12}.contains(h)) hits.add((name, '$h'));
  }
  final cancel = <(String, String)>[];
  final d = a.grahas[Graha.mars]!.dignity;
  if (d == Dignity.own || d == Dignity.moolatrikona || d == Dignity.exalted) {
    cancel.add(('marsStrong', mars.label));
  }
  if (c.grahas[Graha.jupiter]!.rashi == mars) cancel.add(('withJupiter', ''));
  if (c.grahas[Graha.moon]!.rashi == mars) cancel.add(('withMoon', ''));
  // House-and-sign exceptions (lagna-based house).
  const signExceptions = {
    1: [Rashi.leo, Rashi.aquarius],
    2: [Rashi.gemini, Rashi.virgo],
    4: [Rashi.aries, Rashi.scorpio],
    7: [Rashi.cancer, Rashi.capricorn],
    8: [Rashi.sagittarius, Rashi.pisces],
    12: [Rashi.taurus, Rashi.libra],
  };
  final lagnaHouse = (mars.index - c.lagna.rashi.index) % 12 + 1;
  if (signExceptions[lagnaHouse]?.contains(mars) ?? false) {
    cancel.add(('signException', '$lagnaHouse'));
  }
  return YogaResult(
    id: 'mangal',
    found: hits.isNotEmpty,
    cancelled: hits.isNotEmpty && cancel.isNotEmpty,
    planets: const [Graha.mars],
    detail: [...hits, ...cancel],
    isDosha: true,
  );
}

/// Kaal Sarp: all seven grahas on one side of the Rahu–Ketu axis. Named by
/// Rahu's house from the lagna (Anant … Sheshnag).
YogaResult _kaalSarp(ChartAnalysis a) {
  final c = a.chart;
  final rahu = c.grahas[Graha.rahu]!.longitude;
  bool ahead(Graha g) => norm360(c.grahas[g]!.longitude - rahu) < 180;
  final sides = _sevenGrahas.map(ahead).toSet();
  final rahuHouse = c.grahas[Graha.rahu]!.house;
  return YogaResult(
    id: 'kaalSarp',
    found: sides.length == 1,
    planets: const [Graha.rahu, Graha.ketu],
    detail: [('type', kaalSarpNames[rahuHouse - 1])],
    isDosha: true,
  );
}

const kaalSarpNames = [
  'Anant', 'Kulik', 'Vasuki', 'Shankhpal', 'Padma', 'Mahapadma',
  'Takshak', 'Karkotak', 'Shankhachud', 'Ghatak', 'Vishdhar', 'Sheshnag',
];
