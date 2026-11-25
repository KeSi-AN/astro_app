import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

import '../../core/db/app_database.dart';

/// What a backup file holds (read before restoring).
class BackupInfo {
  const BackupInfo({
    required this.createdAt,
    required this.schemaVersion,
    this.charts = 0,
    this.clients = 0,
    this.appointments = 0,
  });

  final DateTime createdAt;
  final int schemaVersion;
  final int charts;
  final int clients;
  final int appointments;
}

/// Not a backup from this app (or damaged).
class InvalidBackupException implements Exception {
  const InvalidBackupException();
  @override
  String toString() => 'Not a backup from this app';
}

/// Made by a newer version of the app: update before restoring.
class BackupTooNewException implements Exception {
  const BackupTooNewException();
  @override
  String toString() => 'Backup is from a newer version of the app';
}

/// Everything the astrologer entered (charts, clients, consultations,
/// settings and the letterhead logo) as one zip, to keep on Google Drive or
/// move to a new phone.
///
/// Same design as shop_app's backups: `manifest.json`, a `VACUUM INTO`
/// snapshot of the database, and the media folders.
class BackupService {
  BackupService(
    this._db, {
    required this._databaseFile,
    required this._storageDir,
    required this._tempDir,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final Future<File> Function() _databaseFile;
  final Future<Directory> Function() _storageDir;
  final Future<Directory> Function() _tempDir;
  final DateTime Function() _clock;

  static const formatVersion = 1;
  static const _manifest = 'manifest.json';
  static const _database = 'astro.sqlite';
  static const _marker = 'last_backup.txt';

  /// Folder in app storage for the letterhead logo.
  static const logoFolder = 'letterhead';
  static const mediaFolders = [logoFolder];

  Future<int> _count(AppDatabase db, String table) async =>
      (await db.customSelect('SELECT COUNT(*) AS c FROM $table').getSingle())
          .read<int>('c');

  /// Writes a backup file and returns its path (to share).
  Future<String> create() async {
    final now = _clock();
    final temp = await _tempDir();
    final work = Directory(p.join(temp.path, 'backup_work'));
    if (work.existsSync()) await work.delete(recursive: true);
    await work.create(recursive: true);

    final dbCopy = File(p.join(work.path, _database));
    await _db.customStatement(
      "VACUUM INTO '${dbCopy.path.replaceAll("'", "''")}'",
    );
    final manifest = {
      'app': 'astro_app',
      'format': formatVersion,
      'schemaVersion': _db.schemaVersion,
      'createdAt': now.toIso8601String(),
      'charts': await _count(_db, 'charts'),
      'clients': await _count(_db, 'clients'),
      'appointments': await _count(_db, 'appointments'),
    };
    final archive = Archive();
    void add(String name, List<int> data) =>
        archive.addFile(ArchiveFile(name, data.length, data));
    add(_manifest, utf8.encode(jsonEncode(manifest)));
    add(_database, await dbCopy.readAsBytes());
    final storage = await _storageDir();
    for (final folder in mediaFolders) {
      final dir = Directory(p.join(storage.path, folder));
      if (!dir.existsSync()) continue;
      for (final f in dir.listSync().whereType<File>()) {
        add('$folder/${p.basename(f.path)}', await f.readAsBytes());
      }
    }
    final bytes = ZipEncoder().encode(archive);
    await work.delete(recursive: true);

    final out = Directory(p.join(temp.path, 'exports'));
    if (out.existsSync()) await out.delete(recursive: true);
    await out.create(recursive: true);
    String two(int n) => n.toString().padLeft(2, '0');
    final stamp =
        '${now.year}-${two(now.month)}-${two(now.day)}_${two(now.hour)}${two(now.minute)}';
    final file = File(p.join(out.path, 'AstroBackup_$stamp.zip'));
    await file.writeAsBytes(bytes, flush: true);
    await File(p.join(storage.path, _marker)).writeAsString(now.toIso8601String());
    return file.path;
  }

  /// When [create] last succeeded on this phone.
  Future<DateTime?> lastBackupAt() async {
    final f = File(p.join((await _storageDir()).path, _marker));
    if (!f.existsSync()) return null;
    return DateTime.tryParse((await f.readAsString()).trim());
  }

  Archive _decode(Uint8List bytes) {
    try {
      return ZipDecoder().decodeBytes(bytes);
    } on Object {
      throw const InvalidBackupException();
    }
  }

  BackupInfo _info(Archive zip) {
    final manifest = zip.findFile(_manifest);
    if (manifest == null || zip.findFile(_database) == null) {
      throw const InvalidBackupException();
    }
    try {
      final m = jsonDecode(utf8.decode(manifest.content)) as Map<String, Object?>;
      if (m['app'] != 'astro_app') throw const InvalidBackupException();
      return BackupInfo(
        createdAt: DateTime.parse(m['createdAt']! as String),
        schemaVersion: m['schemaVersion']! as int,
        charts: m['charts'] as int? ?? 0,
        clients: m['clients'] as int? ?? 0,
        appointments: m['appointments'] as int? ?? 0,
      );
    } on InvalidBackupException {
      rethrow;
    } on Object {
      throw const InvalidBackupException();
    }
  }

  /// Reads a backup's manifest. Throws [InvalidBackupException].
  Future<BackupInfo> inspect(Uint8List bytes) async => _info(_decode(bytes));

  /// Replaces everything on this phone with [bytes]. Closes the database:
  /// the app must restart its services afterwards.
  Future<void> restore(Uint8List bytes) async {
    final zip = _decode(bytes);
    final info = _info(zip);
    if (info.schemaVersion > _db.schemaVersion) {
      throw const BackupTooNewException();
    }
    final storage = await _storageDir();
    final work = Directory(p.join((await _tempDir()).path, 'restore_work'));
    if (work.existsSync()) await work.delete(recursive: true);
    await work.create(recursive: true);

    // Open the backup on its own first: this upgrades an older backup to
    // the current schema and points the logo at this phone's storage.
    final staged = File(p.join(work.path, _database));
    await staged.writeAsBytes(zip.findFile(_database)!.content, flush: true);
    final copy = AppDatabase(NativeDatabase(staged));
    try {
      await _relinkLogo(copy, storage);
    } finally {
      await copy.close();
    }

    await _db.close();
    final live = await _databaseFile();
    for (final suffix in ['', '-wal', '-shm', '-journal']) {
      final f = File('${live.path}$suffix');
      if (f.existsSync()) await f.delete();
    }
    await staged.copy(live.path);

    for (final folder in mediaFolders) {
      final dir = Directory(p.join(storage.path, folder));
      if (dir.existsSync()) await dir.delete(recursive: true);
    }
    for (final f in zip.files) {
      final folder = p.posix.dirname(f.name);
      if (!f.isFile || !mediaFolders.contains(folder)) continue;
      final target = File(p.join(storage.path, folder, p.posix.basename(f.name)));
      await target.parent.create(recursive: true);
      await target.writeAsBytes(f.content, flush: true);
    }
    await work.delete(recursive: true);
  }

  /// The logo path is absolute; keep its file name and re-point it at
  /// [storage] (a new phone has a different app folder).
  static Future<void> _relinkLogo(AppDatabase db, Directory storage) async {
    final row = await db
        .customSelect("SELECT value FROM settings WHERE key = 'lhLogo'")
        .getSingleOrNull();
    final old = row?.read<String>('value') ?? '';
    if (old.isEmpty) return;
    final parts = old.replaceAll(r'\', '/').split('/');
    final folder = parts.length > 1 ? parts[parts.length - 2] : '';
    final next = folder == logoFolder ? p.join(storage.path, folder, parts.last) : '';
    await db.customUpdate(
      "UPDATE settings SET value = ? WHERE key = 'lhLogo'",
      variables: [Variable.withString(next)],
    );
  }
}
