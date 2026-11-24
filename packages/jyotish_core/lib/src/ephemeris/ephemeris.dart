import '../model/enums.dart';
import '../model/settings.dart';

/// Ecliptic position of one body. Longitude is sidereal or tropical depending
/// on the settings used; speed is degrees/day (negative = retrograde).
class EclipticPosition {
  const EclipticPosition(this.longitude, this.latitude, this.speed);
  final double longitude;
  final double latitude;
  final double speed;
}

enum HouseSystem { placidus, sripati, porphyry, wholeSign, equal }

/// How sunrise is defined. Indian panchangs differ on this; it shifts
/// sunrise by a few minutes.
enum SunriseMode {
  /// Upper edge of the disc, with atmospheric refraction (almanac sunrise;
  /// AstroSage and Drik Panchang default). Listed first: our default.
  upperLimb('Upper limb, with refraction'),

  /// Centre of the disc on the horizon, no refraction (Swiss Ephemeris
  /// "Hindu rising").
  hindu('Disc centre, no refraction');

  const SunriseMode(this.label);
  final String label;
}

class HousesResult {
  const HousesResult({
    required this.cusps,
    required this.ascendant,
    required this.mc,
  });

  /// 12 cusp longitudes, index 0 = house 1.
  final List<double> cusps;
  final double ascendant;
  final double mc;
}

/// The only place the app touches an astronomy library. Everything else
/// works from these numbers, so the library can be swapped later
/// (e.g. Swiss Ephemeris Pro licence or a clean-room JPL reader).
abstract class Ephemeris {
  /// Julian day in UT for a Gregorian calendar date and UT decimal hours.
  double julianDayUt(int year, int month, int day, double utHours);

  EclipticPosition position(double jdUt, Graha graha, CalcSettings s);

  /// Ayanamsa in degrees for [jdUt] (0 for tropical).
  double ayanamsa(double jdUt, CalcSettings s);

  HousesResult houses(
    double jdUt,
    double latitude,
    double longitude,
    HouseSystem system,
    CalcSettings s,
  );

  /// Greenwich sidereal time in hours.
  double siderealTimeGreenwich(double jdUt);

  /// True obliquity of the ecliptic in degrees.
  double trueObliquity(double jdUt);

  /// Mean obliquity (without nutation) in degrees.
  double meanObliquity(double jdUt);

  /// Next sunrise ([rise] = true) or sunset after [jdUtStart], in JD UT;
  /// null if the Sun doesn't rise/set that day (polar regions).
  double? sunEvent(
    double jdUtStart,
    double latitude,
    double longitude, {
    required bool rise,
    SunriseMode mode = SunriseMode.upperLimb,
  });
}
