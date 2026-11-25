import '../chart/chart_analysis.dart';
import '../model/enums.dart';
import '../phase6/yogas.dart';
import '../rules/avakhada.dart';
import '../rules/relationships.dart';

/// The eight kootas of Ashtakoota (Guna Milan), Muhurta Chintamani,
/// vivaha prakarana.
enum Koota {
  varna(1),
  vashya(2),
  tara(3),
  yoni(4),
  grahaMaitri(5),
  gana(6),
  bhakoot(7),
  nadi(8);

  const Koota(this.max);
  final double max;
}

class KootaScore {
  const KootaScore(this.koota, this.points, this.boy, this.girl,
      {this.cancelled = false});
  final Koota koota;
  final double points;

  /// What each side has for this koota (e.g. 'Kshatriya', 'Deva', 'Adi').
  final String boy, girl;

  /// A dosha (0 points in Bhakoot or Nadi) that a classical exception
  /// cancels. The score is not changed; the app shows a note.
  final bool cancelled;
}

/// One partner's Moon facts used in matching.
class MatchSide {
  MatchSide(this.analysis) : avakhada = analysis.avakhada;
  final ChartAnalysis analysis;
  final Avakhada avakhada;

  Rashi get rashi => analysis.chart.grahas[Graha.moon]!.rashi;
  Nakshatra get nakshatra => analysis.chart.grahas[Graha.moon]!.nakshatra;
  int get pada => analysis.chart.grahas[Graha.moon]!.pada;
}

class Ashtakoota {
  Ashtakoota._(this.boy, this.girl, this.kootas, this.boyMangal,
      this.girlMangal);

  final MatchSide boy, girl;
  final List<KootaScore> kootas;
  final YogaResult boyMangal, girlMangal;

  double get total => kootas.fold(0, (s, k) => s + k.points);

  /// Present before cancellations.
  bool get nadiDosha => kootas[Koota.nadi.index].points == 0;
  bool get bhakootDosha => kootas[Koota.bhakoot.index].points == 0;

  /// Mangal dosha is considered matched when both or neither have it.
  bool get mangalCompatible => boyMangal.present == girlMangal.present;

  static Ashtakoota of(ChartAnalysis boyChart, ChartAnalysis girlChart) {
    final b = MatchSide(boyChart), g = MatchSide(girlChart);
    final out = <KootaScore>[];

    // Varna: the boy's varna must be equal or higher.
    const varnaRank = {'Brahmin': 4, 'Kshatriya': 3, 'Vaishya': 2, 'Shudra': 1};
    final vb = b.avakhada.varna, vg = g.avakhada.varna;
    out.add(KootaScore(Koota.varna,
        varnaRank[vb]! >= varnaRank[vg]! ? 1 : 0, vb, vg));

    // Vashya (boy row, girl column).
    const vashyaOrder = ['Chatushpada', 'Manava', 'Jalachara', 'Vanachara', 'Keeta'];
    const vashyaTable = [
      [2.0, 1, 1, 0.5, 1],
      [1.0, 2, 0.5, 0, 1],
      [1.0, 0.5, 2, 1, 1],
      [0.0, 0, 0, 2, 0],
      [1.0, 1, 1, 0, 2],
    ];
    final wb = b.avakhada.vashya, wg = g.avakhada.vashya;
    out.add(KootaScore(
        Koota.vashya,
        vashyaTable[vashyaOrder.indexOf(wb)][vashyaOrder.indexOf(wg)]
            .toDouble(),
        wb,
        wg));

    // Tara: count both ways; remainders 3, 5, 7 (of 9) are inauspicious.
    bool goodTara(Nakshatra from, Nakshatra to) {
      final n = (to.index - from.index) % 27 + 1;
      return !const {3, 5, 7}.contains(n % 9);
    }

    final t1 = goodTara(g.nakshatra, b.nakshatra);
    final t2 = goodTara(b.nakshatra, g.nakshatra);
    out.add(KootaScore(Koota.tara, (t1 ? 1.5 : 0) + (t2 ? 1.5 : 0),
        b.nakshatra.label, g.nakshatra.label));

    // Yoni.
    final yb = b.avakhada.yoni, yg = g.avakhada.yoni;
    out.add(KootaScore(Koota.yoni,
        _yoniTable[_yonis.indexOf(yb)][_yonis.indexOf(yg)].toDouble(), yb, yg));

    // Graha Maitri: relationship of the Moon-sign lords, both ways.
    final lb = b.rashi.lord, lg = g.rashi.lord;
    out.add(KootaScore(Koota.grahaMaitri, _maitri(lb, lg), lb.label, lg.label));

    // Gana (boy row, girl column).
    const ganaOrder = ['Deva', 'Manushya', 'Rakshasa'];
    const ganaTable = [
      [6.0, 6, 1],
      [5.0, 6, 0],
      [1.0, 0, 6],
    ];
    final gb = b.avakhada.gana, gg = g.avakhada.gana;
    out.add(KootaScore(Koota.gana,
        ganaTable[ganaOrder.indexOf(gb)][ganaOrder.indexOf(gg)].toDouble(), gb, gg));

    // Bhakoot: 2/12, 5/9 and 6/8 placements of the Moon signs are doshas.
    final d = (g.rashi.index - b.rashi.index) % 12 + 1;
    final bhakootBad = const {2, 12, 5, 9, 6, 8}.contains(d);
    // Exception: same sign lord, or the lords are natural friends both ways.
    final bhakootCancel = bhakootBad &&
        (lb == lg ||
            (naturalRelation(lb, lg) == Relation.friend &&
                naturalRelation(lg, lb) == Relation.friend));
    out.add(KootaScore(Koota.bhakoot, bhakootBad ? 0 : 7, b.rashi.label,
        g.rashi.label,
        cancelled: bhakootCancel));

    // Nadi: same nadi is a dosha. Exceptions: same rashi with different
    // nakshatras, or same nakshatra in different rashis or padas.
    final nb = b.avakhada.nadi, ng = g.avakhada.nadi;
    final nadiBad = nb == ng;
    final nadiCancel = nadiBad &&
        ((b.rashi == g.rashi && b.nakshatra != g.nakshatra) ||
            (b.nakshatra == g.nakshatra &&
                (b.rashi != g.rashi || b.pada != g.pada)));
    out.add(KootaScore(Koota.nadi, nadiBad ? 0 : 8, nb, ng,
        cancelled: nadiCancel));

    YogaResult mangal(ChartAnalysis a) =>
        yogas(a).firstWhere((y) => y.id == 'mangal');
    return Ashtakoota._(b, g, out, mangal(boyChart), mangal(girlChart));
  }
}

