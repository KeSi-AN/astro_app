import '../model/enums.dart';

/// Planetary relationships for the seven grahas (Sun..Saturn), BPHS ch. 3.
enum Relation {
  greatFriend('Great friend', 'GF'),
  friend('Friend', 'F'),
  neutral('Neutral', 'N'),
  enemy('Enemy', 'E'),
  greatEnemy('Great enemy', 'GE');

  const Relation(this.label, this.short);
  final String label;
  final String short;
}

const sevenGrahas = [
  Graha.sun, Graha.moon, Graha.mars, Graha.mercury,
  Graha.jupiter, Graha.venus, Graha.saturn,
];

const _f = Relation.friend, _n = Relation.neutral, _e = Relation.enemy;

/// Natural (naisargika) relationship of [a] towards [b].
const _natural = <Graha, Map<Graha, Relation>>{
  Graha.sun: {Graha.moon: _f, Graha.mars: _f, Graha.mercury: _n, Graha.jupiter: _f, Graha.venus: _e, Graha.saturn: _e},
  Graha.moon: {Graha.sun: _f, Graha.mars: _n, Graha.mercury: _f, Graha.jupiter: _n, Graha.venus: _n, Graha.saturn: _n},
  Graha.mars: {Graha.sun: _f, Graha.moon: _f, Graha.mercury: _e, Graha.jupiter: _f, Graha.venus: _n, Graha.saturn: _n},
  Graha.mercury: {Graha.sun: _f, Graha.moon: _e, Graha.mars: _n, Graha.jupiter: _n, Graha.venus: _f, Graha.saturn: _n},
  Graha.jupiter: {Graha.sun: _f, Graha.moon: _f, Graha.mars: _f, Graha.mercury: _e, Graha.venus: _e, Graha.saturn: _n},
  Graha.venus: {Graha.sun: _e, Graha.moon: _e, Graha.mars: _n, Graha.mercury: _f, Graha.jupiter: _n, Graha.saturn: _f},
  Graha.saturn: {Graha.sun: _e, Graha.moon: _e, Graha.mars: _e, Graha.mercury: _f, Graha.jupiter: _n, Graha.venus: _f},
};

Relation naturalRelation(Graha a, Graha b) {
  if (a == b) throw ArgumentError('Same graha');
  return _natural[a]![b]!;
}

/// Temporal (tatkalika): friend if [b] sits in the 2nd, 3rd, 4th, 10th,
/// 11th or 12th sign counted from [a]; otherwise enemy.
Relation temporalRelation(Rashi a, Rashi b) {
  final house = (b.index - a.index) % 12 + 1;
  return const {2, 3, 4, 10, 11, 12}.contains(house)
      ? Relation.friend
      : Relation.enemy;
}

/// Compound (panchadha) relationship from natural + temporal.
Relation compoundRelation(Relation natural, Relation temporal) {
  final score = _score(natural) + _score(temporal);
  return switch (score) {
    2 => Relation.greatFriend,
    1 => Relation.friend,
    0 => Relation.neutral,
    -1 => Relation.enemy,
    _ => Relation.greatEnemy,
  };
}

int _score(Relation r) => switch (r) {
      Relation.friend || Relation.greatFriend => 1,
      Relation.neutral => 0,
      _ => -1,
    };
