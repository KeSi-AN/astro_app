import '../chart/rasi_chart.dart';
import '../ephemeris/ephemeris.dart';
import '../model/enums.dart';

const tithiNames = [
  'Pratipada', 'Dwitiya', 'Tritiya', 'Chaturthi', 'Panchami', 'Shashthi',
  'Saptami', 'Ashtami', 'Navami', 'Dashami', 'Ekadashi', 'Dwadashi',
  'Trayodashi', 'Chaturdashi',
];

const yogaNames = [
  'Vishkambha', 'Priti', 'Ayushman', 'Saubhagya', 'Shobhana', 'Atiganda',
  'Sukarma', 'Dhriti', 'Shula', 'Ganda', 'Vriddhi', 'Dhruva', 'Vyaghata',
  'Harshana', 'Vajra', 'Siddhi', 'Vyatipata', 'Variyana', 'Parigha',
  'Shiva', 'Siddha', 'Sadhya', 'Shubha', 'Shukla', 'Brahma', 'Indra',
  'Vaidhriti',
];

const _movableKaranas = [
  'Bava', 'Balava', 'Kaulava', 'Taitila', 'Gara', 'Vanija', 'Vishti',
];

const weekdayNames = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
];
const varaLords = [
  Graha.moon, Graha.mars, Graha.mercury, Graha.jupiter, Graha.venus,
  Graha.saturn, Graha.sun,
];

/// Tithi number 1..30 (1–15 Shukla, 16–30 Krishna).
int tithiNumber(double sunLon, double moonLon) =>
    (norm360(moonLon - sunLon) / 12).floor() + 1;

String tithiName(int n) {
  if (n == 15) return 'Purnima';
  if (n == 30) return 'Amavasya';
  return tithiNames[(n - 1) % 15];
}

/// Karana number 1..60 (half-tithis).
int karanaNumber(double sunLon, double moonLon) =>
    (norm360(moonLon - sunLon) / 6).floor() + 1;

String karanaName(int n) => switch (n) {
      1 => 'Kimstughna',
      58 => 'Shakuni',
      59 => 'Chatushpada',
      60 => 'Naga',
      _ => _movableKaranas[(n - 2) % 7],
    };

/// Yoga number 1..27 from the sum of sidereal Sun and Moon.
int yogaNumber(double sunLon, double moonLon) =>
    (norm360(sunLon + moonLon) / Nakshatra.span).floor() + 1;

/// Panchang elements at the moment of birth, plus the Hindu day
/// (sunrise to sunrise) the birth falls in.
class BirthPanchang {
  const BirthPanchang({
    required this.tithi,
    required this.karana,
    required this.yoga,
    required this.sunriseJd,
    required this.sunsetJd,
    required this.nextSunriseJd,
    required this.weekday,
    required this.sunriseMode,
    required this.birthJd,
  });

  final int tithi;
  final int karana;
  final int yoga;

  /// JD (UT) of the sunrise that starts the birth's Hindu day; null in
  /// polar day/night.
  final double? sunriseJd;
  final double? sunsetJd;
  final double? nextSunriseJd;

  /// 1 = Monday … 7 = Sunday, counted from sunrise.
  final int weekday;
  final SunriseMode sunriseMode;
  final double birthJd;

  String get tithiName => _tithiName(tithi);
  String get paksha => tithi <= 15 ? 'Shukla' : 'Krishna';
  String get karanaName => _karanaName(karana);
  String get yogaName => yogaNames[yoga - 1];
  String get weekdayName => weekdayNames[weekday - 1];
  Graha get varaLord => varaLords[weekday - 1];

  /// Day length in hours.
  double? get dayLengthHours => sunriseJd == null || sunsetJd == null
      ? null
      : (sunsetJd! - sunriseJd!) * 24;

  /// Time since sunrise in ghatis (1 ghati = 24 minutes).
  double? get ishtkaalGhatis =>
      sunriseJd == null ? null : (birthJd - sunriseJd!) * 24 * 2.5;

  static BirthPanchang of(
    RasiChart chart,
    Ephemeris eph, {
    SunriseMode mode = SunriseMode.upperLimb,
  }) {
    final sun = chart.grahas[Graha.sun]!.longitude;
    final moon = chart.grahas[Graha.moon]!.longitude;
    final b = chart.birth;

    // JD (UT) of local civil midnight starting the birth date.
    final midnight = chart.jdUt - b.localHours / 24;
    double? rise(double from) =>
        eph.sunEvent(from, b.latitude, b.longitude, rise: true, mode: mode);

    var dayShift = 0;
    var sunrise = rise(midnight);
    if (sunrise != null && sunrise > chart.jdUt) {
      // Born before today's sunrise: the Hindu day began yesterday.
      dayShift = -1;
      sunrise = rise(midnight - 1);
    }
    final sunset = sunrise == null
        ? null
        : eph.sunEvent(sunrise, b.latitude, b.longitude, rise: false, mode: mode);
    final next = sunrise == null ? null : rise(sunrise + 0.01);

    final date = DateTime.utc(b.year, b.month, b.day).add(Duration(days: dayShift));
    return BirthPanchang(
      tithi: tithiNumber(sun, moon),
      karana: karanaNumber(sun, moon),
      yoga: yogaNumber(sun, moon),
      sunriseJd: sunrise,
      sunsetJd: sunset,
      nextSunriseJd: next,
      weekday: date.weekday,
      sunriseMode: mode,
      birthJd: chart.jdUt,
    );
  }
}

String _tithiName(int n) => tithiName(n);
String _karanaName(int n) => karanaName(n);
