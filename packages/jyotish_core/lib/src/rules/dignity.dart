import '../model/enums.dart';
import 'relationships.dart';

/// Exaltation sign and deepest degree (BPHS ch. 3).
const exaltation = {
  Graha.sun: (Rashi.aries, 10.0),
  Graha.moon: (Rashi.taurus, 3.0),
  Graha.mars: (Rashi.capricorn, 28.0),
  Graha.mercury: (Rashi.virgo, 15.0),
  Graha.jupiter: (Rashi.cancer, 5.0),
  Graha.venus: (Rashi.pisces, 27.0),
  Graha.saturn: (Rashi.libra, 20.0),
};

/// Moolatrikona sign and degree range [from, to) (BPHS ch. 3).
const moolatrikona = {
  Graha.sun: (Rashi.leo, 0.0, 20.0),
  Graha.moon: (Rashi.taurus, 3.0, 30.0),
  Graha.mars: (Rashi.aries, 0.0, 12.0),
  Graha.mercury: (Rashi.virgo, 15.0, 20.0),
  Graha.jupiter: (Rashi.sagittarius, 0.0, 10.0),
  Graha.venus: (Rashi.libra, 0.0, 15.0),
  Graha.saturn: (Rashi.aquarius, 0.0, 20.0),
};

enum Dignity {
  exalted('Exalted'),
  moolatrikona('Moolatrikona'),
  own('Own sign'),
  greatFriend("Great friend's sign"),
  friend("Friend's sign"),
  neutral('Neutral sign'),
  enemy("Enemy's sign"),
  greatEnemy("Great enemy's sign"),
  debilitated('Debilitated');

  const Dignity(this.label);
  final String label;
}

Rashi debilitationSign(Graha g) =>
    Rashi.values[(exaltation[g]!.$1.index + 6) % 12];

/// Dignity of one of the seven grahas at [lon]. [compoundTo] gives the
/// graha's compound relationship to the lord of the sign it occupies (so
/// friend/enemy signs reflect this chart, as in Parashari practice).
/// Returns null for Rahu, Ketu and the outer planets (no agreed scheme).
Dignity? dignityOf(Graha g, double lon,
    {Relation Function(Graha signLord)? compoundTo}) {
  if (!sevenGrahas.contains(g)) return null;
  final sign = Rashi.ofLongitude(lon);
  final deg = norm360(lon) % 30;
  final (exSign, _) = exaltation[g]!;
  final (mtSign, mtFrom, mtTo) = moolatrikona[g]!;

  // Moon (Taurus) and Mercury (Virgo) have exaltation and moolatrikona in
  // the same sign: exaltation covers the degrees before moolatrikona.
  if (sign == mtSign && deg >= mtFrom && deg < mtTo) return Dignity.moolatrikona;
  if (sign == exSign) {
    if (exSign == mtSign && deg >= mtTo) return Dignity.own; // Mercury 20–30
    return Dignity.exalted;
  }
  if (sign == debilitationSign(g)) return Dignity.debilitated;
  if (sign.lord == g) return Dignity.own;

  final rel = compoundTo?.call(sign.lord) ??
      naturalRelation(g, sign.lord);
  return switch (rel) {
    Relation.greatFriend => Dignity.greatFriend,
    Relation.friend => Dignity.friend,
    Relation.neutral => Dignity.neutral,
    Relation.enemy => Dignity.enemy,
    Relation.greatEnemy => Dignity.greatEnemy,
  };
}

/// Combustion orbs in degrees from the Sun (Surya Siddhanta / common use).
/// Mercury and Venus have smaller orbs when retrograde.
double? combustionOrb(Graha g, {required bool retrograde}) => switch (g) {
      Graha.moon => 12,
      Graha.mars => 17,
      Graha.mercury => retrograde ? 12 : 14,
      Graha.jupiter => 11,
      Graha.venus => retrograde ? 8 : 10,
      Graha.saturn => 15,
      _ => null,
    };

/// Angular distance 0..180.
double separation(double a, double b) {
  final d = norm360(a - b);
  return d > 180 ? 360 - d : d;
}
