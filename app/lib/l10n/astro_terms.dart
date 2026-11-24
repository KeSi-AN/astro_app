import 'package:birth_input/birth_input.dart';
import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../features/chart_view/domain/chart_plate.dart';
import '../features/chart_view/presentation/chart_geometry.dart';

/// Astrology vocabulary in the app's language. Kept in Dart (not ARB)
/// because it is a few hundred fixed terms indexed by engine enums.
abstract class AstroTerms {
  const AstroTerms();

  static AstroTerms of(BuildContext context) =>
      forLocale(Localizations.localeOf(context));

  static AstroTerms forLocale(Locale l) =>
      l.languageCode == 'hi' ? const HindiTerms() : const EnglishTerms();

  String graha(Graha g);
  String grahaShort(Graha g);

  /// Short lagna marker on charts.
  String get lagnaShort;
  String get lagna;
  String rashi(Rashi r);
  String rashiShort(Rashi r);
  String nakshatra(Nakshatra n);
  String tithi(int n);
  String paksha(int tithi);
  String yoga(int n);
  String karana(int n);

  /// 1 = Monday … 7 = Sunday.
  String weekday(int n);
  String dignity(Dignity d);
  String relation(Relation r);
  String relationShort(Relation r);
  String karaka(Karaka k);
  String karakaShort(Karaka k);
  String karakaScheme(KarakaScheme s);
  String ayanamsa(Ayanamsa a);
  String nodeType(NodeType n);
  String sunriseMode(SunriseMode m);
  String chartStyle(ChartStyle s);
  String plateKind(PlateKind k);
  String timeBasis(TimeBasis b);

  /// Avakhada values arrive from the engine as English words.
  String avakhadaValue(String english);
  String nameSyllable(Nakshatra n, int pada);
  String maritalStatus(String english);
  String occupation(String english);
  String month(int m);
  String varga(Varga v);
  String yogini(Yogini y);

  /// 1 = maha … 5 = prana.
  String dashaLevel(int level);
  String dashaYear(DashaYear y);
  String yogaName(String id);
  String yogaRule(String id);
  String upagraha(Upagraha u);
  String baladi(Baladi b);
  String jagratadi(Jagratadi j);
  String deeptadi(Deeptadi d);
  String navatara(int i);
}

