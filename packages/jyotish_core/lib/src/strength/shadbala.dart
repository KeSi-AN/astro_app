import 'dart:math' as math;

import '../chart/chart_analysis.dart';
import '../ephemeris/ephemeris.dart';
import '../model/enums.dart';
import '../panchang/birth_panchang.dart';
import '../rules/dignity.dart';
import '../rules/relationships.dart';
import '../varga/varga.dart';

/// Shadbala of the seven grahas (BPHS ch. 27; computation as in
/// B.V. Raman, "Graha and Bhava Balas"). All values in virupas
/// (shashtiamsas); 60 virupas = 1 rupa.
///
/// Where texts differ, the choice made is noted next to the code and in
/// DIVERGENCES.md, so the astrologer can see why numbers may differ from
/// other software.
class GrahaShadbala {
  GrahaShadbala(this.graha);
  final Graha graha;

  // Sthana bala
  double uchcha = 0;
  double saptavargaja = 0;
  double ojayugma = 0;
  double kendradi = 0;
  double drekkana = 0;
  double get sthana => uchcha + saptavargaja + ojayugma + kendradi + drekkana;

  double dig = 0;

  // Kala bala
  double nathonnatha = 0;
  double paksha = 0;
  double tribhaga = 0;
  double abda = 0;
  double masa = 0;
  double vara = 0;
  double hora = 0;
  double ayana = 0;
  double yuddha = 0;
  double get kala =>
      nathonnatha + paksha + tribhaga + abda + masa + vara + hora + ayana + yuddha;

  double cheshta = 0;
  double naisargika = 0;
  double drik = 0;

  double get total => sthana + dig + kala + cheshta + naisargika + drik;
  double get rupas => total / 60;

  /// Minimum strength required (rupas), BPHS ch. 27.
  double get requiredRupas => _required[graha]!;
  double get ratio => rupas / requiredRupas;
}

const _required = {
  Graha.sun: 6.5, Graha.moon: 6.0, Graha.mars: 5.0, Graha.mercury: 7.0,
  Graha.jupiter: 6.5, Graha.venus: 5.5, Graha.saturn: 5.0,
};

const _naisargika = {
  Graha.sun: 60.0, Graha.moon: 51.43, Graha.venus: 42.85, Graha.jupiter: 34.28,
  Graha.mercury: 25.70, Graha.mars: 17.14, Graha.saturn: 8.57,
};

/// Bhava bala of one house, virupas.
class BhavaBala {
  BhavaBala(this.bhava);
  final int bhava;
  double lordStrength = 0;
  double dig = 0;
  double drishti = 0;
  double get total => lordStrength + dig + drishti;
  double get rupas => total / 60;
}

class Shadbala {
  Shadbala._(this.grahas, this.bhavas);

  final Map<Graha, GrahaShadbala> grahas;
  final List<BhavaBala> bhavas;

  /// Rank 1 = strongest, by total rupas.
  Map<Graha, int> get ranks {
    final sorted = sevenGrahas.toList()
      ..sort((a, b) => grahas[b]!.total.compareTo(grahas[a]!.total));
    return {for (var i = 0; i < 7; i++) sorted[i]: i + 1};
  }

  List<int> get bhavaRanks {
    final order = List.generate(12, (i) => i)
      ..sort((a, b) => bhavas[b].total.compareTo(bhavas[a].total));
    final r = List.filled(12, 0);
    for (var i = 0; i < 12; i++) {
      r[order[i]] = i + 1;
    }
    return r;
  }

