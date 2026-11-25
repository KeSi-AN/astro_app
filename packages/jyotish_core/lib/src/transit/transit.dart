import '../chart/rasi_chart.dart';
import '../ephemeris/ephemeris.dart';
import '../model/enums.dart';
import '../model/settings.dart';
import '../strength/ashtakavarga.dart';

/// Grahas followed in transits.
const transitGrahas = [
  Graha.sun, Graha.moon, Graha.mars, Graha.mercury, Graha.jupiter,
  Graha.venus, Graha.saturn, Graha.rahu, Graha.ketu,
];

/// Classical gochara: houses from the natal Moon where each graha gives
/// good results (Phaladeepika ch. 26), and the vedha house that blocks
/// each good house.
const _goodFromMoon = <Graha, Map<int, int>>{
  // good house : vedha house
  Graha.sun: {3: 9, 6: 12, 10: 4, 11: 5},
  Graha.moon: {1: 5, 3: 9, 6: 12, 7: 2, 10: 4, 11: 8},
  Graha.mars: {3: 12, 6: 9, 11: 5},
  Graha.mercury: {2: 5, 4: 3, 6: 9, 8: 1, 10: 8, 11: 12},
  Graha.jupiter: {2: 12, 5: 4, 7: 3, 9: 10, 11: 8},
  Graha.venus: {1: 8, 2: 7, 3: 1, 4: 10, 5: 9, 8: 5, 9: 11, 11: 3, 12: 6},
  Graha.saturn: {3: 12, 6: 9, 11: 5},
  Graha.rahu: {3: 12, 6: 9, 11: 5},
  Graha.ketu: {3: 12, 6: 9, 11: 5},
};

/// Pairs that do not cause vedha to each other (Sun–Saturn, Moon–Mercury).
bool _vedhaExempt(Graha a, Graha b) =>
    {a, b}.containsAll({Graha.sun, Graha.saturn}) ||
    {a, b}.containsAll({Graha.moon, Graha.mercury});

enum GocharaResult { good, goodButVedha, bad }

class TransitInfo {
  const TransitInfo({
    required this.graha,
    required this.longitude,
    required this.speed,
    required this.houseFromLagna,
    required this.houseFromMoon,
    required this.gochara,
    required this.vedhaBy,
    required this.savBindus,
    required this.bavBindus,
  });

  final Graha graha;
  final double longitude;
  final double speed;
  final int houseFromLagna;
  final int houseFromMoon;
  final GocharaResult gochara;

  /// The graha in the vedha house, if any.
  final Graha? vedhaBy;

  /// Sarvashtakavarga bindus of the sign it transits (natal SAV).
  final int savBindus;

  /// Its own Bhinnashtakavarga bindus in that sign (seven grahas only).
  final int? bavBindus;

  Rashi get rashi => Rashi.ofLongitude(longitude);
  bool get retrograde => graha.isNode || speed < 0;
}

/// Transit positions at [jdUt] read against a natal chart.
class TransitChart {
  TransitChart._(this.natal, this.jdUt, this.positions, this.infos);

  final RasiChart natal;
  final double jdUt;
  final Map<Graha, double> positions;
  final Map<Graha, TransitInfo> infos;