const _yogaText = <String, List<String>>{
  'ruchaka': [
    'Ruchaka (Panch Mahapurush)',
    'रुचक (पंच महापुरुष)',
    'Mars in own or exalted sign in a kendra',
    'मंगल स्वराशि या उच्च होकर केंद्र में',
  ],
  'bhadra': [
    'Bhadra (Panch Mahapurush)',
    'भद्र (पंच महापुरुष)',
    'Mercury in own or exalted sign in a kendra',
    'बुध स्वराशि या उच्च होकर केंद्र में',
  ],
  'hamsa': [
    'Hamsa (Panch Mahapurush)',
    'हंस (पंच महापुरुष)',
    'Jupiter in own or exalted sign in a kendra',
    'गुरु स्वराशि या उच्च होकर केंद्र में',
  ],
  'malavya': [
    'Malavya (Panch Mahapurush)',
    'मालव्य (पंच महापुरुष)',
    'Venus in own or exalted sign in a kendra',
    'शुक्र स्वराशि या उच्च होकर केंद्र में',
  ],
  'shasha': [
    'Shasha (Panch Mahapurush)',
    'शश (पंच महापुरुष)',
    'Saturn in own or exalted sign in a kendra',
    'शनि स्वराशि या उच्च होकर केंद्र में',
  ],
  'gajakesari': [
    'Gajakesari',
    'गजकेसरी',
    'Jupiter in a kendra from the Moon',
    'चंद्र से केंद्र में गुरु',
  ],
  'sunapha': [
    'Sunapha',
    'सुनफा',
    'A planet (not Sun) in the 2nd from the Moon',
    'चंद्र से दूसरे भाव में ग्रह (सूर्य के अतिरिक्त)',
  ],
  'anapha': [
    'Anapha',
    'अनफा',
    'A planet (not Sun) in the 12th from the Moon',
    'चंद्र से बारहवें भाव में ग्रह (सूर्य के अतिरिक्त)',
  ],
  'durudhara': [
    'Durudhara',
    'दुरुधरा',
    'Planets on both sides of the Moon',
    'चंद्र के दोनों ओर ग्रह',
  ],
  'kemadruma': [
    'Kemadruma',
    'केमद्रुम',
    'No planet on either side of the Moon (cancelled by planets in kendra)',
    'चंद्र के दोनों ओर कोई ग्रह नहीं (केंद्र में ग्रह होने पर भंग)',
  ],
  'chandraMangala': [
    'Chandra-Mangala',
    'चंद्र-मंगल',
    'Moon and Mars together or opposite',
    'चंद्र और मंगल साथ या आमने-सामने',
  ],
  'adhi': [
    'Adhi',
    'अधि',
    'Mercury, Jupiter and Venus in 6/7/8 from the Moon',
    'बुध, गुरु, शुक्र चंद्र से 6/7/8 में',
  ],
  'vesi': [
    'Vesi',
    'वेशि',
    'A planet (not Moon) in the 2nd from the Sun',
    'सूर्य से दूसरे भाव में ग्रह (चंद्र के अतिरिक्त)',
  ],
  'vosi': [
    'Vosi',
    'वोशि',
    'A planet (not Moon) in the 12th from the Sun',
    'सूर्य से बारहवें भाव में ग्रह (चंद्र के अतिरिक्त)',
  ],
  'ubhayachari': [
    'Ubhayachari',
    'उभयचरी',
    'Planets on both sides of the Sun',
    'सूर्य के दोनों ओर ग्रह',
  ],
  'budhaditya': [
    'Budhaditya',
    'बुधादित्य',
    'Sun and Mercury together',
    'सूर्य और बुध साथ',
  ],
  'amala': [
    'Amala',
    'अमल',
    'A benefic in the 10th from lagna or Moon',
    'लग्न या चंद्र से दसवें भाव में शुभ ग्रह',
  ],
  'saraswati': [
    'Saraswati',
    'सरस्वती',
    'Jupiter, Venus, Mercury in kendra/trikona/2nd, Jupiter strong',
    'गुरु, शुक्र, बुध केंद्र/त्रिकोण/द्वितीय में, गुरु बलवान',
  ],
  'parvata': [
    'Parvata',
    'पर्वत',
    'Lagna lord and 12th lord in mutual kendras',
    'लग्नेश और द्वादशेश परस्पर केंद्र में',
  ],
  'kahala': [
    'Kahala',
    'काहल',
    '4th lord and 9th lord in mutual kendras',
    'चतुर्थेश और नवमेश परस्पर केंद्र में',
  ],
  'raja': [
    'Parashari Raja yoga',
    'पाराशरी राजयोग',
    'Kendra lord linked with a trikona lord (or a yogakaraka)',
    'केंद्रेश और त्रिकोणेश का संबंध (या योगकारक)',
  ],
  'dhana': [
    'Dhana yoga',
    'धन योग',
    'Lords of 1, 2, 5, 9, 11 linked',
    '1, 2, 5, 9, 11 भाव के स्वामियों का संबंध',
  ],
  'harsha': [
    'Harsha (Viparita Raja)',
    'हर्ष (विपरीत राजयोग)',
    '6th lord in 6, 8 or 12',
    'षष्ठेश 6, 8 या 12 में',
  ],
  'sarala': [
    'Sarala (Viparita Raja)',
    'सरल (विपरीत राजयोग)',
    '8th lord in 6, 8 or 12',
    'अष्टमेश 6, 8 या 12 में',
  ],
  'vimala': [
    'Vimala (Viparita Raja)',
    'विमल (विपरीत राजयोग)',
    '12th lord in 6, 8 or 12',
    'द्वादशेश 6, 8 या 12 में',
  ],
  'neechaBhanga': [
    'Neecha Bhanga Raja yoga',
    'नीचभंग राजयोग',
    'A debilitated planet whose sign lord or exaltation lord is in a kendra',
    'नीच ग्रह जिसका राशि स्वामी या उच्च स्वामी केंद्र में',
  ],
  'mangal': [
    'Mangal dosha',
    'मांगलिक दोष',
    'Mars in 1, 2, 4, 7, 8, 12 from lagna, Moon or Venus',
    'लग्न, चंद्र या शुक्र से 1, 2, 4, 7, 8, 12 में मंगल',
  ],
  'kaalSarp': [
    'Kaal Sarp dosha',
    'काल सर्प दोष',
    'All seven planets on one side of Rahu–Ketu',
    'सातों ग्रह राहु–केतु के एक ओर',
  ],
  'guruChandala': [
    'Guru Chandala',
    'गुरु चांडाल',
    'Jupiter with Rahu or Ketu',
    'गुरु राहु या केतु के साथ',
  ],
  'grahan': [
    'Grahan dosha',
    'ग्रहण दोष',
    'Sun or Moon with Rahu or Ketu',
    'सूर्य या चंद्र राहु या केतु के साथ',
  ],
  'shakata': [
    'Shakata',
    'शकट',
    'Moon in 6, 8 or 12 from Jupiter (cancelled if Moon in kendra)',
    'गुरु से 6, 8 या 12 में चंद्र (चंद्र केंद्र में हो तो भंग)',
  ],
};

