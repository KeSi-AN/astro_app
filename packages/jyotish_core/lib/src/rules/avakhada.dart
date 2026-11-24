import '../chart/rasi_chart.dart';
import '../model/enums.dart';
import 'vimshottari.dart';

/// Avakhada chakra: the birth-star attributes printed on Indian kundlis and
/// used in matching (Muhurta Chintamani, vivaha prakarana).
class Avakhada {
  const Avakhada({
    required this.varna,
    required this.vashya,
    required this.yoni,
    required this.gana,
    required this.nadi,
    required this.tatva,
    required this.payaByMoonHouse,
    required this.payaByNakshatra,
    required this.nameSyllable,
    required this.dashaLord,
    required this.dashaBalanceYears,
  });

  final String varna;
  final String vashya;
  final String yoni;
  final String gana;
  final String nadi;
  final String tatva;

  /// Paya from the Moon's house counted from the lagna (1/6/11 gold,
  /// 2/5/9 silver, 3/7/10 copper, 4/8/12 iron).
  final String payaByMoonHouse;

  /// Paya from the Moon's nakshatra (what AstroSage prints). Checked against
  /// AstroSage for Bharani (Gold), Ashlesha (Silver), Shravana (Copper); the
  /// group boundaries follow the common table and need more confirmation.
  final String payaByNakshatra;

  /// Traditional first syllable for a name from the Moon's nakshatra pada.
  final String nameSyllable;

  /// Vimshottari lord running at birth and the years left in it.
  final Graha dashaLord;
  final double dashaBalanceYears;

  static Avakhada of(RasiChart chart) {
    final moon = chart.grahas[Graha.moon]!;
    final sign = moon.rashi;
    final nak = moon.nakshatra;
    final deg = moon.degreeInSign;
    final house = moon.house;
    return Avakhada(
      varna: _varna[sign.index % 4],
      vashya: _vashya(sign, deg),
      yoni: _yoni[nak.index],
      gana: _gana[nak.index],
      nadi: _nadi[nak.index],
      tatva: const ['Fire', 'Earth', 'Air', 'Water'][sign.index % 4],
      payaByMoonHouse: switch (house) {
        1 || 6 || 11 => 'Gold',
        2 || 5 || 9 => 'Silver',
        3 || 7 || 10 => 'Copper',
        _ => 'Iron',
      },
      payaByNakshatra: _payaFor(nak),
      nameSyllable: _syllables[nak.index][moon.pada - 1],
      dashaLord: nak.lord,
      dashaBalanceYears:
          nakshatraRemaining(moon.longitude) * vimshottariYears[nak.lord]!,
    );
  }
}

// Fire, earth, air, water signs → Kshatriya, Vaishya, Shudra, Brahmin.
const _varna = ['Kshatriya', 'Vaishya', 'Shudra', 'Brahmin'];

String _vashya(Rashi s, double deg) => switch (s) {
      Rashi.aries || Rashi.taurus => 'Chatushpada',
      Rashi.gemini || Rashi.virgo || Rashi.libra || Rashi.aquarius => 'Manava',
      Rashi.cancer || Rashi.pisces => 'Jalachara',
      Rashi.leo => 'Vanachara',
      Rashi.scorpio => 'Keeta',
      // Sagittarius: first half human, second half quadruped.
      Rashi.sagittarius => deg < 15 ? 'Manava' : 'Chatushpada',
      // Capricorn: first half quadruped, second half water.
      Rashi.capricorn => deg < 15 ? 'Chatushpada' : 'Jalachara',
    };

const _yoni = [
  'Horse', 'Elephant', 'Sheep', 'Serpent', 'Serpent', 'Dog', 'Cat', 'Sheep',
  'Cat', 'Rat', 'Rat', 'Cow', 'Buffalo', 'Tiger', 'Buffalo', 'Tiger', 'Deer',
  'Deer', 'Dog', 'Monkey', 'Mongoose', 'Monkey', 'Lion', 'Horse', 'Lion',
  'Cow', 'Elephant',
];

const _d = 'Deva', _m = 'Manushya', _r = 'Rakshasa';
const _gana = [
  _d, _m, _r, _m, _d, _m, _d, _d, _r, _r, _m, _m, _d, _r, _d, _r, _d, _r,
  _r, _m, _m, _d, _r, _r, _m, _m, _d,
];

const _a = 'Adi', _md = 'Madhya', _an = 'Antya';
const _nadi = [
  _a, _md, _an, _an, _md, _a, _a, _md, _an, _an, _md, _a, _a, _md, _an, _an,
  _md, _a, _a, _md, _an, _an, _md, _a, _a, _md, _an,
];

const _syllables = [
  ['Chu', 'Che', 'Cho', 'La'], // Ashwini
  ['Li', 'Lu', 'Le', 'Lo'], // Bharani
  ['A', 'I', 'U', 'E'], // Krittika
  ['O', 'Va', 'Vi', 'Vu'], // Rohini
  ['Ve', 'Vo', 'Ka', 'Ki'], // Mrigashira
  ['Ku', 'Gha', 'Nga', 'Chha'], // Ardra
  ['Ke', 'Ko', 'Ha', 'Hi'], // Punarvasu
  ['Hu', 'He', 'Ho', 'Da'], // Pushya
  ['Di', 'Du', 'De', 'Do'], // Ashlesha
  ['Ma', 'Mi', 'Mu', 'Me'], // Magha
  ['Mo', 'Ta', 'Ti', 'Tu'], // Purva Phalguni
  ['Te', 'To', 'Pa', 'Pi'], // Uttara Phalguni
  ['Pu', 'Sha', 'Na', 'Tha'], // Hasta
  ['Pe', 'Po', 'Ra', 'Ri'], // Chitra
  ['Ru', 'Re', 'Ro', 'Ta'], // Swati
  ['Ti', 'Tu', 'Te', 'To'], // Vishakha
  ['Na', 'Ni', 'Nu', 'Ne'], // Anuradha
  ['No', 'Ya', 'Yi', 'Yu'], // Jyeshtha
  ['Ye', 'Yo', 'Bha', 'Bhi'], // Mula
  ['Bhu', 'Dha', 'Pha', 'Dha'], // Purva Ashadha
  ['Bhe', 'Bho', 'Ja', 'Ji'], // Uttara Ashadha
  ['Khi', 'Khu', 'Khe', 'Kho'], // Shravana
  ['Ga', 'Gi', 'Gu', 'Ge'], // Dhanishta
  ['Go', 'Sa', 'Si', 'Su'], // Shatabhisha
  ['Se', 'So', 'Da', 'Di'], // Purva Bhadrapada
  ['Du', 'Tha', 'Jha', 'Na'], // Uttara Bhadrapada
  ['De', 'Do', 'Cha', 'Chi'], // Revati
];

/// Nakshatra paya groups: Revati–Mrigashira gold, Ardra–Anuradha silver,
/// Jyeshtha–Uttara Bhadrapada copper.
String _payaFor(Nakshatra n) {
  if (n == Nakshatra.revati || n.index <= Nakshatra.mrigashira.index) return 'Gold';
  if (n.index <= Nakshatra.anuradha.index) return 'Silver';
  return 'Copper';
}
