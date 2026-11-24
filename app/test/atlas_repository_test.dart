import 'package:astro_app/features/atlas/data/atlas_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AtlasRepository atlas;
  setUpAll(() => atlas = AtlasRepository.open('assets/atlas/atlas.sqlite'));
  tearDownAll(() => atlas.close());

  test('Agra comes first with correct data', () {
    final r = atlas.search('agra');
    expect(r.first.name, 'Agra');
    expect(r.first.admin1, 'Uttar Pradesh');
    expect(r.first.countryName, 'India');
    expect(r.first.zoneName, 'Asia/Kolkata');
    expect(r.first.latitude, closeTo(27.18, 0.05));
    expect(r.first.longitude, closeTo(78.02, 0.05));
  });

  test('search is case-insensitive and finds villages', () {
    final r = atlas.search('BHAGALPUR');
    expect(r.length, greaterThan(3)); // the city plus same-named villages
    expect(r.first.admin1, 'Bihar');
  });

  test('state filter after a comma', () {
    final r = atlas.search('Bhagalpur, Uttar Pradesh');
    expect(r, isNotEmpty);
    expect(r.every((p) => p.admin1 == 'Uttar Pradesh'), isTrue);
  });

  test('world cities', () {
    final r = atlas.search('new york');
    expect(r.first.country, 'US');
    expect(r.first.zoneName, 'America/New_York');
  });

  test('short or wildcard queries return nothing harmful', () {
    expect(atlas.search('a'), isEmpty);
    expect(atlas.search('%%'), isEmpty);
    expect(atlas.search('_a'), isEmpty);
  });
}
