import 'package:equatable/equatable.dart';

/// A birth place from the atlas (or typed by hand).
class Place extends Equatable {
  const Place({
    required this.name,
    this.admin2 = '',
    this.admin1 = '',
    this.country = '',
    this.countryName = '',
    required this.latitude,
    required this.longitude,
    required this.zoneName,
    this.population = 0,
  });

  final String name;

  /// District.
  final String admin2;

  /// State / province.
  final String admin1;

  /// ISO-3166 alpha-2 code.
  final String country;
  final String countryName;
  final double latitude;
  final double longitude;
  final String zoneName;
  final int population;

  /// "Agra, Uttar Pradesh, India"
  String get displayName => [name, admin1, countryName]
      .where((s) => s.isNotEmpty)
      .toSet()
      .join(', ');

  /// "Agra district · Uttar Pradesh · India"
  String get detail {
    final parts = <String>[];
    if (admin2.isNotEmpty && admin2 != name) parts.add(admin2);
    if (admin1.isNotEmpty) parts.add(admin1);
    if (countryName.isNotEmpty) parts.add(countryName);
    return parts.join(' · ');
  }

  @override
  List<Object?> get props =>
      [name, admin2, admin1, country, latitude, longitude, zoneName];
}

/// 27.15 → "27°09′N"
String formatLatitude(double v) => _coord(v, 'N', 'S', 2);
String formatLongitude(double v) => _coord(v, 'E', 'W', 3);

String _coord(double v, String pos, String neg, int width) {
  final total = (v.abs() * 60).round();
  final d = (total ~/ 60).toString().padLeft(width, '0');
  final m = (total % 60).toString().padLeft(2, '0');
  return '$d°$m′${v < 0 ? neg : pos}';
}
