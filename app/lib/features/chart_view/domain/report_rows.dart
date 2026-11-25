import 'package:jyotish_core/jyotish_core.dart';

import '../../../core/format/formatters.dart';
import '../../../l10n/l10n.dart';
import '../../atlas/domain/place.dart';
import '../../charts/domain/chart_entry.dart';
import '../../settings/settings.dart';

/// Table rows shared by the chart screens and the PDF kundli, so both
/// always show the same figures.

typedef KeyValues = List<(String, String)>;

/// Birth details, panchang at birth and the Avakhada chakra.
List<(String, KeyValues)> detailsSections(
  AppLocalizations l10n,
  AstroTerms t,
  ChartEntry e,
  ChartAnalysis a,
  AppSettings settings,
) {
  final c = a.chart, p = a.panchang, av = a.avakhada;
  final b = c.birth;
  final offset = b.utcOffsetHours + b.dstHours;
  String clock(double? jd) =>
      jd == null ? '—' : Dms.of(((jd + 0.5 + offset / 24) % 1) * 24).clock;
  String hours(double h) => Dms.of(((h % 24) + 24) % 24).clock;
  final moon = c.grahas[Graha.moon]!;
  final sun = c.grahas[Graha.sun]!;
  final tropicalSun = Rashi.ofLongitude(sun.longitude + c.ayanamsa);
  final isht = p.ishtkaalGhatis;
  String ghati(double g) {
    final total = (g * 3600).round(); // vipal
    return '${total ~/ 3600}-${(total % 3600 ~/ 60).toString().padLeft(2, '0')}'
        '-${(total % 60).toString().padLeft(2, '0')}';
  }

  String withLord(String name, Graha lord) =>
      l10n.withLord(name, t.graha(lord));
  final (y, mo, d) = yearsToYmd(av.dashaBalanceYears);

  return [
    (
      l10n.birthDetails,
      [
        (l10n.name, e.name),
        if (e.gender != null)
          (l10n.gender, e.gender == 'male' ? l10n.male : l10n.female),
        (l10n.date, formatDate(e.year, e.month, e.day, month: t.month)),
        (l10n.time, formatTime(e.hour, e.minute, e.second)),
        (l10n.place, e.place.displayName),
        (
          l10n.latLon,
          '${formatLatitude(e.place.latitude)}  '
              '${formatLongitude(e.place.longitude)}',
        ),
        (
          l10n.timeZone,
          '${formatOffset(e.utcOffsetHours)} (${t.timeBasis(e.timeBasis)})',
        ),
        if (e.dstHours != 0)
          (
            e.warTimeApplied == true ? l10n.warTime : l10n.dst,
            l10n.hoursValue('${e.dstHours}'),
          ),
        (l10n.lmtCorrection, formatSignedHms(b.lmtCorrectionHours - b.dstHours)),
        (l10n.lmtAtBirth, hours(b.utHours + b.longitude / 15)),
        (l10n.utAtBirth, hours(b.utHours)),
        (l10n.julianDay, c.jdUt.toStringAsFixed(5)),
        (
          l10n.ayanamsa,
          '${t.ayanamsa(settings.ayanamsa)}  ${Dms.of(c.ayanamsa)}',
        ),
        (l10n.obliquity, Dms.of(c.obliquity).degrees),
        (l10n.siderealTime, Dms.of(c.siderealTimeLocal).clock),
        if (e.maritalStatus != null)
          (l10n.maritalStatus, t.maritalStatus(e.maritalStatus!)),
        if (e.occupation != null)
          (l10n.occupation, t.occupation(e.occupation!)),
      ],
    ),
    (
      l10n.panchangAtBirth,
      [
        (l10n.hinduWeekday, withLord(t.weekday(p.weekday), p.varaLord)),
        (l10n.tithi, '${t.tithi(p.tithi)} (${t.paksha(p.tithi)})'),
        (l10n.nakshatra, '${t.nakshatra(moon.nakshatra)} ${moon.pada}'),
        (l10n.yoga, t.yoga(p.yoga)),
        (l10n.karana, t.karana(p.karana)),
        (l10n.sunrise, clock(p.sunriseJd)),
        (l10n.sunset, clock(p.sunsetJd)),
        if (p.dayLengthHours != null)
          (l10n.dayLength, hours(p.dayLengthHours!)),
        if (isht != null) (l10n.ishtkaal, ghati(isht)),
        (l10n.sunriseRule, t.sunriseMode(p.sunriseMode)),
      ],
    ),
    (
      l10n.avakhada,
      [
        (l10n.lagna, withLord(t.rashi(c.lagna.rashi), c.lagna.rashi.lord)),
        (l10n.rashi, withLord(t.rashi(moon.rashi), moon.rashi.lord)),
        (
          l10n.nakshatraPadaLabel,
          withLord(
            '${t.nakshatra(moon.nakshatra)}-${moon.pada}',
            moon.nakshatraLord,
          ),
        ),
        (l10n.varna, t.avakhadaValue(av.varna)),
        (l10n.vashya, t.avakhadaValue(av.vashya)),
        (l10n.yoni, t.avakhadaValue(av.yoni)),
        (l10n.gana, t.avakhadaValue(av.gana)),
        (l10n.nadi, t.avakhadaValue(av.nadi)),
        (l10n.tatva, t.avakhadaValue(av.tatva)),
        (l10n.payaNakshatra, t.avakhadaValue(av.payaByNakshatra)),
        (l10n.payaMoon, t.avakhadaValue(av.payaByMoonHouse)),
        (l10n.nameSyllable, t.nameSyllable(moon.nakshatra, moon.pada)),
        (
          l10n.dashaBalance,
          '${t.graha(av.dashaLord)}  ${l10n.ymd('$y', '$mo', '$d')}',
        ),
        (l10n.sunSignIndian, t.rashi(sun.rashi)),
        (l10n.sunSignWestern, t.rashi(tropicalSun)),
      ],
    ),
  ];
}

