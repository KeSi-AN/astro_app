import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @startError.
  ///
  /// In en, this message translates to:
  /// **'Could not start: {error}'**
  String startError(Object error);

  /// No description provided for @chartsTitle.
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get chartsTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @searchCharts.
  ///
  /// In en, this message translates to:
  /// **'Search by name or place'**
  String get searchCharts;

  /// No description provided for @newChart.
  ///
  /// In en, this message translates to:
  /// **'New chart'**
  String get newChart;

  /// No description provided for @loadChartsError.
  ///
  /// In en, this message translates to:
  /// **'Could not load charts: {error}'**
  String loadChartsError(Object error);

  /// No description provided for @noChartsYet.
  ///
  /// In en, this message translates to:
  /// **'No charts yet.\nTap \"New chart\" to add one.'**
  String get noChartsYet;

  /// No description provided for @noChartMatches.
  ///
  /// In en, this message translates to:
  /// **'No chart matches \"{query}\".'**
  String noChartMatches(Object query);

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete chart?'**
  String get deleteChartTitle;

  /// No description provided for @deleteChartBody.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" will be removed from this phone. This cannot be undone.'**
  String deleteChartBody(Object name);

  /// No description provided for @copySuffix.
  ///
  /// In en, this message translates to:
  /// **'(copy)'**
  String get copySuffix;

  /// No description provided for @editChart.
  ///
  /// In en, this message translates to:
  /// **'Edit chart'**
  String get editChart;

  /// No description provided for @pasteDetails.
  ///
  /// In en, this message translates to:
  /// **'Paste details'**
  String get pasteDetails;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get enterName;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date (DD/MM/YYYY)'**
  String get dateLabel;

  /// No description provided for @dateError.
  ///
  /// In en, this message translates to:
  /// **'DD/MM/YYYY, 1800–2399'**
  String get dateError;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time (24h, HH:MM:SS)'**
  String get timeLabel;

  /// No description provided for @timeError.
  ///
  /// In en, this message translates to:
  /// **'e.g. 22:45:10'**
  String get timeError;

  /// No description provided for @birthPlace.
  ///
  /// In en, this message translates to:
  /// **'Birth place'**
  String get birthPlace;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital status'**
  String get maritalStatus;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get occupation;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @saveAndOpen.
  ///
  /// In en, this message translates to:
  /// **'Save & open'**
  String get saveAndOpen;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @choosePlace.
  ///
  /// In en, this message translates to:
  /// **'Choose the birth place.'**
  String get choosePlace;

  /// No description provided for @checkTimeZone.
  ///
  /// In en, this message translates to:
  /// **'Check the time zone.'**
  String get checkTimeZone;

  /// No description provided for @enterOffset.
  ///
  /// In en, this message translates to:
  /// **'Enter the UTC offset, e.g. 5:30'**
  String get enterOffset;

  /// No description provided for @unknownZone.
  ///
  /// In en, this message translates to:
  /// **'Unknown time zone \"{zone}\". Use a manual offset.'**
  String unknownZone(Object zone);

  /// No description provided for @noDetailsFound.
  ///
  /// In en, this message translates to:
  /// **'No birth details found in that text.'**
  String get noDetailsFound;

  /// No description provided for @noDateFound.
  ///
  /// In en, this message translates to:
  /// **'No date found: enter it below.'**
  String get noDateFound;

  /// No description provided for @noTimeFound.
  ///
  /// In en, this message translates to:
  /// **'No time found: enter it below.'**
  String get noTimeFound;

  /// No description provided for @placeMatched.
  ///
  /// In en, this message translates to:
  /// **'Place matched to {place}. Tap the place to change it.'**
  String placeMatched(Object place);

  /// No description provided for @placeNeedsChoosing.
  ///
  /// In en, this message translates to:
  /// **'Place \"{place}\" needs choosing.'**
  String placeNeedsChoosing(Object place);

  /// No description provided for @noteMonthFirst.
  ///
  /// In en, this message translates to:
  /// **'Date read as month/day ({a}/{b}), since {b} is not a valid month.'**
  String noteMonthFirst(Object a, Object b);

  /// No description provided for @noteDayFirst.
  ///
  /// In en, this message translates to:
  /// **'Date read as day/month (Indian order). Check it isn\'t month/day.'**
  String get noteDayFirst;

  /// No description provided for @noteAfterMidnight.
  ///
  /// In en, this message translates to:
  /// **'Night time read as {time} after midnight. Check the date.'**
  String noteAfterMidnight(Object time);

  /// No description provided for @noteNoAmPm.
  ///
  /// In en, this message translates to:
  /// **'No AM/PM given: time read as 24-hour ({time}).'**
  String noteNoAmPm(Object time);

  /// No description provided for @pasteTitle.
  ///
  /// In en, this message translates to:
  /// **'Paste birth details'**
  String get pasteTitle;

  /// No description provided for @pasteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g.\nName: Rahul Sharma\nDOB 12/03/1990, 10:45 am\nPlace: Lucknow'**
  String get pasteHint;

  /// No description provided for @fillForm.
  ///
  /// In en, this message translates to:
  /// **'Fill form'**
  String get fillForm;

  /// No description provided for @timeZone.
  ///
  /// In en, this message translates to:
  /// **'Time zone'**
  String get timeZone;

  /// No description provided for @birthTimeIsIn.
  ///
  /// In en, this message translates to:
  /// **'Birth time is in'**
  String get birthTimeIsIn;

  /// No description provided for @utcOffset.
  ///
  /// In en, this message translates to:
  /// **'UTC offset'**
  String get utcOffset;

  /// No description provided for @dstWarHours.
  ///
  /// In en, this message translates to:
  /// **'DST / war time (h)'**
  String get dstWarHours;

  /// No description provided for @standardOffset.
  ///
  /// In en, this message translates to:
  /// **'Standard {offset}'**
  String standardOffset(Object offset);

  /// No description provided for @dstPlus.
  ///
  /// In en, this message translates to:
  /// **'DST +{hours}h'**
  String dstPlus(Object hours);

  /// No description provided for @warTimePlus.
  ///
  /// In en, this message translates to:
  /// **'War time +{hours}h'**
  String warTimePlus(Object hours);

  /// No description provided for @lmtCorrection.
  ///
  /// In en, this message translates to:
  /// **'LMT correction'**
  String get lmtCorrection;

  /// No description provided for @warTimeSwitch.
  ///
  /// In en, this message translates to:
  /// **'Recorded time includes war time (+1h)'**
  String get warTimeSwitch;

  /// No description provided for @tzPre1906.
  ///
  /// In en, this message translates to:
  /// **'Before 1906 India had no single standard time. Local mean time is assumed; switch if the record used Madras or Calcutta time.'**
  String get tzPre1906;

  /// No description provided for @tzBombay.
  ///
  /// In en, this message translates to:
  /// **'Bombay kept its own Bombay Time (UTC+4:51) until 1955. If the birth was recorded in Bombay Time, choose it above.'**
  String get tzBombay;

  /// No description provided for @tzCalcutta.
  ///
  /// In en, this message translates to:
  /// **'Calcutta kept its own Calcutta Time (UTC+5:53:20) until 1948. If the birth was recorded in Calcutta Time, choose it above.'**
  String get tzCalcutta;

  /// No description provided for @tzNonExistent.
  ///
  /// In en, this message translates to:
  /// **'This time did not exist here (clocks were moved forward). Check the recorded time or set the offset manually.'**
  String get tzNonExistent;

  /// No description provided for @tzAmbiguous.
  ///
  /// In en, this message translates to:
  /// **'Clocks went back around this time, so it may have occurred twice. Confirm whether daylight saving was still on.'**
  String get tzAmbiguous;

  /// No description provided for @tzWarOn.
  ///
  /// In en, this message translates to:
  /// **'War time was in force (clocks 1 hour ahead of IST, UTC+6:30). Turn this off only if the recorded time was in IST.'**
  String get tzWarOn;

  /// No description provided for @tzWarOff.
  ///
  /// In en, this message translates to:
  /// **'War-time hour removed: the recorded time is treated as IST (UTC+5:30).'**
  String get tzWarOff;

  /// No description provided for @placeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Town or village (add \", state\" to narrow)'**
  String get placeSearchHint;

  /// No description provided for @placeSearchLatin.
  ///
  /// In en, this message translates to:
  /// **'Type place names in English letters, e.g. Lucknow.'**
  String get placeSearchLatin;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @noPlaceFound.
  ///
  /// In en, this message translates to:
  /// **'No place found. Try another spelling, or enter the coordinates yourself.'**
  String get noPlaceFound;

  /// No description provided for @enterCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Enter coordinates manually'**
  String get enterCoordinates;

  /// No description provided for @geonamesCredit.
  ///
  /// In en, this message translates to:
  /// **'Place data © GeoNames (geonames.org), CC BY 4.0'**
  String get geonamesCredit;

  /// No description provided for @placeByCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Place by coordinates'**
  String get placeByCoordinates;

  /// No description provided for @placeName.
  ///
  /// In en, this message translates to:
  /// **'Place name'**
  String get placeName;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitudeGeo.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitudeGeo;

  /// No description provided for @latError.
  ///
  /// In en, this message translates to:
  /// **'e.g. 27.15 or 27N09'**
  String get latError;

  /// No description provided for @lonError.
  ///
  /// In en, this message translates to:
  /// **'e.g. 78.0 or 078E00'**
  String get lonError;

  /// No description provided for @zoneError.
  ///
  /// In en, this message translates to:
  /// **'An IANA zone like Asia/Kolkata'**
  String get zoneError;

  /// No description provided for @use.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get use;

  /// No description provided for @editBirthDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit birth details'**
  String get editBirthDetails;

  /// No description provided for @tabChart.
  ///
  /// In en, this message translates to:
  /// **'Chart'**
  String get tabChart;

  /// No description provided for @tabPlanets.
  ///
  /// In en, this message translates to:
  /// **'Planets'**
  String get tabPlanets;

  /// No description provided for @tabBhava.
  ///
  /// In en, this message translates to:
  /// **'Bhava'**
  String get tabBhava;

  /// No description provided for @tabDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get tabDetails;

  /// No description provided for @tabFriendship.
  ///
  /// In en, this message translates to:
  /// **'Friendship'**
  String get tabFriendship;

  /// No description provided for @tabKarakas.
  ///
  /// In en, this message translates to:
  /// **'Karakas'**
  String get tabKarakas;

  /// No description provided for @chartNotFound.
  ///
  /// In en, this message translates to:
  /// **'Chart not found'**
  String get chartNotFound;

  /// No description provided for @chartLegend.
  ///
  /// In en, this message translates to:
  /// **'* retrograde  ^ combust  ◻ vargottama  ↑ exalted  ↓ debilitated'**
  String get chartLegend;

  /// No description provided for @chalitNorthOnly.
  ///
  /// In en, this message translates to:
  /// **'Chalit is always shown North Indian (house-based).'**
  String get chalitNorthOnly;

  /// No description provided for @tapPlanet.
  ///
  /// In en, this message translates to:
  /// **'Tap a planet for details.'**
  String get tapPlanet;

  /// No description provided for @navamshaTitle.
  ///
  /// In en, this message translates to:
  /// **'Navamsha (D9)'**
  String get navamshaTitle;

  /// No description provided for @chalitTitle.
  ///
  /// In en, this message translates to:
  /// **'Chalit (Sripati)'**
  String get chalitTitle;

  /// No description provided for @sign.
  ///
  /// In en, this message translates to:
  /// **'Sign'**
  String get sign;

  /// No description provided for @withLord.
  ///
  /// In en, this message translates to:
  /// **'{name} (lord {lord})'**
  String withLord(Object name, Object lord);

  /// No description provided for @degreeInSignLabel.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get degreeInSignLabel;

  /// No description provided for @nakshatraPada.
  ///
  /// In en, this message translates to:
  /// **'{nakshatra}, pada {pada}'**
  String nakshatraPada(Object nakshatra, Object pada);

  /// No description provided for @starSubLords.
  ///
  /// In en, this message translates to:
  /// **'Star / sub / sub-sub lord'**
  String get starSubLords;

  /// No description provided for @houseWholeSign.
  ///
  /// In en, this message translates to:
  /// **'House (whole sign)'**
  String get houseWholeSign;

  /// No description provided for @chalitBhava.
  ///
  /// In en, this message translates to:
  /// **'Chalit bhava'**
  String get chalitBhava;

  /// No description provided for @navamsha.
  ///
  /// In en, this message translates to:
  /// **'Navamsha'**
  String get navamsha;

  /// No description provided for @dignity.
  ///
  /// In en, this message translates to:
  /// **'Dignity'**
  String get dignity;

  /// No description provided for @motion.
  ///
  /// In en, this message translates to:
  /// **'Motion'**
  String get motion;

  /// No description provided for @retrograde.
  ///
  /// In en, this message translates to:
  /// **'Retrograde'**
  String get retrograde;

  /// No description provided for @direct.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get direct;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @speedValue.
  ///
  /// In en, this message translates to:
  /// **'{value}°/day'**
  String speedValue(Object value);

  /// No description provided for @combust.
  ///
  /// In en, this message translates to:
  /// **'Combust'**
  String get combust;

  /// No description provided for @vargottama.
  ///
  /// In en, this message translates to:
  /// **'Vargottama'**
  String get vargottama;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @colPlanet.
  ///
  /// In en, this message translates to:
  /// **'Planet'**
  String get colPlanet;

  /// No description provided for @colDegree.
  ///
  /// In en, this message translates to:
  /// **'Degree'**
  String get colDegree;

  /// No description provided for @colNakshatra.
  ///
  /// In en, this message translates to:
  /// **'Nakshatra'**
  String get colNakshatra;

  /// No description provided for @colStar.
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get colStar;

  /// No description provided for @colSub.
  ///
  /// In en, this message translates to:
  /// **'Sub'**
  String get colSub;

  /// No description provided for @flagRetro.
  ///
  /// In en, this message translates to:
  /// **'R'**
  String get flagRetro;

  /// No description provided for @flagCombust.
  ///
  /// In en, this message translates to:
  /// **'C'**
  String get flagCombust;

  /// No description provided for @flagVargottama.
  ///
  /// In en, this message translates to:
  /// **'V'**
  String get flagVargottama;

  /// No description provided for @planetsLegend.
  ///
  /// In en, this message translates to:
  /// **'R retrograde · C combust · V vargottama. Dignity uses the compound (five-fold) relationship with the sign lord.'**
  String get planetsLegend;

  /// No description provided for @bhavaTitle.
  ///
  /// In en, this message translates to:
  /// **'Bhava chalit (Sripati)'**
  String get bhavaTitle;

  /// No description provided for @colBhava.
  ///
  /// In en, this message translates to:
  /// **'Bhava'**
  String get colBhava;

  /// No description provided for @colStart.
  ///
  /// In en, this message translates to:
  /// **'Start (sandhi)'**
  String get colStart;

  /// No description provided for @colMadhya.
  ///
  /// In en, this message translates to:
  /// **'Madhya'**
  String get colMadhya;

  /// No description provided for @colEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get colEnd;

  /// No description provided for @colPlanets.
  ///
  /// In en, this message translates to:
  /// **'Planets'**
  String get colPlanets;

  /// No description provided for @chalitDiffers.
  ///
  /// In en, this message translates to:
  /// **'Planets whose chalit bhava differs from their sign house:'**
  String get chalitDiffers;

  /// No description provided for @chalitShift.
  ///
  /// In en, this message translates to:
  /// **'{planet}: house {house} → bhava {bhava}'**
  String chalitShift(Object planet, Object house, Object bhava);

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @kpCuspsTitle.
  ///
  /// In en, this message translates to:
  /// **'Placidus cusps (KP)'**
  String get kpCuspsTitle;

  /// No description provided for @colCusp.
  ///
  /// In en, this message translates to:
  /// **'Cusp'**
  String get colCusp;

  /// No description provided for @colLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get colLongitude;

  /// No description provided for @birthDetails.
  ///
  /// In en, this message translates to:
  /// **'Birth details'**
  String get birthDetails;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get place;

  /// No description provided for @latLon.
  ///
  /// In en, this message translates to:
  /// **'Latitude / longitude'**
  String get latLon;

  /// No description provided for @warTime.
  ///
  /// In en, this message translates to:
  /// **'War time'**
  String get warTime;

  /// No description provided for @dst.
  ///
  /// In en, this message translates to:
  /// **'DST'**
  String get dst;

  /// No description provided for @hoursValue.
  ///
  /// In en, this message translates to:
  /// **'+{hours} h'**
  String hoursValue(Object hours);

  /// No description provided for @lmtAtBirth.
  ///
  /// In en, this message translates to:
  /// **'LMT at birth'**
  String get lmtAtBirth;

  /// No description provided for @utAtBirth.
  ///
  /// In en, this message translates to:
  /// **'UT (GMT) at birth'**
  String get utAtBirth;

  /// No description provided for @julianDay.
  ///
  /// In en, this message translates to:
  /// **'Julian day (UT)'**
  String get julianDay;

  /// No description provided for @ayanamsa.
  ///
  /// In en, this message translates to:
  /// **'Ayanamsa'**
  String get ayanamsa;

  /// No description provided for @obliquity.
  ///
  /// In en, this message translates to:
  /// **'Obliquity'**
  String get obliquity;

  /// No description provided for @siderealTime.
  ///
  /// In en, this message translates to:
  /// **'Sidereal time'**
  String get siderealTime;

  /// No description provided for @panchangAtBirth.
  ///
  /// In en, this message translates to:
  /// **'Panchang at birth'**
  String get panchangAtBirth;

  /// No description provided for @hinduWeekday.
  ///
  /// In en, this message translates to:
  /// **'Hindu weekday'**
  String get hinduWeekday;

  /// No description provided for @tithi.
  ///
  /// In en, this message translates to:
  /// **'Tithi'**
  String get tithi;

  /// No description provided for @nakshatra.
  ///
  /// In en, this message translates to:
  /// **'Nakshatra'**
  String get nakshatra;

  /// No description provided for @yoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get yoga;

  /// No description provided for @karana.
  ///
  /// In en, this message translates to:
  /// **'Karana'**
  String get karana;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @sunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunset;

  /// No description provided for @dayLength.
  ///
  /// In en, this message translates to:
  /// **'Day length'**
  String get dayLength;

  /// No description provided for @ishtkaal.
  ///
  /// In en, this message translates to:
  /// **'Ishtkaal (ghati)'**
  String get ishtkaal;

  /// No description provided for @sunriseRule.
  ///
  /// In en, this message translates to:
  /// **'Sunrise rule'**
  String get sunriseRule;

  /// No description provided for @avakhada.
  ///
  /// In en, this message translates to:
  /// **'Avakhada chakra'**
  String get avakhada;

  /// No description provided for @lagna.
  ///
  /// In en, this message translates to:
  /// **'Lagna'**
  String get lagna;

  /// No description provided for @rashi.
  ///
  /// In en, this message translates to:
  /// **'Rashi'**
  String get rashi;

  /// No description provided for @nakshatraPadaLabel.
  ///
  /// In en, this message translates to:
  /// **'Nakshatra-pada'**
  String get nakshatraPadaLabel;

  /// No description provided for @varna.
  ///
  /// In en, this message translates to:
  /// **'Varna'**
  String get varna;

  /// No description provided for @vashya.
  ///
  /// In en, this message translates to:
  /// **'Vashya'**
  String get vashya;

  /// No description provided for @yoni.
  ///
  /// In en, this message translates to:
  /// **'Yoni'**
  String get yoni;

  /// No description provided for @gana.
  ///
  /// In en, this message translates to:
  /// **'Gana'**
  String get gana;

  /// No description provided for @nadi.
  ///
  /// In en, this message translates to:
  /// **'Nadi'**
  String get nadi;

  /// No description provided for @tatva.
  ///
  /// In en, this message translates to:
  /// **'Tatva'**
  String get tatva;

  /// No description provided for @payaNakshatra.
  ///
  /// In en, this message translates to:
  /// **'Paya (nakshatra)'**
  String get payaNakshatra;

  /// No description provided for @payaMoon.
  ///
  /// In en, this message translates to:
  /// **'Paya (Moon house)'**
  String get payaMoon;

  /// No description provided for @nameSyllable.
  ///
  /// In en, this message translates to:
  /// **'Name syllable'**
  String get nameSyllable;

  /// No description provided for @dashaBalance.
  ///
  /// In en, this message translates to:
  /// **'Dasha balance'**
  String get dashaBalance;

  /// No description provided for @sunSignIndian.
  ///
  /// In en, this message translates to:
  /// **'Sun sign (Indian)'**
  String get sunSignIndian;

  /// No description provided for @sunSignWestern.
  ///
  /// In en, this message translates to:
  /// **'Sun sign (Western)'**
  String get sunSignWestern;

  /// No description provided for @ymd.
  ///
  /// In en, this message translates to:
  /// **'{y}y {m}m {d}d'**
  String ymd(Object y, Object m, Object d);

  /// No description provided for @naturalTitle.
  ///
  /// In en, this message translates to:
  /// **'Natural (permanent)'**
  String get naturalTitle;

  /// No description provided for @temporalTitle.
  ///
  /// In en, this message translates to:
  /// **'Temporal (in this chart)'**
  String get temporalTitle;

  /// No description provided for @compoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Five-fold (compound)'**
  String get compoundTitle;

  /// No description provided for @friendshipLegend.
  ///
  /// In en, this message translates to:
  /// **'GF great friend · F friend · N neutral · E enemy · GE great enemy'**
  String get friendshipLegend;

  /// No description provided for @charaKarakasTitle.
  ///
  /// In en, this message translates to:
  /// **'Chara karakas · {scheme}'**
  String charaKarakasTitle(Object scheme);

  /// No description provided for @colKaraka.
  ///
  /// In en, this message translates to:
  /// **'Karaka'**
  String get colKaraka;

  /// No description provided for @colDegreeInSign.
  ///
  /// In en, this message translates to:
  /// **'Degree in sign'**
  String get colDegreeInSign;

  /// No description provided for @rahuBackwards.
  ///
  /// In en, this message translates to:
  /// **'Rahu\'s degree is counted backwards (30° − its degree).'**
  String get rahuBackwards;

  /// No description provided for @karakaSchemeHint.
  ///
  /// In en, this message translates to:
  /// **'Change to the 8-karaka scheme (with Rahu) in Settings.'**
  String get karakaSchemeHint;

  /// No description provided for @display.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get display;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Same as phone'**
  String get languageSystem;

  /// No description provided for @chartStyle.
  ///
  /// In en, this message translates to:
  /// **'Chart style'**
  String get chartStyle;

  /// No description provided for @showOuterPlanets.
  ///
  /// In en, this message translates to:
  /// **'Show Uranus, Neptune, Pluto'**
  String get showOuterPlanets;

  /// No description provided for @calculation.
  ///
  /// In en, this message translates to:
  /// **'Calculation'**
  String get calculation;

  /// No description provided for @rahuKetu.
  ///
  /// In en, this message translates to:
  /// **'Rahu / Ketu'**
  String get rahuKetu;

  /// No description provided for @charaKarakas.
  ///
  /// In en, this message translates to:
  /// **'Chara karakas'**
  String get charaKarakas;

  /// No description provided for @settingsFootnote.
  ///
  /// In en, this message translates to:
  /// **'Defaults match AstroSage: Lahiri, mean node, upper-limb sunrise. Planet positions come from Swiss Ephemeris (Astrodienst, AGPL). Place data © GeoNames, CC BY 4.0.'**
  String get settingsFootnote;

  /// No description provided for @tabVargas.
  ///
  /// In en, this message translates to:
  /// **'Vargas'**
  String get tabVargas;

  /// No description provided for @tabDasha.
  ///
  /// In en, this message translates to:
  /// **'Dasha'**
  String get tabDasha;

  /// No description provided for @vimshottari.
  ///
  /// In en, this message translates to:
  /// **'Vimshottari'**
  String get vimshottari;

  /// No description provided for @yoginiDasha.
  ///
  /// In en, this message translates to:
  /// **'Yogini'**
  String get yoginiDasha;

  /// No description provided for @charaDasha.
  ///
  /// In en, this message translates to:
  /// **'Chara'**
  String get charaDasha;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @jumpToDate.
  ///
  /// In en, this message translates to:
  /// **'Go to date'**
  String get jumpToDate;

  /// No description provided for @colLord.
  ///
  /// In en, this message translates to:
  /// **'Lord'**
  String get colLord;

  /// No description provided for @colFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get colFrom;

  /// No description provided for @colTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get colTo;

  /// No description provided for @colAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get colAge;

  /// No description provided for @runningAt.
  ///
  /// In en, this message translates to:
  /// **'Running on {date}'**
  String runningAt(Object date);

  /// No description provided for @dashaHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a period to open its sub-periods.'**
  String get dashaHint;

  /// No description provided for @dashaYearSetting.
  ///
  /// In en, this message translates to:
  /// **'Dasha year'**
  String get dashaYearSetting;

  /// No description provided for @charaNote.
  ///
  /// In en, this message translates to:
  /// **'Chara dasha per K.N. Rao: sequence runs {direction} from the lagna; antardashas start from the next sign.'**
  String charaNote(Object direction);

  /// No description provided for @forwards.
  ///
  /// In en, this message translates to:
  /// **'forwards'**
  String get forwards;

  /// No description provided for @backwards.
  ///
  /// In en, this message translates to:
  /// **'backwards'**
  String get backwards;

  /// No description provided for @yoginiNote.
  ///
  /// In en, this message translates to:
  /// **'Yogini dasha: 36-year cycle, starting yogini = nakshatra number + 3.'**
  String get yoginiNote;

  /// No description provided for @vargaTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign of each planet in the 16 vargas'**
  String get vargaTableTitle;

  /// No description provided for @vargaTableNote.
  ///
  /// In en, this message translates to:
  /// **'Numbers are signs: 1 Aries … 12 Pisces; highlighted = same sign as in D1. Tap a varga below to open its chart.'**
  String get vargaTableNote;

  /// No description provided for @divisional.
  ///
  /// In en, this message translates to:
  /// **'D-charts'**
  String get divisional;

  /// No description provided for @tabStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get tabStrength;

  /// No description provided for @ashtakavarga.
  ///
  /// In en, this message translates to:
  /// **'Ashtakavarga'**
  String get ashtakavarga;

  /// No description provided for @shadbala.
  ///
  /// In en, this message translates to:
  /// **'Shadbala'**
  String get shadbala;

  /// No description provided for @bhavaBala.
  ///
  /// In en, this message translates to:
  /// **'Bhava bala'**
  String get bhavaBala;

  /// No description provided for @bavTitle.
  ///
  /// In en, this message translates to:
  /// **'Bhinnashtakavarga (bindus per sign)'**
  String get bavTitle;

  /// No description provided for @savTitle.
  ///
  /// In en, this message translates to:
  /// **'Sarvashtakavarga'**
  String get savTitle;

  /// No description provided for @savByHouse.
  ///
  /// In en, this message translates to:
  /// **'SAV by house from lagna'**
  String get savByHouse;

  /// No description provided for @prastaraTitle.
  ///
  /// In en, this message translates to:
  /// **'Prastara of {planet}'**
  String prastaraTitle(Object planet);

  /// No description provided for @avNote.
  ///
  /// In en, this message translates to:
  /// **'Signs: 1 Aries … 12 Pisces. Total 337. Houses with 28+ bindus are strong.'**
  String get avNote;

  /// No description provided for @colTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get colTotal;

  /// No description provided for @contributor.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get contributor;

  /// No description provided for @sthanaBala.
  ///
  /// In en, this message translates to:
  /// **'Sthana bala'**
  String get sthanaBala;

  /// No description provided for @uchchaBala.
  ///
  /// In en, this message translates to:
  /// **'Uchcha'**
  String get uchchaBala;

  /// No description provided for @saptavargajaBala.
  ///
  /// In en, this message translates to:
  /// **'Saptavargaja'**
  String get saptavargajaBala;

  /// No description provided for @ojayugmaBala.
  ///
  /// In en, this message translates to:
  /// **'Ojayugma'**
  String get ojayugmaBala;

  /// No description provided for @kendradiBala.
  ///
  /// In en, this message translates to:
  /// **'Kendradi'**
  String get kendradiBala;

  /// No description provided for @drekkanaBala.
  ///
  /// In en, this message translates to:
  /// **'Drekkana'**
  String get drekkanaBala;

  /// No description provided for @digBala.
  ///
  /// In en, this message translates to:
  /// **'Dig bala'**
  String get digBala;

  /// No description provided for @kalaBala.
  ///
  /// In en, this message translates to:
  /// **'Kala bala'**
  String get kalaBala;

  /// No description provided for @nathonnathaBala.
  ///
  /// In en, this message translates to:
  /// **'Nathonnatha'**
  String get nathonnathaBala;

  /// No description provided for @pakshaBala.
  ///
  /// In en, this message translates to:
  /// **'Paksha'**
  String get pakshaBala;

  /// No description provided for @tribhagaBala.
  ///
  /// In en, this message translates to:
  /// **'Tribhaga'**
  String get tribhagaBala;

  /// No description provided for @abdaBala.
  ///
  /// In en, this message translates to:
  /// **'Abda (year)'**
  String get abdaBala;

  /// No description provided for @masaBala.
  ///
  /// In en, this message translates to:
  /// **'Masa (month)'**
  String get masaBala;

  /// No description provided for @varaBala.
  ///
  /// In en, this message translates to:
  /// **'Vara (day)'**
  String get varaBala;

  /// No description provided for @horaBala.
  ///
  /// In en, this message translates to:
  /// **'Hora'**
  String get horaBala;

  /// No description provided for @ayanaBala.
  ///
  /// In en, this message translates to:
  /// **'Ayana'**
  String get ayanaBala;

  /// No description provided for @yuddhaBala.
  ///
  /// In en, this message translates to:
  /// **'Yuddha'**
  String get yuddhaBala;

  /// No description provided for @cheshtaBala.
  ///
  /// In en, this message translates to:
  /// **'Cheshta bala'**
  String get cheshtaBala;

  /// No description provided for @naisargikaBala.
  ///
  /// In en, this message translates to:
  /// **'Naisargika bala'**
  String get naisargikaBala;

  /// No description provided for @drikBala.
  ///
  /// In en, this message translates to:
  /// **'Drik bala'**
  String get drikBala;

  /// No description provided for @totalVirupas.
  ///
  /// In en, this message translates to:
  /// **'Total (virupas)'**
  String get totalVirupas;

  /// No description provided for @totalRupas.
  ///
  /// In en, this message translates to:
  /// **'Total (rupas)'**
  String get totalRupas;

  /// No description provided for @requiredRupas.
  ///
  /// In en, this message translates to:
  /// **'Required (rupas)'**
  String get requiredRupas;

  /// No description provided for @strengthRatio.
  ///
  /// In en, this message translates to:
  /// **'Ratio'**
  String get strengthRatio;

  /// No description provided for @strengthRank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get strengthRank;

  /// No description provided for @shadbalaNote.
  ///
  /// In en, this message translates to:
  /// **'Values in virupas (60 = 1 rupa), per BPHS ch. 27 as computed by B.V. Raman. Ratio ≥ 1 means the planet meets its required strength.'**
  String get shadbalaNote;

  /// No description provided for @bhavaLordStrength.
  ///
  /// In en, this message translates to:
  /// **'Lord\'s shadbala'**
  String get bhavaLordStrength;

  /// No description provided for @bhavaDig.
  ///
  /// In en, this message translates to:
  /// **'Dig'**
  String get bhavaDig;

  /// No description provided for @bhavaDrishti.
  ///
  /// In en, this message translates to:
  /// **'Drishti'**
  String get bhavaDrishti;

  /// No description provided for @bhavaNote.
  ///
  /// In en, this message translates to:
  /// **'Bhava bala = lord\'s shadbala + directional strength + aspects on the bhava madhya (virupas).'**
  String get bhavaNote;

  /// No description provided for @showSavOnChart.
  ///
  /// In en, this message translates to:
  /// **'Show SAV bindus in each house'**
  String get showSavOnChart;

  /// No description provided for @tabKp.
  ///
  /// In en, this message translates to:
  /// **'KP'**
  String get tabKp;

  /// No description provided for @kpAyanamsaSetting.
  ///
  /// In en, this message translates to:
  /// **'KP ayanamsa'**
  String get kpAyanamsaSetting;

  /// No description provided for @kpPlanets.
  ///
  /// In en, this message translates to:
  /// **'Planets'**
  String get kpPlanets;

  /// No description provided for @kpCusps.
  ///
  /// In en, this message translates to:
  /// **'Cusps'**
  String get kpCusps;

  /// No description provided for @kpSignif.
  ///
  /// In en, this message translates to:
  /// **'Significations'**
  String get kpSignif;

  /// No description provided for @kpRuling.
  ///
  /// In en, this message translates to:
  /// **'Ruling planets'**
  String get kpRuling;

  /// No description provided for @kpHorary.
  ///
  /// In en, this message translates to:
  /// **'Horary'**
  String get kpHorary;

  /// No description provided for @colSignLord.
  ///
  /// In en, this message translates to:
  /// **'Sign'**
  String get colSignLord;

  /// No description provided for @colSubSub.
  ///
  /// In en, this message translates to:
  /// **'Sub-sub'**
  String get colSubSub;

  /// No description provided for @colHouse.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get colHouse;

  /// No description provided for @colL1.
  ///
  /// In en, this message translates to:
  /// **'Star lord occ.'**
  String get colL1;

  /// No description provided for @colL2.
  ///
  /// In en, this message translates to:
  /// **'Occupies'**
  String get colL2;

  /// No description provided for @colL3.
  ///
  /// In en, this message translates to:
  /// **'Star lord owns'**
  String get colL3;

  /// No description provided for @colL4.
  ///
  /// In en, this message translates to:
  /// **'Owns'**
  String get colL4;

  /// No description provided for @colAllHouses.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get colAllHouses;

  /// No description provided for @houseSignificators.
  ///
  /// In en, this message translates to:
  /// **'House significators'**
  String get houseSignificators;

  /// No description provided for @colSignificators.
  ///
  /// In en, this message translates to:
  /// **'Planets'**
  String get colSignificators;

  /// No description provided for @kpSignifNote.
  ///
  /// In en, this message translates to:
  /// **'L1 houses occupied by the star lord, L2 occupied by the planet, L3 owned by the star lord, L4 owned by the planet (Placidus cusps). + = no planet in its stars, or in its own star.'**
  String get kpSignifNote;

  /// No description provided for @rpAtBirth.
  ///
  /// In en, this message translates to:
  /// **'At birth'**
  String get rpAtBirth;

  /// No description provided for @rpNow.
  ///
  /// In en, this message translates to:
  /// **'Now (at birth place)'**
  String get rpNow;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @rpDayLord.
  ///
  /// In en, this message translates to:
  /// **'Day lord'**
  String get rpDayLord;

  /// No description provided for @rpAscSign.
  ///
  /// In en, this message translates to:
  /// **'Lagna sign lord'**
  String get rpAscSign;

  /// No description provided for @rpAscStar.
  ///
  /// In en, this message translates to:
  /// **'Lagna star lord'**
  String get rpAscStar;

  /// No description provided for @rpAscSub.
  ///
  /// In en, this message translates to:
  /// **'Lagna sub lord'**
  String get rpAscSub;

  /// No description provided for @rpMoonSign.
  ///
  /// In en, this message translates to:
  /// **'Moon sign lord'**
  String get rpMoonSign;

  /// No description provided for @rpMoonStar.
  ///
  /// In en, this message translates to:
  /// **'Moon star lord'**
  String get rpMoonStar;

  /// No description provided for @rpMoonSub.
  ///
  /// In en, this message translates to:
  /// **'Moon sub lord'**
  String get rpMoonSub;

  /// No description provided for @horaryNumber.
  ///
  /// In en, this message translates to:
  /// **'Horary number (1–249)'**
  String get horaryNumber;

  /// No description provided for @horaryHint.
  ///
  /// In en, this message translates to:
  /// **'Cusps for the moment today when the lagna reaches the start of this number; planets as of now, at the birth place.'**
  String get horaryHint;

  /// No description provided for @horaryCast.
  ///
  /// In en, this message translates to:
  /// **'Cast horary chart'**
  String get horaryCast;

  /// No description provided for @horaryAsc.
  ///
  /// In en, this message translates to:
  /// **'Lagna {degree}'**
  String horaryAsc(Object degree);

  /// No description provided for @invalidHorary.
  ///
  /// In en, this message translates to:
  /// **'Enter a number from 1 to 249'**
  String get invalidHorary;

  /// No description provided for @kpNadi.
  ///
  /// In en, this message translates to:
  /// **'Nadi'**
  String get kpNadi;

  /// No description provided for @kp4Step.
  ///
  /// In en, this message translates to:
  /// **'4-step'**
  String get kp4Step;

  /// No description provided for @kpCil.
  ///
  /// In en, this message translates to:
  /// **'CIL'**
  String get kpCil;

  /// No description provided for @nadiNote.
  ///
  /// In en, this message translates to:
  /// **'Nakshatra Nadi: houses occupied and owned; Rahu/Ketu also take their sign lord, star lord, and conjunct and aspecting planets.'**
  String get nadiNote;

  /// No description provided for @rowPlanet.
  ///
  /// In en, this message translates to:
  /// **'Planet'**
  String get rowPlanet;

  /// No description provided for @rowStarLord.
  ///
  /// In en, this message translates to:
  /// **'Star lord'**
  String get rowStarLord;

  /// No description provided for @rowSubLord.
  ///
  /// In en, this message translates to:
  /// **'Sub lord'**
  String get rowSubLord;

  /// No description provided for @rowSubStar.
  ///
  /// In en, this message translates to:
  /// **'Star lord of sub lord'**
  String get rowSubStar;

  /// No description provided for @fourStepNote.
  ///
  /// In en, this message translates to:
  /// **'Each step shows the lord and its Nakshatra Nadi houses.'**
  String get fourStepNote;

  /// No description provided for @colT1.
  ///
  /// In en, this message translates to:
  /// **'T1'**
  String get colT1;

  /// No description provided for @colT3.
  ///
  /// In en, this message translates to:
  /// **'T3'**
  String get colT3;

  /// No description provided for @colT4.
  ///
  /// In en, this message translates to:
  /// **'T4'**
  String get colT4;

  /// No description provided for @cilNote.
  ///
  /// In en, this message translates to:
  /// **'Cuspal interlinks (sub), as in AstroSage. T1: cusps whose sub lord is the star or sub lord of this cusp\'s sub lord. T3: cusps whose sub lord has this sub lord as star lord. T4: house occupied by the sub lord\'s star lord.'**
  String get cilNote;

  /// No description provided for @tabYogas.
  ///
  /// In en, this message translates to:
  /// **'Yogas'**
  String get tabYogas;

  /// No description provided for @secYogas.
  ///
  /// In en, this message translates to:
  /// **'Yogas & doshas'**
  String get secYogas;

  /// No description provided for @secSadeSati.
  ///
  /// In en, this message translates to:
  /// **'Sade Sati'**
  String get secSadeSati;

  /// No description provided for @secAvastha.
  ///
  /// In en, this message translates to:
  /// **'Avastha'**
  String get secAvastha;

  /// No description provided for @secUpagraha.
  ///
  /// In en, this message translates to:
  /// **'Upagraha'**
  String get secUpagraha;

  /// No description provided for @secArudha.
  ///
  /// In en, this message translates to:
  /// **'Arudha'**
  String get secArudha;

  /// No description provided for @secNavatara.
  ///
  /// In en, this message translates to:
  /// **'Navatara'**
  String get secNavatara;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @absent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get absent;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @showAbsent.
  ///
  /// In en, this message translates to:
  /// **'Show absent ones'**
  String get showAbsent;

  /// No description provided for @mangalFrom.
  ///
  /// In en, this message translates to:
  /// **'from {ref}: house {house}'**
  String mangalFrom(Object ref, Object house);

  /// No description provided for @refLagna.
  ///
  /// In en, this message translates to:
  /// **'lagna'**
  String get refLagna;

  /// No description provided for @refMoon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get refMoon;

  /// No description provided for @refVenus.
  ///
  /// In en, this message translates to:
  /// **'Venus'**
  String get refVenus;

  /// No description provided for @cancelMarsStrong.
  ///
  /// In en, this message translates to:
  /// **'Mars in own/exalted sign'**
  String get cancelMarsStrong;

  /// No description provided for @cancelWithJupiter.
  ///
  /// In en, this message translates to:
  /// **'Mars with Jupiter'**
  String get cancelWithJupiter;

  /// No description provided for @cancelWithMoon.
  ///
  /// In en, this message translates to:
  /// **'Mars with Moon'**
  String get cancelWithMoon;

  /// No description provided for @cancelSignException.
  ///
  /// In en, this message translates to:
  /// **'Mars in a sign that cancels it in house {house}'**
  String cancelSignException(Object house);

  /// No description provided for @kaalSarpType.
  ///
  /// In en, this message translates to:
  /// **'Type: {name}'**
  String kaalSarpType(Object name);

  /// No description provided for @colYoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga / dosha'**
  String get colYoga;

  /// No description provided for @colResult.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get colResult;

  /// No description provided for @sadeSatiNote.
  ///
  /// In en, this message translates to:
  /// **'Saturn in the 12th, 1st or 2nd from the Moon sign is Sade Sati; in the 4th or 8th, Small Panoti (Dhaiya). Retrograde returns are listed separately.'**
  String get sadeSatiNote;

  /// No description provided for @colKind.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get colKind;

  /// No description provided for @colPhase.
  ///
  /// In en, this message translates to:
  /// **'Phase'**
  String get colPhase;

  /// No description provided for @sadeSatiKind.
  ///
  /// In en, this message translates to:
  /// **'Sade Sati'**
  String get sadeSatiKind;

  /// No description provided for @smallPanoti.
  ///
  /// In en, this message translates to:
  /// **'Small Panoti'**
  String get smallPanoti;

  /// No description provided for @phaseRising.
  ///
  /// In en, this message translates to:
  /// **'Rising'**
  String get phaseRising;

  /// No description provided for @phasePeak.
  ///
  /// In en, this message translates to:
  /// **'Peak'**
  String get phasePeak;

  /// No description provided for @phaseSetting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get phaseSetting;

  /// No description provided for @runningNow.
  ///
  /// In en, this message translates to:
  /// **'running now'**
  String get runningNow;

  /// No description provided for @colBaladi.
  ///
  /// In en, this message translates to:
  /// **'Baladi'**
  String get colBaladi;

  /// No description provided for @colJagratadi.
  ///
  /// In en, this message translates to:
  /// **'Jagratadi'**
  String get colJagratadi;

  /// No description provided for @colDeeptadi.
  ///
  /// In en, this message translates to:
  /// **'Deeptadi'**
  String get colDeeptadi;

  /// No description provided for @avasthaNote.
  ///
  /// In en, this message translates to:
  /// **'Baladi and Jagratadi by degrees (reversed in even signs); Deeptadi by dignity, Kopa if combust.'**
  String get avasthaNote;

  /// No description provided for @upagrahaNote.
  ///
  /// In en, this message translates to:
  /// **'Gulika = lagna at the start of Saturn\'s part of the day/night; Maandi = at its middle (BPHS). Other software may use a different rule.'**
  String get upagrahaNote;

  /// No description provided for @arudhaNote.
  ///
  /// In en, this message translates to:
  /// **'A1 = Arudha Lagna (AL), A12 = Upapada (UL).'**
  String get arudhaNote;

  /// No description provided for @colTara.
  ///
  /// In en, this message translates to:
  /// **'Tara'**
  String get colTara;

  /// No description provided for @colCycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle {n}'**
  String colCycle(Object n);

  /// No description provided for @panchang.
  ///
  /// In en, this message translates to:
  /// **'Panchang'**
  String get panchang;

  /// No description provided for @choosePanchangPlace.
  ///
  /// In en, this message translates to:
  /// **'Choose a place for the panchang'**
  String get choosePanchangPlace;

  /// No description provided for @changePlace.
  ///
  /// In en, this message translates to:
  /// **'Change place'**
  String get changePlace;

  /// No description provided for @secToday.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get secToday;

  /// No description provided for @secHora.
  ///
  /// In en, this message translates to:
  /// **'Hora'**
  String get secHora;

  /// No description provided for @secChogadia.
  ///
  /// In en, this message translates to:
  /// **'Chogadia'**
  String get secChogadia;

  /// No description provided for @secMuhurta.
  ///
  /// In en, this message translates to:
  /// **'Muhurta'**
  String get secMuhurta;

  /// No description provided for @secLagnaTable.
  ///
  /// In en, this message translates to:
  /// **'Lagna table'**
  String get secLagnaTable;

  /// No description provided for @secPanchakBhadra.
  ///
  /// In en, this message translates to:
  /// **'Panchak & Bhadra'**
  String get secPanchakBhadra;

  /// No description provided for @secVrat.
  ///
  /// In en, this message translates to:
  /// **'Vrat'**
  String get secVrat;

  /// No description provided for @untilTime.
  ///
  /// In en, this message translates to:
  /// **'until {time}'**
  String untilTime(Object time);

  /// No description provided for @thenNext.
  ///
  /// In en, this message translates to:
  /// **'then {name}'**
  String thenNext(Object name);

  /// No description provided for @moonrise.
  ///
  /// In en, this message translates to:
  /// **'Moonrise'**
  String get moonrise;

  /// No description provided for @moonset.
  ///
  /// In en, this message translates to:
  /// **'Moonset'**
  String get moonset;

  /// No description provided for @noRiseSet.
  ///
  /// In en, this message translates to:
  /// **'none today'**
  String get noRiseSet;

  /// No description provided for @paksha.
  ///
  /// In en, this message translates to:
  /// **'Paksha'**
  String get paksha;

  /// No description provided for @monthAmanta.
  ///
  /// In en, this message translates to:
  /// **'Month (amanta)'**
  String get monthAmanta;

  /// No description provided for @monthPurnimanta.
  ///
  /// In en, this message translates to:
  /// **'Month (purnimanta)'**
  String get monthPurnimanta;

  /// No description provided for @adhikaPrefix.
  ///
  /// In en, this message translates to:
  /// **'Adhika'**
  String get adhikaPrefix;

  /// No description provided for @samvat.
  ///
  /// In en, this message translates to:
  /// **'Samvat'**
  String get samvat;

  /// No description provided for @samvatValue.
  ///
  /// In en, this message translates to:
  /// **'Vikram {v} · Shaka {s}'**
  String samvatValue(Object v, Object s);

  /// No description provided for @sunSign.
  ///
  /// In en, this message translates to:
  /// **'Sun sign'**
  String get sunSign;

  /// No description provided for @moonSign.
  ///
  /// In en, this message translates to:
  /// **'Moon sign'**
  String get moonSign;

  /// No description provided for @rightNow.
  ///
  /// In en, this message translates to:
  /// **'Right now'**
  String get rightNow;

  /// No description provided for @currentHora.
  ///
  /// In en, this message translates to:
  /// **'Hora'**
  String get currentHora;

  /// No description provided for @currentChogadia.
  ///
  /// In en, this message translates to:
  /// **'Chogadia'**
  String get currentChogadia;

  /// No description provided for @currentLagna.
  ///
  /// In en, this message translates to:
  /// **'Lagna'**
  String get currentLagna;

  /// No description provided for @currentMuhurta.
  ///
  /// In en, this message translates to:
  /// **'Muhurta'**
  String get currentMuhurta;

  /// No description provided for @lagnaNature.
  ///
  /// In en, this message translates to:
  /// **'{sign} ({nature})'**
  String lagnaNature(Object sign, Object nature);

  /// No description provided for @movable.
  ///
  /// In en, this message translates to:
  /// **'movable'**
  String get movable;

  /// No description provided for @fixed.
  ///
  /// In en, this message translates to:
  /// **'fixed'**
  String get fixed;

  /// No description provided for @dual.
  ///
  /// In en, this message translates to:
  /// **'dual'**
  String get dual;

  /// No description provided for @kaalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Inauspicious & auspicious periods'**
  String get kaalsTitle;

  /// No description provided for @dayPart.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayPart;

  /// No description provided for @nightPart.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get nightPart;

  /// No description provided for @colTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get colTime;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'good'**
  String get good;

  /// No description provided for @bad.
  ///
  /// In en, this message translates to:
  /// **'avoid'**
  String get bad;

  /// No description provided for @panchakTitle.
  ///
  /// In en, this message translates to:
  /// **'Panchak this month'**
  String get panchakTitle;

  /// No description provided for @bhadraTitle.
  ///
  /// In en, this message translates to:
  /// **'Bhadra this month'**
  String get bhadraTitle;

  /// No description provided for @nonePeriod.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get nonePeriod;

  /// No description provided for @vratTitle.
  ///
  /// In en, this message translates to:
  /// **'Vrat dates {year}'**
  String vratTitle(Object year);

  /// No description provided for @vratNote.
  ///
  /// In en, this message translates to:
  /// **'Smarta rules: Ekadashi, Purnima, Amavasya by the tithi at sunrise; Pradosh at sunset; Sankashti at moonrise; Shivaratri at midnight.'**
  String get vratNote;

  /// No description provided for @allVrats.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allVrats;

  /// No description provided for @computing.
  ///
  /// In en, this message translates to:
  /// **'Calculating…'**
  String get computing;

  /// No description provided for @matching.
  ///
  /// In en, this message translates to:
  /// **'Matching'**
  String get matching;

  /// No description provided for @boy.
  ///
  /// In en, this message translates to:
  /// **'Boy'**
  String get boy;

  /// No description provided for @girl.
  ///
  /// In en, this message translates to:
  /// **'Girl'**
  String get girl;

  /// No description provided for @chooseChart.
  ///
  /// In en, this message translates to:
  /// **'Choose a saved chart'**
  String get chooseChart;

  /// No description provided for @needTwoCharts.
  ///
  /// In en, this message translates to:
  /// **'Save at least two charts to match them.'**
  String get needTwoCharts;

  /// No description provided for @ashtakoota.
  ///
  /// In en, this message translates to:
  /// **'Ashtakoota (Guna Milan)'**
  String get ashtakoota;

  /// No description provided for @colKoota.
  ///
  /// In en, this message translates to:
  /// **'Koota'**
  String get colKoota;

  /// No description provided for @colMax.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get colMax;

  /// No description provided for @colObtained.
  ///
  /// In en, this message translates to:
  /// **'Got'**
  String get colObtained;

  /// No description provided for @totalGunas.
  ///
  /// In en, this message translates to:
  /// **'Total: {got} / 36'**
  String totalGunas(Object got);

  /// No description provided for @verdictGood.
  ///
  /// In en, this message translates to:
  /// **'Good match (18 or more)'**
  String get verdictGood;

  /// No description provided for @verdictPoor.
  ///
  /// In en, this message translates to:
  /// **'Below 18: not recommended by the rule'**
  String get verdictPoor;

  /// No description provided for @nadiDosha.
  ///
  /// In en, this message translates to:
  /// **'Nadi dosha'**
  String get nadiDosha;

  /// No description provided for @bhakootDosha.
  ///
  /// In en, this message translates to:
  /// **'Bhakoot dosha'**
  String get bhakootDosha;

  /// No description provided for @doshaCancelled.
  ///
  /// In en, this message translates to:
  /// **'{dosha} present but cancelled by a classical exception'**
  String doshaCancelled(Object dosha);

  /// No description provided for @doshaPresent.
  ///
  /// In en, this message translates to:
  /// **'{dosha} present'**
  String doshaPresent(Object dosha);

  /// No description provided for @mangalTitle.
  ///
  /// In en, this message translates to:
  /// **'Mangal dosha'**
  String get mangalTitle;

  /// No description provided for @mangalBoth.
  ///
  /// In en, this message translates to:
  /// **'Both or neither are manglik: compatible'**
  String get mangalBoth;

  /// No description provided for @mangalOne.
  ///
  /// In en, this message translates to:
  /// **'Only one is manglik: needs remedies or a cancelling factor'**
  String get mangalOne;

  /// No description provided for @poruthamTitle.
  ///
  /// In en, this message translates to:
  /// **'10 Porutham (South Indian)'**
  String get poruthamTitle;

  /// No description provided for @colRajju.
  ///
  /// In en, this message translates to:
  /// **'Rajju'**
  String get colRajju;

  /// No description provided for @resultGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get resultGood;

  /// No description provided for @resultAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get resultAverage;

  /// No description provided for @resultBad.
  ///
  /// In en, this message translates to:
  /// **'Not good'**
  String get resultBad;

  /// No description provided for @poruthamCount.
  ///
  /// In en, this message translates to:
  /// **'{n} of 10 agree'**
  String poruthamCount(Object n);

  /// No description provided for @matchingNote.
  ///
  /// In en, this message translates to:
  /// **'Ashtakoota per Muhurta Chintamani. Counts are from the Moon\'s sign and nakshatra. Cancellations are shown as notes; the score is not changed.'**
  String get matchingNote;

  /// No description provided for @tabTransit.
  ///
  /// In en, this message translates to:
  /// **'Transit'**
  String get tabTransit;

  /// No description provided for @transitOn.
  ///
  /// In en, this message translates to:
  /// **'Transits on {date}'**
  String transitOn(Object date);

  /// No description provided for @stepDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get stepDay;

  /// No description provided for @stepMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get stepMonth;

  /// No description provided for @stepYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get stepYear;

  /// No description provided for @transitChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Transit on natal'**
  String get transitChartTitle;

  /// No description provided for @transitNote.
  ///
  /// In en, this message translates to:
  /// **'Inner ring: natal planets. Outer labels marked ▸ are transiting planets.'**
  String get transitNote;

  /// No description provided for @colFromLagna.
  ///
  /// In en, this message translates to:
  /// **'From lagna'**
  String get colFromLagna;

  /// No description provided for @colFromMoon.
  ///
  /// In en, this message translates to:
  /// **'From Moon'**
  String get colFromMoon;

  /// No description provided for @colSav.
  ///
  /// In en, this message translates to:
  /// **'SAV'**
  String get colSav;

  /// No description provided for @colBav.
  ///
  /// In en, this message translates to:
  /// **'BAV'**
  String get colBav;

  /// No description provided for @colGochara.
  ///
  /// In en, this message translates to:
  /// **'Gochara'**
  String get colGochara;

  /// No description provided for @gocharaGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get gocharaGood;

  /// No description provided for @gocharaVedha.
  ///
  /// In en, this message translates to:
  /// **'Good, but vedha by {planet}'**
  String gocharaVedha(Object planet);

  /// No description provided for @gocharaBad.
  ///
  /// In en, this message translates to:
  /// **'Unfavourable'**
  String get gocharaBad;

  /// No description provided for @gocharaNote.
  ///
  /// In en, this message translates to:
  /// **'Gochara from the natal Moon (Phaladeepika 26) with vedha; SAV ≥ 28 in a sign supports good results.'**
  String get gocharaNote;

  /// No description provided for @transitSearch.
  ///
  /// In en, this message translates to:
  /// **'Transit search'**
  String get transitSearch;

  /// No description provided for @searchPlanet.
  ///
  /// In en, this message translates to:
  /// **'Planet'**
  String get searchPlanet;

  /// No description provided for @searchTarget.
  ///
  /// In en, this message translates to:
  /// **'Over'**
  String get searchTarget;

  /// No description provided for @searchYears.
  ///
  /// In en, this message translates to:
  /// **'Next {n} years'**
  String searchYears(Object n);

  /// No description provided for @searchRun.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchRun;

  /// No description provided for @targetSigns.
  ///
  /// In en, this message translates to:
  /// **'Sign changes'**
  String get targetSigns;

  /// No description provided for @targetNatal.
  ///
  /// In en, this message translates to:
  /// **'Natal {planet}'**
  String targetNatal(Object planet);

  /// No description provided for @targetLagna.
  ///
  /// In en, this message translates to:
  /// **'Natal lagna'**
  String get targetLagna;

  /// No description provided for @eventEnters.
  ///
  /// In en, this message translates to:
  /// **'enters {sign}'**
  String eventEnters(Object sign);

  /// No description provided for @eventOver.
  ///
  /// In en, this message translates to:
  /// **'exact over target'**
  String get eventOver;

  /// No description provided for @retroMark.
  ///
  /// In en, this message translates to:
  /// **'(R)'**
  String get retroMark;

  /// No description provided for @noEvents.
  ///
  /// In en, this message translates to:
  /// **'No events in this period.'**
  String get noEvents;

  /// No description provided for @goToDate.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get goToDate;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Janam Kundli'**
  String get reportTitle;

  /// No description provided for @reportCharts.
  ///
  /// In en, this message translates to:
  /// **'Birth charts'**
  String get reportCharts;

  /// No description provided for @reportPage.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {total}'**
  String reportPage(String page, String total);

  /// No description provided for @reportPreparedOn.
  ///
  /// In en, this message translates to:
  /// **'Prepared on {date}'**
  String reportPreparedOn(String date);

  /// No description provided for @reportRunning.
  ///
  /// In en, this message translates to:
  /// **'Running now: {path} (until {date})'**
  String reportRunning(String path, String date);

  /// No description provided for @pdfKundli.
  ///
  /// In en, this message translates to:
  /// **'PDF kundli'**
  String get pdfKundli;

  /// No description provided for @reportInclude.
  ///
  /// In en, this message translates to:
  /// **'Include'**
  String get reportInclude;

  /// No description provided for @reportLanguage.
  ///
  /// In en, this message translates to:
  /// **'Report language'**
  String get reportLanguage;

  /// No description provided for @makePdf.
  ///
  /// In en, this message translates to:
  /// **'Make PDF'**
  String get makePdf;

  /// No description provided for @makingPdf.
  ///
  /// In en, this message translates to:
  /// **'Making the PDF…'**
  String get makingPdf;

  /// No description provided for @reportReady.
  ///
  /// In en, this message translates to:
  /// **'{pages} pages · made in {seconds} s'**
  String reportReady(String pages, String seconds);

  /// No description provided for @sharePdf.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get sharePdf;

  /// No description provided for @printPdf.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get printPdf;

  /// No description provided for @reportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not make the PDF: {error}'**
  String reportFailed(String error);

  /// No description provided for @letterhead.
  ///
  /// In en, this message translates to:
  /// **'Letterhead (PDF)'**
  String get letterhead;

  /// No description provided for @letterheadHint.
  ///
  /// In en, this message translates to:
  /// **'Printed at the top of every page of the PDF kundli.'**
  String get letterheadHint;

  /// No description provided for @letterheadMissing.
  ///
  /// In en, this message translates to:
  /// **'Your letterhead is empty. Add your name, phone and logo in Settings → Letterhead.'**
  String get letterheadMissing;

  /// No description provided for @lhName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get lhName;

  /// No description provided for @lhTitle.
  ///
  /// In en, this message translates to:
  /// **'Title line (e.g. Vedic Astrologer)'**
  String get lhTitle;

  /// No description provided for @lhPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get lhPhone;

  /// No description provided for @lhAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get lhAddress;

  /// No description provided for @lhLogo.
  ///
  /// In en, this message translates to:
  /// **'Logo'**
  String get lhLogo;

  /// No description provided for @chooseLogo.
  ///
  /// In en, this message translates to:
  /// **'Choose logo'**
  String get chooseLogo;

  /// No description provided for @removeLogo.
  ///
  /// In en, this message translates to:
  /// **'Remove logo'**
  String get removeLogo;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @saveAction.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveAction;

  /// No description provided for @ashtakavargaShort.
  ///
  /// In en, this message translates to:
  /// **'Ashtakavarga'**
  String get ashtakavargaShort;

  /// No description provided for @clients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clients;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @client.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// No description provided for @newClient.
  ///
  /// In en, this message translates to:
  /// **'New client'**
  String get newClient;

  /// No description provided for @editClient.
  ///
  /// In en, this message translates to:
  /// **'Edit client'**
  String get editClient;

  /// No description provided for @searchClients.
  ///
  /// In en, this message translates to:
  /// **'Search name, phone or notes'**
  String get searchClients;

  /// No description provided for @noClientsYet.
  ///
  /// In en, this message translates to:
  /// **'No clients yet. Add one with New client.'**
  String get noClientsYet;

  /// No description provided for @noClientMatches.
  ///
  /// In en, this message translates to:
  /// **'No client matches \"{query}\".'**
  String noClientMatches(String query);

  /// No description provided for @clientNotFound.
  ///
  /// In en, this message translates to:
  /// **'Client not found.'**
  String get clientNotFound;

  /// No description provided for @chartCount.
  ///
  /// In en, this message translates to:
  /// **'{n} charts'**
  String chartCount(String n);

  /// No description provided for @dueAmount.
  ///
  /// In en, this message translates to:
  /// **'Due {amount}'**
  String dueAmount(String amount);

  /// No description provided for @paidTotal.
  ///
  /// In en, this message translates to:
  /// **'Paid {amount}'**
  String paidTotal(String amount);

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @clientNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get clientNotes;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get nameRequired;

  /// No description provided for @deleteClientTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete client?'**
  String get deleteClientTitle;

  /// No description provided for @deleteClientBody.
  ///
  /// In en, this message translates to:
  /// **'{name} will be removed. Their charts and consultations stay, without the link.'**
  String deleteClientBody(String name);

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @familyCharts.
  ///
  /// In en, this message translates to:
  /// **'Family charts'**
  String get familyCharts;

  /// No description provided for @noFamilyCharts.
  ///
  /// In en, this message translates to:
  /// **'No charts linked yet. Use + to add one.'**
  String get noFamilyCharts;

  /// No description provided for @newChartForClient.
  ///
  /// In en, this message translates to:
  /// **'New chart'**
  String get newChartForClient;

  /// No description provided for @linkChart.
  ///
  /// In en, this message translates to:
  /// **'Link a saved chart'**
  String get linkChart;

  /// No description provided for @relationTitle.
  ///
  /// In en, this message translates to:
  /// **'Relation to the client'**
  String get relationTitle;

  /// No description provided for @changeRelation.
  ///
  /// In en, this message translates to:
  /// **'Change relation'**
  String get changeRelation;

  /// No description provided for @unlinkChart.
  ///
  /// In en, this message translates to:
  /// **'Remove from client'**
  String get unlinkChart;

  /// No description provided for @relSelf.
  ///
  /// In en, this message translates to:
  /// **'Self'**
  String get relSelf;

  /// No description provided for @relSpouse.
  ///
  /// In en, this message translates to:
  /// **'Spouse'**
  String get relSpouse;

  /// No description provided for @relSon.
  ///
  /// In en, this message translates to:
  /// **'Son'**
  String get relSon;

  /// No description provided for @relDaughter.
  ///
  /// In en, this message translates to:
  /// **'Daughter'**
  String get relDaughter;

  /// No description provided for @relFather.
  ///
  /// In en, this message translates to:
  /// **'Father'**
  String get relFather;

  /// No description provided for @relMother.
  ///
  /// In en, this message translates to:
  /// **'Mother'**
  String get relMother;

  /// No description provided for @relBrother.
  ///
  /// In en, this message translates to:
  /// **'Brother'**
  String get relBrother;

  /// No description provided for @relSister.
  ///
  /// In en, this message translates to:
  /// **'Sister'**
  String get relSister;

  /// No description provided for @relOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get relOther;

  /// No description provided for @consultations.
  ///
  /// In en, this message translates to:
  /// **'Consultations'**
  String get consultations;

  /// No description provided for @noConsultations.
  ///
  /// In en, this message translates to:
  /// **'No consultations yet.'**
  String get noConsultations;

  /// No description provided for @reportsSent.
  ///
  /// In en, this message translates to:
  /// **'PDF kundlis sent'**
  String get reportsSent;

  /// No description provided for @pagesCount.
  ///
  /// In en, this message translates to:
  /// **'{n} pages'**
  String pagesCount(String n);

  /// No description provided for @newAppointment.
  ///
  /// In en, this message translates to:
  /// **'New appointment'**
  String get newAppointment;

  /// No description provided for @editAppointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get editAppointment;

  /// No description provided for @noAppointments.
  ///
  /// In en, this message translates to:
  /// **'Nothing here.'**
  String get noAppointments;

  /// No description provided for @noAppointmentsToday.
  ///
  /// In en, this message translates to:
  /// **'No appointments today.'**
  String get noAppointmentsToday;

  /// No description provided for @followUpsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Follow-ups this week'**
  String get followUpsThisWeek;

  /// No description provided for @noFollowUps.
  ///
  /// In en, this message translates to:
  /// **'No follow-ups due.'**
  String get noFollowUps;

  /// No description provided for @viewToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get viewToday;

  /// No description provided for @viewUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get viewUpcoming;

  /// No description provided for @viewPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get viewPast;

  /// No description provided for @viewUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get viewUnpaid;

  /// No description provided for @totalUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Total unpaid'**
  String get totalUnpaid;

  /// No description provided for @nothingUnpaid.
  ///
  /// In en, this message translates to:
  /// **'All fees are paid.'**
  String get nothingUnpaid;

  /// No description provided for @statusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get statusScheduled;

  /// No description provided for @statusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statusDone;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get statusMissed;

  /// No description provided for @markDone.
  ///
  /// In en, this message translates to:
  /// **'Mark done'**
  String get markDone;

  /// No description provided for @markPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark paid'**
  String get markPaid;

  /// No description provided for @markMissed.
  ///
  /// In en, this message translates to:
  /// **'Mark missed'**
  String get markMissed;

  /// No description provided for @markCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get markCancelled;

  /// No description provided for @noClient.
  ///
  /// In en, this message translates to:
  /// **'— No client (walk-in) —'**
  String get noClient;

  /// No description provided for @walkInName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get walkInName;

  /// No description provided for @topic.
  ///
  /// In en, this message translates to:
  /// **'Topic (optional)'**
  String get topic;

  /// No description provided for @needClientOrName.
  ///
  /// In en, this message translates to:
  /// **'Choose a client or type a name.'**
  String get needClientOrName;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{n} min'**
  String minutesShort(String n);

  /// No description provided for @remindMe.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get remindMe;

  /// No description provided for @remindMeHint.
  ///
  /// In en, this message translates to:
  /// **'30 minutes before, and at 10 am on the follow-up day'**
  String get remindMeHint;

  /// No description provided for @sessionNotes.
  ///
  /// In en, this message translates to:
  /// **'Consultation notes'**
  String get sessionNotes;

  /// No description provided for @sessionNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Questions asked, what you saw in the chart, remedies advised…'**
  String get sessionNotesHint;

  /// No description provided for @fee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get fee;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @followUpOn.
  ///
  /// In en, this message translates to:
  /// **'Follow up on'**
  String get followUpOn;

  /// No description provided for @deleteAppointmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this appointment?'**
  String get deleteAppointmentTitle;

  /// No description provided for @remindersChannel.
  ///
  /// In en, this message translates to:
  /// **'Appointment reminders'**
  String get remindersChannel;

  /// No description provided for @appointmentReminder.
  ///
  /// In en, this message translates to:
  /// **'Appointment: {who}'**
  String appointmentReminder(String who);

  /// No description provided for @followUpReminder.
  ///
  /// In en, this message translates to:
  /// **'Follow up with {who}'**
  String followUpReminder(String who);

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @backupSettingsHint.
  ///
  /// In en, this message translates to:
  /// **'Save everything to Google Drive, or restore'**
  String get backupSettingsHint;

  /// No description provided for @backupIntro.
  ///
  /// In en, this message translates to:
  /// **'A backup is one file with all charts, clients, consultations, settings and your logo. Keep it on Google Drive so nothing is lost if the phone is lost or changed.'**
  String get backupIntro;

  /// No description provided for @neverBackedUp.
  ///
  /// In en, this message translates to:
  /// **'No backup made yet on this phone.'**
  String get neverBackedUp;

  /// No description provided for @lastBackup.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {when}'**
  String lastBackup(String when);

  /// No description provided for @backupNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get backupNow;

  /// No description provided for @backupHint.
  ///
  /// In en, this message translates to:
  /// **'Then choose Drive (Save to Drive), WhatsApp or email in the share sheet.'**
  String get backupHint;

  /// No description provided for @backupShareText.
  ///
  /// In en, this message translates to:
  /// **'Astro app backup'**
  String get backupShareText;

  /// No description provided for @restoreFromFile.
  ///
  /// In en, this message translates to:
  /// **'Restore from a backup file'**
  String get restoreFromFile;

  /// No description provided for @restoreHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a backup .zip (from Drive or the phone). Everything on this phone is replaced by the backup.'**
  String get restoreHint;

  /// No description provided for @restoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup?'**
  String get restoreTitle;

  /// No description provided for @restoreBody.
  ///
  /// In en, this message translates to:
  /// **'Made on {when}: {charts} charts, {clients} clients, {appointments} appointments.\n\nEverything now on this phone will be replaced.'**
  String restoreBody(
    String when,
    String charts,
    String clients,
    String appointments,
  );

  /// No description provided for @restoreAction.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreAction;

  /// No description provided for @notABackup.
  ///
  /// In en, this message translates to:
  /// **'That file is not a backup from this app.'**
  String get notABackup;

  /// No description provided for @backupTooNew.
  ///
  /// In en, this message translates to:
  /// **'This backup is from a newer version of the app. Update the app first.'**
  String get backupTooNew;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed: {error}'**
  String backupFailed(String error);

  /// No description provided for @dashaSystem.
  ///
  /// In en, this message translates to:
  /// **'Dasha system'**
  String get dashaSystem;

  /// No description provided for @dashaApplies.
  ///
  /// In en, this message translates to:
  /// **'applies to this chart'**
  String get dashaApplies;

  /// No description provided for @dashaNotApplies.
  ///
  /// In en, this message translates to:
  /// **'does not apply to this chart (shown for reference)'**
  String get dashaNotApplies;

  /// No description provided for @dashaApplyUnknown.
  ///
  /// In en, this message translates to:
  /// **'check by hand'**
  String get dashaApplyUnknown;

  /// No description provided for @otherDashas.
  ///
  /// In en, this message translates to:
  /// **'Other dashas'**
  String get otherDashas;

  /// No description provided for @otherDashasNote.
  ///
  /// In en, this message translates to:
  /// **'Ashtottari is always shown; the conditional dashas only when their BPHS condition holds for this chart.'**
  String get otherDashasNote;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
