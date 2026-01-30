import 'storage_driver_base.dart';

class _MemoryStorageDriver implements StorageDriver {
  String? _data;

  @override
  Future<String?> load() async => _data;

  @override
  Future<void> save(String data) async {
    _data = data;
  }

  @override
  Future<String> exportCsv(String csvContents) async {
    // No-op; just return a message.
    return 'Export not available on this platform.';
  }
}

StorageDriver buildStorageDriver() => _MemoryStorageDriver();
