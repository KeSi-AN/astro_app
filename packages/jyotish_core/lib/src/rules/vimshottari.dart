import '../model/enums.dart';

/// Vimshottari order and years (BPHS ch. 46). Used for dasha balance,
/// KP sub lords and (Phase 3) the full dasha tree.
const vimshottariOrder = [
  Graha.ketu, Graha.venus, Graha.sun, Graha.moon, Graha.mars,
  Graha.rahu, Graha.jupiter, Graha.saturn, Graha.mercury,
];

const vimshottariYears = {
  Graha.ketu: 7, Graha.venus: 20, Graha.sun: 6, Graha.moon: 10,
  Graha.mars: 7, Graha.rahu: 18, Graha.jupiter: 16, Graha.saturn: 19,
  Graha.mercury: 17,
};

const vimshottariTotal = 120;

/// Fraction (0..1) of the nakshatra still to run at [lon].
double nakshatraRemaining(double lon) {
  final into = norm360(lon) % Nakshatra.span;
  return 1 - into / Nakshatra.span;
}

/// KP sub lord (and sub-sub lord with [depth] = 2) of a longitude: the
/// nakshatra is split in Vimshottari proportions starting from its lord.
List<Graha> kpLords(double lon, {int depth = 2}) {
  final lords = <Graha>[Nakshatra.ofLongitude(lon).lord];
  var start = (norm360(lon) / Nakshatra.span).floor() * Nakshatra.span;
  var span = Nakshatra.span;
  var lord = lords.first;
  for (var level = 0; level < depth; level++) {
    var i = vimshottariOrder.indexOf(lord);
    var pos = start;
    for (var k = 0; k < 9; k++) {
      final g = vimshottariOrder[(i + k) % 9];
      final part = span * vimshottariYears[g]! / vimshottariTotal;
      if (norm360(lon) < pos + part || k == 8) {
        lords.add(g);
        start = pos;
        span = part;
        lord = g;
        break;
      }
      pos += part;
    }
  }
  return lords; // [star lord, sub lord, sub-sub lord]
}
