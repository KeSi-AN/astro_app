import '../model/enums.dart';

/// The sixteen Parashari divisional charts (BPHS ch. 6), in the order
/// AstroSage and most Indian software list them.
enum Varga {
  d1('Rasi', 1),
  d2('Hora', 2),
  d3('Drekkana', 3),
  d4('Chaturthamsha', 4),
  d7('Saptamsha', 7),
  d9('Navamsha', 9),
  d10('Dashamsha', 10),
  d12('Dwadashamsha', 12),
  d16('Shodashamsha', 16),
  d20('Vimshamsha', 20),
  d24('Chaturvimshamsha', 24),
  d27('Saptavimshamsha', 27),
  d30('Trimshamsha', 30),
  d40('Khavedamsha', 40),
  d45('Akshavedamsha', 45),
  d60('Shashtiamsha', 60);

  const Varga(this.label, this.division);
  final String label;
  final int division;

  String get code => 'D$division';
}

/// Sign of [lon] in [varga], by the Parashara rules of BPHS ch. 6.
Rashi vargaSign(double lon, Varga varga) {
  final l = norm360(lon);
  final sign = (l ~/ 30) % 12; // 0 = Aries
  final deg = l % 30;
  final odd = sign.isEven; // Aries (index 0) is an odd sign
  final movable = sign % 3 == 0, fixed = sign % 3 == 1;
  int part(int n) => (deg * n / 30).floor().clamp(0, n - 1);
  Rashi at(int index) => Rashi.values[index % 12];

  switch (varga) {
    case Varga.d1:
      return at(sign);
    case Varga.d2:
      // Odd signs: Sun's hora (Leo) then Moon's (Cancer); even: reverse.
      final first = deg < 15;
      return (odd == first) ? Rashi.leo : Rashi.cancer;
    case Varga.d3:
      // Same sign, then 5th, then 9th.
      return at(sign + const [0, 4, 8][part(3)]);
    case Varga.d4:
      // Same sign, 4th, 7th, 10th.
      return at(sign + 3 * part(4));
    case Varga.d7:
      // Odd signs start from themselves, even signs from the 7th.
      return at(sign + (odd ? 0 : 6) + part(7));
    case Varga.d9:
      // Movable from itself, fixed from the 9th, dual from the 5th — the
      // same as counting continuously from 0° Aries.
      return at((l * 9 / 30).floor());
    case Varga.d10:
      // Odd signs from themselves, even signs from the 9th.
      return at(sign + (odd ? 0 : 8) + part(10));
    case Varga.d12:
      return at(sign + part(12));
    case Varga.d16:
      // Movable from Aries, fixed from Leo, dual from Sagittarius.
      return at((movable ? 0 : fixed ? 4 : 8) + part(16));
    case Varga.d20:
      // Movable from Aries, fixed from Sagittarius, dual from Leo.
      return at((movable ? 0 : fixed ? 8 : 4) + part(20));
    case Varga.d24:
      // Odd signs from Leo, even signs from Cancer.
      return at((odd ? 4 : 3) + part(24));
    case Varga.d27:
      // Fire from Aries, earth from Cancer, air from Libra, water from
      // Capricorn — equal to counting continuously from 0° Aries.
      return at((l * 27 / 30).floor());
    case Varga.d30:
      return _trimshamsha(odd, deg);
    case Varga.d40:
      // Odd signs from Aries, even signs from Libra.
      return at((odd ? 0 : 6) + part(40));
    case Varga.d45:
      // Movable from Aries, fixed from Leo, dual from Sagittarius.
      return at((movable ? 0 : fixed ? 4 : 8) + part(45));
    case Varga.d60:
      // From the sign itself, half a degree each.
      return at(sign + part(60));
  }
}

/// Parashari trimshamsha: unequal parts ruled by the five tara grahas.
Rashi _trimshamsha(bool odd, double deg) {
  if (odd) {
    // Mars 5°, Saturn 5°, Jupiter 8°, Mercury 7°, Venus 5°.
    if (deg < 5) return Rashi.aries;
    if (deg < 10) return Rashi.aquarius;
    if (deg < 18) return Rashi.sagittarius;
    if (deg < 25) return Rashi.gemini;
    return Rashi.libra;
  }
  // Even signs in reverse: Venus 5°, Mercury 7°, Jupiter 8°, Saturn 5°, Mars 5°.
  if (deg < 5) return Rashi.taurus;
  if (deg < 12) return Rashi.virgo;
  if (deg < 20) return Rashi.pisces;
  if (deg < 25) return Rashi.capricorn;
  return Rashi.scorpio;
}

/// Position inside the varga sign, scaled back to 0–30° (the "degree"
/// most software prints in divisional charts).
double vargaDegree(double lon, Varga varga) =>
    (norm360(lon) * varga.division) % 30;
