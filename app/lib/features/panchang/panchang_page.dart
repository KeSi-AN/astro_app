import 'dart:math';

import 'package:birth_input/birth_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jyotish_core/jyotish_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/services.dart';
import '../../app/theme.dart';
import '../../core/format/formatters.dart';
import '../../l10n/l10n.dart';
import '../atlas/domain/place.dart';
import '../atlas/presentation/place_search_page.dart';
import '../chart_view/presentation/tabs/table_widgets.dart';
import '../settings/settings.dart';

enum _Sec {
  day,
  hora,
  chogadia,
  gowri,
  muhurta,
  lagna,
  panchakaRahita,
  bala,
  panchakBhadra,
  vrat,
}

/// Daily panchang and muhurta tools for any date and place.
class PanchangPage extends StatefulWidget {
  const PanchangPage({super.key});

  @override
  State<PanchangPage> createState() => _PanchangPageState();
}

class _PanchangPageState extends State<PanchangPage> {
  late DateTime _date = _today();
  _Sec _sec = _Sec.day;
  DayPanchang? _day;
  Object? _key;
  List<VratDay>? _vrats;
  int? _vratYear;
  Vrat? _vratFilter;

  static DateTime _today() {
    final n = DateTime.now();
    return DateTime.utc(n.year, n.month, n.day);
  }

  PanchangPlace _placeFor(Place p) {
    final r = TimeResolver.resolve(
      zoneName: p.zoneName,
      longitude: p.longitude,
      admin1: p.admin1,
      year: _date.year,
      month: _date.month,
      day: _date.day,
      hour: 12,
      minute: 0,
    );
    return PanchangPlace(
      latitude: p.latitude,
      longitude: p.longitude,
      utcOffsetHours: r.totalOffsetHours,
      name: p.name,
    );
  }

  Future<void> _choosePlace() async {
    final p = await Navigator.of(
      context,
    ).push<Place>(MaterialPageRoute(builder: (_) => const PlaceSearchPage()));
    if (p != null && mounted) {
      await context.read<SettingsCubit>().update(
        (s) => s.copyWith(panchangPlace: p.encode()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SettingsCubit, AppSettings>(
      builder: (context, settings) {
        final place = Place.decode(settings.panchangPlace);
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.panchang),
            actions: [
              IconButton(
                tooltip: l10n.changePlace,
                icon: const Icon(Icons.place_outlined),
                onPressed: _choosePlace,
              ),
            ],
          ),
          body: place == null
              ? Center(
                  child: FilledButton.icon(
                    onPressed: _choosePlace,
                    icon: const Icon(Icons.place_outlined),
                    label: Text(l10n.choosePanchangPlace),
                  ),
                )
              : _body(context, settings, place),
        );
      },
    );
  }

