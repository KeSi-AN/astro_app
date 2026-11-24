import 'package:astro_app/core/db/app_database.dart';
import 'package:astro_app/features/atlas/domain/place.dart';
import 'package:astro_app/features/charts/data/chart_repository.dart';
import 'package:astro_app/features/charts/domain/chart_entry.dart';
import 'package:birth_input/birth_input.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

const agra = Place(
  name: 'Agra', admin2: 'Agra', admin1: 'Uttar Pradesh', country: 'IN',
  countryName: 'India', latitude: 27.15, longitude: 78.0,
  zoneName: 'Asia/Kolkata',
);

ChartEntry entry(String name, {int year = 1990}) => ChartEntry(
      name: name, gender: 'male', year: year, month: 3, day: 12,
      hour: 10, minute: 45, second: 30, place: agra,
      timeBasis: TimeBasis.zone, utcOffsetHours: 5.5,
    );

void main() {
  late AppDatabase db;
  late ChartRepository repo;
  var now = DateTime(2026, 11, 24, 10);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = ChartRepository(db, clock: () => now = now.add(const Duration(minutes: 1)));
  });
  tearDown(() => db.close());

  test('save, read back and round-trip birth data', () async {
    final id = await repo.save(entry('Rahul Sharma'));
    final e = (await repo.get(id))!;
    expect(e.name, 'Rahul Sharma');
    expect([e.year, e.month, e.day, e.hour, e.minute, e.second],
        [1990, 3, 12, 10, 45, 30]);
    expect(e.place.name, 'Agra');
    expect(e.place.admin1, 'Uttar Pradesh');
    expect(e.place.displayName, 'Agra, Uttar Pradesh, India');
    expect(e.timeBasis, TimeBasis.zone);
    final b = e.toBirthData();
    expect(b.utHours, closeTo(10.75 + 30 / 3600 - 5.5, 1e-9));
  });

  test('list is newest-edited first and searchable', () async {
    final a = await repo.save(entry('Amit'));
    await repo.save(entry('Sunita'));
    var list = await repo.watchAll().first;
    expect(list.map((e) => e.name), ['Sunita', 'Amit']);

    final amit = (await repo.get(a))!;
    await repo.save(amit.copyWith(name: 'Amit Kumar'));
    list = await repo.watchAll().first;
    expect(list.first.name, 'Amit Kumar');

    expect((await repo.watchAll(search: 'sun').first).single.name, 'Sunita');
    expect((await repo.watchAll(search: 'agra').first).length, 2);
    expect(await repo.watchAll(search: '100%').first, isEmpty);
  });

  test('duplicate and delete', () async {
    final id = await repo.save(entry('Priya'));
    final copy = await repo.duplicate(id);
    expect((await repo.get(copy))!.name, 'Priya (copy)');
    await repo.delete(id);
    expect(await repo.get(id), isNull);
    expect(await repo.get(copy), isNotNull);
  });
}