  static TransitChart at(
    Ephemeris eph,
    RasiChart natal,
    double jdUt, {
    CalcSettings? settings,
  }) {
    final s = settings ?? natal.settings;
    final pos = <Graha, double>{};
    final speed = <Graha, double>{};
    for (final g in transitGrahas) {
      final p = eph.position(jdUt, g, s);
      pos[g] = p.longitude;
      speed[g] = p.speed;
    }
    final av = Ashtakavarga.of(natal);
    final sav = av.sav;
    final lagna = natal.lagna.rashi.index;
    final moon = natal.grahas[Graha.moon]!.rashi.index;
    int houseFrom(int from, double lon) =>
        (Rashi.ofLongitude(lon).index - from) % 12 + 1;

    final infos = <Graha, TransitInfo>{};
    for (final g in transitGrahas) {
      final fromMoon = houseFrom(moon, pos[g]!);
      final good = _goodFromMoon[g]!;
      var result = GocharaResult.bad;
      Graha? vedhaBy;
      if (good.containsKey(fromMoon)) {
        result = GocharaResult.good;
        final vedhaHouse = good[fromMoon]!;
        for (final other in transitGrahas) {
          if (other == g || _vedhaExempt(g, other)) continue;
          if (houseFrom(moon, pos[other]!) == vedhaHouse) {
            result = GocharaResult.goodButVedha;
            vedhaBy = other;
            break;
          }
        }
      }
      final signIdx = Rashi.ofLongitude(pos[g]!).index;
      infos[g] = TransitInfo(
        graha: g,
        longitude: pos[g]!,
        speed: speed[g]!,
        houseFromLagna: houseFrom(lagna, pos[g]!),
        houseFromMoon: fromMoon,
        gochara: result,
        vedhaBy: vedhaBy,
        savBindus: sav[signIdx],
        bavBindus: avGrahas.contains(g) ? av.bav(g)[signIdx] : null,
      );
    }
    return TransitChart._(natal, jdUt, pos, infos);
  }
}

// ---------------------------------------------------------------------------
// Transit search

enum TransitTarget { sign, nakshatra, degree, natalPoint }

class TransitEvent {
  const TransitEvent(this.graha, this.jdUt, this.description, {this.retrograde = false});
  final Graha graha;
  final double jdUt;

  /// Machine-readable key, e.g. 'sign:5' (enters Leo), 'nak:3', 'deg:120.5'.
  final String description;
  final bool retrograde;
}

/// Times when [graha] reaches longitude [target] between [from] and [to]
/// (both directions, so retrograde passes are included).
List<TransitEvent> findCrossings(
  Ephemeris eph,
  Graha graha,
  double target,
  double from,
  double to, {
  CalcSettings settings = const CalcSettings(),
  String description = '',
}) {
  double diff(double jd) {
    var d = eph.position(jd, graha, settings).longitude - target;
    d = d % 360;
    if (d > 180) d -= 360;
    return d;
  }

  // Step size: well under the time to move 180° even for the Moon.
  final step = switch (graha) {
    Graha.moon => 0.5,
    Graha.sun || Graha.mercury || Graha.venus || Graha.mars => 2.0,
    _ => 5.0,
  };
  final out = <TransitEvent>[];
  var t = from;
  var d0 = diff(t);
  while (t < to) {
    final t1 = (t + step).clamp(from, to).toDouble();
    final d1 = diff(t1);
    if (d0.sign != d1.sign && (d0 - d1).abs() < 90) {
      var lo = t, hi = t1, dlo = d0;
      for (var i = 0; i < 40; i++) {
        final mid = (lo + hi) / 2, dm = diff(mid);
        if (dm.sign == dlo.sign) {
          lo = mid;
          dlo = dm;
        } else {
          hi = mid;
        }
      }
      final speed = eph.position(hi, graha, settings).speed;
      out.add(TransitEvent(graha, hi, description, retrograde: speed < 0));
    }
    t = t1;
    d0 = d1;
    if (t1 >= to) break;
  }
  return out;
}

/// Sign ingresses of [graha] between [from] and [to].
List<TransitEvent> signIngresses(
  Ephemeris eph,
  Graha graha,
  double from,
  double to, {
  CalcSettings settings = const CalcSettings(),
}) {
  final out = <TransitEvent>[];
  for (var s = 0; s < 12; s++) {
    out.addAll(findCrossings(eph, graha, s * 30.0, from, to,
        settings: settings, description: 'sign:$s'));
  }
  // Nodes move backwards: the sign entered is the one below the boundary.
  return [
    for (final e in out)
      graha.isNode || e.retrograde
          ? TransitEvent(e.graha, e.jdUt,
              'sign:${(int.parse(e.description.substring(5)) + 11) % 12}',
              retrograde: true)
          : e,
  ]..sort((a, b) => a.jdUt.compareTo(b.jdUt));
}
