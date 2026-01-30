import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

import 'package:shared_preferences/shared_preferences.dart';

import 'storage_driver_base.dart';

class _WebStorageDriver implements StorageDriver {
  static const _storageKey = 'pontaj_data_json';

  @override
  Future<String?> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_storageKey);
  }

  @override
  Future<void> save(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, data);
  }

  @override
  Future<String> exportCsv(String csvContents) async {
    final bytes = utf8.encode(csvContents);
    final blob = html.Blob([bytes], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = 'pontaje.csv'
      ..style.display = 'none';
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);
    return 'Downloaded pontaje.csv';
  }
}

StorageDriver buildStorageDriver() => _WebStorageDriver();
