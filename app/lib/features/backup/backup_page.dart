import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/app.dart';
import '../../app/services.dart';
import '../../l10n/l10n.dart';
import '../appointments/presentation/appointment_format.dart';
import 'backup_service.dart';

/// Make a backup and send it to Google Drive / WhatsApp / email through
/// the share sheet, or restore one picked from the phone or Drive.
class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  bool _busy = false;
  DateTime? _last;

  BackupService get _service => context.read<AppServices>().backup;

  @override
  void initState() {
    super.initState();
    _service.lastBackupAt().then((d) {
      if (mounted) setState(() => _last = d);
    });
  }

  void _snack(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _backup() async {
    final l10n = context.l10n;
    setState(() => _busy = true);
    try {
      final path = await _service.create();
      final last = await _service.lastBackupAt();
      if (!mounted) return;
      setState(() => _last = last);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(path, mimeType: 'application/zip')],
          text: l10n.backupShareText,
        ),
      );
    } catch (e) {
      if (mounted) _snack(l10n.backupFailed('$e'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final l10n = context.l10n;
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['zip'],
    );
    if (picked.isEmpty || !mounted) return;
    final Uint8List bytes = await picked.single.xFile.readAsBytes();
    BackupInfo info;
    try {
      info = await _service.inspect(bytes);
    } on Object {
      if (mounted) _snack(l10n.notABackup);
      return;
    }
    if (!mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.restoreTitle),
        content: Text(
          l10n.restoreBody(
            '${formatDay(context, info.createdAt)} ${formatClock(info.createdAt)}',
            '${info.charts}',
            '${info.clients}',
            '${info.appointments}',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.restoreAction)),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await _service.restore(bytes);
      if (mounted) AstroApp.restart(context);
    } on BackupTooNewException {
      if (mounted) {
        _snack(l10n.backupTooNew);
        setState(() => _busy = false);
      }
    } catch (e) {
      if (mounted) {
        _snack(l10n.backupFailed('$e'));
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final last = _last;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.backup)),
      body: AbsorbPointer(
        absorbing: _busy,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(l10n.backupIntro, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text(
              last == null
                  ? l10n.neverBackedUp
                  : l10n.lastBackup('${formatDay(context, last)} ${formatClock(last)}'),
              style: TextStyle(
                color: last == null || DateTime.now().difference(last).inDays > 7
                    ? const Color(0xFFE57373)
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              icon: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_upload_outlined),
              label: Text(l10n.backupNow),
              onPressed: _backup,
            ),
            const SizedBox(height: 8),
            Text(l10n.backupHint, style: theme.textTheme.bodySmall),
            const SizedBox(height: 28),
            OutlinedButton.icon(
              icon: const Icon(Icons.settings_backup_restore),
              label: Text(l10n.restoreFromFile),
              onPressed: _restore,
            ),
            const SizedBox(height: 8),
            Text(l10n.restoreHint, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
