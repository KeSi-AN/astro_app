// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String startError(Object error) {
    return 'Could not start: $error';
  }

  @override
  String get chartsTitle => 'Charts';

  @override
  String get settings => 'Settings';

  @override
  String get searchCharts => 'Search by name or place';

  @override
  String get newChart => 'New chart';

  @override
  String loadChartsError(Object error) {
    return 'Could not load charts: $error';
  }

  @override
  String get noChartsYet => 'No charts yet.\nTap \"New chart\" to add one.';

  @override
  String noChartMatches(Object query) {
    return 'No chart matches \"$query\".';
  }

  @override
  String get edit => 'Edit';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteChartTitle => 'Delete chart?';

  @override
  String deleteChartBody(Object name) {
    return '\"$name\" will be removed from this phone. This cannot be undone.';
  }

  @override
  String get copySuffix => '(copy)';

  @override
  String get editChart => 'Edit chart';

  @override
  String get pasteDetails => 'Paste details';

  @override
  String get name => 'Name';

  @override
  String get enterName => 'Enter a name';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get gender => 'Gender';

  @override
  String get dateLabel => 'Date (DD/MM/YYYY)';

  @override
  String get dateError => 'DD/MM/YYYY, 1800–2399';

  @override
  String get timeLabel => 'Time (24h, HH:MM:SS)';

  @override
  String get timeError => 'e.g. 22:45:10';

  @override
  String get birthPlace => 'Birth place';

  @override
  String get optional => 'Optional';

  @override
  String get maritalStatus => 'Marital status';

  @override
  String get occupation => 'Occupation';

  @override
  String get notes => 'Notes';

  @override
  String get saveAndOpen => 'Save & open';

  @override
  String get save => 'Save';

  @override
  String get choosePlace => 'Choose the birth place.';

  @override
  String get checkTimeZone => 'Check the time zone.';

  @override
  String get enterOffset => 'Enter the UTC offset, e.g. 5:30';

  @override
  String unknownZone(Object zone) {
    return 'Unknown time zone \"$zone\". Use a manual offset.';
  }

  @override
  String get noDetailsFound => 'No birth details found in that text.';

  @override
  String get noDateFound => 'No date found: enter it below.';

  @override
  String get noTimeFound => 'No time found: enter it below.';

  @override
  String placeMatched(Object place) {
    return 'Place matched to $place. Tap the place to change it.';
  }

  @override
  String placeNeedsChoosing(Object place) {
    return 'Place \"$place\" needs choosing.';
  }

  @override
  String noteMonthFirst(Object a, Object b) {
    return 'Date read as month/day ($a/$b), since $b is not a valid month.';
  }

  @override
  String get noteDayFirst =>
      'Date read as day/month (Indian order). Check it isn\'t month/day.';

  @override
  String noteAfterMidnight(Object time) {
    return 'Night time read as $time after midnight. Check the date.';
  }

  @override
  String noteNoAmPm(Object time) {
    return 'No AM/PM given: time read as 24-hour ($time).';
  }

  @override
  String get pasteTitle => 'Paste birth details';

  @override
  String get pasteHint =>
      'e.g.\nName: Rahul Sharma\nDOB 12/03/1990, 10:45 am\nPlace: Lucknow';

  @override
  String get fillForm => 'Fill form';

  @override
  String get timeZone => 'Time zone';

  @override
  String get birthTimeIsIn => 'Birth time is in';

  @override
  String get utcOffset => 'UTC offset';

  @override
  String get dstWarHours => 'DST / war time (h)';

  @override
  String standardOffset(Object offset) {
    return 'Standard $offset';
  }

  @override
  String dstPlus(Object hours) {
    return 'DST +${hours}h';
  }

  @override
  String warTimePlus(Object hours) {
    return 'War time +${hours}h';
  }

  @override
  String get lmtCorrection => 'LMT correction';

  @override
  String get warTimeSwitch => 'Recorded time includes war time (+1h)';

  @override
  String get tzPre1906 =>
      'Before 1906 India had no single standard time. Local mean time is assumed; switch if the record used Madras or Calcutta time.';

  @override
  String get tzBombay =>
      'Bombay kept its own Bombay Time (UTC+4:51) until 1955. If the birth was recorded in Bombay Time, choose it above.';

  @override
  String get tzCalcutta =>
      'Calcutta kept its own Calcutta Time (UTC+5:53:20) until 1948. If the birth was recorded in Calcutta Time, choose it above.';

  @override
  String get tzNonExistent =>
      'This time did not exist here (clocks were moved forward). Check the recorded time or set the offset manually.';

  @override
  String get tzAmbiguous =>
      'Clocks went back around this time, so it may have occurred twice. Confirm whether daylight saving was still on.';

  @override
  String get tzWarOn =>
      'War time was in force (clocks 1 hour ahead of IST, UTC+6:30). Turn this off only if the recorded time was in IST.';

  @override
  String get tzWarOff =>
      'War-time hour removed: the recorded time is treated as IST (UTC+5:30).';

  @override
  String get placeSearchHint => 'Town or village (add \", state\" to narrow)';

  @override
  String get placeSearchLatin =>
      'Type place names in English letters, e.g. Lucknow.';

  @override
  String get clear => 'Clear';

  @override
  String get noPlaceFound =>
      'No place found. Try another spelling, or enter the coordinates yourself.';

  @override
  String get enterCoordinates => 'Enter coordinates manually';

  @override
  String get geonamesCredit =>
      'Place data © GeoNames (geonames.org), CC BY 4.0';

  @override
  String get placeByCoordinates => 'Place by coordinates';

  @override
  String get placeName => 'Place name';

  @override
  String get required => 'Required';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitudeGeo => 'Longitude';

  @override
  String get latError => 'e.g. 27.15 or 27N09';

  @override
  String get lonError => 'e.g. 78.0 or 078E00';

  @override
  String get zoneError => 'An IANA zone like Asia/Kolkata';

  @override
  String get use => 'Use';

  @override
  String get editBirthDetails => 'Edit birth details';

  @override
  String get tabChart => 'Chart';

  @override
  String get tabPlanets => 'Planets';

  @override
  String get tabBhava => 'Bhava';

  @override
  String get tabDetails => 'Details';

  @override
  String get tabFriendship => 'Friendship';

  @override
  String get tabKarakas => 'Karakas';

  @override
  String get chartNotFound => 'Chart not found';

  @override
  String get chartLegend =>
      '* retrograde  ^ combust  ◻ vargottama  ↑ exalted  ↓ debilitated';

  @override
  String get chalitNorthOnly =>
      'Chalit is always shown North Indian (house-based).';

  @override
  String get tapPlanet => 'Tap a planet for details.';

  @override
  String get navamshaTitle => 'Navamsha (D9)';

  @override
  String get chalitTitle => 'Chalit (Sripati)';

  @override
  String get sign => 'Sign';

  @override
  String withLord(Object name, Object lord) {
    return '$name (lord $lord)';
  }

  @override
  String get degreeInSignLabel => 'Longitude';

  @override
  String nakshatraPada(Object nakshatra, Object pada) {
    return '$nakshatra, pada $pada';
  }

  @override
  String get starSubLords => 'Star / sub / sub-sub lord';

  @override
  String get houseWholeSign => 'House (whole sign)';

  @override
  String get chalitBhava => 'Chalit bhava';

  @override
  String get navamsha => 'Navamsha';

  @override
  String get dignity => 'Dignity';

  @override
  String get motion => 'Motion';

  @override
  String get retrograde => 'Retrograde';

  @override
  String get direct => 'Direct';

  @override
  String get speed => 'Speed';

  @override
  String speedValue(Object value) {
    return '$value°/day';
  }

  @override
  String get combust => 'Combust';

  @override
  String get vargottama => 'Vargottama';

  @override
  String get yes => 'Yes';

  @override
  String get colPlanet => 'Planet';

  @override
  String get colDegree => 'Degree';

  @override
  String get colNakshatra => 'Nakshatra';

  @override
  String get colStar => 'Star';

  @override
  String get colSub => 'Sub';

  @override
  String get flagRetro => 'R';

  @override
  String get flagCombust => 'C';

  @override
  String get flagVargottama => 'V';

  @override
  String get planetsLegend =>
      'R retrograde · C combust · V vargottama. Dignity uses the compound (five-fold) relationship with the sign lord.';

  @override
  String get bhavaTitle => 'Bhava chalit (Sripati)';

  @override
  String get colBhava => 'Bhava';

  @override
  String get colStart => 'Start (sandhi)';

  @override
  String get colMadhya => 'Madhya';

  @override
  String get colEnd => 'End';

  @override
  String get colPlanets => 'Planets';

  @override
  String get chalitDiffers =>
      'Planets whose chalit bhava differs from their sign house:';

  @override
  String chalitShift(Object planet, Object house, Object bhava) {
    return '$planet: house $house → bhava $bhava';
  }

  @override
  String get none => 'None';

  @override
  String get kpCuspsTitle => 'Placidus cusps (KP)';

  @override
  String get colCusp => 'Cusp';

  @override
  String get colLongitude => 'Longitude';

  @override
  String get birthDetails => 'Birth details';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get place => 'Place';

  @override
  String get latLon => 'Latitude / longitude';

  @override
  String get warTime => 'War time';

  @override
  String get dst => 'DST';

  @override
  String hoursValue(Object hours) {
    return '+$hours h';
  }

  @override
  String get lmtAtBirth => 'LMT at birth';

  @override
  String get utAtBirth => 'UT (GMT) at birth';

  @override
  String get julianDay => 'Julian day (UT)';

  @override
  String get ayanamsa => 'Ayanamsa';

  @override
  String get obliquity => 'Obliquity';

  @override
  String get siderealTime => 'Sidereal time';

  @override
  String get panchangAtBirth => 'Panchang at birth';

  @override
  String get hinduWeekday => 'Hindu weekday';

  @override
  String get tithi => 'Tithi';

  @override
  String get nakshatra => 'Nakshatra';

  @override
  String get yoga => 'Yoga';

  @override
  String get karana => 'Karana';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get sunset => 'Sunset';

  @override
  String get dayLength => 'Day length';

  @override
  String get ishtkaal => 'Ishtkaal (ghati)';

  @override
  String get sunriseRule => 'Sunrise rule';

  @override
  String get avakhada => 'Avakhada chakra';

  @override
  String get lagna => 'Lagna';

  @override
  String get rashi => 'Rashi';

  @override
  String get nakshatraPadaLabel => 'Nakshatra-pada';

  @override
  String get varna => 'Varna';

  @override
  String get vashya => 'Vashya';

  @override
  String get yoni => 'Yoni';

  @override
  String get gana => 'Gana';

  @override
  String get nadi => 'Nadi';

  @override
  String get tatva => 'Tatva';

  @override
  String get payaNakshatra => 'Paya (nakshatra)';

  @override
  String get payaMoon => 'Paya (Moon house)';

  @override
  String get nameSyllable => 'Name syllable';

  @override
  String get dashaBalance => 'Dasha balance';

  @override
  String get sunSignIndian => 'Sun sign (Indian)';

  @override
  String get sunSignWestern => 'Sun sign (Western)';

  @override
  String ymd(Object y, Object m, Object d) {
    return '${y}y ${m}m ${d}d';
  }

  @override
  String get naturalTitle => 'Natural (permanent)';

  @override
  String get temporalTitle => 'Temporal (in this chart)';

  @override
  String get compoundTitle => 'Five-fold (compound)';

  @override
  String get friendshipLegend =>
      'GF great friend · F friend · N neutral · E enemy · GE great enemy';

  @override
  String charaKarakasTitle(Object scheme) {
    return 'Chara karakas · $scheme';
  }

  @override
  String get colKaraka => 'Karaka';

  @override
  String get colDegreeInSign => 'Degree in sign';

  @override
  String get rahuBackwards =>
      'Rahu\'s degree is counted backwards (30° − its degree).';

  @override
  String get karakaSchemeHint =>
      'Change to the 8-karaka scheme (with Rahu) in Settings.';

  @override
  String get display => 'Display';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Same as phone';

  @override
  String get chartStyle => 'Chart style';

  @override
  String get showOuterPlanets => 'Show Uranus, Neptune, Pluto';

  @override
  String get calculation => 'Calculation';

  @override
  String get rahuKetu => 'Rahu / Ketu';

  @override
  String get charaKarakas => 'Chara karakas';

  @override
  String get settingsFootnote =>
      'Defaults match AstroSage: Lahiri, mean node, upper-limb sunrise. Planet positions come from Swiss Ephemeris (Astrodienst, AGPL). Place data © GeoNames, CC BY 4.0.';

  @override
  String get tabVargas => 'Vargas';

  @override
  String get tabDasha => 'Dasha';

  @override
  String get vimshottari => 'Vimshottari';

  @override
  String get yoginiDasha => 'Yogini';

  @override
  String get charaDasha => 'Chara';

  @override
  String get today => 'Today';

  @override
  String get jumpToDate => 'Go to date';

  @override
  String get colLord => 'Lord';

  @override
  String get colFrom => 'From';

  @override
  String get colTo => 'To';

  @override
  String get colAge => 'Age';

  @override
  String runningAt(Object date) {
    return 'Running on $date';
  }

  @override
  String get dashaHint => 'Tap a period to open its sub-periods.';

  @override
  String get dashaYearSetting => 'Dasha year';

  @override
  String charaNote(Object direction) {
    return 'Chara dasha per K.N. Rao: sequence runs $direction from the lagna; antardashas start from the next sign.';
  }

  @override
  String get forwards => 'forwards';

  @override
  String get backwards => 'backwards';

  @override
  String get yoginiNote =>
      'Yogini dasha: 36-year cycle, starting yogini = nakshatra number + 3.';

  @override
  String get vargaTableTitle => 'Sign of each planet in the 16 vargas';

  @override
  String get vargaTableNote =>
      'Numbers are signs: 1 Aries … 12 Pisces; highlighted = same sign as in D1. Tap a varga below to open its chart.';

  @override
  String get divisional => 'D-charts';

  @override
  String get tabStrength => 'Strength';

  @override
  String get ashtakavarga => 'Ashtakavarga';

  @override
  String get shadbala => 'Shadbala';

  @override
  String get bhavaBala => 'Bhava bala';

  @override
  String get bavTitle => 'Bhinnashtakavarga (bindus per sign)';

  @override
  String get savTitle => 'Sarvashtakavarga';

  @override
  String get savByHouse => 'SAV by house from lagna';

  @override
  String prastaraTitle(Object planet) {
    return 'Prastara of $planet';
  }

  @override
  String get avNote =>
      'Signs: 1 Aries … 12 Pisces. Total 337. Houses with 28+ bindus are strong.';

  @override
  String get colTotal => 'Total';

  @override
  String get contributor => 'From';

  @override
  String get sthanaBala => 'Sthana bala';

  @override
  String get uchchaBala => 'Uchcha';

  @override
  String get saptavargajaBala => 'Saptavargaja';

  @override
  String get ojayugmaBala => 'Ojayugma';

  @override
  String get kendradiBala => 'Kendradi';

  @override
  String get drekkanaBala => 'Drekkana';

  @override
  String get digBala => 'Dig bala';

  @override
  String get kalaBala => 'Kala bala';

  @override
  String get nathonnathaBala => 'Nathonnatha';

  @override
  String get pakshaBala => 'Paksha';

  @override
  String get tribhagaBala => 'Tribhaga';

  @override
  String get abdaBala => 'Abda (year)';

  @override
  String get masaBala => 'Masa (month)';

  @override
  String get varaBala => 'Vara (day)';

  @override
  String get horaBala => 'Hora';

  @override
  String get ayanaBala => 'Ayana';

  @override
  String get yuddhaBala => 'Yuddha';

  @override
  String get cheshtaBala => 'Cheshta bala';

  @override
  String get naisargikaBala => 'Naisargika bala';

  @override
  String get drikBala => 'Drik bala';

  @override
  String get totalVirupas => 'Total (virupas)';

  @override
  String get totalRupas => 'Total (rupas)';

  @override
  String get requiredRupas => 'Required (rupas)';

  @override
  String get strengthRatio => 'Ratio';

  @override
  String get strengthRank => 'Rank';

  @override
  String get shadbalaNote =>
      'Values in virupas (60 = 1 rupa), per BPHS ch. 27 as computed by B.V. Raman. Ratio ≥ 1 means the planet meets its required strength.';

  @override
  String get bhavaLordStrength => 'Lord\'s shadbala';

  @override
  String get bhavaDig => 'Dig';

  @override
  String get bhavaDrishti => 'Drishti';

  @override
  String get bhavaNote =>
      'Bhava bala = lord\'s shadbala + directional strength + aspects on the bhava madhya (virupas).';

  @override
  String get showSavOnChart => 'Show SAV bindus in each house';

  @override
  String get tabKp => 'KP';

  @override
  String get kpAyanamsaSetting => 'KP ayanamsa';

  @override
  String get kpPlanets => 'Planets';

  @override
  String get kpCusps => 'Cusps';

  @override
  String get kpSignif => 'Significations';

  @override
  String get kpRuling => 'Ruling planets';

  @override
  String get kpHorary => 'Horary';

  @override
  String get colSignLord => 'Sign';

  @override
  String get colSubSub => 'Sub-sub';

  @override
  String get colHouse => 'House';

  @override
  String get colL1 => 'Star lord occ.';

  @override
  String get colL2 => 'Occupies';

  @override
  String get colL3 => 'Star lord owns';

  @override
  String get colL4 => 'Owns';

  @override
  String get colAllHouses => 'All';

  @override
  String get houseSignificators => 'House significators';

  @override
  String get colSignificators => 'Planets';

  @override
  String get kpSignifNote =>
      'L1 houses occupied by the star lord, L2 occupied by the planet, L3 owned by the star lord, L4 owned by the planet (Placidus cusps). + = no planet in its stars, or in its own star.';

  @override
  String get rpAtBirth => 'At birth';

  @override
  String get rpNow => 'Now (at birth place)';

  @override
  String get refresh => 'Refresh';

  @override
  String get rpDayLord => 'Day lord';

  @override
  String get rpAscSign => 'Lagna sign lord';

  @override
  String get rpAscStar => 'Lagna star lord';

  @override
  String get rpAscSub => 'Lagna sub lord';

  @override
  String get rpMoonSign => 'Moon sign lord';

  @override
  String get rpMoonStar => 'Moon star lord';

  @override
  String get rpMoonSub => 'Moon sub lord';

  @override
  String get horaryNumber => 'Horary number (1–249)';

  @override
  String get horaryHint =>
      'Cusps for the moment today when the lagna reaches the start of this number; planets as of now, at the birth place.';

  @override
  String get horaryCast => 'Cast horary chart';

  @override
  String horaryAsc(Object degree) {
    return 'Lagna $degree';
  }

  @override
  String get invalidHorary => 'Enter a number from 1 to 249';

  @override
  String get kpNadi => 'Nadi';

  @override
  String get kp4Step => '4-step';

  @override
  String get kpCil => 'CIL';

  @override
  String get nadiNote =>
      'Nakshatra Nadi: houses occupied and owned; Rahu/Ketu also take their sign lord, star lord, and conjunct and aspecting planets.';

  @override
  String get rowPlanet => 'Planet';

  @override
  String get rowStarLord => 'Star lord';

  @override
  String get rowSubLord => 'Sub lord';

  @override
  String get rowSubStar => 'Star lord of sub lord';

  @override
  String get fourStepNote =>
      'Each step shows the lord and its Nakshatra Nadi houses.';

  @override
  String get colT1 => 'T1';

  @override
  String get colT3 => 'T3';

  @override
  String get colT4 => 'T4';

  @override
  String get cilNote =>
      'Cuspal interlinks (sub), as in AstroSage. T1: cusps whose sub lord is the star or sub lord of this cusp\'s sub lord. T3: cusps whose sub lord has this sub lord as star lord. T4: house occupied by the sub lord\'s star lord.';

  @override
  String get tabYogas => 'Yogas';

  @override
  String get secYogas => 'Yogas & doshas';

  @override
  String get secSadeSati => 'Sade Sati';

  @override
  String get secAvastha => 'Avastha';

  @override
  String get secUpagraha => 'Upagraha';

  @override
  String get secArudha => 'Arudha';

  @override
  String get secNavatara => 'Navatara';

  @override
  String get present => 'Present';

  @override
  String get absent => 'Absent';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get showAbsent => 'Show absent ones';

  @override
  String mangalFrom(Object ref, Object house) {
    return 'from $ref: house $house';
  }

  @override
  String get refLagna => 'lagna';

  @override
  String get refMoon => 'Moon';

  @override
  String get refVenus => 'Venus';

  @override
  String get cancelMarsStrong => 'Mars in own/exalted sign';

  @override
  String get cancelWithJupiter => 'Mars with Jupiter';

  @override
  String get cancelWithMoon => 'Mars with Moon';

  @override
  String cancelSignException(Object house) {
    return 'Mars in a sign that cancels it in house $house';
  }

  @override
  String kaalSarpType(Object name) {
    return 'Type: $name';
  }

  @override
  String get colYoga => 'Yoga / dosha';

  @override
  String get colResult => 'Result';

  @override
  String get sadeSatiNote =>
      'Saturn in the 12th, 1st or 2nd from the Moon sign is Sade Sati; in the 4th or 8th, Small Panoti (Dhaiya). Retrograde returns are listed separately.';

  @override
  String get colKind => 'Period';

  @override
  String get colPhase => 'Phase';

  @override
  String get sadeSatiKind => 'Sade Sati';

  @override
  String get smallPanoti => 'Small Panoti';

  @override
  String get phaseRising => 'Rising';

  @override
  String get phasePeak => 'Peak';

  @override
  String get phaseSetting => 'Setting';

  @override
  String get runningNow => 'running now';

  @override
  String get colBaladi => 'Baladi';

  @override
  String get colJagratadi => 'Jagratadi';

  @override
  String get colDeeptadi => 'Deeptadi';

  @override
  String get avasthaNote =>
      'Baladi and Jagratadi by degrees (reversed in even signs); Deeptadi by dignity, Kopa if combust.';

  @override
  String get upagrahaNote =>
      'Gulika = lagna at the start of Saturn\'s part of the day/night; Maandi = at its middle (BPHS). Other software may use a different rule.';

  @override
  String get arudhaNote => 'A1 = Arudha Lagna (AL), A12 = Upapada (UL).';

  @override
  String get colTara => 'Tara';

  @override
  String colCycle(Object n) {
    return 'Cycle $n';
  }

  @override
  String get panchang => 'Panchang';

  @override
  String get choosePanchangPlace => 'Choose a place for the panchang';

  @override
  String get changePlace => 'Change place';

  @override
  String get secToday => 'Day';

  @override
  String get secHora => 'Hora';

  @override
  String get secChogadia => 'Chogadia';

  @override
  String get secMuhurta => 'Muhurta';

  @override
  String get secLagnaTable => 'Lagna table';

  @override
  String get secPanchakBhadra => 'Panchak & Bhadra';

  @override
  String get secVrat => 'Vrat';

  @override
  String untilTime(Object time) {
    return 'until $time';
  }

  @override
  String thenNext(Object name) {
    return 'then $name';
  }

  @override
  String get moonrise => 'Moonrise';

  @override
  String get moonset => 'Moonset';

  @override
  String get noRiseSet => 'none today';

  @override
  String get paksha => 'Paksha';

  @override
  String get monthAmanta => 'Month (amanta)';

  @override
  String get monthPurnimanta => 'Month (purnimanta)';

  @override
  String get adhikaPrefix => 'Adhika';

  @override
  String get samvat => 'Samvat';

  @override
  String samvatValue(Object v, Object s) {
    return 'Vikram $v · Shaka $s';
  }

  @override
  String get sunSign => 'Sun sign';

  @override
  String get moonSign => 'Moon sign';

  @override
  String get rightNow => 'Right now';

  @override
  String get currentHora => 'Hora';

  @override
  String get currentChogadia => 'Chogadia';

  @override
  String get currentLagna => 'Lagna';

  @override
  String get currentMuhurta => 'Muhurta';

  @override
  String lagnaNature(Object sign, Object nature) {
    return '$sign ($nature)';
  }

  @override
  String get movable => 'movable';

  @override
  String get fixed => 'fixed';

  @override
  String get dual => 'dual';

  @override
  String get kaalsTitle => 'Inauspicious & auspicious periods';

  @override
  String get dayPart => 'Day';

  @override
  String get nightPart => 'Night';

  @override
  String get colTime => 'Time';

  @override
  String get good => 'good';

  @override
  String get bad => 'avoid';

  @override
  String get panchakTitle => 'Panchak this month';

  @override
  String get bhadraTitle => 'Bhadra this month';

  @override
  String get nonePeriod => 'None';

  @override
  String vratTitle(Object year) {
    return 'Vrat dates $year';
  }

  @override
  String get vratNote =>
      'Smarta rules: Ekadashi, Purnima, Amavasya by the tithi at sunrise; Pradosh at sunset; Sankashti at moonrise; Shivaratri at midnight.';

  @override
  String get allVrats => 'All';

  @override
  String get computing => 'Calculating…';
}
