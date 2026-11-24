import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Copies the bundled atlas out of the APK the first time (SQLite needs a
/// real file), and again whenever a new app version ships a different one.
Future<String> installAtlas() async {
  const asset = 'assets/atlas/atlas.sqlite';
  final dir = await getApplicationSupportDirectory();
  final file = File('${dir.path}/atlas.sqlite');
  final stamp = File('${dir.path}/atlas.stamp');

  final data = await rootBundle.load(asset);
  final version = '${data.lengthInBytes}';
  if (file.existsSync() &&
      stamp.existsSync() &&
      stamp.readAsStringSync() == version) {
    return file.path;
  }
  final tmp = File('${file.path}.tmp');
  await tmp.writeAsBytes(
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    flush: true,
  );
  if (file.existsSync()) file.deleteSync();
  await tmp.rename(file.path);
  await stamp.writeAsString(version, flush: true);
  return file.path;
}
