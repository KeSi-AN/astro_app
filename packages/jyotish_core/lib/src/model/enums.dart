/// Grahas used in charts. Order is the traditional one (Sun..Ketu), then the
/// outer planets which are shown but not used in Parashari rules.
enum Graha {
  sun('Sun', 'Su'),
  moon('Moon', 'Mo'),
  mars('Mars', 'Ma'),
  mercury('Mercury', 'Me'),
  jupiter('Jupiter', 'Ju'),
  venus('Venus', 'Ve'),
  saturn('Saturn', 'Sa'),
  rahu('Rahu', 'Ra'),
  ketu('Ketu', 'Ke'),
  uranus('Uranus', 'Ur'),
  neptune('Neptune', 'Ne'),
  pluto('Pluto', 'Pl');

  const Graha(this.label, this.short);
  final String label;
  final String short;

  bool get isNode => this == rahu || this == ketu;
  bool get isOuter => this == uranus || this == neptune || this == pluto;
}

enum Rashi {
  aries('Aries', 'Ari', Graha.mars),
  taurus('Taurus', 'Tau', Graha.venus),
  gemini('Gemini', 'Gem', Graha.mercury),
  cancer('Cancer', 'Can', Graha.moon),
  leo('Leo', 'Leo', Graha.sun),
  virgo('Virgo', 'Vir', Graha.mercury),
  libra('Libra', 'Lib', Graha.venus),
  scorpio('Scorpio', 'Sco', Graha.mars),
  sagittarius('Sagittarius', 'Sag', Graha.jupiter),
  capricorn('Capricorn', 'Cap', Graha.saturn),
  aquarius('Aquarius', 'Aqu', Graha.saturn),
  pisces('Pisces', 'Pis', Graha.jupiter);

  const Rashi(this.label, this.short, this.lord);
  final String label;
  final String short;
  final Graha lord;

  /// 1-based sign number (Aries = 1).
  int get number => index + 1;

  static Rashi ofLongitude(double lon) => values[(norm360(lon) ~/ 30) % 12];
}

/// The 27 nakshatras with their Vimshottari lords.
enum Nakshatra {
  ashwini('Ashwini', Graha.ketu),
  bharani('Bharani', Graha.venus),
  krittika('Krittika', Graha.sun),
  rohini('Rohini', Graha.moon),
  mrigashira('Mrigashira', Graha.mars),
  ardra('Ardra', Graha.rahu),
  punarvasu('Punarvasu', Graha.jupiter),
  pushya('Pushya', Graha.saturn),
  ashlesha('Ashlesha', Graha.mercury),
  magha('Magha', Graha.ketu),
  purvaPhalguni('Purva Phalguni', Graha.venus),
  uttaraPhalguni('Uttara Phalguni', Graha.sun),
  hasta('Hasta', Graha.moon),
  chitra('Chitra', Graha.mars),
  swati('Swati', Graha.rahu),
  vishakha('Vishakha', Graha.jupiter),
  anuradha('Anuradha', Graha.saturn),
  jyeshtha('Jyeshtha', Graha.mercury),
  mula('Mula', Graha.ketu),
  purvaAshadha('Purva Ashadha', Graha.venus),
  uttaraAshadha('Uttara Ashadha', Graha.sun),
  shravana('Shravana', Graha.moon),
  dhanishta('Dhanishta', Graha.mars),
  shatabhisha('Shatabhisha', Graha.rahu),
  purvaBhadrapada('Purva Bhadrapada', Graha.jupiter),
  uttaraBhadrapada('Uttara Bhadrapada', Graha.saturn),
  revati('Revati', Graha.mercury);

  const Nakshatra(this.label, this.lord);
  final String label;
  final Graha lord;

  static const double span = 360 / 27; // 13°20′

  static Nakshatra ofLongitude(double lon) =>
      values[(norm360(lon) / span).floor() % 27];

  /// Pada 1..4.
  static int padaOf(double lon) =>
      ((norm360(lon) % span) / (span / 4)).floor() + 1;
}

double norm360(double x) {
  final r = x % 360;
  return r < 0 ? r + 360 : r;
}
