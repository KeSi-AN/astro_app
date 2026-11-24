import '../chart/rasi_chart.dart';
import '../model/enums.dart';

/// Jaimini chara karakas (BPHS ch. 32; Jaimini Upadesha Sutras 1.1).
enum Karaka {
  atma('Atmakaraka', 'AK'),
  amatya('Amatyakaraka', 'AmK'),
  bhratri('Bhratrikaraka', 'BK'),
  matri('Matrikaraka', 'MK'),
  pitri('Pitrikaraka', 'PiK'),
  putra('Putrakaraka', 'PK'),
  gnati('Gnatikaraka', 'GK'),
  dara('Darakaraka', 'DK');

  const Karaka(this.label, this.short);
  final String label;
  final String short;
}

enum KarakaScheme {
  seven('7 karakas (Sun–Saturn)'),
  eight('8 karakas (with Rahu)');

  const KarakaScheme(this.label);
  final String label;
}

/// Grahas ranked by degrees travelled in their sign, highest first.
/// Rahu (8-karaka scheme) is counted backwards: 30° − its degree.
/// Ties keep the natural order Sun..Saturn, Rahu (a disputed point).
List<(Karaka, Graha, double)> charaKarakas(RasiChart chart,
    [KarakaScheme scheme = KarakaScheme.seven]) {
  final grahas = [
    Graha.sun, Graha.moon, Graha.mars, Graha.mercury, Graha.jupiter,
    Graha.venus, Graha.saturn,
    if (scheme == KarakaScheme.eight) Graha.rahu,
  ];
  double degree(Graha g) {
    final d = chart.grahas[g]!.degreeInSign;
    return g == Graha.rahu ? 30 - d : d;
  }

  final ranked = [...grahas]
    ..sort((a, b) {
      final c = degree(b).compareTo(degree(a));
      return c != 0 ? c : grahas.indexOf(a).compareTo(grahas.indexOf(b));
    });
  final roles = scheme == KarakaScheme.eight
      ? Karaka.values
      : Karaka.values.where((k) => k != Karaka.pitri).toList();
  return [
    for (var i = 0; i < ranked.length; i++)
      (roles[i], ranked[i], degree(ranked[i])),
  ];
}
