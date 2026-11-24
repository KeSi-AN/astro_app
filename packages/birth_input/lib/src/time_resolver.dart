import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// How the birth's local clock time is converted to UT.
enum TimeBasis {
  /// IANA time-zone rules for the place (includes DST and India's war time).
  zone('Standard time (time-zone rules)'),

  /// Local mean time of the birth place: longitude / 15.
  lmt('Local mean time (LMT)'),

  /// Bombay Time, UTC+4:51, kept in Bombay until 1955.
  bombay('Bombay Time (UTC+4:51)'),

  /// Calcutta Time, UTC+5:53:20, kept in Calcutta until 1948.
  calcutta('Calcutta Time (UTC+5:53:20)'),

  /// Offset typed by the user.
  manual('Manual offset');

  const TimeBasis(this.label);
  final String label;
}

enum NoteLevel { info, warning }

class TimeNote {
  const TimeNote(this.level, this.text);
  final NoteLevel level;
  final String text;
}

/// Result of resolving a local birth time. [standardOffsetHours] +
/// [dstHours] is what gets subtracted from local time to get UT.
class TimeResolution {
  const TimeResolution({
    required this.basis,
    required this.standardOffsetHours,
    required this.dstHours,
    required this.zoneName,
    required this.abbreviation,
    required this.isWarTime,
    this.notes = const [],
    this.alternatives = const [],
  });

  final TimeBasis basis;
  final double standardOffsetHours;

  /// Daylight saving or war-time hour in effect (0 or 1, rarely 0.5/2).
  final double dstHours;
  final String zoneName;
  final String abbreviation;
  final bool isWarTime;
  final List<TimeNote> notes;

  /// Other bases worth offering for this date and place.
  final List<TimeBasis> alternatives;

  double get totalOffsetHours => standardOffsetHours + dstHours;
}

/// Converts local birth times to UT offsets, with India's historical quirks.
///
/// Sources: IANA tzdb `asia` file (Asia/Kolkata history, incl. 1941–45 war
/// time) and the Bombay/Calcutta city times it documents in comments.
class TimeResolver {
  static bool _ready = false;

  /// Loads the full tz database (all zones, full history). Call once.
  static void ensureInitialized() {
    if (_ready) return;
    tzdata.initializeTimeZones();
    _ready = true;
  }

  static const _bombayOffset = 4 + 51 / 60;
  static const _calcuttaOffset = 5 + 53 / 60 + 20 / 3600;
  static const _indiaZones = {'Asia/Kolkata', 'Asia/Calcutta'};
  static const _bombayStates = {'Maharashtra', 'Gujarat'};
  static const _calcuttaStates = {'West Bengal'};

  /// Basis chosen when the user hasn't picked one.
  static TimeBasis defaultBasis({
    required String zoneName,
    required int year,
    required int month,
    required int day,
  }) {
    if (_indiaZones.contains(zoneName) && _ymd(year, month, day) < 19060101) {
      return TimeBasis.lmt;
    }
    return TimeBasis.zone;
  }

