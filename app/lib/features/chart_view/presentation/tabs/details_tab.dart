import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/format/formatters.dart';
import '../../../../l10n/l10n.dart';
import '../../../atlas/domain/place.dart';
import '../../../charts/domain/chart_entry.dart';
import '../../../settings/settings.dart';
import 'table_widgets.dart';

/// Birth details, panchang at birth and the Avakhada chakra.
class DetailsTab extends StatelessWidget {
  const DetailsTab({
    super.key,
    required this.entry,
    required this.analysis,
    required this.settings,
  });

  final ChartEntry entry;
  final ChartAnalysis analysis;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = context.terms;
    final e = entry, a = analysis, c = a.chart, p = a.panchang, av = a.avakhada;
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

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        KeyValueCard(
          title: l10n.birthDetails,
          rows: [
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
            (
              l10n.lmtCorrection,
              formatSignedHms(b.lmtCorrectionHours - b.dstHours),
            ),
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
        KeyValueCard(
          title: l10n.panchangAtBirth,
          rows: [
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
        KeyValueCard(
          title: l10n.avakhada,
          rows: [
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
      ],
    );
  }
}
