import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  static const _fileName = 'pontaj_data.json';
  Map<String, dynamic> _cache = {};
  String? _filePath;

  Future<void> init() async {
    _filePath = await _getFilePath();
    await _loadFromDisk();
  }

  Future<String> _getFilePath() async {
    try {
      if (Platform.isWindows) {
        final home = Platform.environment['UserProfile'] ?? 'C:\\';
        final dir = Directory('$home\\AppData\\Local\\PontajApp');
        if (!dir.existsSync()) dir.createSync(recursive: true);
        return '${dir.path}\\$_fileName';
      } else if (Platform.isMacOS || Platform.isLinux) {
        final home = Platform.environment['HOME'] ?? '/tmp';
        final dir = Directory('$home/.pontaj_app');
        if (!dir.existsSync()) dir.createSync(recursive: true);
        return '${dir.path}/$_fileName';
      } else {
        final dir = await getApplicationDocumentsDirectory();
        return '${dir.path}/$_fileName';
      }
    } catch (e) {
      debugPrint('Error getting file path: $e');
      return '${Directory.systemTemp.path}/$_fileName';
    }
  }

  Future<void> _loadFromDisk() async {
    try {
      final file = File(_filePath!);
      if (file.existsSync()) {
        final text = await file.readAsString();
        if (text.trim().isNotEmpty) {
          _cache = jsonDecode(text) as Map<String, dynamic>;
        }
      }
    } catch (e) {
      debugPrint('Error loading from disk: $e');
      _cache = {};
    }
  }

  Future<void> _saveToDisk() async {
    try {
      final file = File(_filePath!);
      await file.writeAsString(jsonEncode(_cache), encoding: utf8);
    } catch (e) {
      debugPrint('Error saving to disk: $e');
    }
  }

  T? read<T>(String key) {
    return _cache[key] as T?;
  }

  Future<void> write(String key, dynamic value) async {
    _cache[key] = value;
    await _saveToDisk();
  }

  Future<void> delete(String key) async {
    _cache.remove(key);
    await _saveToDisk();
  }

  Future<void> clear() async {
    _cache.clear();
    await _saveToDisk();
  }

  Map<String, dynamic> get allData => Map.unmodifiable(_cache);
}