  static TimeResolution resolve({
    required String zoneName,
    required double longitude,
    String admin1 = '',
    required int year,
    required int month,
    required int day,
    required int hour,
    required int minute,
    int second = 0,
    TimeBasis? basis,
    double? manualOffsetHours,
    double manualDstHours = 0,
    bool? applyWarTime,
  }) {
    ensureInitialized();
    final date = _ymd(year, month, day);
    final india = _indiaZones.contains(zoneName);
    basis ??= defaultBasis(zoneName: zoneName, year: year, month: month, day: day);

    final notes = <TimeNote>[];
    final alternatives = <TimeBasis>[];
    if (india && date < 19060101) {
      notes.add(const TimeNote(NoteLevel.info,
          'Before 1906 India had no single standard time. Local mean time is '
          'assumed; switch if the record used Madras or Calcutta time.'));
      alternatives.addAll([TimeBasis.lmt, TimeBasis.zone]);
    }
    if (india && date >= 19060101 && date < 19560101 &&
        _bombayStates.contains(admin1)) {
      notes.add(const TimeNote(NoteLevel.warning,
          'Bombay kept its own Bombay Time (UTC+4:51) until 1955. If the '
          'birth was recorded in Bombay Time, choose it below.'));
      alternatives.addAll([TimeBasis.zone, TimeBasis.bombay]);
    }
    if (india && date >= 19060101 && date < 19490101 &&
        _calcuttaStates.contains(admin1)) {
      notes.add(const TimeNote(NoteLevel.warning,
          'Calcutta kept its own Calcutta Time (UTC+5:53:20) until 1948. If '
          'the birth was recorded in Calcutta Time, choose it below.'));
      alternatives.addAll([TimeBasis.zone, TimeBasis.calcutta]);
    }
    if (alternatives.isNotEmpty) alternatives.add(TimeBasis.manual);

    switch (basis) {
      case TimeBasis.lmt:
        return TimeResolution(
          basis: basis, standardOffsetHours: longitude / 15, dstHours: 0,
          zoneName: zoneName, abbreviation: 'LMT', isWarTime: false,
          notes: notes, alternatives: alternatives.toSet().toList(),
        );
      case TimeBasis.bombay:
      case TimeBasis.calcutta:
        return TimeResolution(
          basis: basis,
          standardOffsetHours:
              basis == TimeBasis.bombay ? _bombayOffset : _calcuttaOffset,
          dstHours: 0, zoneName: zoneName,
          abbreviation: basis == TimeBasis.bombay ? 'BMT' : 'CMT',
          isWarTime: false, notes: notes,
          alternatives: alternatives.toSet().toList(),
        );
      case TimeBasis.manual:
        if (manualOffsetHours == null) {
          throw ArgumentError('Manual basis needs manualOffsetHours');
        }
        return TimeResolution(
          basis: basis, standardOffsetHours: manualOffsetHours,
          dstHours: manualDstHours, zoneName: zoneName, abbreviation: '',
          isWarTime: false, notes: notes,
          alternatives: alternatives.toSet().toList(),
        );
      case TimeBasis.zone:
        break;
    }

    final loc = tz.getLocation(zoneName);
    final t = tz.TZDateTime(loc, year, month, day, hour, minute, second);
    final zone = loc.timeZone(t.millisecondsSinceEpoch);
    final total = zone.offset.inSeconds / 3600;

    // A local time that doesn't exist (clocks jumped forward) comes back
    // shifted; a time that occurs twice (clocks went back) is ambiguous.
    if (t.hour != hour || t.minute != minute) {
      notes.add(const TimeNote(NoteLevel.warning,
          'This time did not exist here (clocks were moved forward). Check '
          'the recorded time or set the offset manually.'));
    } else {
      final hourBefore = loc.timeZone(t.millisecondsSinceEpoch - 3600000);
      final hourAfter = loc.timeZone(t.millisecondsSinceEpoch + 3600000);
      final drop = hourBefore.offset - hourAfter.offset;
      if (drop > Duration.zero && drop <= const Duration(hours: 1)) {
        notes.add(const TimeNote(NoteLevel.warning,
            'Clocks went back around this time, so it may have occurred '
            'twice. Confirm whether daylight saving was still on.'));
      }
    }

    var dst = zone.isDst ? 1.0 : 0.0;
    final war = india && zone.isDst;
    if (war) {
      final apply = applyWarTime ?? true;
      notes.add(TimeNote(NoteLevel.warning, apply
          ? 'War time was in force (clocks 1 hour ahead of IST, UTC+6:30). '
              'Turn this off only if the recorded time was in IST.'
          : 'War-time hour removed: the recorded time is treated as IST '
              '(UTC+5:30).'));
      if (!apply) dst = 0;
    }
    final standard = total - (zone.isDst ? 1.0 : 0.0);
    return TimeResolution(
      basis: TimeBasis.zone,
      standardOffsetHours: standard,
      dstHours: dst,
      zoneName: zoneName,
      abbreviation: zone.abbreviation,
      isWarTime: war,
      notes: notes,
      alternatives: alternatives.toSet().toList(),
    );
  }

  static int _ymd(int y, int m, int d) => y * 10000 + m * 100 + d;
}
