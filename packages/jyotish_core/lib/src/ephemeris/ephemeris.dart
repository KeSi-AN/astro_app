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
}
