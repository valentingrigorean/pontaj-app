abstract class StorageDriver {
  Future<String?> load();
  Future<void> save(String data);
  Future<String> exportCsv(String csvContents);
}
