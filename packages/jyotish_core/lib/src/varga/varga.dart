import '../model/enums.dart';

/// Divisional charts. Phase 2 needs only the navamsha; Phase 3 adds all
/// sixteen with their variants.
enum Varga {
  d1('Rasi', 1),
  d9('Navamsha', 9);

  const Varga(this.label, this.division);
  final String label;
  final int division;
}

/// Sign of [lon] in [varga].
Rashi vargaSign(double lon, Varga varga) => switch (varga) {
      Varga.d1 => Rashi.ofLongitude(lon),
      // Each navamsha is 3°20′; counting continuously from 0° Aries gives
      // the classical rule (movable signs start from themselves, fixed
      // from the 9th, dual from the 5th).
      Varga.d9 => Rashi.values[(norm360(lon) * 9 / 30).floor() % 12],
    };

/// Position inside the varga sign, scaled back to 0–30° (used to print a
/// "degree" in divisional charts the way most software does).
double vargaDegree(double lon, Varga varga) =>
    (norm360(lon) * varga.division) % 30;