const _upaEn = {
  Upagraha.dhuma: 'Dhuma',
  Upagraha.vyatipata: 'Vyatipata',
  Upagraha.parivesha: 'Parivesha',
  Upagraha.indrachapa: 'Indrachapa',
  Upagraha.upaketu: 'Upaketu',
  Upagraha.kaala: 'Kaala',
  Upagraha.mrityu: 'Mrityu',
  Upagraha.arthaprahara: 'Arthaprahara',
  Upagraha.yamaghantaka: 'Yamaghantaka',
  Upagraha.gulika: 'Gulika',
  Upagraha.maandi: 'Maandi',
};
const _upaHi = {
  Upagraha.dhuma: 'धूम',
  Upagraha.vyatipata: 'व्यतिपात',
  Upagraha.parivesha: 'परिवेष',
  Upagraha.indrachapa: 'इंद्रचाप',
  Upagraha.upaketu: 'उपकेतु',
  Upagraha.kaala: 'काल',
  Upagraha.mrityu: 'मृत्यु',
  Upagraha.arthaprahara: 'अर्धप्रहर',
  Upagraha.yamaghantaka: 'यमघंटक',
  Upagraha.gulika: 'गुलिक',
  Upagraha.maandi: 'मांदी',
};

class EnglishTerms extends AstroTerms {
  const EnglishTerms();