  static Shadbala of(ChartAnalysis a, Ephemeris eph) {
    final c = a.chart;
    final b = c.birth;
    final out = {for (final g in sevenGrahas) g: GrahaShadbala(g)};
    double lon(Graha g) => c.grahas[g]!.longitude;
    final sun = lon(Graha.sun), moon = lon(Graha.moon);
    final elong = norm360(moon - sun);
    final waxing = elong < 180;
    final pakshaAngle = elong > 180 ? 360 - elong : elong;
    bool benefic(Graha g) =>
        g == Graha.jupiter || g == Graha.venus || g == Graha.mercury ||
        (g == Graha.moon && waxing);

    // ---- Sthana bala --------------------------------------------------
    const saptaVargas = [
      Varga.d1, Varga.d2, Varga.d3, Varga.d7, Varga.d9, Varga.d12, Varga.d30,
    ];
    for (final g in sevenGrahas) {
      final s = out[g]!;
      final l = lon(g);
      final (exSign, exDeg) = exaltation[g]!;
      s.uchcha = (180 - separation(l, exSign.index * 30 + exDeg)) / 3;

      // Saptavargaja: BPHS values. In D1 moolatrikona is judged by degree;
      // in the other vargas the moolatrikona sign counts as own sign.
      // Friend/enemy uses the compound relationship from the birth chart.
      for (final v in saptaVargas) {
        final sign = vargaSign(l, v);
        double pts;
        if (v == Varga.d1 &&
            moolatrikona[g]!.$1 == sign &&
            norm360(l) % 30 >= moolatrikona[g]!.$2 &&
            norm360(l) % 30 < moolatrikona[g]!.$3) {
          pts = 45;
        } else if (sign.lord == g) {
          pts = 30;
        } else {
          final rel = compoundRelation(naturalRelation(g, sign.lord),
              temporalRelation(c.grahas[g]!.rashi, c.grahas[sign.lord]!.rashi));
          pts = switch (rel) {
            Relation.greatFriend => 22.5,
            Relation.friend => 15,
            Relation.neutral => 7.5,
            Relation.enemy => 3.75,
            Relation.greatEnemy => 1.875,
          };
        }
        s.saptavargaja += pts;
      }

      // Odd/even sign and navamsha.
      final female = g == Graha.moon || g == Graha.venus;
      bool oddSign(Rashi r) => r.index.isEven;
      final rasiOk = oddSign(c.grahas[g]!.rashi) != female;
      final navOk = oddSign(vargaSign(l, Varga.d9)) != female;
      s.ojayugma = (rasiOk ? 15 : 0) + (navOk ? 15 : 0);

      // Kendradi by Sripati bhava (Raman).
      final bh = a.grahas[g]!.chalitBhava;
      s.kendradi = switch (bh % 3) { 1 => 60, 2 => 30, _ => 15 };

      // Drekkana: male in 1st decanate, neuter in 2nd, female in 3rd.
      final dec = (norm360(l) % 30 / 10).floor();
      final want = switch (g) {
        Graha.sun || Graha.mars || Graha.jupiter => 0,
        Graha.mercury || Graha.saturn => 1,
        _ => 2,
      };
      s.drekkana = dec == want ? 15 : 0;
    }

    // ---- Dig bala -----------------------------------------------------
    // Weakest point is opposite the house of strength: Sun/Mars strong in
    // the 10th (weak at the 4th madhya), Moon/Venus in the 4th, Saturn in
    // the 7th, Jupiter/Mercury in the 1st.
    final madhya = c.bhavas.madhya;
    for (final g in sevenGrahas) {
      final weak = switch (g) {
        Graha.sun || Graha.mars => madhya[3],
        Graha.moon || Graha.venus => madhya[9],
        Graha.saturn => madhya[0],
        _ => madhya[6],
      };
      out[g]!.dig = separation(lon(g), weak) / 3;
    }

    // ---- Kala bala ----------------------------------------------------
    final p = a.panchang;
    // Natonnata from local mean time: day planets strongest at noon,
    // night planets at midnight, Mercury always 60.
    final lmt = ((b.utHours + b.longitude / 15) % 24 + 24) % 24;
    final fromMidnight = lmt <= 12 ? lmt : 24 - lmt;
    final dayStrength = 60 * fromMidnight / 12;
    for (final g in sevenGrahas) {
      final s = out[g]!;
      s.nathonnatha = switch (g) {
        Graha.sun || Graha.jupiter || Graha.venus => dayStrength,
        Graha.moon || Graha.mars || Graha.saturn => 60 - dayStrength,
        _ => 60,
      };
      final pb = benefic(g) || g == Graha.moon
          ? pakshaAngle / 3
          : 60 - pakshaAngle / 3;
      s.paksha = g == Graha.moon ? 2 * pb : pb;
    }

    // Tribhaga: day in thirds (Mercury, Sun, Saturn), night in thirds
    // (Moon, Venus, Mars); Jupiter always gets 60.
    if (p.sunriseJd != null && p.sunsetJd != null && p.nextSunriseJd != null) {
      final jd = c.jdUt;
      Graha ruler;
      if (jd < p.sunsetJd!) {
        final third = (p.sunsetJd! - p.sunriseJd!) / 3;
        ruler = const [Graha.mercury, Graha.sun, Graha.saturn][
            ((jd - p.sunriseJd!) / third).floor().clamp(0, 2)];
      } else {
        final third = (p.nextSunriseJd! - p.sunsetJd!) / 3;
        ruler = const [Graha.moon, Graha.venus, Graha.mars][
            ((jd - p.sunsetJd!) / third).floor().clamp(0, 2)];
      }
      out[ruler]!.tribhaga = 60;
    }
    out[Graha.jupiter]!.tribhaga = 60;

    // Year, month, day and hora lords. Year and month lords are the lords
    // of the weekdays on which the Sun last entered Aries and its present
    // sign (sankranti method, as in Jagannatha Hora).
    final offset = (b.utcOffsetHours + b.dstHours) / 24;
    Graha weekdayLordAt(double jd) {
      final civil = DateTime.utc(-4713, 11, 24, 12)
          .add(Duration(milliseconds: ((jd + offset) * 86400000).round()));
      return varaLords[civil.weekday - 1];
    }

    final sunSidereal = sun;
    double lastIngress(double target) {
      var back = norm360(sunSidereal - target) / 0.9856 + 2;
      var lo = c.jdUt - back, hi = c.jdUt;
      for (var i = 0; i < 50; i++) {
        final mid = (lo + hi) / 2;
        final s = eph.position(mid, Graha.sun, c.settings).longitude;
        // Has the Sun passed [target] by [mid]?
        if (norm360(s - target) < norm360(sunSidereal - target) + 1e-9 &&
            norm360(s - target) < 180) {
          hi = mid;
        } else {
          lo = mid;
        }
      }
      return hi;
    }

    out[weekdayLordAt(lastIngress(0))]!.abda += 15;
    out[weekdayLordAt(lastIngress((sunSidereal ~/ 30) * 30.0))]!.masa += 30;
    out[p.varaLord]!.vara += 45;
    if (p.sunriseJd != null) {
      const horaOrder = [
        Graha.sun, Graha.venus, Graha.mercury, Graha.moon,
        Graha.saturn, Graha.jupiter, Graha.mars,
      ];
      final n = ((c.jdUt - p.sunriseJd!) * 24).floor();
      final start = horaOrder.indexOf(p.varaLord);
      out[horaOrder[(start + n) % 7]]!.hora = 60;
    }

    // Ayana bala from declination (Raman): north-strong planets gain with
    // north declination, Moon and Saturn with south; Mercury either way.
    // The Sun's ayana bala is doubled.
    for (final g in sevenGrahas) {
      final d = eph.declination(c.jdUt, g);
      final v = switch (g) {
        Graha.moon || Graha.saturn => (24 - d) / 48 * 60,
        Graha.mercury => (24 + d.abs()) / 48 * 60,
        _ => (24 + d) / 48 * 60,
      };
      out[g]!.ayana = g == Graha.sun ? 2 * v : v;
    }

    // ---- Cheshta bala -------------------------------------------------
    // Sun: its ayana bala (undoubled); Moon: its paksha bala (undoubled).
    // Others: cheshta kendra approximated by the angle between the
    // planet's heliocentric longitude and the Sun's geocentric longitude
    // (180° at opposition / inferior conjunction, when retrograde).
    final sunTropical = norm360(sun + c.ayanamsa);
    for (final g in sevenGrahas) {
      final s = out[g]!;
      s.cheshta = switch (g) {
        Graha.sun => s.ayana / 2,
        Graha.moon => s.paksha / 2,
        _ => separation(eph.heliocentricLongitude(c.jdUt, g), sunTropical) / 3,
      };
      s.naisargika = _naisargika[g]!;
    }

    // ---- Yuddha (planetary war) -----------------------------------------
    // Mars–Saturn within 1°: the one further north wins the difference of
    // their sthana + dig + kala strengths.
    const fighters = [Graha.mars, Graha.mercury, Graha.jupiter, Graha.venus, Graha.saturn];
    for (var i = 0; i < fighters.length; i++) {
      for (var j = i + 1; j < fighters.length; j++) {
        final x = fighters[i], y = fighters[j];
        if (separation(lon(x), lon(y)) >= 1) continue;
        final winner = c.grahas[x]!.latitude >= c.grahas[y]!.latitude ? x : y;
        final loser = winner == x ? y : x;
        double base(Graha g) => out[g]!.sthana + out[g]!.dig + out[g]!.kala;
        final diff = (base(winner) - base(loser)).abs();
        out[winner]!.yuddha += diff;
        out[loser]!.yuddha -= diff;
      }
    }

    // ---- Drik bala --------------------------------------------------------
    double aspectOn(Graha from, double target) {
      final d = norm360(target - lon(from));
      var v = _drishti(d);
      final house = ((norm360(target) ~/ 30) - c.grahas[from]!.rashi.index) % 12 + 1;
      if (from == Graha.mars && (house == 4 || house == 8)) v += 15;
      if (from == Graha.jupiter && (house == 5 || house == 9)) v += 30;
      if (from == Graha.saturn && (house == 3 || house == 10)) v += 45;
      return math.min(v, 60);
    }

    double drikOn(double target, {Graha? self}) {
      var quarter = 0.0, full = 0.0;
      for (final f in sevenGrahas) {
        if (f == self) continue;
        final v = aspectOn(f, target);
        if (f == Graha.jupiter || f == Graha.mercury) {
          full += v; // Jupiter's and Mercury's aspects are added in full.
        } else {
          quarter += benefic(f) ? v : -v;
        }
      }
      return quarter / 4 + full;
    }

    for (final g in sevenGrahas) {
      out[g]!.drik = drikOn(lon(g), self: g);
    }

    // ---- Bhava bala -------------------------------------------------------
    final bhavas = <BhavaBala>[];
    for (var i = 0; i < 12; i++) {
      final bb = BhavaBala(i + 1);
      final m = madhya[i];
      final sign = Rashi.ofLongitude(m);
      bb.lordStrength = out[sign.lord]!.total;
      final deg = norm360(m) % 30;
      final strongIn = switch (sign) {
        Rashi.gemini || Rashi.virgo || Rashi.libra || Rashi.aquarius => 1,
        Rashi.sagittarius => deg < 15 ? 1 : 10,
        Rashi.capricorn => deg < 15 ? 10 : 4,
        Rashi.cancer || Rashi.pisces => 4,
        Rashi.scorpio => 7,
        _ => 10, // Aries, Taurus, Leo (quadrupeds)
      };
      final n = ((i + 1) - strongIn).abs();
      final dist = math.min(n, 12 - n);
      bb.dig = (6 - dist) * 10.0;
      bb.drishti = drikOn(m);
      bhavas.add(bb);
    }

    return Shadbala._(out, bhavas);
  }
}

/// Aspect value (virupas) of a planet on a point [d] degrees ahead of it
/// (BPHS ch. 26 piecewise formula).
double _drishti(double d) {
  if (d < 30) return 0;
  if (d < 60) return (d - 30) / 2;
  if (d < 90) return d - 45;
  if (d < 120) return (120 - d) / 2 + 30;
  if (d < 150) return 150 - d;
  if (d < 180) return (d - 150) * 2;
  if (d < 300) return (300 - d) / 2;
  return 0;
}
