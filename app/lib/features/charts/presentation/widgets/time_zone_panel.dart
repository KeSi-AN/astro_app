import 'package:birth_input/birth_input.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/format/formatters.dart';
import '../../../atlas/domain/place.dart';

/// Shows how the birth time converts to UT and lets the astrologer override
/// it (LMT, Bombay/Calcutta time, manual offset, war time).
class TimeZonePanel extends StatelessWidget {
  const TimeZonePanel({
    super.key,
    required this.place,
    required this.resolution,
    required this.error,
    required this.basis,
    required this.manualOffset,
    required this.manualDst,
    required this.onBasis,
    required this.onWarTime,
  });

  final Place place;
  final TimeResolution? resolution;
  final String? error;
  final TimeBasis? basis;
  final TextEditingController manualOffset;
  final TextEditingController manualDst;
  final ValueChanged<TimeBasis?> onBasis;
  final ValueChanged<bool> onWarTime;

  @override
  Widget build(BuildContext context) {
    final r = resolution;
    final theme = Theme.of(context);
    final small = theme.textTheme.bodySmall;
    final current = basis ?? r?.basis ?? TimeBasis.zone;
    final options = {
      TimeBasis.zone,
      TimeBasis.lmt,
      ...?r?.alternatives,
      TimeBasis.manual,
      current,
    }.toList();
    final lmt = place.longitude / 15 - (r?.totalOffsetHours ?? 0);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.public, size: 18),
              const SizedBox(width: 8),
              Text('Time zone', style: theme.textTheme.titleSmall),
              const Spacer(),
              if (r != null)
                Text(formatOffset(r.totalOffsetHours),
                    style: theme.textTheme.titleSmall
                        ?.copyWith(color: theme.colorScheme.primary)),
            ]),
            const SizedBox(height: 8),
            DropdownButtonFormField<TimeBasis>(
              key: ValueKey(current),
              initialValue: current,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Birth time is in'),
              items: [
                for (final b in options)
                  DropdownMenuItem(value: b, child: Text(b.label)),
              ],
              onChanged: onBasis,
            ),
            if (current == TimeBasis.manual) ...[
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: manualOffset,
                    decoration: const InputDecoration(
                        labelText: 'UTC offset', hintText: '5:30'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: manualDst,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    decoration: const InputDecoration(
                        labelText: 'DST / war time (h)', hintText: '0 or 1'),
                  ),
                ),
              ]),
            ],
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(error!, style: TextStyle(color: theme.colorScheme.error)),
            ],
            if (r != null) ...[
              const SizedBox(height: 8),
              Text(
                [
                  if (r.basis == TimeBasis.zone)
                    '${r.zoneName}${r.abbreviation.isEmpty ? '' : ' (${r.abbreviation})'}',
                  'Standard ${formatOffset(r.standardOffsetHours)}',
                  if (r.dstHours != 0)
                    '${r.isWarTime ? 'War time' : 'DST'} +${r.dstHours}h',
                  'LMT correction ${formatSignedHms(lmt)}',
                ].join(' · '),
                style: small,
              ),
              if (r.isWarTime)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Recorded time includes war time (+1h)'),
                  value: r.dstHours != 0,
                  onChanged: onWarTime,
                ),
              for (final n in r.notes)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(
                      n.level == NoteLevel.warning
                          ? Icons.warning_amber_rounded
                          : Icons.info_outline,
                      size: 16,
                      color: n.level == NoteLevel.warning
                          ? Colors.amber
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Expanded(child: Text(n.text, style: small)),
                  ]),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