  @override
  String graha(Graha g) => g.label;
  @override
  String grahaShort(Graha g) => g.short;
  @override
  String get lagnaShort => 'As';
  @override
  String get lagna => 'Lagna';
  @override
  String rashi(Rashi r) => r.label;
  @override
  String rashiShort(Rashi r) => r.short;
  @override
  String nakshatra(Nakshatra n) => n.label;
  @override
  String tithi(int n) => tithiName(n);
  @override
  String paksha(int tithi) => tithi <= 15 ? 'Shukla' : 'Krishna';
  @override
  String yoga(int n) => yogaNames[n - 1];
  @override
  String karana(int n) => karanaName(n);
  @override
  String weekday(int n) => weekdayNames[n - 1];
  @override
  String dignity(Dignity d) => d.label;
  @override
  String relation(Relation r) => r.label;
  @override
  String relationShort(Relation r) => r.short;
  @override
  String karaka(Karaka k) => k.label;
  @override
  String karakaShort(Karaka k) => k.short;
  @override
  String karakaScheme(KarakaScheme s) => s.label;
  @override
  String ayanamsa(Ayanamsa a) => a.label;
  @override
  String nodeType(NodeType n) =>
      n == NodeType.meanNode ? 'Mean node' : 'True node';
  @override
  String sunriseMode(SunriseMode m) => m.label;
  @override
  String chartStyle(ChartStyle s) => s.label;
  @override
  String plateKind(PlateKind k) => k.label;
  @override
  String timeBasis(TimeBasis b) => b.label;
  @override
  String avakhadaValue(String english) => english;
  @override
  String nameSyllable(Nakshatra n, int pada) => _syllablesEn[n.index][pada - 1];
  @override
  String maritalStatus(String english) => english;
  @override
  String occupation(String english) => english;
  @override
  String varga(Varga v) => v.label;
  @override
  String yogini(Yogini y) => y.label;
  @override
  String dashaLevel(int level) => const [
    'Mahadasha',
    'Antardasha',
    'Pratyantar',
    'Sookshma',
    'Prana',
  ][level - 1];
  @override
  String dashaYear(DashaYear y) => y.label;
  @override
  String yogaName(String id) => _yogaText[id]?[0] ?? id;
  @override
  String yogaRule(String id) => _yogaText[id]?[2] ?? '';
  @override
  String upagraha(Upagraha u) => _upaEn[u]!;
  @override
  String baladi(Baladi b) =>
      const ['Bala', 'Kumara', 'Yuva', 'Vriddha', 'Mrita'][b.index];
  @override
  String jagratadi(Jagratadi j) =>
      const ['Jagrat', 'Swapna', 'Sushupta'][j.index];
  @override
  String deeptadi(Deeptadi d) => const [
    'Deepta',
    'Swastha',
    'Mudita',
    'Shanta',
    'Deena',
    'Dukhita',
    'Khala',
    'Kopa',
  ][d.index];
  @override
  String navatara(int i) => navataraNames[i];
  @override
  String month(int m) => const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][m - 1];
}

class HindiTerms extends AstroTerms {
  @override
  String yogaName(String id) => _yogaText[id]?[1] ?? id;
  @override
  String yogaRule(String id) => _yogaText[id]?[3] ?? '';
  @override
  String upagraha(Upagraha u) => _upaHi[u]!;
  @override
  String baladi(Baladi b) =>
      const ['बाल', 'कुमार', 'युवा', 'वृद्ध', 'मृत'][b.index];
  @override
  String jagratadi(Jagratadi j) =>
      const ['जाग्रत', 'स्वप्न', 'सुषुप्त'][j.index];
  @override
  String deeptadi(Deeptadi d) => const [
    'दीप्त',
    'स्वस्थ',
    'मुदित',
    'शांत',
    'दीन',
    'दुःखित',
    'खल',
    'कोप',
  ][d.index];
  @override
  String navatara(int i) => const [
    'जन्म',
    'संपत्',
    'विपत्',
    'क्षेम',
    'प्रत्यरि',
    'साधक',
    'वध',
    'मित्र',
    'अतिमित्र',
  ][i];

  @override
  String varga(Varga v) => const {
    Varga.d1: 'राशि',
    Varga.d2: 'होरा',
    Varga.d3: 'द्रेष्काण',
    Varga.d4: 'चतुर्थांश',
    Varga.d7: 'सप्तांश',
    Varga.d9: 'नवांश',
    Varga.d10: 'दशमांश',
    Varga.d12: 'द्वादशांश',
    Varga.d16: 'षोडशांश',
    Varga.d20: 'विंशांश',
    Varga.d24: 'चतुर्विंशांश',
    Varga.d27: 'सप्तविंशांश',
    Varga.d30: 'त्रिंशांश',
    Varga.d40: 'खवेदांश',
    Varga.d45: 'अक्षवेदांश',
    Varga.d60: 'षष्ट्यंश',
  }[v]!;
  @override
  String yogini(Yogini y) => const {
    Yogini.mangala: 'मंगला',
    Yogini.pingala: 'पिंगला',
    Yogini.dhanya: 'धान्या',
    Yogini.bhramari: 'भ्रामरी',
    Yogini.bhadrika: 'भद्रिका',
    Yogini.ulka: 'उल्का',
    Yogini.siddha: 'सिद्धा',
    Yogini.sankata: 'संकटा',
  }[y]!;
  @override
  String dashaLevel(int level) => const [
    'महादशा',
    'अंतर्दशा',
    'प्रत्यंतर दशा',
    'सूक्ष्म दशा',
    'प्राण दशा',
  ][level - 1];
  @override
  String dashaYear(DashaYear y) => switch (y) {
    DashaYear.julian => '365.25 दिन',
    DashaYear.tropical => '365.2422 दिन (सायन वर्ष)',
    DashaYear.sidereal => '365.2564 दिन (नाक्षत्र वर्ष)',
    DashaYear.savana => '360 दिन (सावन)',
  };