/// Header and rows of the planets table (lagna first).
(List<String>, List<List<String>>) planetTable(
  AppLocalizations l10n,
  AstroTerms t,
  ChartAnalysis a,
) {
  final lagna = a.chart.lagna;
  String flags(GrahaInfo i) => [
    if (i.placement.isRetrograde) l10n.flagRetro,
    if (i.combust) l10n.flagCombust,
    if (i.vargottama) l10n.flagVargottama,
  ].join(' ');
  String nak(Placement p) => '${t.nakshatra(p.nakshatra)} ${p.pada}';
  return (
    [
      l10n.colPlanet,
      '',
      l10n.sign,
      l10n.colDegree,
      l10n.colNakshatra,
      l10n.colStar,
      l10n.colSub,
      l10n.dignity,
      'D9',
    ],
    [
      [
        t.lagna,
        '',
        t.rashiShort(lagna.rashi),
        Dms.of(lagna.degreeInSign).degrees,
        nak(lagna),
        t.grahaShort(lagna.nakshatraLord),
        t.grahaShort(a.lagnaSubLords[1]),
        '',
        t.rashiShort(a.lagnaNavamsha),
      ],
      for (final g in Graha.values)
        () {
          final i = a.grahas[g]!;
          final p = i.placement;
          return [
            t.graha(g),
            flags(i),
            t.rashiShort(p.rashi),
            Dms.of(p.degreeInSign).degrees,
            nak(p),
            t.grahaShort(p.nakshatraLord),
            t.grahaShort(i.subLord),
            i.dignity == null ? '' : t.dignity(i.dignity!),
            t.rashiShort(i.navamshaSign),
          ];
        }(),
    ],
  );
}

/// One-line explanation of why a yoga or dosha was (not) found.
String yogaDetail(AppLocalizations l10n, AstroTerms t, YogaResult y) {
  final parts = <String>[];
  for (final (k, v) in y.detail) {
    switch (k) {
      case 'lagna' || 'moon' || 'venus':
        final ref = switch (k) {
          'lagna' => l10n.refLagna,
          'moon' => l10n.refMoon,
          _ => l10n.refVenus,
        };
        parts.add(l10n.mangalFrom(ref, v));
      case 'marsStrong':
        parts.add(l10n.cancelMarsStrong);
      case 'withJupiter':
        parts.add(l10n.cancelWithJupiter);
      case 'withMoon':
        parts.add(l10n.cancelWithMoon);
      case 'signException':
        parts.add(l10n.cancelSignException(v));
      case 'type':
        if (y.found) parts.add(l10n.kaalSarpType(v));
    }
  }
  if (y.planets.isNotEmpty && y.found && y.id != 'mangal') {
    parts.add(y.planets.map(t.graha).join(', '));
  }
  return parts.join(' · ');
}

/// Shadbala rows (one column per graha in [sevenGrahas]); the last five
/// rows are the totals, ratio and rank.
List<List<String>> shadbalaRows(AppLocalizations l10n, Shadbala sb) {
  final g = sevenGrahas;
  final s = sb.grahas;
  String f(double v) => v.toStringAsFixed(1);
  List<String> row(String label, double Function(GrahaShadbala) pick) => [
    label,
    for (final p in g) f(pick(s[p]!)),
  ];
  final ranks = sb.ranks;
  return [
    row(l10n.uchchaBala, (x) => x.uchcha),
    row(l10n.saptavargajaBala, (x) => x.saptavargaja),
    row(l10n.ojayugmaBala, (x) => x.ojayugma),
    row(l10n.kendradiBala, (x) => x.kendradi),
    row(l10n.drekkanaBala, (x) => x.drekkana),
    row('= ${l10n.sthanaBala}', (x) => x.sthana),
    row(l10n.digBala, (x) => x.dig),
    row(l10n.nathonnathaBala, (x) => x.nathonnatha),
    row(l10n.pakshaBala, (x) => x.paksha),
    row(l10n.tribhagaBala, (x) => x.tribhaga),
    row(l10n.abdaBala, (x) => x.abda),
    row(l10n.masaBala, (x) => x.masa),
    row(l10n.varaBala, (x) => x.vara),
    row(l10n.horaBala, (x) => x.hora),
    row(l10n.ayanaBala, (x) => x.ayana),
    row(l10n.yuddhaBala, (x) => x.yuddha),
    row('= ${l10n.kalaBala}', (x) => x.kala),
    row(l10n.cheshtaBala, (x) => x.cheshta),
    row(l10n.naisargikaBala, (x) => x.naisargika),
    row(l10n.drikBala, (x) => x.drik),
    row(l10n.totalVirupas, (x) => x.total),
    [l10n.totalRupas, for (final p in g) s[p]!.rupas.toStringAsFixed(2)],
    [l10n.requiredRupas, for (final p in g) s[p]!.requiredRupas.toString()],
    [l10n.strengthRatio, for (final p in g) s[p]!.ratio.toStringAsFixed(2)],
    [l10n.strengthRank, for (final p in g) '${ranks[p]}'],
  ];
}
