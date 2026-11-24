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
}