  const HindiTerms();

  static const _graha = {
    Graha.sun: 'सूर्य',
    Graha.moon: 'चंद्र',
    Graha.mars: 'मंगल',
    Graha.mercury: 'बुध',
    Graha.jupiter: 'गुरु',
    Graha.venus: 'शुक्र',
    Graha.saturn: 'शनि',
    Graha.rahu: 'राहु',
    Graha.ketu: 'केतु',
    Graha.uranus: 'यूरेनस',
    Graha.neptune: 'नेपच्यून',
    Graha.pluto: 'प्लूटो',
  };
  static const _grahaShort = {
    Graha.sun: 'सू',
    Graha.moon: 'चं',
    Graha.mars: 'मं',
    Graha.mercury: 'बु',
    Graha.jupiter: 'गु',
    Graha.venus: 'शु',
    Graha.saturn: 'श',
    Graha.rahu: 'रा',
    Graha.ketu: 'के',
    Graha.uranus: 'यू',
    Graha.neptune: 'ने',
    Graha.pluto: 'प्लू',
  };
  static const _rashi = [
    'मेष',
    'वृषभ',
    'मिथुन',
    'कर्क',
    'सिंह',
    'कन्या',
    'तुला',
    'वृश्चिक',
    'धनु',
    'मकर',
    'कुंभ',
    'मीन',
  ];
  static const _nakshatra = [
    'अश्विनी',
    'भरणी',
    'कृत्तिका',
    'रोहिणी',
    'मृगशिरा',
    'आर्द्रा',
    'पुनर्वसु',
    'पुष्य',
    'आश्लेषा',
    'मघा',
    'पूर्वा फाल्गुनी',
    'उत्तरा फाल्गुनी',
    'हस्त',
    'चित्रा',
    'स्वाति',
    'विशाखा',
    'अनुराधा',
    'ज्येष्ठा',
    'मूल',
    'पूर्वाषाढ़ा',
    'उत्तराषाढ़ा',
    'श्रवण',
    'धनिष्ठा',
    'शतभिषा',
    'पूर्वा भाद्रपद',
    'उत्तरा भाद्रपद',
    'रेवती',
  ];
  static const _tithi = [
    'प्रतिपदा',
    'द्वितीया',
    'तृतीया',
    'चतुर्थी',
    'पंचमी',
    'षष्ठी',
    'सप्तमी',
    'अष्टमी',
    'नवमी',
    'दशमी',
    'एकादशी',
    'द्वादशी',
    'त्रयोदशी',
    'चतुर्दशी',
  ];
  static const _yoga = [
    'विष्कुम्भ',
    'प्रीति',
    'आयुष्मान',
    'सौभाग्य',
    'शोभन',
    'अतिगण्ड',
    'सुकर्मा',
    'धृति',
    'शूल',
    'गण्ड',
    'वृद्धि',
    'ध्रुव',
    'व्याघात',
    'हर्षण',
    'वज्र',
    'सिद्धि',
    'व्यतीपात',
    'वरीयान',
    'परिघ',
    'शिव',
    'सिद्ध',
    'साध्य',
    'शुभ',
    'शुक्ल',
    'ब्रह्म',
    'इन्द्र',
    'वैधृति',
  ];
  static const _movableKarana = [
    'बव',
    'बालव',
    'कौलव',
    'तैतिल',
    'गर',
    'वणिज',
    'विष्टि (भद्रा)',
  ];
  static const _weekday = [
    'सोमवार',
    'मंगलवार',
    'बुधवार',
    'गुरुवार',
    'शुक्रवार',
    'शनिवार',
    'रविवार',
  ];