double _maitri(Graha a, Graha b) {
  if (a == b) return 5;
  final ab = naturalRelation(a, b), ba = naturalRelation(b, a);
  int s(Relation r) => switch (r) {
        Relation.friend || Relation.greatFriend => 2,
        Relation.neutral => 1,
        _ => 0,
      };
  return switch ((s(ab), s(ba))) {
    (2, 2) => 5,
    (2, 1) || (1, 2) => 4,
    (1, 1) => 3,
    (2, 0) || (0, 2) => 1,
    (1, 0) || (0, 1) => 0.5,
    _ => 0,
  };
}

const _yonis = [
  'Horse', 'Elephant', 'Sheep', 'Serpent', 'Dog', 'Cat', 'Rat', 'Cow',
  'Buffalo', 'Tiger', 'Deer', 'Monkey', 'Mongoose', 'Lion',
];

const _yoniTable = [
  [4, 2, 2, 3, 2, 2, 2, 1, 0, 1, 3, 3, 2, 1],
  [2, 4, 3, 3, 2, 2, 2, 2, 3, 1, 2, 3, 2, 0],
  [2, 3, 4, 2, 1, 2, 1, 3, 3, 1, 2, 0, 3, 1],
  [3, 3, 2, 4, 2, 1, 1, 1, 1, 2, 2, 2, 0, 2],
  [2, 2, 1, 2, 4, 2, 1, 2, 2, 1, 0, 2, 1, 1],
  [2, 2, 2, 1, 2, 4, 0, 2, 2, 1, 3, 3, 2, 1],
  [2, 2, 1, 1, 1, 0, 4, 2, 2, 2, 2, 2, 1, 2],
  [1, 2, 3, 1, 2, 2, 2, 4, 3, 0, 3, 2, 2, 1],
  [0, 3, 3, 1, 2, 2, 2, 3, 4, 1, 2, 2, 2, 1],
  [1, 1, 1, 2, 1, 1, 2, 0, 1, 4, 1, 1, 2, 1],
  [3, 2, 2, 2, 0, 3, 2, 3, 2, 1, 4, 2, 2, 1],
  [3, 3, 0, 2, 2, 3, 2, 2, 2, 1, 2, 4, 3, 2],
  [2, 2, 3, 0, 1, 2, 1, 2, 2, 2, 2, 3, 4, 2],
  [1, 0, 1, 2, 1, 1, 2, 1, 1, 1, 1, 2, 2, 4],
];

