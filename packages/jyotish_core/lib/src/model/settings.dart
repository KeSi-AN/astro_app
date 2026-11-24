/// Ayanamsa choices. [swephMode] is the Swiss Ephemeris SE_SIDM_* number;
/// `null` means tropical (Sayana), and [user] needs [CalcSettings.userT0] and
/// [CalcSettings.userAyanamsaAtT0].
enum Ayanamsa {
  lahiri('N.C. Lahiri', 1),
  kpNew('KP New (Krishnamurti–Senthilathiban)', 45),
  kpOld('KP Old (Krishnamurti)', 5),
  raman('B.V. Raman', 3),
  trueChitra('True Chitrapaksha', 27),
  sayan('Sayan (tropical)', null),
  // KP Khullar is not a Swiss Ephemeris mode. It will be defined from a
  // published reference value once confirmed; until then it is user-defined.
  user('User-defined', 255);

  const Ayanamsa(this.label, this.swephMode);
  final String label;
  final int? swephMode;
}

enum NodeType { trueNode, meanNode }

/// Every calculation choice that astrology programs disagree on lives here,
/// so results can always be reproduced and explained.
class CalcSettings {
  const CalcSettings({
    this.ayanamsa = Ayanamsa.lahiri,
    this.nodeType = NodeType.meanNode,
    this.userT0,
    this.userAyanamsaAtT0,
  });

  final Ayanamsa ayanamsa;
  final NodeType nodeType;

  /// Julian day (UT) of the reference epoch for [Ayanamsa.user].
  final double? userT0;

  /// Ayanamsa value in degrees at [userT0] for [Ayanamsa.user].
  final double? userAyanamsaAtT0;

  CalcSettings copyWith({
    Ayanamsa? ayanamsa,
    NodeType? nodeType,
    double? userT0,
    double? userAyanamsaAtT0,
  }) =>
      CalcSettings(
        ayanamsa: ayanamsa ?? this.ayanamsa,
        nodeType: nodeType ?? this.nodeType,
        userT0: userT0 ?? this.userT0,
        userAyanamsaAtT0: userAyanamsaAtT0 ?? this.userAyanamsaAtT0,
      );
}
