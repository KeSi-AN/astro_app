// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String startError(Object error) {
    return 'शुरू नहीं हो सका: $error';
  }

  @override
  String get chartsTitle => 'कुंडलियाँ';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get searchCharts => 'नाम या स्थान से खोजें';

  @override
  String get newChart => 'नई कुंडली';

  @override
  String loadChartsError(Object error) {
    return 'कुंडलियाँ लोड नहीं हो सकीं: $error';
  }

  @override
  String get noChartsYet =>
      'अभी कोई कुंडली नहीं है।\nजोड़ने के लिए \"नई कुंडली\" दबाएँ।';

  @override
  String noChartMatches(Object query) {
    return '\"$query\" से मेल खाती कोई कुंडली नहीं।';
  }

  @override
  String get edit => 'संपादित करें';

  @override
  String get duplicate => 'प्रतिलिपि बनाएँ';

  @override
  String get delete => 'हटाएँ';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get deleteChartTitle => 'कुंडली हटाएँ?';

  @override
  String deleteChartBody(Object name) {
    return '\"$name\" इस फ़ोन से हटा दी जाएगी। इसे वापस नहीं लाया जा सकता।';
  }

  @override
  String get copySuffix => '(प्रति)';

  @override
  String get editChart => 'कुंडली संपादित करें';

  @override
  String get pasteDetails => 'विवरण पेस्ट करें';

  @override
  String get name => 'नाम';

  @override
  String get enterName => 'नाम दर्ज करें';

  @override
  String get male => 'पुरुष';

  @override
  String get female => 'स्त्री';

  @override
  String get gender => 'लिंग';

  @override
  String get dateLabel => 'तारीख (DD/MM/YYYY)';

  @override
  String get dateError => 'DD/MM/YYYY, 1800–2399';

  @override
  String get timeLabel => 'समय (24 घंटे, HH:MM:SS)';

  @override
  String get timeError => 'जैसे 22:45:10';

  @override
  String get birthPlace => 'जन्म स्थान';

  @override
  String get optional => 'वैकल्पिक';

  @override
  String get maritalStatus => 'वैवाहिक स्थिति';

  @override
  String get occupation => 'व्यवसाय';

  @override
  String get notes => 'टिप्पणियाँ';

  @override
  String get saveAndOpen => 'सहेजें और खोलें';

  @override
  String get save => 'सहेजें';

  @override
  String get choosePlace => 'जन्म स्थान चुनें।';

  @override
  String get checkTimeZone => 'समय क्षेत्र जाँचें।';

  @override
  String get enterOffset => 'UTC ऑफ़सेट दर्ज करें, जैसे 5:30';

  @override
  String unknownZone(Object zone) {
    return 'अज्ञात समय क्षेत्र \"$zone\"। ऑफ़सेट स्वयं दर्ज करें।';
  }

  @override
  String get noDetailsFound => 'उस पाठ में जन्म विवरण नहीं मिला।';

  @override
  String get noDateFound => 'तारीख नहीं मिली: नीचे दर्ज करें।';

  @override
  String get noTimeFound => 'समय नहीं मिला: नीचे दर्ज करें।';

  @override
  String placeMatched(Object place) {
    return 'स्थान $place चुना गया। बदलने के लिए स्थान पर टैप करें।';
  }

  @override
  String placeNeedsChoosing(Object place) {
    return 'स्थान \"$place\" चुनना होगा।';
  }

  @override
  String noteMonthFirst(Object a, Object b) {
    return 'तारीख महीना/दिन ($a/$b) के क्रम में पढ़ी गई, क्योंकि $b मान्य महीना नहीं है।';
  }

  @override
  String get noteDayFirst =>
      'तारीख दिन/महीना (भारतीय क्रम) में पढ़ी गई। जाँच लें कि यह महीना/दिन तो नहीं।';

  @override
  String noteAfterMidnight(Object time) {
    return 'रात का समय आधी रात के बाद $time पढ़ा गया। तारीख जाँच लें।';
  }

  @override
  String noteNoAmPm(Object time) {
    return 'AM/PM नहीं दिया: समय 24 घंटे के क्रम में ($time) पढ़ा गया।';
  }

  @override
  String get pasteTitle => 'जन्म विवरण पेस्ट करें';

  @override
  String get pasteHint =>
      'जैसे\nनाम: राहुल शर्मा\nजन्म तिथि 12/03/1990, सुबह 10:45\nस्थान: Lucknow';

  @override
  String get fillForm => 'फ़ॉर्म भरें';

  @override
  String get timeZone => 'समय क्षेत्र';

  @override
  String get birthTimeIsIn => 'जन्म समय किस मानक में है';

  @override
  String get utcOffset => 'UTC ऑफ़सेट';

  @override
  String get dstWarHours => 'DST / युद्ध समय (घंटे)';

  @override
  String standardOffset(Object offset) {
    return 'मानक $offset';
  }

  @override
  String dstPlus(Object hours) {
    return 'DST +$hours घं';
  }

  @override
  String warTimePlus(Object hours) {
    return 'युद्ध समय +$hours घं';
  }

  @override
  String get lmtCorrection => 'LMT संशोधन';

  @override
  String get warTimeSwitch => 'दर्ज समय में युद्ध समय (+1 घं) शामिल है';

  @override
  String get tzPre1906 =>
      '1906 से पहले भारत में कोई एक मानक समय नहीं था। स्थानीय माध्य समय माना गया है; यदि रिकॉर्ड मद्रास या कलकत्ता समय में है तो बदलें।';

  @override
  String get tzBombay =>
      'बॉम्बे में 1955 तक अपना बॉम्बे समय (UTC+4:51) चलता था। यदि जन्म बॉम्बे समय में दर्ज है तो ऊपर उसे चुनें।';

  @override
  String get tzCalcutta =>
      'कलकत्ता में 1948 तक अपना कलकत्ता समय (UTC+5:53:20) चलता था। यदि जन्म कलकत्ता समय में दर्ज है तो ऊपर उसे चुनें।';

  @override
  String get tzNonExistent =>
      'यहाँ यह समय था ही नहीं (घड़ियाँ आगे की गई थीं)। दर्ज समय जाँचें या ऑफ़सेट स्वयं दर्ज करें।';

  @override
  String get tzAmbiguous =>
      'इस समय के आसपास घड़ियाँ पीछे की गई थीं, इसलिए यह समय दो बार आया हो सकता है। जाँचें कि डेलाइट सेविंग चालू थी या नहीं।';

  @override
  String get tzWarOn =>
      'युद्ध समय लागू था (घड़ियाँ IST से 1 घंटा आगे, UTC+6:30)। इसे तभी बंद करें जब दर्ज समय IST में हो।';

  @override
  String get tzWarOff =>
      'युद्ध समय का घंटा हटाया गया: दर्ज समय IST (UTC+5:30) माना गया।';

  @override
  String get placeSearchHint =>
      'शहर या गाँव (सीमित करने के लिए \", राज्य\" जोड़ें)';

  @override
  String get placeSearchLatin =>
      'स्थान का नाम अंग्रेज़ी अक्षरों में लिखें, जैसे Lucknow।';

  @override
  String get clear => 'साफ़ करें';

  @override
  String get noPlaceFound =>
      'कोई स्थान नहीं मिला। दूसरी वर्तनी आज़माएँ, या निर्देशांक स्वयं दर्ज करें।';

  @override
  String get enterCoordinates => 'निर्देशांक स्वयं दर्ज करें';

  @override
  String get geonamesCredit =>
      'स्थान डेटा © GeoNames (geonames.org), CC BY 4.0';

  @override
  String get placeByCoordinates => 'निर्देशांक से स्थान';

  @override
  String get placeName => 'स्थान का नाम';

  @override
  String get required => 'आवश्यक';

  @override
  String get latitude => 'अक्षांश';

  @override
  String get longitudeGeo => 'देशांतर';

  @override
  String get latError => 'जैसे 27.15 या 27N09';

  @override
  String get lonError => 'जैसे 78.0 या 078E00';

  @override
  String get zoneError => 'Asia/Kolkata जैसा IANA क्षेत्र';

  @override
  String get use => 'उपयोग करें';

  @override
  String get editBirthDetails => 'जन्म विवरण संपादित करें';

  @override
  String get tabChart => 'कुंडली';

  @override
  String get tabPlanets => 'ग्रह';

  @override
  String get tabBhava => 'भाव';

  @override
  String get tabDetails => 'विवरण';

  @override
  String get tabFriendship => 'मैत्री';

  @override
  String get tabKarakas => 'कारक';

  @override
  String get chartNotFound => 'कुंडली नहीं मिली';

  @override
  String get chartLegend => '* वक्री  ^ अस्त  ◻ वर्गोत्तम  ↑ उच्च  ↓ नीच';

  @override
  String get chalitNorthOnly =>
      'चलित हमेशा उत्तर भारतीय (भाव आधारित) शैली में दिखाया जाता है।';

  @override
  String get tapPlanet => 'विवरण के लिए ग्रह पर टैप करें।';

  @override
  String get navamshaTitle => 'नवांश (D9)';

  @override
  String get chalitTitle => 'चलित (श्रीपति)';

  @override
  String get sign => 'राशि';

  @override
  String withLord(Object name, Object lord) {
    return '$name (स्वामी $lord)';
  }

  @override
  String get degreeInSignLabel => 'स्पष्ट';

  @override
  String nakshatraPada(Object nakshatra, Object pada) {
    return '$nakshatra, चरण $pada';
  }

  @override
  String get starSubLords => 'नक्षत्र / उप / उप-उप स्वामी';

  @override
  String get houseWholeSign => 'भाव (राशि अनुसार)';

  @override
  String get chalitBhava => 'चलित भाव';

  @override
  String get navamsha => 'नवांश';

  @override
  String get dignity => 'स्थिति';

  @override
  String get motion => 'गति';

  @override
  String get retrograde => 'वक्री';

  @override
  String get direct => 'मार्गी';

  @override
  String get speed => 'दैनिक गति';

  @override
  String speedValue(Object value) {
    return '$value°/दिन';
  }

  @override
  String get combust => 'अस्त';

  @override
  String get vargottama => 'वर्गोत्तम';

  @override
  String get yes => 'हाँ';

  @override
  String get colPlanet => 'ग्रह';

  @override
  String get colDegree => 'अंश';

  @override
  String get colNakshatra => 'नक्षत्र';

  @override
  String get colStar => 'नक्ष. स्वामी';

  @override
  String get colSub => 'उप स्वामी';

  @override
  String get flagRetro => 'व';

  @override
  String get flagCombust => 'अ';

  @override
  String get flagVargottama => 'वर्गो';

  @override
  String get planetsLegend =>
      'व = वक्री · अ = अस्त · वर्गो = वर्गोत्तम। स्थिति राशि स्वामी से पंचधा मैत्री के अनुसार है।';

  @override
  String get bhavaTitle => 'भाव चलित (श्रीपति)';

  @override
  String get colBhava => 'भाव';

  @override
  String get colStart => 'आरंभ (संधि)';

  @override
  String get colMadhya => 'मध्य';

  @override
  String get colEnd => 'अंत';

  @override
  String get colPlanets => 'ग्रह';

  @override
  String get chalitDiffers => 'जिन ग्रहों का चलित भाव राशि भाव से अलग है:';

  @override
  String chalitShift(Object planet, Object house, Object bhava) {
    return '$planet: भाव $house → चलित भाव $bhava';
  }

  @override
  String get none => 'कोई नहीं';

  @override
  String get kpCuspsTitle => 'प्लासिडस भाव संधि (केपी)';

  @override
  String get colCusp => 'भाव';

  @override
  String get colLongitude => 'स्पष्ट';

  @override
  String get birthDetails => 'जन्म विवरण';

  @override
  String get date => 'तारीख';

  @override
  String get time => 'समय';

  @override
  String get place => 'स्थान';

  @override
  String get latLon => 'अक्षांश / देशांतर';

  @override
  String get warTime => 'युद्ध समय';

  @override
  String get dst => 'DST';

  @override
  String hoursValue(Object hours) {
    return '+$hours घं';
  }

  @override
  String get lmtAtBirth => 'जन्म समय LMT';

  @override
  String get utAtBirth => 'जन्म समय UT (GMT)';

  @override
  String get julianDay => 'जूलियन दिन (UT)';

  @override
  String get ayanamsa => 'अयनांश';

  @override
  String get obliquity => 'क्रांतिवृत्त झुकाव';

  @override
  String get siderealTime => 'नाक्षत्र समय';

  @override
  String get panchangAtBirth => 'जन्म समय पंचांग';

  @override
  String get hinduWeekday => 'वार';

  @override
  String get tithi => 'तिथि';

  @override
  String get nakshatra => 'नक्षत्र';

  @override
  String get yoga => 'योग';

  @override
  String get karana => 'करण';

  @override
  String get sunrise => 'सूर्योदय';

  @override
  String get sunset => 'सूर्यास्त';

  @override
  String get dayLength => 'दिनमान';

  @override
  String get ishtkaal => 'इष्टकाल (घटी)';

  @override
  String get sunriseRule => 'सूर्योदय नियम';

  @override
  String get avakhada => 'अवकहड़ा चक्र';

  @override
  String get lagna => 'लग्न';

  @override
  String get rashi => 'राशि';

  @override
  String get nakshatraPadaLabel => 'नक्षत्र-चरण';

  @override
  String get varna => 'वर्ण';

  @override
  String get vashya => 'वश्य';

  @override
  String get yoni => 'योनि';

  @override
  String get gana => 'गण';

  @override
  String get nadi => 'नाड़ी';

  @override
  String get tatva => 'तत्व';

  @override
  String get payaNakshatra => 'पाया (नक्षत्र)';

  @override
  String get payaMoon => 'पाया (चंद्र भाव)';

  @override
  String get nameSyllable => 'नामाक्षर';

  @override
  String get dashaBalance => 'दशा शेष';

  @override
  String get sunSignIndian => 'सूर्य राशि (भारतीय)';

  @override
  String get sunSignWestern => 'सूर्य राशि (पश्चिमी)';

  @override
  String ymd(Object y, Object m, Object d) {
    return '$y वर्ष $m माह $d दिन';
  }

  @override
  String get naturalTitle => 'नैसर्गिक (स्थायी)';

  @override
  String get temporalTitle => 'तात्कालिक (इस कुंडली में)';

  @override
  String get compoundTitle => 'पंचधा';

  @override
  String get friendshipLegend =>
      'अमि अधिमित्र · मि मित्र · स सम · श शत्रु · अश अधिशत्रु';

  @override
  String charaKarakasTitle(Object scheme) {
    return 'चर कारक · $scheme';
  }

  @override
  String get colKaraka => 'कारक';

  @override
  String get colDegreeInSign => 'राशि में अंश';

  @override
  String get rahuBackwards => 'राहु के अंश उल्टे गिने जाते हैं (30° − अंश)।';

  @override
  String get karakaSchemeHint =>
      'सेटिंग्स में 8-कारक पद्धति (राहु सहित) चुन सकते हैं।';

  @override
  String get display => 'प्रदर्शन';

  @override
  String get language => 'भाषा';

  @override
  String get languageSystem => 'फ़ोन के अनुसार';

  @override
  String get chartStyle => 'कुंडली शैली';

  @override
  String get showOuterPlanets => 'यूरेनस, नेपच्यून, प्लूटो दिखाएँ';

  @override
  String get calculation => 'गणना';

  @override
  String get rahuKetu => 'राहु / केतु';

  @override
  String get charaKarakas => 'चर कारक';

  @override
  String get settingsFootnote =>
      'डिफ़ॉल्ट सेटिंग्स AstroSage के अनुसार हैं: लाहिड़ी, मध्यम राहु, ऊपरी किनारे वाला सूर्योदय। ग्रह स्थितियाँ Swiss Ephemeris (Astrodienst, AGPL) से। स्थान डेटा © GeoNames, CC BY 4.0।';

  @override
  String get tabVargas => 'वर्ग';

  @override
  String get tabDasha => 'दशा';

  @override
  String get vimshottari => 'विंशोत्तरी';

  @override
  String get yoginiDasha => 'योगिनी';

  @override
  String get charaDasha => 'चर';

  @override
  String get today => 'आज';

  @override
  String get jumpToDate => 'तारीख पर जाएँ';

  @override
  String get colLord => 'स्वामी';

  @override
  String get colFrom => 'से';

  @override
  String get colTo => 'तक';

  @override
  String get colAge => 'आयु';

  @override
  String runningAt(Object date) {
    return '$date को चल रही';
  }

  @override
  String get dashaHint => 'उप-दशाएँ देखने के लिए दशा पर टैप करें।';

  @override
  String get dashaYearSetting => 'दशा वर्ष';

  @override
  String charaNote(Object direction) {
    return 'चर दशा (के.एन. राव पद्धति): क्रम लग्न से $direction चलता है; अंतर्दशा अगली राशि से आरंभ होती है।';
  }

  @override
  String get forwards => 'सीधा';

  @override
  String get backwards => 'उल्टा';

  @override
  String get yoginiNote =>
      'योगिनी दशा: 36 वर्ष का चक्र, प्रारंभिक योगिनी = नक्षत्र संख्या + 3।';

  @override
  String get vargaTableTitle => '16 वर्गों में प्रत्येक ग्रह की राशि';

  @override
  String get vargaTableNote =>
      'अंक राशि दर्शाते हैं: 1 मेष … 12 मीन; रंगीन = D1 वाली ही राशि। कुंडली देखने के लिए नीचे वर्ग पर टैप करें।';

  @override
  String get divisional => 'वर्ग कुंडली';

  @override
  String get tabStrength => 'बल';

  @override
  String get ashtakavarga => 'अष्टकवर्ग';

  @override
  String get shadbala => 'षड्बल';

  @override
  String get bhavaBala => 'भाव बल';

  @override
  String get bavTitle => 'भिन्नाष्टकवर्ग (प्रति राशि बिंदु)';

  @override
  String get savTitle => 'सर्वाष्टकवर्ग';

  @override
  String get savByHouse => 'लग्न से भाव अनुसार सर्वाष्टकवर्ग';

  @override
  String prastaraTitle(Object planet) {
    return '$planet का प्रस्तार';
  }

  @override
  String get avNote =>
      'राशियाँ: 1 मेष … 12 मीन। कुल 337। 28 या अधिक बिंदु वाले भाव बलवान।';

  @override
  String get colTotal => 'कुल';

  @override
  String get contributor => 'दाता';

  @override
  String get sthanaBala => 'स्थान बल';

  @override
  String get uchchaBala => 'उच्च';

  @override
  String get saptavargajaBala => 'सप्तवर्गज';

  @override
  String get ojayugmaBala => 'ओजयुग्म';

  @override
  String get kendradiBala => 'केन्द्रादि';

  @override
  String get drekkanaBala => 'द्रेष्काण';

  @override
  String get digBala => 'दिग्बल';

  @override
  String get kalaBala => 'काल बल';

  @override
  String get nathonnathaBala => 'नतोन्नत';

  @override
  String get pakshaBala => 'पक्ष';

  @override
  String get tribhagaBala => 'त्रिभाग';

  @override
  String get abdaBala => 'अब्द (वर्ष)';

  @override
  String get masaBala => 'मास';

  @override
  String get varaBala => 'वार';

  @override
  String get horaBala => 'होरा';

  @override
  String get ayanaBala => 'अयन';

  @override
  String get yuddhaBala => 'युद्ध';

  @override
  String get cheshtaBala => 'चेष्टा बल';

  @override
  String get naisargikaBala => 'नैसर्गिक बल';

  @override
  String get drikBala => 'दृक् बल';

  @override
  String get totalVirupas => 'कुल (विरूप)';

  @override
  String get totalRupas => 'कुल (रूप)';

  @override
  String get requiredRupas => 'आवश्यक (रूप)';

  @override
  String get strengthRatio => 'अनुपात';

  @override
  String get strengthRank => 'क्रम';

  @override
  String get shadbalaNote =>
      'मान विरूप में (60 = 1 रूप), बृहत् पाराशर होरा शास्त्र अध्याय 27 के अनुसार (बी.वी. रमन की गणना विधि)। अनुपात 1 या अधिक हो तो ग्रह आवश्यक बल पूरा करता है।';

  @override
  String get bhavaLordStrength => 'भावेश बल';

  @override
  String get bhavaDig => 'दिग्बल';

  @override
  String get bhavaDrishti => 'दृष्टि बल';

  @override
  String get bhavaNote =>
      'भाव बल = भावेश का षड्बल + दिग्बल + भाव मध्य पर दृष्टि (विरूप)।';

  @override
  String get showSavOnChart => 'प्रत्येक भाव में सर्वाष्टकवर्ग बिंदु दिखाएँ';

  @override
  String get tabKp => 'केपी';

  @override
  String get kpAyanamsaSetting => 'केपी अयनांश';

  @override
  String get kpPlanets => 'ग्रह';

  @override
  String get kpCusps => 'भाव संधि';

  @override
  String get kpSignif => 'कारकत्व';

  @override
  String get kpRuling => 'शासक ग्रह';

  @override
  String get kpHorary => 'प्रश्न';

  @override
  String get colSignLord => 'राशि स्वामी';

  @override
  String get colSubSub => 'उप-उप';

  @override
  String get colHouse => 'भाव';

  @override
  String get colL1 => 'नक्ष. स्वामी स्थिति';

  @override
  String get colL2 => 'स्थिति';

  @override
  String get colL3 => 'नक्ष. स्वामी स्वामित्व';

  @override
  String get colL4 => 'स्वामित्व';

  @override
  String get colAllHouses => 'सभी';

  @override
  String get houseSignificators => 'भाव कारक ग्रह';

  @override
  String get colSignificators => 'ग्रह';

  @override
  String get kpSignifNote =>
      'L1 नक्षत्र स्वामी की स्थिति, L2 ग्रह की स्थिति, L3 नक्षत्र स्वामी का स्वामित्व, L4 ग्रह का स्वामित्व (प्लासिडस भाव)। + = इसके नक्षत्र में कोई ग्रह नहीं, या ग्रह अपने ही नक्षत्र में।';

  @override
  String get rpAtBirth => 'जन्म समय';

  @override
  String get rpNow => 'अभी (जन्म स्थान पर)';

  @override
  String get refresh => 'ताज़ा करें';

  @override
  String get rpDayLord => 'वार स्वामी';

  @override
  String get rpAscSign => 'लग्न राशि स्वामी';

  @override
  String get rpAscStar => 'लग्न नक्षत्र स्वामी';

  @override
  String get rpAscSub => 'लग्न उप स्वामी';

  @override
  String get rpMoonSign => 'चंद्र राशि स्वामी';

  @override
  String get rpMoonStar => 'चंद्र नक्षत्र स्वामी';

  @override
  String get rpMoonSub => 'चंद्र उप स्वामी';

  @override
  String get horaryNumber => 'प्रश्न संख्या (1–249)';

  @override
  String get horaryHint =>
      'आज उस क्षण की भाव संधि जब लग्न इस संख्या के आरंभ पर पहुँचे; ग्रह अभी के, जन्म स्थान पर।';

  @override
  String get horaryCast => 'प्रश्न कुंडली बनाएँ';

  @override
  String horaryAsc(Object degree) {
    return 'लग्न $degree';
  }

  @override
  String get invalidHorary => '1 से 249 के बीच संख्या दर्ज करें';

  @override
  String get kpNadi => 'नाड़ी';

  @override
  String get kp4Step => '4-चरण';

  @override
  String get kpCil => 'सीआईएल';

  @override
  String get nadiNote =>
      'नक्षत्र नाड़ी: स्थित और स्वामित्व वाले भाव; राहु/केतु अपने राशि स्वामी, नक्षत्र स्वामी तथा युति और दृष्टि वाले ग्रहों के भाव भी लेते हैं।';

  @override
  String get rowPlanet => 'ग्रह';

  @override
  String get rowStarLord => 'नक्षत्र स्वामी';

  @override
  String get rowSubLord => 'उप स्वामी';

  @override
  String get rowSubStar => 'उप स्वामी का नक्षत्र स्वामी';

  @override
  String get fourStepNote =>
      'प्रत्येक चरण में स्वामी और उसके नक्षत्र नाड़ी भाव।';

  @override
  String get colT1 => 'T1';

  @override
  String get colT3 => 'T3';

  @override
  String get colT4 => 'T4';

  @override
  String get cilNote =>
      'भाव संधि अंतर्संबंध (उप)। T1: वे भाव जिनका उप स्वामी इस भाव के उप स्वामी का नक्षत्र या उप स्वामी है। T3: वे भाव जिनके उप स्वामी का नक्षत्र स्वामी यह उप स्वामी है। T4: उप स्वामी के नक्षत्र स्वामी का भाव।';

  @override
  String get tabYogas => 'योग';

  @override
  String get secYogas => 'योग व दोष';

  @override
  String get secSadeSati => 'साढ़ेसाती';

  @override
  String get secAvastha => 'अवस्था';

  @override
  String get secUpagraha => 'उपग्रह';

  @override
  String get secArudha => 'आरूढ़';

  @override
  String get secNavatara => 'नवतारा';

  @override
  String get present => 'है';

  @override
  String get absent => 'नहीं';

  @override
  String get cancelled => 'भंग';

  @override
  String get showAbsent => 'जो नहीं हैं वे भी दिखाएँ';

  @override
  String mangalFrom(Object ref, Object house) {
    return '$ref से: भाव $house';
  }

  @override
  String get refLagna => 'लग्न';

  @override
  String get refMoon => 'चंद्र';

  @override
  String get refVenus => 'शुक्र';

  @override
  String get cancelMarsStrong => 'मंगल स्वराशि/उच्च में';

  @override
  String get cancelWithJupiter => 'मंगल गुरु के साथ';

  @override
  String get cancelWithMoon => 'मंगल चंद्र के साथ';

  @override
  String cancelSignException(Object house) {
    return 'भाव $house में मंगल ऐसी राशि में जो दोष भंग करती है';
  }

  @override
  String kaalSarpType(Object name) {
    return 'प्रकार: $name';
  }

  @override
  String get colYoga => 'योग / दोष';

  @override
  String get colResult => 'परिणाम';

  @override
  String get sadeSatiNote =>
      'चंद्र राशि से 12वें, पहले या दूसरे शनि = साढ़ेसाती; चौथे या आठवें = लघु पनौती (ढैया)। वक्री होकर लौटने की अवधियाँ अलग दिखाई गई हैं।';

  @override
  String get colKind => 'अवधि';

  @override
  String get colPhase => 'चरण';

  @override
  String get sadeSatiKind => 'साढ़ेसाती';

  @override
  String get smallPanoti => 'लघु पनौती';

  @override
  String get phaseRising => 'आरंभ';

  @override
  String get phasePeak => 'शिखर';

  @override
  String get phaseSetting => 'अंत';

  @override
  String get runningNow => 'अभी चल रही';

  @override
  String get colBaladi => 'बालादि';

  @override
  String get colJagratadi => 'जाग्रतादि';

  @override
  String get colDeeptadi => 'दीप्तादि';

  @override
  String get avasthaNote =>
      'बालादि और जाग्रतादि अंशों से (सम राशि में उल्टा); दीप्तादि स्थिति से, अस्त हो तो कोप।';

  @override
  String get upagrahaNote =>
      'गुलिक = दिन/रात्रि के शनि भाग के आरंभ का लग्न; मांदी = उसके मध्य का (बृहत् पाराशर)। अन्य सॉफ़्टवेयर भिन्न नियम अपना सकते हैं।';

  @override
  String get arudhaNote => 'A1 = आरूढ़ लग्न (AL), A12 = उपपद (UL)।';

  @override
  String get colTara => 'तारा';

  @override
  String colCycle(Object n) {
    return 'चक्र $n';
  }

  @override
  String get panchang => 'पंचांग';

  @override
  String get choosePanchangPlace => 'पंचांग के लिए स्थान चुनें';

  @override
  String get changePlace => 'स्थान बदलें';

  @override
  String get secToday => 'दिन';

  @override
  String get secHora => 'होरा';

  @override
  String get secChogadia => 'चौघड़िया';

  @override
  String get secMuhurta => 'मुहूर्त';

  @override
  String get secLagnaTable => 'लग्न सारणी';

  @override
  String get secPanchakBhadra => 'पंचक व भद्रा';

  @override
  String get secVrat => 'व्रत';

  @override
  String untilTime(Object time) {
    return '$time तक';
  }

  @override
  String thenNext(Object name) {
    return 'फिर $name';
  }

  @override
  String get moonrise => 'चंद्रोदय';

  @override
  String get moonset => 'चंद्रास्त';

  @override
  String get noRiseSet => 'आज नहीं';

  @override
  String get paksha => 'पक्ष';

  @override
  String get monthAmanta => 'मास (अमांत)';

  @override
  String get monthPurnimanta => 'मास (पूर्णिमांत)';

  @override
  String get adhikaPrefix => 'अधिक';

  @override
  String get samvat => 'संवत';

  @override
  String samvatValue(Object v, Object s) {
    return 'विक्रम $v · शक $s';
  }

  @override
  String get sunSign => 'सूर्य राशि';

  @override
  String get moonSign => 'चंद्र राशि';

  @override
  String get rightNow => 'अभी';

  @override
  String get currentHora => 'होरा';

  @override
  String get currentChogadia => 'चौघड़िया';

  @override
  String get currentLagna => 'लग्न';

  @override
  String get currentMuhurta => 'मुहूर्त';

  @override
  String lagnaNature(Object sign, Object nature) {
    return '$sign ($nature)';
  }

  @override
  String get movable => 'चर';

  @override
  String get fixed => 'स्थिर';

  @override
  String get dual => 'द्विस्वभाव';

  @override
  String get kaalsTitle => 'अशुभ व शुभ काल';

  @override
  String get dayPart => 'दिन';

  @override
  String get nightPart => 'रात्रि';

  @override
  String get colTime => 'समय';

  @override
  String get good => 'शुभ';

  @override
  String get bad => 'अशुभ';

  @override
  String get panchakTitle => 'इस माह पंचक';

  @override
  String get bhadraTitle => 'इस माह भद्रा';

  @override
  String get nonePeriod => 'कोई नहीं';

  @override
  String vratTitle(Object year) {
    return 'व्रत तिथियाँ $year';
  }

  @override
  String get vratNote =>
      'स्मार्त नियम: एकादशी, पूर्णिमा, अमावस्या सूर्योदय की तिथि से; प्रदोष सूर्यास्त से; संकष्टी चंद्रोदय से; शिवरात्रि मध्यरात्रि से।';

  @override
  String get allVrats => 'सभी';

  @override
  String get computing => 'गणना हो रही है…';

  @override
  String get matching => 'कुंडली मिलान';

  @override
  String get boy => 'वर';

  @override
  String get girl => 'कन्या';

  @override
  String get chooseChart => 'सहेजी कुंडली चुनें';

  @override
  String get needTwoCharts => 'मिलान के लिए कम से कम दो कुंडलियाँ सहेजें।';

  @override
  String get ashtakoota => 'अष्टकूट (गुण मिलान)';

  @override
  String get colKoota => 'कूट';

  @override
  String get colMax => 'अधिकतम';

  @override
  String get colObtained => 'प्राप्त';

  @override
  String totalGunas(Object got) {
    return 'कुल: $got / 36';
  }

  @override
  String get verdictGood => 'अच्छा मिलान (18 या अधिक)';

  @override
  String get verdictPoor => '18 से कम: नियम के अनुसार अनुशंसित नहीं';

  @override
  String get nadiDosha => 'नाड़ी दोष';

  @override
  String get bhakootDosha => 'भकूट दोष';

  @override
  String doshaCancelled(Object dosha) {
    return '$dosha है, पर शास्त्रीय अपवाद से भंग';
  }

  @override
  String doshaPresent(Object dosha) {
    return '$dosha है';
  }

  @override
  String get mangalTitle => 'मांगलिक दोष';

  @override
  String get mangalBoth => 'दोनों मांगलिक या दोनों नहीं: अनुकूल';

  @override
  String get mangalOne => 'केवल एक मांगलिक: उपाय या भंग कारक आवश्यक';

  @override
  String get poruthamTitle => '10 पोरुथम (दक्षिण भारतीय)';

  @override
  String get colRajju => 'रज्जु';

  @override
  String get resultGood => 'उत्तम';

  @override
  String get resultAverage => 'मध्यम';

  @override
  String get resultBad => 'अशुभ';

  @override
  String poruthamCount(Object n) {
    return '10 में से $n अनुकूल';
  }

  @override
  String get matchingNote =>
      'अष्टकूट मुहूर्त चिंतामणि अनुसार। गणना चंद्र राशि व नक्षत्र से। भंग केवल टिप्पणी के रूप में; अंक नहीं बदलते।';

  @override
  String get tabTransit => 'गोचर';

  @override
  String transitOn(Object date) {
    return '$date का गोचर';
  }

  @override
  String get stepDay => 'दिन';

  @override
  String get stepMonth => 'माह';

  @override
  String get stepYear => 'वर्ष';

  @override
  String get transitChartTitle => 'जन्म कुंडली पर गोचर';

  @override
  String get transitNote => 'भीतर: जन्म के ग्रह। ▸ चिह्नित: गोचर के ग्रह।';

  @override
  String get colFromLagna => 'लग्न से';

  @override
  String get colFromMoon => 'चंद्र से';

  @override
  String get colSav => 'सर्वा.';

  @override
  String get colBav => 'भिन्ना.';

  @override
  String get colGochara => 'गोचर फल';

  @override
  String get gocharaGood => 'शुभ';

  @override
  String gocharaVedha(Object planet) {
    return 'शुभ, पर $planet से वेध';
  }

  @override
  String get gocharaBad => 'अशुभ';

  @override
  String get gocharaNote =>
      'जन्म चंद्र से गोचर (फलदीपिका 26), वेध सहित; राशि में सर्वाष्टकवर्ग 28 या अधिक हो तो शुभ फल को बल।';

  @override
  String get transitSearch => 'गोचर खोज';

  @override
  String get searchPlanet => 'ग्रह';

  @override
  String get searchTarget => 'किस पर';

  @override
  String searchYears(Object n) {
    return 'अगले $n वर्ष';
  }

  @override
  String get searchRun => 'खोजें';

  @override
  String get targetSigns => 'राशि परिवर्तन';

  @override
  String targetNatal(Object planet) {
    return 'जन्म $planet';
  }

  @override
  String get targetLagna => 'जन्म लग्न';

  @override
  String eventEnters(Object sign) {
    return '$sign में प्रवेश';
  }

  @override
  String get eventOver => 'लक्ष्य पर ठीक';

  @override
  String get retroMark => '(व)';

  @override
  String get noEvents => 'इस अवधि में कोई घटना नहीं।';

  @override
  String get goToDate => 'दिखाएँ';

  @override
  String get reportTitle => 'जन्म कुंडली';

  @override
  String get reportCharts => 'कुंडली चक्र';

  @override
  String reportPage(String page, String total) {
    return 'पृष्ठ $page / $total';
  }

  @override
  String reportPreparedOn(String date) {
    return '$date को तैयार';
  }

  @override
  String reportRunning(String path, String date) {
    return 'अभी चल रही: $path ($date तक)';
  }

  @override
  String get pdfKundli => 'PDF कुंडली';

  @override
  String get reportInclude => 'शामिल करें';

  @override
  String get reportLanguage => 'रिपोर्ट की भाषा';

  @override
  String get makePdf => 'PDF बनाएँ';

  @override
  String get makingPdf => 'PDF बन रही है…';

  @override
  String reportReady(String pages, String seconds) {
    return '$pages पृष्ठ · $seconds सेकंड में बनी';
  }

  @override
  String get sharePdf => 'भेजें';

  @override
  String get printPdf => 'प्रिंट';

  @override
  String reportFailed(String error) {
    return 'PDF नहीं बन सकी: $error';
  }

  @override
  String get letterhead => 'लेटरहेड (PDF)';

  @override
  String get letterheadHint => 'PDF कुंडली के हर पृष्ठ के ऊपर छपता है।';

  @override
  String get letterheadMissing =>
      'आपका लेटरहेड खाली है। सेटिंग्स → लेटरहेड में अपना नाम, फ़ोन और लोगो जोड़ें।';

  @override
  String get lhName => 'आपका नाम';

  @override
  String get lhTitle => 'पद (जैसे वैदिक ज्योतिषी)';

  @override
  String get lhPhone => 'फ़ोन';

  @override
  String get lhAddress => 'पता';

  @override
  String get lhLogo => 'लोगो';

  @override
  String get chooseLogo => 'लोगो चुनें';

  @override
  String get removeLogo => 'लोगो हटाएँ';

  @override
  String get saved => 'सहेजा गया';

  @override
  String get saveAction => 'सहेजें';

  @override
  String get ashtakavargaShort => 'अष्टकवर्ग';

  @override
  String get clients => 'ग्राहक';

  @override
  String get appointments => 'मुलाक़ातें';

  @override
  String get client => 'ग्राहक';

  @override
  String get newClient => 'नया ग्राहक';

  @override
  String get editClient => 'ग्राहक बदलें';

  @override
  String get searchClients => 'नाम, फ़ोन या नोट्स खोजें';

  @override
  String get noClientsYet => 'अभी कोई ग्राहक नहीं। \'नया ग्राहक\' से जोड़ें।';

  @override
  String noClientMatches(String query) {
    return '\"$query\" से कोई ग्राहक नहीं मिला।';
  }

  @override
  String get clientNotFound => 'ग्राहक नहीं मिला।';

  @override
  String chartCount(String n) {
    return '$n कुंडलियाँ';
  }

  @override
  String dueAmount(String amount) {
    return 'बाकी $amount';
  }

  @override
  String paidTotal(String amount) {
    return 'मिला $amount';
  }

  @override
  String get city => 'शहर';

  @override
  String get clientNotes => 'नोट्स';

  @override
  String get nameRequired => 'नाम लिखें';

  @override
  String get deleteClientTitle => 'ग्राहक हटाएँ?';

  @override
  String deleteClientBody(String name) {
    return '$name हटा दिए जाएँगे। उनकी कुंडलियाँ और मुलाक़ातें रहेंगी, बस जुड़ाव हटेगा।';
  }

  @override
  String get call => 'कॉल';

  @override
  String get familyCharts => 'परिवार की कुंडलियाँ';

  @override
  String get noFamilyCharts => 'अभी कोई कुंडली नहीं जुड़ी। + से जोड़ें।';

  @override
  String get newChartForClient => 'नई कुंडली';

  @override
  String get linkChart => 'सहेजी कुंडली जोड़ें';

  @override
  String get relationTitle => 'ग्राहक से संबंध';

  @override
  String get changeRelation => 'संबंध बदलें';

  @override
  String get unlinkChart => 'ग्राहक से हटाएँ';

  @override
  String get relSelf => 'स्वयं';

  @override
  String get relSpouse => 'पति/पत्नी';

  @override
  String get relSon => 'पुत्र';

  @override
  String get relDaughter => 'पुत्री';

  @override
  String get relFather => 'पिता';

  @override
  String get relMother => 'माता';

  @override
  String get relBrother => 'भाई';

  @override
  String get relSister => 'बहन';

  @override
  String get relOther => 'अन्य';

  @override
  String get consultations => 'मुलाक़ातें';

  @override
  String get noConsultations => 'अभी कोई मुलाक़ात नहीं।';

  @override
  String get reportsSent => 'भेजी गई PDF कुंडलियाँ';

  @override
  String pagesCount(String n) {
    return '$n पृष्ठ';
  }

  @override
  String get newAppointment => 'नई मुलाक़ात';

  @override
  String get editAppointment => 'मुलाक़ात';

  @override
  String get noAppointments => 'यहाँ कुछ नहीं।';

  @override
  String get noAppointmentsToday => 'आज कोई मुलाक़ात नहीं।';

  @override
  String get followUpsThisWeek => 'इस सप्ताह फ़ॉलो-अप';

  @override
  String get noFollowUps => 'कोई फ़ॉलो-अप बाकी नहीं।';

  @override
  String get viewToday => 'आज';

  @override
  String get viewUpcoming => 'आगे';

  @override
  String get viewPast => 'पिछली';

  @override
  String get viewUnpaid => 'बाकी';

  @override
  String get totalUnpaid => 'कुल बाकी';

  @override
  String get nothingUnpaid => 'सारी फ़ीस मिल गई है।';

  @override
  String get statusScheduled => 'तय';

  @override
  String get statusDone => 'हो गई';

  @override
  String get statusCancelled => 'रद्द';

  @override
  String get statusMissed => 'नहीं आए';

  @override
  String get markDone => 'हो गई';

  @override
  String get markPaid => 'फ़ीस मिली';

  @override
  String get markMissed => 'नहीं आए';

  @override
  String get markCancelled => 'रद्द करें';

  @override
  String get noClient => '— बिना ग्राहक (सीधे आए) —';

  @override
  String get walkInName => 'नाम';

  @override
  String get topic => 'विषय (वैकल्पिक)';

  @override
  String get needClientOrName => 'ग्राहक चुनें या नाम लिखें।';

  @override
  String minutesShort(String n) {
    return '$n मिनट';
  }

  @override
  String get remindMe => 'याद दिलाएँ';

  @override
  String get remindMeHint => '30 मिनट पहले, और फ़ॉलो-अप के दिन सुबह 10 बजे';

  @override
  String get sessionNotes => 'मुलाक़ात के नोट्स';

  @override
  String get sessionNotesHint =>
      'पूछे गए प्रश्न, कुंडली में क्या देखा, बताए गए उपाय…';

  @override
  String get fee => 'फ़ीस';

  @override
  String get paid => 'मिली';

  @override
  String get followUpOn => 'फ़ॉलो-अप की तारीख';

  @override
  String get deleteAppointmentTitle => 'यह मुलाक़ात हटाएँ?';

  @override
  String get remindersChannel => 'मुलाक़ात अनुस्मारक';

  @override
  String appointmentReminder(String who) {
    return 'मुलाक़ात: $who';
  }

  @override
  String followUpReminder(String who) {
    return '$who से फ़ॉलो-अप';
  }

  @override
  String get backup => 'बैकअप';

  @override
  String get backupSettingsHint =>
      'सब कुछ Google Drive में सहेजें, या वापस लाएँ';

  @override
  String get backupIntro =>
      'बैकअप एक फ़ाइल है जिसमें सारी कुंडलियाँ, ग्राहक, मुलाक़ातें, सेटिंग्स और आपका लोगो होता है। इसे Google Drive पर रखें ताकि फ़ोन खोने या बदलने पर कुछ न खोए।';

  @override
  String get neverBackedUp => 'इस फ़ोन पर अभी तक कोई बैकअप नहीं बना।';

  @override
  String lastBackup(String when) {
    return 'पिछला बैकअप: $when';
  }

  @override
  String get backupNow => 'अभी बैकअप लें';

  @override
  String get backupHint =>
      'फिर शेयर सूची में Drive (Save to Drive), WhatsApp या ईमेल चुनें।';

  @override
  String get backupShareText => 'एस्ट्रो ऐप बैकअप';

  @override
  String get restoreFromFile => 'बैकअप फ़ाइल से वापस लाएँ';

  @override
  String get restoreHint =>
      'बैकअप .zip चुनें (Drive या फ़ोन से)। इस फ़ोन का सारा डेटा बैकअप से बदल जाएगा।';

  @override
  String get restoreTitle => 'यह बैकअप वापस लाएँ?';

  @override
  String restoreBody(
    String when,
    String charts,
    String clients,
    String appointments,
  ) {
    return '$when को बना: $charts कुंडलियाँ, $clients ग्राहक, $appointments मुलाक़ातें।\n\nइस फ़ोन का अभी का सारा डेटा बदल जाएगा।';
  }

  @override
  String get restoreAction => 'वापस लाएँ';

  @override
  String get notABackup => 'यह फ़ाइल इस ऐप का बैकअप नहीं है।';

  @override
  String get backupTooNew =>
      'यह बैकअप ऐप के नए संस्करण का है। पहले ऐप अपडेट करें।';

  @override
  String backupFailed(String error) {
    return 'बैकअप नहीं हो सका: $error';
  }

  @override
  String get dashaSystem => 'दशा पद्धति';

  @override
  String get dashaApplies => 'इस कुंडली पर लागू';

  @override
  String get dashaNotApplies => 'इस कुंडली पर लागू नहीं (केवल संदर्भ के लिए)';

  @override
  String get dashaApplyUnknown => 'स्वयं जाँचें';

  @override
  String get otherDashas => 'अन्य दशाएँ';

  @override
  String get otherDashasNote =>
      'अष्टोत्तरी सदा दिखाई जाती है; सशर्त दशाएँ केवल तब जब उनकी BPHS शर्त इस कुंडली पर पूरी हो।';

  @override
  String get auspiciousTimings => 'शुभ समय';

  @override
  String get inauspiciousTimings => 'अशुभ समय';

  @override
  String get anandadiTitle => 'आनन्दादि योग';

  @override
  String get nivasTitle => 'निवास और शूल';

  @override
  String get homahutiLabel => 'होमाहुति';

  @override
  String get dishaShoolLabel => 'दिशा शूल';

  @override
  String get rahuVasaLabel => 'राहु वास';

  @override
  String get agnivasaLabel => 'अग्निवास';

  @override
  String get bhadravasaLabel => 'भद्रा वास';

  @override
  String get chandraVasaLabel => 'चन्द्र वास';

  @override
  String get shivavasaLabel => 'शिववास';

  @override
  String get otherCalendars => 'अन्य पंचांग और युग';

  @override
  String get kaliyugaLabel => 'कलियुग';

  @override
  String get kaliAharganaLabel => 'कलि अहर्गण';

  @override
  String get rataDieLabel => 'राटा डाई';

  @override
  String get mjdLabel => 'संशोधित जूलियन दिन';

  @override
  String get julianDateLabel => 'जूलियन तिथि';

  @override
  String get nationalCivilDateLabel => 'राष्ट्रीय शक तिथि';

  @override
  String yearsValue(String n) {
    return '$n वर्ष';
  }

  @override
  String daysValue(String n) {
    return '$n दिन';
  }

  @override
  String get rituTitle => 'ऋतु और अयन';

  @override
  String get drikRituLabel => 'दृक् ऋतु';

  @override
  String get vedicRituLabel => 'वैदिक ऋतु';

  @override
  String get drikAyanaLabel => 'दृक् अयन';

  @override
  String get vedicAyanaLabel => 'वैदिक अयन';

  @override
  String get uttarayana => 'उत्तरायण';

  @override
  String get dakshinayana => 'दक्षिणायन';

  @override
  String get madhyahnaLabel => 'मध्याह्न';

  @override
  String get dinamanaLabel => 'दिनमान';

  @override
  String get ratrimanaLabel => 'रात्रिमान';

  @override
  String get samvatTitle => 'संवत्';

  @override
  String get pravishteLabel => 'प्रविष्टे / गते';

  @override
  String get shakaSamvatLabel => 'शक संवत्';

  @override
  String get vikramSamvatLabel => 'विक्रम संवत्';

  @override
  String get gujaratiSamvatLabel => 'गुजराती संवत्';

  @override
  String get suryaNakshatraLabel => 'सूर्य नक्षत्र';

  @override
  String get baanaLabel => 'बाण';

  @override
  String fromTime(String time) {
    return '$time से';
  }

  @override
  String get secGowri => 'गौरी';

  @override
  String get secPanchakaRahita => 'पंचक रहित';

  @override
  String get secBala => 'चन्द्र / तारा बल';

  @override
  String get shubhaMuhurta => 'शुभ मुहूर्त';

  @override
  String panchakaName(String name) {
    return '$name पंचक';
  }

  @override
  String get dayHalf => 'दिन';

  @override
  String get nightHalf => 'रात्रि';

  @override
  String get chandrabalamTitle => 'चन्द्र बल (12 राशियाँ)';

  @override
  String get tarabalamTitle => 'तारा बल (27 नक्षत्र)';

  @override
  String get panchakaRahitaNote =>
      '(तिथि + वार + नक्षत्र + लग्न) ÷ 9: शेष 1 मृत्यु, 2 अग्नि, 4 राज, 6 चोर, 8 रोग पंचक; बाकी शुभ।';

  @override
  String get ahoratri => 'अहोरात्र';

  @override
  String get lahiriNote => 'अयनांश';

  @override
  String get bhadraLabel => 'भद्रा';

  @override
  String get tamilYogaLabel => 'तमिल योग';

  @override
  String get jeevanamaLabel => 'जीवनम';

  @override
  String get netramaLabel => 'नेत्रम';

  @override
  String get kumbhaChakraLabel => 'कुम्भ चक्र';

  @override
  String mantriMandalaTitle(String year) {
    return 'विक्रम संवत् $year का मंत्रिमंडल';
  }

  @override
  String get brihaspatiSamvatsaraLabel => 'बार्हस्पत्य संवत्सर';

  @override
  String get secFestivals => 'त्योहार';

  @override
  String get secEclipses => 'ग्रहण';

  @override
  String festivalsTitle(String year) {
    return '$year के त्योहार';
  }

  @override
  String get festivalsNote =>
      'तिथि सही समय (सूर्योदय, मध्याह्न, अपराह्न, प्रदोष, निशीथ या चंद्रोदय) पर देखकर, इस स्थान के लिए। दिन खोलने के लिए त्योहार पर टैप करें।';

  @override
  String eclipsesTitle(String year) {
    return '$year के ग्रहण';
  }

  @override
  String get eclipseMaximum => 'परमग्रास';

  @override
  String get eclipseVisibility => 'यहाँ';

  @override
  String get eclipseNotVisible => 'दिखाई नहीं देगा';

  @override
  String get eclipseVisibleFrom => 'दिखाई देगा';

  @override
  String get eclipseRisesEclipsed => 'ग्रस्तोदय';

  @override
  String get eclipseSetsEclipsed => 'ग्रस्तास्त';

  @override
  String get eclipseMagnitude => 'ग्रास मान';

  @override
  String get sutakLabel => 'सूतक';

  @override
  String get noSutak => 'नहीं (उपच्छाया)';

  @override
  String get sutakKidsLabel => 'बालक, वृद्ध, रोगी हेतु सूतक';

  @override
  String get eclipseNote =>
      'सूतक: सूर्य ग्रहण से 12 घंटे और चन्द्र ग्रहण से 9 घंटे पहले से ग्रहण समाप्ति तक; केवल जहाँ ग्रहण दिखे।';

  @override
  String get nakshatraShoolLabel => 'नक्षत्र शूल';

  @override
  String get nationalNirayanaDateLabel => 'राष्ट्रीय निरयण तिथि';
}