/// Yoni points (0–4) between two yoni animals.
double yoniPoints(String a, String b) =>
    _yoniTable[_yonis.indexOf(a)][_yonis.indexOf(b)].toDouble();

// ---------------------------------------------------------------------------
// South Indian 10 porutham

enum Porutham {
  dina, gana, mahendra, streeDeergha, yoni, rasi, rasiAdhipati, vasya,
  rajju, vedha,
}

enum PoruthamResult { good, average, bad }

enum Rajju { pada, kati, nabhi, kanta, siro }

Rajju rajjuOf(Nakshatra n) => const [
      Rajju.pada, Rajju.kati, Rajju.nabhi, Rajju.kanta, Rajju.siro,
      Rajju.kanta, Rajju.nabhi, Rajju.kati, Rajju.pada,
    ][n.index % 9];

/// Vedha (mutually afflicting) nakshatra pairs.
const _vedhaPairs = <Set<Nakshatra>>[
  {Nakshatra.ashwini, Nakshatra.jyeshtha},
  {Nakshatra.bharani, Nakshatra.anuradha},
  {Nakshatra.krittika, Nakshatra.vishakha},
  {Nakshatra.rohini, Nakshatra.swati},
  {Nakshatra.ardra, Nakshatra.shravana},
  {Nakshatra.punarvasu, Nakshatra.uttaraAshadha},
  {Nakshatra.pushya, Nakshatra.purvaAshadha},
  {Nakshatra.ashlesha, Nakshatra.mula},
  {Nakshatra.magha, Nakshatra.revati},
  {Nakshatra.purvaPhalguni, Nakshatra.uttaraBhadrapada},
  {Nakshatra.uttaraPhalguni, Nakshatra.purvaBhadrapada},
  {Nakshatra.hasta, Nakshatra.shatabhisha},
  {Nakshatra.mrigashira, Nakshatra.chitra},
  {Nakshatra.mrigashira, Nakshatra.dhanishta},
  {Nakshatra.chitra, Nakshatra.dhanishta},
];

bool isVedha(Nakshatra a, Nakshatra b) =>
    _vedhaPairs.any((p) => p.length == 2 && p.contains(a) && p.contains(b));

/// The ten poruthams, counted from the girl's star/sign to the boy's.
Map<Porutham, PoruthamResult> poruthams(Ashtakoota m) {
  final b = m.boy, g = m.girl;
  final n = (b.nakshatra.index - g.nakshatra.index) % 27 + 1;
  const good = PoruthamResult.good, avg = PoruthamResult.average,
      bad = PoruthamResult.bad;
  final rasiCount = (b.rashi.index - g.rashi.index) % 12 + 1;
  final lordRel = b.rashi.lord == g.rashi.lord
      ? Relation.friend
      : naturalRelation(g.rashi.lord, b.rashi.lord);
  final gb = b.avakhada.gana, gg = g.avakhada.gana;
  return {
    Porutham.dina: const {0, 2, 4, 6, 8}.contains(n % 9) ? good : bad,
    Porutham.gana: gb == gg ||
            (gg == 'Deva' && gb == 'Manushya') ||
            (gg == 'Manushya' && gb == 'Deva')
        ? good
        : (gg == 'Rakshasa' ? bad : avg),
    Porutham.mahendra:
        const {4, 7, 10, 13, 16, 19, 22, 25}.contains(n) ? good : bad,
    Porutham.streeDeergha: n > 13 ? good : (n >= 7 ? avg : bad),
    Porutham.yoni:
        yoniPoints(b.avakhada.yoni, g.avakhada.yoni) >= 2 ? good : bad,
    Porutham.rasi: rasiCount == 1 || rasiCount >= 7 ? good : bad,
    Porutham.rasiAdhipati: switch (lordRel) {
      Relation.friend || Relation.greatFriend => good,
      Relation.neutral => avg,
      _ => bad,
    },
    Porutham.vasya:
        m.kootas[Koota.vashya.index].points >= 1 ? good : bad,
    Porutham.rajju: rajjuOf(b.nakshatra) == rajjuOf(g.nakshatra) ? bad : good,
    Porutham.vedha: isVedha(b.nakshatra, g.nakshatra) ? bad : good,
  };
}
