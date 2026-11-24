/// Birth details exactly as entered: local civil date/time plus the offsets
/// used to convert to UT. Storing the offsets (not just a time-zone name)
/// keeps historical charts reproducible.
class BirthData {
  const BirthData({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    this.second = 0,
    required this.latitude,
    required this.longitude,
    required this.utcOffsetHours,
    this.dstHours = 0,
    this.placeName = '',
  });

  final int year, month, day, hour, minute, second;

  /// Degrees, north positive.
  final double latitude;

  /// Degrees, east positive.
  final double longitude;

  /// Standard time zone offset from UTC in hours (India = 5.5).
  final double utcOffsetHours;

  /// Extra hours added by daylight saving or war time (India 1942–45 = 1).
  final double dstHours;

  final String placeName;

  /// Local clock time as decimal hours.
  double get localHours => hour + minute / 60 + second / 3600;

  /// UT as decimal hours on the local date (may be <0 or ≥24; Julian-day
  /// conversion handles the date roll-over).
  double get utHours => localHours - utcOffsetHours - dstHours;

  /// Local mean time correction in hours: (longitude/15) − zone offset.
  double get lmtCorrectionHours => longitude / 15 - utcOffsetHours;
}
