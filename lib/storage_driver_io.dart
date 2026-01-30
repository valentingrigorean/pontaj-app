import 'dart:convert';
import 'dart:io';

import 'storage_driver_base.dart';

class _IoStorageDriver implements StorageDriver {
  static const _fileName = 'pontaj_data.json';

  @override
  Future<String?> load() async {
    try {
      final file = File(_dataFilePath());
      if (!file.existsSync()) return null;
      final text = await file.readAsString();
      if (text.trim().isEmpty) return null;
      return text;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(String data) async {
    final file = File(_dataFilePath());
    await file.writeAsString(data, encoding: utf8);
  }

  @override
  Future<String> exportCsv(String csvContents) async {
    final path = _defaultCsvPath();
    await File(path).writeAsString(csvContents, encoding: utf8);
    return path;
  }

  String _dataFilePath() {
    try {
      if (Platform.isWindows) {
        final home = Platform.environment['UserProfile'] ?? 'C:\\\\';
        final dir = Directory('$home\\AppData\\Local\\PontajApp');
        if (!dir.existsSync()) dir.createSync(recursive: true);
        return '${dir.path}\\$_fileName';
      } else if (Platform.isMacOS || Platform.isLinux) {
        final home = Platform.environment['HOME'] ?? '/tmp';
        final dir = Directory('$home/.pontaj_app');
        if (!dir.existsSync()) dir.createSync(recursive: true);
        return '${dir.path}/$_fileName';
      }
    } catch (_) {}
    return '${Directory.systemTemp.path}/$_fileName';
  }

  String _defaultCsvPath() {
    try {
      if (Platform.isWindows) {
        final home = Platform.environment['UserProfile'] ?? 'C:\\\\';
        return '$home\\Desktop\\pontaje.csv';
      } else if (Platform.isMacOS || Platform.isLinux) {
        final home = Platform.environment['HOME'] ?? '/tmp';
        final desktop = Directory('$home/Desktop');
        return '${(desktop.existsSync() ? desktop.path : home)}/pontaje.csv';
      }
    } catch (_) {}
    return '${Directory.systemTemp.path}/pontaje.csv';
  }
}

StorageDriver buildStorageDriver() => _IoStorageDriver();
