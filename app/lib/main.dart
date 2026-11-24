import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jyotish_core/jyotish_core.dart';
import 'package:path_provider/path_provider.dart';

/// Phase 0 shell: proves the engine runs on the phone by computing a fixed
/// test chart. Real chart entry arrives in Phase 1.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AstroApp());
}

Future<Ephemeris> _initEphemeris() async {
  final dir = await getApplicationSupportDirectory();
  return SwephEphemeris.init(
    epheDir: '${dir.path}/ephe',
    loadAsset: (f) async =>
        (await rootBundle.load('packages/sweph/assets/ephe/$f'))
            .buffer
            .asUint8List(),
  );
}

/// Same input as golden fixture 001 (TestChart, Agra).
const _testBirth = BirthData(
  year: 2026, month: 11, day: 23, hour: 23, minute: 21, second: 37,
  latitude: 27 + 9 / 60, longitude: 78, utcOffsetHours: 5.5,
  placeName: 'Agra',
);

class AstroApp extends StatelessWidget {
  const AstroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFB8860B), brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const EngineCheckScreen(),
    );
  }
}

class EngineCheckScreen extends StatelessWidget {
  const EngineCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Engine check · TestChart')),
      body: FutureBuilder<RasiChart>(
        future: _initEphemeris()
            .then((eph) => RasiChart.calculate(eph, _testBirth)),
        builder: (context, snap) {
          if (snap.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Engine failed: ${snap.error}'),
            );
          }
          final c = snap.data;
          if (c == null) return const Center(child: CircularProgressIndicator());
          return _PlanetTable(chart: c);
        },
      ),
    );
  }
}

class _PlanetTable extends StatelessWidget {
  const _PlanetTable({required this.chart});
  final RasiChart chart;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, Placement)>[
      ('Lagna', chart.lagna),
      for (final g in Graha.values) (g.label, chart.grahas[g]!),
    ];
    final mono = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(
          '23-11-2026 23:21:37 · Agra 27°09′N 78°00′E +5:30\n'
          'Ayanamsa (${chart.settings.ayanamsa.label}): ${Dms.of(chart.ayanamsa)}',
          style: mono,
        ),
        const SizedBox(height: 12),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2.2),
            1: FlexColumnWidth(1.2),
            2: FlexColumnWidth(2.4),
            3: FlexColumnWidth(3.2),
          },
          children: [
            TableRow(children: [
              for (final h in ['Planet', 'Sign', 'Degree', 'Nakshatra'])
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(h, style: mono.copyWith(fontWeight: FontWeight.bold)),
                ),
            ]),
            for (final (name, p) in rows)
              TableRow(children: [
                _cell('$name${name != 'Lagna' && p.isRetrograde ? ' (R)' : ''}', mono),
                _cell(p.rashi.short, mono),
                _cell(Dms.of(p.degreeInSign).degrees, mono),
                _cell('${p.nakshatra.label} ${p.pada}', mono),
              ]),
          ],
        ),
      ],
    );
  }

  Widget _cell(String t, TextStyle s) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(t, style: s),
      );
}
