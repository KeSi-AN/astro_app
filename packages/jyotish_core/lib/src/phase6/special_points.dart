import '../chart/chart_analysis.dart';
import '../chart/rasi_chart.dart';
import '../dasha/dasha.dart';
import '../ephemeris/ephemeris.dart';
import '../model/enums.dart';
import '../rules/dignity.dart';

// ---------------------------------------------------------------------------
// Upagrahas (BPHS ch. 3)

enum Upagraha {
  dhuma, vyatipata, parivesha, indrachapa, upaketu,
  kaala, mrityu, arthaprahara, yamaghantaka, gulika, maandi,
}

/// Longitudes of the eleven upagrahas.
///
/// Sun-based five: Dhuma = Sun + 133°20′, Vyatipata = 360° − Dhuma,
/// Parivesha = Vyatipata + 180°, Indrachapa = 360° − Parivesha,
/// Upaketu = Indrachapa + 16°40′.
///
/// Time-based: the day (or night) is split into eight parts ruled from the
/// weekday lord (night: from the 5th weekday lord); the upagraha is the
/// lagna at the start of its lord's part (Kaala = Sun, Mrityu = Mars,
/// Arthaprahara = Mercury, Yamaghantaka = Jupiter, Gulika = Saturn) and
/// Maandi the lagna at the middle of Saturn's part.
Map<Upagraha, double> upagrahas(ChartAnalysis a, Ephemeris eph) {
  final c = a.chart;
  final out = <Upagraha, double>{};
  final dhuma = norm360(c.grahas[Graha.sun]!.longitude + 133 + 1 / 3);
  final vyati = norm360(360 - dhuma);
  final pari = norm360(vyati + 180);
  final indra = norm360(360 - pari);
  out[Upagraha.dhuma] = dhuma;
  out[Upagraha.vyatipata] = vyati;
  out[Upagraha.parivesha] = pari;
  out[Upagraha.indrachapa] = indra;
  out[Upagraha.upaketu] = norm360(indra + 16 + 2 / 3);

  final p = a.panchang;
  if (p.sunriseJd == null || p.sunsetJd == null || p.nextSunriseJd == null) {
    return out;
  }
  final day = c.jdUt < p.sunsetJd!;
  final start = day ? p.sunriseJd! : p.sunsetJd!;
  final part = ((day ? p.sunsetJd! : p.nextSunriseJd!) - start) / 8;
  // Weekday order Sun..Sat; day parts start from the weekday lord, night
  // parts from the 5th lord counted from it.
  const week = [
    Graha.sun, Graha.moon, Graha.mars, Graha.mercury,
    Graha.jupiter, Graha.venus, Graha.saturn,
  ];
  final first = (week.indexOf(p.varaLord) + (day ? 0 : 4)) % 7;
  int partOf(Graha g) => (week.indexOf(g) - first) % 7;
  double lagnaAt(double jd) => eph
      .houses(jd, c.birth.latitude, c.birth.longitude, HouseSystem.wholeSign,
          c.settings)
      .ascendant;
  for (final (u, g) in [
    (Upagraha.kaala, Graha.sun),
    (Upagraha.mrityu, Graha.mars),
    (Upagraha.arthaprahara, Graha.mercury),
    (Upagraha.yamaghantaka, Graha.jupiter),
    (Upagraha.gulika, Graha.saturn),
  ]) {
    out[u] = lagnaAt(start + partOf(g) * part);
  }
  out[Upagraha.maandi] = lagnaAt(start + (partOf(Graha.saturn) + 0.5) * part);
  return out;
}

// ---------------------------------------------------------------------------
// Avasthas

enum Baladi { bala, kumara, yuva, vriddha, mrita }

enum Jagratadi { jagrat, swapna, sushupta }

enum Deeptadi { deepta, swastha, mudita, shanta, deena, dukhita, khala, kopa }

/// Baladi: 6° parts, Bala→Mrita in odd signs, reversed in even signs.
Baladi baladi(double lon) {
  final deg = norm360(lon) % 30;
  final i = (deg / 6).floor().clamp(0, 4);
  final odd = Rashi.ofLongitude(lon).index.isEven;
  return Baladi.values[odd ? i : 4 - i];
}

/// Jagratadi by degrees (as AstroSage): 10° parts, Jagrat→Sushupta in odd
/// signs, reversed in even signs.
Jagratadi jagratadi(double lon) {
  final deg = norm360(lon) % 30;
  final i = (deg / 10).floor().clamp(0, 2);
  final odd = Rashi.ofLongitude(lon).index.isEven;
  return Jagratadi.values[odd ? i : 2 - i];
}

/// Deeptadi (Phaladeepika ch. 3): combust → Kopa; otherwise by dignity.
Deeptadi deeptadi(GrahaInfo info) {
  if (info.combust) return Deeptadi.kopa;
  return switch (info.dignity) {
    Dignity.exalted => Deeptadi.deepta,
    Dignity.moolatrikona || Dignity.own => Deeptadi.swastha,
    Dignity.greatFriend => Deeptadi.mudita,
    Dignity.friend => Deeptadi.shanta,
    Dignity.neutral => Deeptadi.deena,
    Dignity.enemy || Dignity.greatEnemy => Deeptadi.dukhita,
    Dignity.debilitated => Deeptadi.khala,
    null => Deeptadi.deena,
  };
}

// ---------------------------------------------------------------------------
// Arudha padas (BPHS ch. 29 / Jaimini)

/// Arudha of each house 1..12 (index 0 = A1 = Arudha Lagna; A12 = Upapada).
/// Count from the house to its lord, then as many again; if that lands in
/// the house itself or the 7th from it, take the 10th from there.
/// Scorpio and Aquarius use the stronger of their two lords (Chara dasha
/// rules).
List<Rashi> arudhas(RasiChart chart) {
  final chara = CharaDasha(chart: chart, birthJd: chart.jdUt);
  final lagna = chart.lagna.rashi.index;
  return [
    for (var h = 0; h < 12; h++)
      () {
        final sign = (lagna + h) % 12;
        final lord = chara.lordOf(Rashi.values[sign]);
        final at = chart.grahas[lord]!.rashi.index;
        final n = (at - sign) % 12;
        var pada = (at + n) % 12;
        if (pada == sign || pada == (sign + 6) % 12) pada = (pada + 9) % 12;
        return Rashi.values[pada];
      }(),
  ];
}

// ---------------------------------------------------------------------------
// Navatara (Tarabala from the birth star)

const navataraNames = [
  'Janma', 'Sampat', 'Vipat', 'Kshema', 'Pratyari', 'Sadhaka', 'Vadha',
  'Mitra', 'Ati-mitra',
];

/// For each of the 9 taras, the three nakshatras (from the Moon's).
List<List<Nakshatra>> navatara(Nakshatra janma) => [
      for (var t = 0; t < 9; t++)
        [for (var cycle = 0; cycle < 3; cycle++)
          Nakshatra.values[(janma.index + t + 9 * cycle) % 27]],
    ];