  Widget _body(BuildContext context, AppSettings settings, Place place) {
    final l10n = context.l10n;
    final t = context.terms;
    final eph = context.read<AppServices>().ephemeris;
    final calc = PanchangCalc(eph, settings.calc);
    final pp = _placeFor(place);
    final key = (_date, place, settings.calc, settings.sunriseMode);
    if (_key != key) {
      _key = key;
      _day = DayPanchang.of(calc, pp, _date, sunriseMode: settings.sunriseMode);
    }
    final d = _day!;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => setState(
                () => _date = _date.subtract(const Duration(days: 1)),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final p = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(1800),
                    lastDate: DateTime(2399, 12, 31),
                  );
                  if (p != null) {
                    setState(
                      () => _date = DateTime.utc(p.year, p.month, p.day),
                    );
                  }
                },
                child: Column(
                  children: [
                    Text(
                      '${t.weekday(d.weekday)}, '
                      '${formatDate(_date.year, _date.month, _date.day, month: t.month)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${place.displayName} · ${formatOffset(pp.utcOffsetHours)}',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () =>
                  setState(() => _date = _date.add(const Duration(days: 1))),
            ),
          ],
        ),
        if (_date != _today())
          Center(
            child: TextButton(
              onPressed: () => setState(() => _date = _today()),
              child: Text(l10n.today),
            ),
          ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final (s, label) in [
              (_Sec.day, l10n.secToday),
              (_Sec.hora, l10n.secHora),
              (_Sec.chogadia, l10n.secChogadia),
              (_Sec.gowri, l10n.secGowri),
              (_Sec.muhurta, l10n.secMuhurta),
              (_Sec.lagna, l10n.secLagnaTable),
              (_Sec.panchakaRahita, l10n.secPanchakaRahita),
              (_Sec.bala, l10n.secBala),
              (_Sec.panchakBhadra, l10n.secPanchakBhadra),
              (_Sec.vrat, l10n.secVrat),
            ])
              ChoiceChip(
                label: Text(label),
                selected: _sec == s,
                onSelected: (_) => setState(() => _sec = s),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...switch (_sec) {
          _Sec.day => _dayView(context, d, eph, calc),
          _Sec.hora => _horaView(context, d),
          _Sec.chogadia => _chogadiaView(context, d),
          _Sec.gowri => _gowriView(context, d),
          _Sec.muhurta => _muhurtaView(context, d),
          _Sec.lagna => _lagnaView(context, d, eph, calc),
          _Sec.panchakaRahita => _panchakaRahitaView(context, d, eph, calc),
          _Sec.bala => _balaView(context, d, calc),
          _Sec.panchakBhadra => _panchakView(context, d, calc),
          _Sec.vrat => _vratView(context, calc, pp, settings),
        },
      ],
    );
  }

  String _time(DayPanchang d, double jd) {
    final h = d.localHours(jd);
    final s = Dms.of(h).clock.substring(0, 5);
    // Mark times that fall on the next civil day.
    final dayOfJd = (jd + 0.5 + d.place.utcOffsetHours / 24).floor();
    final dayOfSunrise = (d.sunrise + 0.5 + d.place.utcOffsetHours / 24)
        .floor();
    return dayOfJd > dayOfSunrise ? '$s⁺' : s;
  }

  List<Widget> _dayView(
    BuildContext context,
    DayPanchang d,
    Ephemeris eph,
    PanchangCalc calc,
  ) {
    final l10n = context.l10n;
    final t = context.terms;
    String spans<T>(List<ElementSpan> list, String Function(int) name) => [
      for (final (i, x) in list.indexed)
        i == list.length - 1 && x.end > d.nextSunrise
            ? name(x.index)
            : '${name(x.index)} ${l10n.untilTime(_time(d, x.end))}',
    ].join(', ');
    // "A until 10:05, B" for values that change during the day.
    String timed<T>(List<TimeSpan<T>> list, String Function(T) name) => [
      for (final (i, x) in list.indexed)
        i == list.length - 1 || x.end >= d.nextSunrise
            ? name(x.value)
            : '${name(x.value)} ${l10n.untilTime(_time(d, x.end))}',
    ].join(', ');
    final m = d.month;
    String month(int i) =>
        '${m.adhika ? '${l10n.adhikaPrefix} ' : ''}${t.lunarMonth(i)}';
    final rows = <(String, String)>[
      (l10n.tithi, spans(d.tithis, (i) => '${t.tithi(i)} (${t.paksha(i)})')),
      (
        l10n.nakshatra,
        spans(d.nakshatras, (i) => t.nakshatra(Nakshatra.values[i - 1])),
      ),
      (l10n.yoga, spans(d.yogas, t.yoga)),
      (l10n.karana, spans(d.karanas, t.karana)),
      (l10n.hinduWeekday, t.weekday(d.weekday)),
      (l10n.monthAmanta, month(m.amanta)),
      (l10n.monthPurnimanta, month(m.purnimanta)),
      (
        l10n.shakaSamvatLabel,
        '${d.shaka} ${t.samvatsara(shakaSamvatsara(d.shaka))}',
      ),
      (
        l10n.vikramSamvatLabel,
        '${d.vikram} ${t.samvatsara(vikramSamvatsara(d.vikram))}',
      ),
      (
        l10n.gujaratiSamvatLabel,
        '${gujaratiYear(d)} ${t.samvatsara(gujaratiSamvatsara(gujaratiYear(d)))}',
      ),
      (l10n.pravishteLabel, '${pravishte(calc, d)}'),
      (l10n.sunrise, _time(d, d.sunrise)),
      (l10n.sunset, _time(d, d.sunset)),
      (
        l10n.moonrise,
        d.moonrise == null ? l10n.noRiseSet : _time(d, d.moonrise!),
      ),
      (l10n.moonset, d.moonset == null ? l10n.noRiseSet : _time(d, d.moonset!)),
      (l10n.sunSign, t.rashi(d.sunSign)),
      (l10n.moonSign, timed(moonSignSpans(calc, d.sunrise, d.nextSunrise), t.rashi)),
      (
        l10n.suryaNakshatraLabel,
        timed(
          sunPadas(calc, d.sunrise, d.nextSunrise),
          (p) => '${t.nakshatra(Nakshatra.values[p ~/ 4])} ${p % 4 + 1}',
        ),
      ),
    ];
    final widgets = <Widget>[KeyValueCard(title: l10n.panchang, rows: rows)];

    // "Right now" when looking at today and the current time is within it.
    final now =
        DateTime.now().toUtc().millisecondsSinceEpoch / 86400000 + 2440587.5;
    if (now >= d.sunrise && now < d.nextSunrise) {
      final hora = horas(d).firstWhere((h) => h.contains(now));
      final cho = chogadias(d).firstWhere((c) => c.contains(now));
      final mu = muhurtas(d).firstWhere((x) => x.contains(now));
      final asc = Rashi.ofLongitude(
        eph
            .houses(
              now,
              d.place.latitude,
              d.place.longitude,
              HouseSystem.wholeSign,
              calc.settings,
            )
            .ascendant,
      );
      final nature = switch (asc.index % 3) {
        0 => l10n.movable,
        1 => l10n.fixed,
        _ => l10n.dual,
      };
      widgets.add(
        KeyValueCard(
          title: l10n.rightNow,
          rows: [
            (
              l10n.currentHora,
              '${t.graha(hora.value)} ${l10n.untilTime(_time(d, hora.end))}',
            ),
            (
              l10n.currentChogadia,
              '${t.chogadia(cho.value)} (${isGoodChogadia(cho.value) ? l10n.good : l10n.bad}) '
                  '${l10n.untilTime(_time(d, cho.end))}',
            ),
            (l10n.currentLagna, l10n.lagnaNature(t.rashi(asc), nature)),
            (
              l10n.currentMuhurta,
              '${t.muhurta(mu.value)} (${goodMuhurtas.contains(mu.value) ? l10n.good : l10n.bad}) '
                  '${l10n.untilTime(_time(d, mu.end))}',
            ),
          ],
        ),
      );
    }

    widgets.addAll(_dayExtras(context, d, calc, timed));
    return widgets;
  }

  /// Drik-style extra cards: ritu, auspicious and inauspicious times,
  /// Anandadi yoga, nivas & shool, other calendars.
  List<Widget> _dayExtras(
    BuildContext context,
    DayPanchang d,
    PanchangCalc calc,
    String Function<T>(List<TimeSpan<T>>, String Function(T)) timed,
  ) {
    final l10n = context.l10n;
    final t = context.terms;
    final eph = calc.eph;
    String range(double s, double e) {
      final all = s <= d.sunrise + 1e-4 && e >= d.nextSunrise - 1e-4;
      return all ? l10n.ahoratri : '${_time(d, s)} – ${_time(d, e)}';
    }

    String hms(double days) {
      final secs = (days * 86400).round();
      return '${secs ~/ 3600}:${(secs % 3600 ~/ 60).toString().padLeft(2, '0')}:'
          '${(secs % 60).toString().padLeft(2, '0')}';
    }

    final trop = calc.sun(d.sunrise) + eph.ayanamsa(d.sunrise, calc.settings);
    String ayana(bool u) => u ? l10n.uttarayana : l10n.dakshinayana;
    final special = specialTimes(calc, d);
    final good = special.where((x) => x.value.good).toList();
    final bad = special.where((x) => !x.value.good).toList();
    final kaals = dayKaals(d);
    final bh = bhadra(calc, d.sunrise, d.nextSunrise);
    final baana = baanas(calc, d);
    final nivas = Nivas.of(calc, d);
    final w = sundayIndex(d);
    final jd0 = civilJd(eph, d.date);
    final (jy, jm, jdd) = julianCalendarDate(jd0);
    final (ny, nm, nd) = nationalCivilDate(d.date);
    final anand = anandadiYogas(calc, d);

    return [
      KeyValueCard(
        title: l10n.rituTitle,
        rows: [
          (l10n.drikRituLabel, t.ritu(drikRitu(trop))),
          (l10n.vedicRituLabel, t.ritu(vedicRitu(d.sunSign))),
          (l10n.drikAyanaLabel, ayana(isUttarayana(trop))),
          (l10n.vedicAyanaLabel, ayana(isUttarayana(calc.sun(d.sunrise)))),
          (l10n.madhyahnaLabel, _time(d, (d.sunrise + d.sunset) / 2)),
          (l10n.dinamanaLabel, hms(d.dayLength)),
          (l10n.ratrimanaLabel, hms(d.nightLength)),
        ],
      ),
      KeyValueCard(
        title: l10n.auspiciousTimings,
        rows: [
          if (kaals[Kaal.abhijit] != null)
            (
              t.kaal(Kaal.abhijit),
              range(kaals[Kaal.abhijit]!.start, kaals[Kaal.abhijit]!.end),
            ),
          for (final x in good) (t.specialTime(x.value), range(x.start, x.end)),
        ],
      ),
      KeyValueCard(
        title: l10n.inauspiciousTimings,
        rows: [
          for (final k in [Kaal.rahu, Kaal.yamaganda, Kaal.gulika])
            (t.kaal(k), range(kaals[k]!.start, kaals[k]!.end)),
          for (final x in bad) (t.specialTime(x.value), range(x.start, x.end)),
          for (final x in bh)
            (l10n.bhadraLabel, range(max(x.start, d.sunrise), min(x.end, d.nextSunrise))),
          for (final x in baana)
            (
              l10n.baanaLabel,
              x.start <= d.sunrise + 1e-4
                  ? '${t.baana(x.value)} ${l10n.untilTime(_time(d, x.end))}'
                  : '${t.baana(x.value)} ${l10n.fromTime(_time(d, x.start))}',
            ),
        ],
      ),
      KeyValueCard(
        title: l10n.anandadiTitle,
        rows: [
          for (final x in anand)
            (
              goodAnandadi.contains(x.value) ? '✓' : '✗',
              x.end >= d.nextSunrise - 1e-4
                  ? t.anandadi(x.value)
                  : '${t.anandadi(x.value)} ${l10n.untilTime(_time(d, x.end))}',
            ),
        ],
      ),
      KeyValueCard(
        title: l10n.nivasTitle,
        rows: [
          (l10n.homahutiLabel, timed(nivas.homahutis, t.graha)),
          (l10n.dishaShoolLabel, t.direction(dishaShool[w])),
          (l10n.rahuVasaLabel, t.direction(rahuVasa[w])),
          (l10n.agnivasaLabel, timed(nivas.agnivasas, t.agnivasa)),
          for (final b in nivas.bhadravasas)
            (l10n.bhadravasaLabel, '${t.bhadravasa(b.value)} · ${range(b.start, b.end)}'),
          (l10n.chandraVasaLabel, timed(nivas.chandraVasas, t.direction)),
          (l10n.shivavasaLabel, timed(nivas.shivavasas, t.shivavasa)),
        ],
      ),
      KeyValueCard(
        title: l10n.otherCalendars,
        rows: [
          (l10n.kaliyugaLabel, l10n.yearsValue('${d.shaka + 3179}')),
          (l10n.kaliAharganaLabel, l10n.daysValue('${kaliAhargana(jd0)}')),
          (l10n.lahiriNote, eph.ayanamsa(d.sunrise, calc.settings).toStringAsFixed(6)),
          (l10n.rataDieLabel, '${rataDie(jd0)}'),
          (l10n.julianDay, jd0.toStringAsFixed(1)),
          (l10n.mjdLabel, '${(jd0 - 2400000.5).round()}'),
          (l10n.julianDateLabel, formatDate(jy, jm, jdd, month: t.month)),
          (
            l10n.nationalCivilDateLabel,
            '${t.lunarMonth(nm - 1)} ${nd.toString().padLeft(2, '0')}, $ny',
          ),
        ],
      ),
    ];
  }

  List<Widget> _gowriView(BuildContext context, DayPanchang d) {
    final l10n = context.l10n;
    final t = context.terms;
    final g = gowriPanchangam(d);
    return [
      GridTable(
        header: ['', l10n.colTime, l10n.secGowri],
        rows: [
          for (final (i, x) in g.indexed)
            [
              i < 8 ? l10n.dayHalf : l10n.nightHalf,
              '${_time(d, x.start)} – ${_time(d, x.end)}',
              t.gowri(x.value),
            ],
        ],
        highlight: (r, c) => c == 2
            ? (isGoodGowri(g[r].value) ? const Color(0xFF81C784) : const Color(0xFFE57373))
            : null,
      ),
    ];
  }

  List<Widget> _panchakaRahitaView(
    BuildContext context,
    DayPanchang d,
    Ephemeris eph,
    PanchangCalc calc,
  ) {
    final l10n = context.l10n;
    final t = context.terms;
    final p = panchakaRahita(d, lagnaTable(d, eph, calc));
    return [
      GridTable(
        header: [l10n.colTime, ''],
        rows: [
          for (final x in p)
            [
              '${_time(d, x.start)} – ${_time(d, x.end)}',
              x.value == null ? l10n.shubhaMuhurta : l10n.panchakaName(t.baana(x.value!)),
            ],
        ],
        highlight: (r, c) => c == 1
            ? (p[r].value == null ? const Color(0xFF81C784) : const Color(0xFFE57373))
            : null,
      ),
      const SizedBox(height: 6),
      Text(l10n.panchakaRahitaNote, style: Theme.of(context).textTheme.bodySmall),
    ];
  }

  List<Widget> _balaView(BuildContext context, DayPanchang d, PanchangCalc calc) {
    final l10n = context.l10n;
    final t = context.terms;
    final signs = moonSignSpans(calc, d.sunrise, d.nextSunrise);
    Color? balaColor(Bala b) => switch (b) {
      Bala.good => const Color(0xFF81C784),
      Bala.bad => const Color(0xFFE57373),
      Bala.pujaNeeded => Theme.of(context).colorScheme.primary,
    };
    final naks = d.nakshatras;
    String taraText(Tara x) => '${t.tara(x)} (${t.taraGrade(taraGrade[x]!)})';
    return [
      Text(l10n.chandrabalamTitle, style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 6),
      GridTable(
        header: [
          l10n.rashi,
          for (final s in signs)
            '${t.rashiShort(s.value)}${s.end < d.nextSunrise ? ' ${l10n.untilTime(_time(d, s.end))}' : ''}',
        ],
        rows: [
          for (final r in Rashi.values)
            [t.rashi(r), for (final s in signs) t.bala(chandrabalam(r, s.value))],
        ],
        highlight: (row, c) =>
            c == 0 ? null : balaColor(chandrabalam(Rashi.values[row], signs[c - 1].value)),
      ),
      const SizedBox(height: 16),
      Text(l10n.tarabalamTitle, style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 6),
      GridTable(
        header: [
          l10n.colNakshatra,
          for (final n in naks)
            '${t.nakshatra(Nakshatra.values[n.index - 1])}${n.end < d.nextSunrise ? ' ${l10n.untilTime(_time(d, n.end))}' : ''}',
        ],
        rows: [
          for (final b in Nakshatra.values)
            [
              t.nakshatra(b),
              for (final n in naks) taraText(tarabalam(b.index, n.index - 1)),
            ],
        ],
        highlight: (row, c) {
          if (c == 0) return null;
          final g = taraGrade[tarabalam(row, naks[c - 1].index - 1)]!;
          return g.contains('ood') && g != 'notGood'
              ? const Color(0xFF81C784)
              : const Color(0xFFE57373);
        },
      ),
    ];
  }

  List<Widget> _horaView(BuildContext context, DayPanchang d) {
    final l10n = context.l10n;
    final t = context.terms;
    final h = horas(d);
    final now =
        DateTime.now().toUtc().millisecondsSinceEpoch / 86400000 + 2440587.5;
    return [
      GridTable(
        header: ['', l10n.colTime, l10n.colLord],
        rows: [
          for (final (i, x) in h.indexed)
            [
              i < 12 ? l10n.dayPart : l10n.nightPart,
              '${_time(d, x.start)} – ${_time(d, x.end)}',
              t.graha(x.value),
            ],
        ],
        highlight: (r, c) =>
            h[r].contains(now) ? Theme.of(context).colorScheme.primary : null,
      ),
    ];
  }

  List<Widget> _chogadiaView(BuildContext context, DayPanchang d) {
    final l10n = context.l10n;
    final t = context.terms;
    final ch = chogadias(d);
    final now =
        DateTime.now().toUtc().millisecondsSinceEpoch / 86400000 + 2440587.5;
    return [
      GridTable(
        header: ['', l10n.colTime, l10n.secChogadia, ''],
        rows: [
          for (final (i, x) in ch.indexed)
            [
              i < 8 ? l10n.dayPart : l10n.nightPart,
              '${_time(d, x.start)} – ${_time(d, x.end)}',
              t.chogadia(x.value),
              isGoodChogadia(x.value) ? l10n.good : l10n.bad,
            ],
        ],
        highlight: (r, c) {
          if (ch[r].contains(now)) return Theme.of(context).colorScheme.primary;
          if (c == 3) {
            return isGoodChogadia(ch[r].value)
                ? const Color(0xFF81C784)
                : const Color(0xFFE57373);
          }
          return null;
        },
      ),
    ];
  }

  List<Widget> _muhurtaView(BuildContext context, DayPanchang d) {
    final l10n = context.l10n;
    final t = context.terms;
    final mu = muhurtas(d);
    final now =
        DateTime.now().toUtc().millisecondsSinceEpoch / 86400000 + 2440587.5;
    return [
      GridTable(
        header: ['#', l10n.colTime, l10n.secMuhurta, ''],
        rows: [
          for (final x in mu)
            [
              '${x.value + 1}',
              '${_time(d, x.start)} – ${_time(d, x.end)}',
              t.muhurta(x.value),
              goodMuhurtas.contains(x.value) ? l10n.good : l10n.bad,
            ],
        ],
        highlight: (r, c) {
          if (mu[r].contains(now)) return Theme.of(context).colorScheme.primary;
          if (c == 3) {
            return goodMuhurtas.contains(mu[r].value)
                ? const Color(0xFF81C784)
                : const Color(0xFFE57373);
          }
          return null;
        },
      ),
    ];
  }

  List<Widget> _lagnaView(
    BuildContext context,
    DayPanchang d,
    Ephemeris eph,
    PanchangCalc calc,
  ) {
    final l10n = context.l10n;
    final t = context.terms;
    final lt = lagnaTable(d, eph, calc);
    String nature(Rashi r) => switch (r.index % 3) {
      0 => l10n.movable,
      1 => l10n.fixed,
      _ => l10n.dual,
    };
    return [
      GridTable(
        header: [l10n.lagna, l10n.colFrom, l10n.colTo, ''],
        rows: [
          for (final x in lt)
            [
              t.rashi(x.value),
              _time(d, x.start),
              _time(d, x.end),
              nature(x.value),
            ],
        ],
      ),
    ];
  }

  List<Widget> _panchakView(
    BuildContext context,
    DayPanchang d,
    PanchangCalc calc,
  ) {
    final l10n = context.l10n;
    final eph = calc.eph;
    final from =
        eph.julianDayUt(_date.year, _date.month, 1, 0) -
        d.place.utcOffsetHours / 24;
    final next = DateTime.utc(_date.year, _date.month + 1);
    final to =
        eph.julianDayUt(next.year, next.month, 1, 0) -
        d.place.utcOffsetHours / 24;
    String dt(double jd) {
      final ms =
          ((jd - 2440587.5) * 86400000 + d.place.utcOffsetHours * 3600000)
              .round();
      final x = DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
      return '${x.day.toString().padLeft(2, '0')}/${x.month.toString().padLeft(2, '0')} '
          '${x.hour.toString().padLeft(2, '0')}:${x.minute.toString().padLeft(2, '0')}';
    }

    Widget table(String title, List<TimeSpan<void>> list) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 6),
        if (list.isEmpty)
          Text(l10n.nonePeriod)
        else
          GridTable(
            header: [l10n.colFrom, l10n.colTo],
            rows: [
              for (final x in list) [dt(x.start), dt(x.end)],
            ],
          ),
        const SizedBox(height: 16),
      ],
    );
    return [
      table(l10n.panchakTitle, panchak(calc, from, to)),
      table(l10n.bhadraTitle, bhadra(calc, from, to)),
    ];
  }

  List<Widget> _vratView(
    BuildContext context,
    PanchangCalc calc,
    PanchangPlace pp,
    AppSettings settings,
  ) {
    final l10n = context.l10n;
    final t = context.terms;
    if (_vratYear != _date.year || _vrats == null) {
      _vratYear = _date.year;
      _vrats = vratDays(
        calc,
        pp,
        _date.year,
        sunriseMode: settings.sunriseMode,
      );
    }
    final list = _vrats!.where(
      (v) => _vratFilter == null || v.vrat == _vratFilter,
    );
    final style = tabular(Theme.of(context).textTheme.bodyMedium!);
    return [
      Text(
        l10n.vratTitle('${_date.year}'),
        style: Theme.of(context).textTheme.titleSmall,
      ),
      const SizedBox(height: 6),
      Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          ChoiceChip(
            label: Text(l10n.allVrats),
            selected: _vratFilter == null,
            onSelected: (_) => setState(() => _vratFilter = null),
          ),
          for (final v in Vrat.values)
            ChoiceChip(
              label: Text(t.vrat(v)),
              selected: _vratFilter == v,
              onSelected: (_) => setState(() => _vratFilter = v),
            ),
        ],
      ),
      const SizedBox(height: 8),
      for (final v in list)
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: Text(
            formatDate(v.date.year, v.date.month, v.date.day, month: t.month),
            style: style,
          ),
          title: Text(
            v.vrat == Vrat.sankranti
                ? '${t.vrat(v.vrat)} – ${t.rashi(v.sign!)}'
                : '${t.vrat(v.vrat)} (${t.paksha(v.tithi)})',
          ),
          trailing: Text(t.weekday(v.date.weekday), style: style),
        ),
      const SizedBox(height: 8),
      Text(l10n.vratNote, style: Theme.of(context).textTheme.bodySmall),
    ];
  }
}
