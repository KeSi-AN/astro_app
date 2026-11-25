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
  String nakshatraDasha(NakshatraDashaKind k);
  String specialTime(SpecialTime k);
  String baana(Baana b);
  String anandadi(int i);
  String gowri(Gowri g);
  String bala(Bala b);
  String tara(Tara t);

  /// Drik's Tarabalam grades: veryGood, good, notGood, bad, totallyBad.
  String taraGrade(String g);
  String direction(Direction d);
  String agnivasa(Agnivasa a);
  String shivavasa(Shivavasa s);
  String bhadravasa(Bhadravasa b);
  String ritu(Ritu r);
  String samvatsara(int i);
  String tamilYoga(TamilYoga y);
  String kumbhaPart(KumbhaPart p);
  String jeevanama(int v);
  String netrama(int v);
  String eclipseKind(EclipseKind k);
  String eclipseType(EclipseType t);
  String mantriOffice(MantriOffice o);
  String festival(String id);

  /// BPHS condition under which [k] applies.
  String nakshatraDashaRule(NakshatraDashaKind k);

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
  String lunarMonth(int i);
  String chogadia(Chogadia c);
  String muhurta(int i);
  String kaal(Kaal k);
  String vrat(Vrat v);
  String koota(Koota k);
  String porutham(Porutham p);
  String rajju(Rajju r);
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
  String nakshatraDasha(NakshatraDashaKind k) => k.label;
  @override
  String specialTime(SpecialTime k) => const {
    SpecialTime.brahmaMuhurta: 'Brahma Muhurta',
    SpecialTime.pratahSandhya: 'Pratah Sandhya',
    SpecialTime.vijayaMuhurta: 'Vijaya Muhurta',
    SpecialTime.godhuli: 'Godhuli Muhurta',
    SpecialTime.sayahnaSandhya: 'Sayahna Sandhya',
    SpecialTime.nishita: 'Nishita Muhurta',
    SpecialTime.amritKalam: 'Amrit Kalam',
    SpecialTime.sarvarthaSiddhi: 'Sarvartha Siddhi Yoga',
    SpecialTime.amritaSiddhi: 'Amrita Siddhi Yoga',
    SpecialTime.raviYoga: 'Ravi Yoga',
    SpecialTime.raviPushya: 'Ravi Pushya Yoga',
    SpecialTime.guruPushya: 'Guru Pushya Yoga',
    SpecialTime.dwipushkar: 'Dwipushkar Yoga',
    SpecialTime.tripushkar: 'Tripushkar Yoga',
    SpecialTime.durMuhurtam: 'Dur Muhurtam',
    SpecialTime.varjyam: 'Varjyam',
    SpecialTime.gandaMoola: 'Ganda Moola',
    SpecialTime.aadal: 'Aadal Yoga',
    SpecialTime.vidaal: 'Vidaal Yoga',
  }[k]!;
  @override
  String baana(Baana b) => const ['Mrityu', 'Agni', 'Raja', 'Chora', 'Roga'][b.index];
  @override
  String anandadi(int i) => anandadiNames[i];
  @override
  String gowri(Gowri g) => const [
    'Uthi', 'Amirdha', 'Rogam', 'Laabam', 'Dhanam', 'Sugam', 'Soram', 'Visham',
  ][g.index];
  @override
  String bala(Bala b) => const ['Good', 'Puja needed', 'Bad'][b.index];
  @override
  String tara(Tara t) => const [
    'Janma', 'Sampat', 'Vipat', 'Kshema', 'Pratyari', 'Sadhaka', 'Naidhana',
    'Mitra', 'Paramitra',
  ][t.index];
  @override
  String taraGrade(String g) => const {
    'veryGood': 'Very good', 'good': 'Good', 'notGood': 'Not good',
    'bad': 'Bad', 'totallyBad': 'Totally bad',
  }[g]!;
  @override
  String direction(Direction d) => const [
    'East', 'South-East', 'South', 'South-West', 'West', 'North-West',
    'North', 'North-East',
  ][d.index];
  @override
  String agnivasa(Agnivasa a) => const ['Prithvi', 'Akasha', 'Patala'][a.index];
  @override
  String shivavasa(Shivavasa s) => const [
    'in Shmashana', 'on Kailash', 'with Gowri', 'on Nandi', 'in Sabha',
    'in Bhojana', 'in Krida',
  ][s.index];
  @override
  String bhadravasa(Bhadravasa b) => const ['Swarga', 'Patala', 'Mrityuloka'][b.index];
  @override
  String ritu(Ritu r) => const [
    'Vasanta', 'Grishma', 'Varsha', 'Sharad', 'Hemanta', 'Shishira',
  ][r.index];
  @override
  String samvatsara(int i) => samvatsaraNames[i];
  @override
  String tamilYoga(TamilYoga y) => const ['Siddha', 'Amrita', 'Marana'][y.index];
  @override
  String kumbhaPart(KumbhaPart p) => const [
    'Mouth', 'East', 'South', 'West', 'North', 'Womb', 'Bottom', 'Throat',
  ][p.index];
  @override
  String jeevanama(int v) => const ['Lifeless', 'Half life', 'Full life'][v];
  @override
  String netrama(int v) => const ['Blind', 'One eye', 'Two eyes'][v];
  @override
  String eclipseKind(EclipseKind k) => const ['Solar eclipse', 'Lunar eclipse'][k.index];
  @override
  String eclipseType(EclipseType t) => const [
    'Total', 'Annular', 'Hybrid', 'Partial', 'Penumbral',
  ][t.index];
  @override
  String mantriOffice(MantriOffice o) => const [
    'Raja (King)', 'Mantri (Minister)', 'Senadhipati (Commander)',
    'Sasyadhipati (Kharif crops)', 'Dhanyadhipati (Rabi crops)',
    'Dhanadhipati (Wealth)', 'Meghadhipati (Rain)', 'Rasadhipati (Liquids)',
    'Nirasadhipati (Metals)', 'Phaladhipati (Fruits)',
  ][o.index];
  @override
  String festival(String id) => const {'makarSankranti': 'Makar Sankranti', 'mauniAmavasya': 'Mauni Amavasya', 'vasantPanchami': 'Vasant Panchami', 'rathaSaptami': 'Ratha Saptami', 'mahaShivaratri': 'Maha Shivaratri', 'holikaDahan': 'Holika Dahan', 'holi': 'Holi', 'chaitraNavratri': 'Chaitra Navratri begins', 'ramNavami': 'Ram Navami', 'hanumanJayanti': 'Hanuman Jayanti', 'akshayaTritiya': 'Akshaya Tritiya', 'buddhaPurnima': 'Buddha Purnima', 'vatSavitri': 'Vat Savitri Vrat', 'gangaDussehra': 'Ganga Dussehra', 'nirjalaEkadashi': 'Nirjala Ekadashi', 'rathYatra': 'Jagannath Rath Yatra', 'devshayaniEkadashi': 'Devshayani Ekadashi', 'guruPurnima': 'Guru Purnima', 'hariyaliTeej': 'Hariyali Teej', 'nagPanchami': 'Nag Panchami', 'rakshaBandhan': 'Raksha Bandhan', 'kajariTeej': 'Kajari Teej', 'janmashtami': 'Krishna Janmashtami', 'hartalikaTeej': 'Hartalika Teej', 'ganeshChaturthi': 'Ganesh Chaturthi', 'rishiPanchami': 'Rishi Panchami', 'anantChaturdashi': 'Anant Chaturdashi', 'sarvaPitruAmavasya': 'Sarva Pitru Amavasya', 'sharadNavratri': 'Sharad Navratri begins', 'durgaAshtami': 'Durga Ashtami', 'mahaNavami': 'Maha Navami', 'dussehra': 'Dussehra', 'sharadPurnima': 'Sharad Purnima', 'karwaChauth': 'Karwa Chauth', 'ahoiAshtami': 'Ahoi Ashtami', 'dhanteras': 'Dhanteras', 'narakChaturdashi': 'Narak Chaturdashi', 'diwali': 'Diwali (Lakshmi Puja)', 'govardhanPuja': 'Govardhan Puja', 'bhaiDooj': 'Bhai Dooj', 'chhathPuja': 'Chhath Puja', 'devUthaniEkadashi': 'Dev Uthani Ekadashi', 'kartikPurnima': 'Kartik Purnima', 'vivahPanchami': 'Vivah Panchami', 'gitaJayanti': 'Gita Jayanti', 'dattaJayanti': 'Datta Jayanti'}[id] ?? id;
  @override
  String nakshatraDashaRule(NakshatraDashaKind k) => switch (k) {
    NakshatraDashaKind.ashtottari =>
      'Rahu in a kendra or trikona from the lagna lord, not in lagna',
    NakshatraDashaKind.shodashottari =>
      "Lagna in the Moon's hora in Krishna paksha or the Sun's in Shukla (texts differ)",
    NakshatraDashaKind.dwadashottari => 'Lagna in a navamsha of Venus',
    NakshatraDashaKind.panchottari => 'Cancer lagna in Cancer dwadashamsha',
    NakshatraDashaKind.shatabdika => 'Vargottama lagna',
    NakshatraDashaKind.chaturashitiSama => '10th lord in the 10th house',
    NakshatraDashaKind.dwisaptatiSama =>
      'Lagna lord in the 7th, or the 7th lord in lagna',
    NakshatraDashaKind.shashtihayani => 'Sun in lagna',
    NakshatraDashaKind.shatTrimshaSama =>
      "Day birth with lagna in the Sun's hora, or night birth in the Moon's",
  };
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
  String koota(Koota k) => const [
    'Varna',
    'Vashya',
    'Tara',
    'Yoni',
    'Graha Maitri',
    'Gana',
    'Bhakoot',
    'Nadi',
  ][k.index];
  @override
  String porutham(Porutham p) => const [
    'Dina',
    'Gana',
    'Mahendra',
    'Stree Deergha',
    'Yoni',
    'Rasi',
    'Rasi Adhipati',
    'Vasya',
    'Rajju',
    'Vedha',
  ][p.index];
  @override
  String rajju(Rajju r) =>
      const ['Pada', 'Kati', 'Nabhi', 'Kanta', 'Siro'][r.index];
  @override
  String lunarMonth(int i) => lunarMonths[i];
  @override
  String chogadia(Chogadia c) =>
      const ['Udveg', 'Char', 'Labh', 'Amrit', 'Kaal', 'Shubh', 'Rog'][c.index];
  @override
  String muhurta(int i) => muhurtaNames[i];
  @override
  String kaal(Kaal k) => const [
    'Rahu Kaal',
    'Yamaganda',
    'Gulika Kaal',
    'Abhijit Muhurta',
  ][k.index];
  @override
  String vrat(Vrat v) => const [
    'Ekadashi',
    'Purnima',
    'Amavasya',
    'Pradosh',
    'Sankashti Chaturthi',
    'Masik Shivaratri',
    'Sankranti',
  ][v.index];
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
  String koota(Koota k) => const [
    'वर्ण',
    'वश्य',
    'तारा',
    'योनि',
    'ग्रह मैत्री',
    'गण',
    'भकूट',
    'नाड़ी',
  ][k.index];
  @override
  String porutham(Porutham p) => const [
    'दिन',
    'गण',
    'माहेंद्र',
    'स्त्री दीर्घ',
    'योनि',
    'राशि',
    'राशि अधिपति',
    'वश्य',
    'रज्जु',
    'वेध',
  ][p.index];
  @override
  String rajju(Rajju r) => const ['पाद', 'कटि', 'नाभि', 'कंठ', 'शिर'][r.index];

  @override
  String lunarMonth(int i) => const [
    'चैत्र',
    'वैशाख',
    'ज्येष्ठ',
    'आषाढ़',
    'श्रावण',
    'भाद्रपद',
    'आश्विन',
    'कार्तिक',
    'मार्गशीर्ष',
    'पौष',
    'माघ',
    'फाल्गुन',
  ][i];
  @override
  String chogadia(Chogadia c) =>
      const ['उद्वेग', 'चर', 'लाभ', 'अमृत', 'काल', 'शुभ', 'रोग'][c.index];
  @override
  String muhurta(int i) => const [
    'रुद्र',
    'आहि',
    'मित्र',
    'पितृ',
    'वसु',
    'वाराह',
    'विश्वेदेवा',
    'विधि (अभिजित)',
    'सतमुखी',
    'पुरुहूत',
    'वाहिनी',
    'नक्तनकरा',
    'वरुण',
    'अर्यमा',
    'भग',
    'गिरीश',
    'अजपाद',
    'अहिर्बुध्न्य',
    'पूषा',
    'अश्विनी',
    'यम',
    'अग्नि',
    'विधाता',
    'चण्ड',
    'अदिति',
    'जीव',
    'विष्णु',
    'द्युमद्गद्युति',
    'ब्रह्मा',
    'समुद्र',
  ][i];
  @override
  String kaal(Kaal k) =>
      const ['राहु काल', 'यमगंड', 'गुलिक काल', 'अभिजित मुहूर्त'][k.index];
  @override
  String vrat(Vrat v) => const [
    'एकादशी',
    'पूर्णिमा',
    'अमावस्या',
    'प्रदोष',
    'संकष्टी चतुर्थी',
    'मासिक शिवरात्रि',
    'संक्रांति',
  ][v.index];

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
  String nakshatraDasha(NakshatraDashaKind k) => const {
    NakshatraDashaKind.ashtottari: 'अष्टोत्तरी',
    NakshatraDashaKind.shodashottari: 'षोडशोत्तरी',
    NakshatraDashaKind.dwadashottari: 'द्वादशोत्तरी',
    NakshatraDashaKind.panchottari: 'पंचोत्तरी',
    NakshatraDashaKind.shatabdika: 'शताब्दिका',
    NakshatraDashaKind.chaturashitiSama: 'चतुरशीति-सम',
    NakshatraDashaKind.dwisaptatiSama: 'द्विसप्तति-सम',
    NakshatraDashaKind.shashtihayani: 'षष्टिहायनी',
    NakshatraDashaKind.shatTrimshaSama: 'षट्त्रिंशत्-सम',
  }[k]!;
  @override
  String specialTime(SpecialTime k) => const {
    SpecialTime.brahmaMuhurta: 'ब्रह्म मुहूर्त',
    SpecialTime.pratahSandhya: 'प्रातः सन्ध्या',
    SpecialTime.vijayaMuhurta: 'विजय मुहूर्त',
    SpecialTime.godhuli: 'गोधूलि मुहूर्त',
    SpecialTime.sayahnaSandhya: 'सायाह्न सन्ध्या',
    SpecialTime.nishita: 'निशिता मुहूर्त',
    SpecialTime.amritKalam: 'अमृत काल',
    SpecialTime.sarvarthaSiddhi: 'सर्वार्थ सिद्धि योग',
    SpecialTime.amritaSiddhi: 'अमृत सिद्धि योग',
    SpecialTime.raviYoga: 'रवि योग',
    SpecialTime.raviPushya: 'रवि पुष्य योग',
    SpecialTime.guruPushya: 'गुरु पुष्य योग',
    SpecialTime.dwipushkar: 'द्विपुष्कर योग',
    SpecialTime.tripushkar: 'त्रिपुष्कर योग',
    SpecialTime.durMuhurtam: 'दुर्मुहूर्त',
    SpecialTime.varjyam: 'वर्ज्य',
    SpecialTime.gandaMoola: 'गण्ड मूल',
    SpecialTime.aadal: 'आडल योग',
    SpecialTime.vidaal: 'विडाल योग',
  }[k]!;
  @override
  String baana(Baana b) => const ['मृत्यु', 'अग्नि', 'राज', 'चोर', 'रोग'][b.index];
  @override
  String anandadi(int i) => const [
    'आनन्द', 'कालदण्ड', 'धूम्र', 'धाता', 'सौम्य', 'ध्वांक्ष', 'ध्वज', 'श्रीवत्स',
    'वज्र', 'मुद्गर', 'छत्र', 'मित्र', 'मानस', 'पद्म', 'लुम्बक', 'उत्पात',
    'मृत्यु', 'काण', 'सिद्धि', 'शुभ', 'अमृत', 'मुसल', 'गद', 'मातंग', 'राक्षस',
    'चर', 'स्थिर', 'वर्धमान',
  ][i];
  @override
  String gowri(Gowri g) => const [
    'उत्ति', 'अमृत', 'रोग', 'लाभ', 'धन', 'सुख', 'चोर', 'विष',
  ][g.index];
  @override
  String bala(Bala b) => const ['शुभ', 'पूजा आवश्यक', 'अशुभ'][b.index];
  @override
  String tara(Tara t) => const [
    'जन्म', 'सम्पत्', 'विपत्', 'क्षेम', 'प्रत्यरि', 'साधक', 'नैधन', 'मित्र',
    'परम मित्र',
  ][t.index];
  @override
  String taraGrade(String g) => const {
    'veryGood': 'अति शुभ', 'good': 'शुभ', 'notGood': 'अशुभ',
    'bad': 'बुरा', 'totallyBad': 'अत्यन्त अशुभ',
  }[g]!;
  @override
  String direction(Direction d) => const [
    'पूर्व', 'आग्नेय (दक्षिण-पूर्व)', 'दक्षिण', 'नैऋत्य (दक्षिण-पश्चिम)', 'पश्चिम',
    'वायव्य (उत्तर-पश्चिम)', 'उत्तर', 'ईशान (उत्तर-पूर्व)',
  ][d.index];
  @override
  String agnivasa(Agnivasa a) => const ['पृथ्वी', 'आकाश', 'पाताल'][a.index];
  @override
  String shivavasa(Shivavasa s) => const [
    'श्मशान में', 'कैलाश पर', 'गौरी के साथ', 'नन्दी पर', 'सभा में',
    'भोजन में', 'क्रीड़ा में',
  ][s.index];
  @override
  String bhadravasa(Bhadravasa b) => const ['स्वर्ग', 'पाताल', 'मृत्युलोक'][b.index];
  @override
  String ritu(Ritu r) => const [
    'वसन्त', 'ग्रीष्म', 'वर्षा', 'शरद', 'हेमन्त', 'शिशिर',
  ][r.index];
  @override
  String tamilYoga(TamilYoga y) => const ['सिद्ध', 'अमृत', 'मरण'][y.index];
  @override
  String kumbhaPart(KumbhaPart p) => const [
    'मुख', 'पूर्व', 'दक्षिण', 'पश्चिम', 'उत्तर', 'गर्भ', 'तल', 'कण्ठ',
  ][p.index];
  @override
  String jeevanama(int v) => const ['निर्जीव', 'अर्ध जीव', 'पूर्ण जीव'][v];
  @override
  String netrama(int v) => const ['अन्ध', 'एक नेत्र', 'दो नेत्र'][v];
  @override
  String eclipseKind(EclipseKind k) => const ['सूर्य ग्रहण', 'चन्द्र ग्रहण'][k.index];
  @override
  String eclipseType(EclipseType t) => const [
    'पूर्ण', 'वलयाकार', 'संकर', 'खण्ड', 'उपच्छाया',
  ][t.index];
  @override
  String mantriOffice(MantriOffice o) => const [
    'राजा', 'मंत्री', 'सेनाधिपति', 'सस्याधिपति (खरीफ)', 'धान्याधिपति (रबी)',
    'धनाधिपति', 'मेघाधिपति', 'रसाधिपति', 'नीरसाधिपति', 'फलाधिपति',
  ][o.index];
  @override
  String festival(String id) => const {'makarSankranti': 'मकर संक्रांति', 'mauniAmavasya': 'मौनी अमावस्या', 'vasantPanchami': 'वसंत पंचमी', 'rathaSaptami': 'रथ सप्तमी', 'mahaShivaratri': 'महाशिवरात्रि', 'holikaDahan': 'होलिका दहन', 'holi': 'होली', 'chaitraNavratri': 'चैत्र नवरात्रि आरम्भ', 'ramNavami': 'राम नवमी', 'hanumanJayanti': 'हनुमान जयंती', 'akshayaTritiya': 'अक्षय तृतीया', 'buddhaPurnima': 'बुद्ध पूर्णिमा', 'vatSavitri': 'वट सावित्री व्रत', 'gangaDussehra': 'गंगा दशहरा', 'nirjalaEkadashi': 'निर्जला एकादशी', 'rathYatra': 'जगन्नाथ रथ यात्रा', 'devshayaniEkadashi': 'देवशयनी एकादशी', 'guruPurnima': 'गुरु पूर्णिमा', 'hariyaliTeej': 'हरियाली तीज', 'nagPanchami': 'नाग पंचमी', 'rakshaBandhan': 'रक्षा बंधन', 'kajariTeej': 'कजरी तीज', 'janmashtami': 'कृष्ण जन्माष्टमी', 'hartalikaTeej': 'हरतालिका तीज', 'ganeshChaturthi': 'गणेश चतुर्थी', 'rishiPanchami': 'ऋषि पंचमी', 'anantChaturdashi': 'अनंत चतुर्दशी', 'sarvaPitruAmavasya': 'सर्व पितृ अमावस्या', 'sharadNavratri': 'शारदीय नवरात्रि आरम्भ', 'durgaAshtami': 'दुर्गा अष्टमी', 'mahaNavami': 'महा नवमी', 'dussehra': 'दशहरा', 'sharadPurnima': 'शरद पूर्णिमा', 'karwaChauth': 'करवा चौथ', 'ahoiAshtami': 'अहोई अष्टमी', 'dhanteras': 'धनतेरस', 'narakChaturdashi': 'नरक चतुर्दशी', 'diwali': 'दीपावली (लक्ष्मी पूजा)', 'govardhanPuja': 'गोवर्धन पूजा', 'bhaiDooj': 'भाई दूज', 'chhathPuja': 'छठ पूजा', 'devUthaniEkadashi': 'देवउठनी एकादशी', 'kartikPurnima': 'कार्तिक पूर्णिमा', 'vivahPanchami': 'विवाह पंचमी', 'gitaJayanti': 'गीता जयंती', 'dattaJayanti': 'दत्त जयंती'}[id] ?? id;
  @override
  String samvatsara(int i) => const [
    'प्रभव', 'विभव', 'शुक्ल', 'प्रमोद', 'प्रजापति', 'अंगिरा', 'श्रीमुख', 'भाव',
    'युवा', 'धाता', 'ईश्वर', 'बहुधान्य', 'प्रमाथी', 'विक्रम', 'वृष', 'चित्रभानु',
    'सुभानु', 'तारण', 'पार्थिव', 'व्यय', 'सर्वजित्', 'सर्वधारी', 'विरोधी',
    'विकृति', 'खर', 'नन्दन', 'विजय', 'जय', 'मन्मथ', 'दुर्मुख', 'हेमलम्ब',
    'विलम्ब', 'विकारी', 'शार्वरी', 'प्लव', 'शुभकृत्', 'शोभकृत्', 'क्रोधी',
    'विश्वावसु', 'पराभव', 'प्लवंग', 'कीलक', 'सौम्य', 'साधारण', 'विरोधकृत्',
    'परिधावी', 'प्रमादी', 'आनन्द', 'राक्षस', 'नल', 'पिंगल', 'कालयुक्त',
    'सिद्धार्थी', 'रौद्र', 'दुर्मति', 'दुन्दुभि', 'रुधिरोद्गारी', 'रक्ताक्षी',
    'क्रोधन', 'अक्षय',
  ][i];
  @override
  String nakshatraDashaRule(NakshatraDashaKind k) => switch (k) {
    NakshatraDashaKind.ashtottari =>
      'राहु लग्नेश से केंद्र या त्रिकोण में हो, पर लग्न में नहीं',
    NakshatraDashaKind.shodashottari =>
      'कृष्ण पक्ष में लग्न चंद्र होरा में या शुक्ल में सूर्य होरा में (ग्रंथों में मतभेद)',
    NakshatraDashaKind.dwadashottari => 'लग्न शुक्र के नवांश में',
    NakshatraDashaKind.panchottari => 'कर्क लग्न, कर्क द्वादशांश में',
    NakshatraDashaKind.shatabdika => 'वर्गोत्तम लग्न',
    NakshatraDashaKind.chaturashitiSama => 'दशमेश दशम भाव में',
    NakshatraDashaKind.dwisaptatiSama => 'लग्नेश सप्तम में या सप्तमेश लग्न में',
    NakshatraDashaKind.shashtihayani => 'सूर्य लग्न में',
    NakshatraDashaKind.shatTrimshaSama =>
      'दिन का जन्म और लग्न सूर्य होरा में, या रात का जन्म और लग्न चंद्र होरा में',
  };
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