  @override
  String graha(Graha g) => _graha[g]!;
  @override
  String grahaShort(Graha g) => _grahaShort[g]!;
  @override
  String get lagnaShort => 'ल';
  @override
  String get lagna => 'लग्न';
  @override
  String rashi(Rashi r) => _rashi[r.index];
  @override
  String rashiShort(Rashi r) => _rashi[r.index];
  @override
  String nakshatra(Nakshatra n) => _nakshatra[n.index];
  @override
  String tithi(int n) => n == 15
      ? 'पूर्णिमा'
      : n == 30
      ? 'अमावस्या'
      : _tithi[(n - 1) % 15];
  @override
  String paksha(int tithi) => tithi <= 15 ? 'शुक्ल' : 'कृष्ण';
  @override
  String yoga(int n) => _yoga[n - 1];
  @override
  String karana(int n) => switch (n) {
    1 => 'किंस्तुघ्न',
    58 => 'शकुनि',
    59 => 'चतुष्पद',
    60 => 'नाग',
    _ => _movableKarana[(n - 2) % 7],
  };
  @override
  String weekday(int n) => _weekday[n - 1];
  @override
  String dignity(Dignity d) => switch (d) {
    Dignity.exalted => 'उच्च',
    Dignity.moolatrikona => 'मूलत्रिकोण',
    Dignity.own => 'स्वराशि',
    Dignity.greatFriend => 'अधिमित्र राशि',
    Dignity.friend => 'मित्र राशि',
    Dignity.neutral => 'सम राशि',
    Dignity.enemy => 'शत्रु राशि',
    Dignity.greatEnemy => 'अधिशत्रु राशि',
    Dignity.debilitated => 'नीच',
  };
  @override
  String relation(Relation r) => switch (r) {
    Relation.greatFriend => 'अधिमित्र',
    Relation.friend => 'मित्र',
    Relation.neutral => 'सम',
    Relation.enemy => 'शत्रु',
    Relation.greatEnemy => 'अधिशत्रु',
  };
  @override
  String relationShort(Relation r) => switch (r) {
    Relation.greatFriend => 'अमि',
    Relation.friend => 'मि',
    Relation.neutral => 'स',
    Relation.enemy => 'श',
    Relation.greatEnemy => 'अश',
  };
  @override
  String karaka(Karaka k) => switch (k) {
    Karaka.atma => 'आत्मकारक',
    Karaka.amatya => 'अमात्यकारक',
    Karaka.bhratri => 'भ्रातृकारक',
    Karaka.matri => 'मातृकारक',
    Karaka.pitri => 'पितृकारक',
    Karaka.putra => 'पुत्रकारक',
    Karaka.gnati => 'ज्ञातिकारक',
    Karaka.dara => 'दाराकारक',
  };
  @override
  String karakaShort(Karaka k) => switch (k) {
    Karaka.atma => 'आ',
    Karaka.amatya => 'अमा',
    Karaka.bhratri => 'भ्रा',
    Karaka.matri => 'मा',
    Karaka.pitri => 'पि',
    Karaka.putra => 'पु',
    Karaka.gnati => 'ज्ञा',
    Karaka.dara => 'दा',
  };
  @override
  String karakaScheme(KarakaScheme s) =>
      s == KarakaScheme.seven ? '7 कारक (सूर्य–शनि)' : '8 कारक (राहु सहित)';
  @override
  String ayanamsa(Ayanamsa a) => switch (a) {
    Ayanamsa.lahiri => 'एन.सी. लाहिड़ी',
    Ayanamsa.kpNew => 'केपी नवीन (कृष्णमूर्ति–सेंथिलथिबन)',
    Ayanamsa.kpOld => 'केपी पुराना (कृष्णमूर्ति)',
    Ayanamsa.raman => 'बी.वी. रमन',
    Ayanamsa.trueChitra => 'सत्य चित्रपक्ष',
    Ayanamsa.sayan => 'सायन (उष्णकटिबंधीय)',
    Ayanamsa.user => 'उपयोगकर्ता द्वारा निर्धारित',
  };
  @override
  String nodeType(NodeType n) => n == NodeType.meanNode
      ? 'मध्यम राहु (मीन नोड)'
      : 'स्पष्ट राहु (ट्रू नोड)';
  @override
  String sunriseMode(SunriseMode m) => m == SunriseMode.upperLimb
      ? 'सूर्य का ऊपरी किनारा, अपवर्तन सहित'
      : 'सूर्य बिंब का केंद्र, अपवर्तन रहित';
  @override
  String chartStyle(ChartStyle s) => switch (s) {
    ChartStyle.north => 'उत्तर भारतीय',
    ChartStyle.south => 'दक्षिण भारतीय',
    ChartStyle.east => 'पूर्व भारतीय',
  };
  @override
  String plateKind(PlateKind k) => switch (k) {
    PlateKind.lagna => 'लग्न',
    PlateKind.moon => 'चंद्र',
    PlateKind.navamsha => 'नवांश',
    PlateKind.chalit => 'चलित',
  };
  @override
  String timeBasis(TimeBasis b) => switch (b) {
    TimeBasis.zone => 'मानक समय (समय क्षेत्र नियम)',
    TimeBasis.lmt => 'स्थानीय माध्य समय (LMT)',
    TimeBasis.bombay => 'बॉम्बे समय (UTC+4:51)',
    TimeBasis.calcutta => 'कलकत्ता समय (UTC+5:53:20)',
    TimeBasis.manual => 'स्वयं दर्ज ऑफ़सेट',
  };

