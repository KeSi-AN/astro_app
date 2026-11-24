import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/format/formatters.dart';
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
    final e = entry, a = analysis, c = a.chart, p = a.panchang, av = a.avakhada;
    final b = c.birth;
    final offset = b.utcOffsetHours + b.dstHours;
    String clock(double? jd) =>
        jd == null ? '—' : Dms.of(((jd + 0.5 + offset / 24) % 1) * 24).clock;
    String hours(double h) => Dms.of(((h % 24) + 24) % 24).clock;
    final moon = c.grahas[Graha.moon]!;
    final sun = c.grahas[Graha.sun]!;
    final tropicalSun = Rashi.ofLongitude(
      sun.longitude + c.ayanamsa,
    ); // Western sun sign
    final isht = p.ishtkaalGhatis;
    String ghati(double g) {
      final total = (g * 3600).round(); // vipal
      return '${total ~/ 3600}-${(total % 3600 ~/ 60).toString().padLeft(2, '0')}'
          '-${(total % 60).toString().padLeft(2, '0')}';
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        KeyValueCard(
          title: 'Birth details',
          rows: [
            ('Name', e.name),
            if (e.gender != null)
              ('Gender', e.gender == 'male' ? 'Male' : 'Female'),
            ('Date', formatDate(e.year, e.month, e.day)),
            ('Time', formatTime(e.hour, e.minute, e.second)),
            ('Place', e.place.displayName),
            (
              'Latitude / longitude',
              '${formatLatitude(e.place.latitude)}  ${formatLongitude(e.place.longitude)}',
            ),
            (
              'Time zone',
              '${formatOffset(e.utcOffsetHours)} (${e.timeBasis.name})',
            ),
            if (e.dstHours != 0)
              (
                e.warTimeApplied == true ? 'War time' : 'DST',
                '+${e.dstHours} h',
              ),
            (
              'LMT correction',
              formatSignedHms(b.lmtCorrectionHours - b.dstHours),
            ),
            ('LMT at birth', hours(b.utHours + b.longitude / 15)),
            ('UT (GMT) at birth', hours(b.utHours)),
            ('Julian day (UT)', c.jdUt.toStringAsFixed(5)),
            ('Ayanamsa', '${settings.ayanamsa.label}  ${Dms.of(c.ayanamsa)}'),
            ('Obliquity', Dms.of(c.obliquity).degrees),
            ('Sidereal time', Dms.of(c.siderealTimeLocal).clock),
            if (e.maritalStatus != null) ('Marital status', e.maritalStatus!),
            if (e.occupation != null) ('Occupation', e.occupation!),
          ],
        ),
        KeyValueCard(
          title: 'Panchang at birth',
          rows: [
            ('Hindu weekday', '${p.weekdayName} (lord ${p.varaLord.label})'),
            ('Tithi', '${p.tithiName} (${p.paksha})'),
            ('Nakshatra', '${moon.nakshatra.label} ${moon.pada}'),
            ('Yoga', p.yogaName),
            ('Karana', p.karanaName),
            ('Sunrise', clock(p.sunriseJd)),
            ('Sunset', clock(p.sunsetJd)),
            if (p.dayLengthHours != null)
              ('Day length', hours(p.dayLengthHours!)),
            if (isht != null) ('Ishtkaal (ghati)', ghati(isht)),
            ('Sunrise rule', p.sunriseMode.label),
          ],
        ),
        KeyValueCard(
          title: 'Avakhada chakra',
          rows: [
            (
              'Lagna',
              '${c.lagna.rashi.label} (lord ${c.lagna.rashi.lord.label})',
            ),
            ('Rashi', '${moon.rashi.label} (lord ${moon.rashi.lord.label})'),
            (
              'Nakshatra-pada',
              '${moon.nakshatra.label}-${moon.pada} (lord ${moon.nakshatraLord.label})',
            ),
            ('Varna', av.varna),
            ('Vashya', av.vashya),
            ('Yoni', av.yoni),
            ('Gana', av.gana),
            ('Nadi', av.nadi),
            ('Tatva', av.tatva),
            ('Paya (nakshatra)', av.payaByNakshatra),
            ('Paya (Moon house)', av.payaByMoonHouse),
            ('Name syllable', av.nameSyllable),
            (
              'Dasha balance',
              '${av.dashaLord.label}  ${formatYmd(av.dashaBalanceYears)}',
            ),
            ('Sun sign (Indian)', sun.rashi.label),
            ('Sun sign (Western)', tropicalSun.label),
          ],
        ),
      ],
    );
  }
}
