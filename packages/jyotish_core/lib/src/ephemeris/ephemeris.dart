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
enum EclipseKind { solar, lunar }

enum EclipseType { total, annular, hybrid, partial, penumbral }

/// An eclipse as seen from one place. Times are JD UT; contacts the place
/// can't see (body below the horizon) are null.
class EclipseEvent {
  const EclipseEvent({
    required this.kind,
    required this.type,
    required this.maximum,
    required this.visible,
    this.begin,
    this.end,
    this.totalBegin,
    this.totalEnd,
    this.penumbralBegin,
    this.penumbralEnd,
    this.bodyRise,
    this.bodySet,
    this.magnitude = 0,
  });

  final EclipseKind kind;
  final EclipseType type;

  /// Greatest eclipse (global for an invisible one).
  final double maximum;
  final bool visible;

  /// Solar: first and last contact. Lunar: umbral (partial) phase.
  final double? begin, end;

  /// Total (or annular) phase.
  final double? totalBegin, totalEnd;

  /// Lunar penumbral phase.
  final double? penumbralBegin, penumbralEnd;

  /// Sun/Moon rising or setting while the eclipse is on.
  final double? bodyRise, bodySet;

  /// Solar: fraction of the Sun's diameter covered; lunar: umbral magnitude.
  final double magnitude;
}

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

  /// Heliocentric tropical longitude of a planet (Mercury–Saturn), used for
  /// cheshta bala.
  double heliocentricLongitude(double jdUt, Graha graha);

  /// Equatorial declination in degrees (true, of date).
  double declination(double jdUt, Graha graha);

  /// Next sunrise ([rise] = true) or sunset after [jdUtStart], in JD UT;
  /// null if the Sun doesn't rise/set that day (polar regions).
  double? sunEvent(
    double jdUtStart,
    double latitude,
    double longitude, {
    required bool rise,
    SunriseMode mode = SunriseMode.upperLimb,
  });

  /// Next moonrise or moonset after [jdUtStart] (upper limb, refraction).
  double? moonEvent(
    double jdUtStart,
    double latitude,
    double longitude, {
    required bool rise,
  });

  /// The next solar or lunar eclipse (globally) after [jdUtStart], with
  /// what [latitude]/[longitude] sees of it.
  EclipseEvent nextEclipse(
    EclipseKind kind,
    double jdUtStart,
    double latitude,
    double longitude,
  );
}