  static const _avakhada = {
    // varna
    'Brahmin': 'ब्राह्मण', 'Kshatriya': 'क्षत्रिय', 'Vaishya': 'वैश्य',
    'Shudra': 'शूद्र',
    // vashya
    'Chatushpada': 'चतुष्पद', 'Manava': 'मानव', 'Jalachara': 'जलचर',
    'Vanachara': 'वनचर', 'Keeta': 'कीट',
    // yoni
    'Horse': 'अश्व', 'Elephant': 'गज', 'Sheep': 'मेष', 'Serpent': 'सर्प',
    'Dog': 'श्वान', 'Cat': 'मार्जार', 'Rat': 'मूषक', 'Cow': 'गौ',
    'Buffalo': 'महिष', 'Tiger': 'व्याघ्र', 'Deer': 'मृग', 'Monkey': 'वानर',
    'Mongoose': 'नकुल', 'Lion': 'सिंह',
    // gana
    'Deva': 'देव', 'Manushya': 'मनुष्य', 'Rakshasa': 'राक्षस',
    // nadi
    'Adi': 'आदि', 'Madhya': 'मध्य', 'Antya': 'अन्त्य',
    // tatva
    'Fire': 'अग्नि', 'Earth': 'पृथ्वी', 'Air': 'वायु', 'Water': 'जल',
    // paya
    'Gold': 'स्वर्ण', 'Silver': 'रजत', 'Copper': 'ताम्र', 'Iron': 'लौह',
  };
  @override
  String avakhadaValue(String english) => _avakhada[english] ?? english;

  static const _syllables = [
    ['चू', 'चे', 'चो', 'ला'],
    ['ली', 'लू', 'ले', 'लो'],
    ['अ', 'ई', 'उ', 'ए'],
    ['ओ', 'वा', 'वी', 'वू'],
    ['वे', 'वो', 'का', 'की'],
    ['कु', 'घ', 'ङ', 'छ'],
    ['के', 'को', 'हा', 'ही'],
    ['हु', 'हे', 'हो', 'डा'],
    ['डी', 'डू', 'डे', 'डो'],
    ['मा', 'मी', 'मू', 'मे'],
    ['मो', 'टा', 'टी', 'टू'],
    ['टे', 'टो', 'पा', 'पी'],
    ['पू', 'ष', 'ण', 'ठ'],
    ['पे', 'पो', 'रा', 'री'],
    ['रू', 'रे', 'रो', 'ता'],
    ['ती', 'तू', 'ते', 'तो'],
    ['ना', 'नी', 'नू', 'ने'],
    ['नो', 'या', 'यी', 'यू'],
    ['ये', 'यो', 'भा', 'भी'],
    ['भू', 'धा', 'फा', 'ढा'],
    ['भे', 'भो', 'जा', 'जी'],
    ['खी', 'खू', 'खे', 'खो'],
    ['गा', 'गी', 'गू', 'गे'],
    ['गो', 'सा', 'सी', 'सू'],
    ['से', 'सो', 'दा', 'दी'],
    ['दू', 'थ', 'झ', 'ञ'],
    ['दे', 'दो', 'चा', 'ची'],
  ];
  @override
  String nameSyllable(Nakshatra n, int pada) => _syllables[n.index][pada - 1];

  static const _marital = {
    'Single': 'अविवाहित',
    'Married': 'विवाहित',
    'Divorced': 'तलाकशुदा',
    'Widowed': 'विधवा / विधुर',
    'Separated': 'अलग रह रहे',
  };
  @override
  String maritalStatus(String english) => _marital[english] ?? english;

  static const _occupation = {
    'Student': 'विद्यार्थी',
    'Private job': 'निजी नौकरी',
    'Government job': 'सरकारी नौकरी',
    'Business': 'व्यापार',
    'Self-employed': 'स्वरोज़गार',
    'Professional (doctor, lawyer, CA…)': 'पेशेवर (डॉक्टर, वकील, सीए…)',
    'Homemaker': 'गृहिणी',
    'Retired': 'सेवानिवृत्त',
    'Unemployed': 'बेरोज़गार',
    'Other': 'अन्य',
  };
  @override
  String occupation(String english) => _occupation[english] ?? english;

  @override
  String month(int m) => const [
    'जन॰',
    'फ़र॰',
    'मार्च',
    'अप्रैल',
    'मई',
    'जून',
    'जुला॰',
    'अग॰',
    'सित॰',
    'अक्टू॰',
    'नव॰',
    'दिस॰',
  ][m - 1];
}

/// Same syllables in Latin script, matching the Hindi table (Shravana
/// uses Khi/Khu/Khe/Kho, Ardra Ku/Gha/Nga/Chha).
const _syllablesEn = [
  ['Chu', 'Che', 'Cho', 'La'],
  ['Li', 'Lu', 'Le', 'Lo'],
  ['A', 'I', 'U', 'E'],
  ['O', 'Va', 'Vi', 'Vu'],
  ['Ve', 'Vo', 'Ka', 'Ki'],
  ['Ku', 'Gha', 'Nga', 'Chha'],
  ['Ke', 'Ko', 'Ha', 'Hi'],
  ['Hu', 'He', 'Ho', 'Da'],
  ['Di', 'Du', 'De', 'Do'],
  ['Ma', 'Mi', 'Mu', 'Me'],
  ['Mo', 'Ta', 'Ti', 'Tu'],
  ['Te', 'To', 'Pa', 'Pi'],
  ['Pu', 'Sha', 'Na', 'Tha'],
  ['Pe', 'Po', 'Ra', 'Ri'],
  ['Ru', 'Re', 'Ro', 'Ta'],
  ['Ti', 'Tu', 'Te', 'To'],
  ['Na', 'Ni', 'Nu', 'Ne'],
  ['No', 'Ya', 'Yi', 'Yu'],
  ['Ye', 'Yo', 'Bha', 'Bhi'],
  ['Bhu', 'Dha', 'Pha', 'Dha'],
  ['Bhe', 'Bho', 'Ja', 'Ji'],
  ['Khi', 'Khu', 'Khe', 'Kho'],
  ['Ga', 'Gi', 'Gu', 'Ge'],
  ['Go', 'Sa', 'Si', 'Su'],
  ['Se', 'So', 'Da', 'Di'],
  ['Du', 'Tha', 'Jha', 'Na'],
  ['De', 'Do', 'Cha', 'Chi'],
];
