import '../core/storage/local_storage.dart';
import '../models/time_entry.dart';

class TimeEntryRepository {
  final LocalStorage _storage;

  TimeEntryRepository({LocalStorage? storage})
      : _storage = storage ?? LocalStorage();

  static const _entriesKey = 'entries';
  static const _locationsKey = 'locatii';

  List<TimeEntry> getEntries() {
    final entriesJson = _storage.read<List<dynamic>>(_entriesKey);
    if (entriesJson == null) return [];
    return entriesJson
        .map((e) => TimeEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveEntries(List<TimeEntry> entries) async {
    await _storage.write(_entriesKey, entries.map((e) => e.toJson()).toList());
  }

  List<String> getLocations() {
    final locations = _storage.read<List<dynamic>>(_locationsKey);
    if (locations == null || locations.isEmpty) {
      return ['Casa A', 'Casa B', 'Fabrica', 'Depozit'];
    }
    return locations.cast<String>();
  }

  Future<void> _saveLocations(List<String> locations) async {
    await _storage.write(_locationsKey, locations);
  }

  Future<void> _rememberLocation(String location) async {
    final trimmed = location.trim();
    if (trimmed.isEmpty) return;

    final locations = getLocations();
    final exists = locations.any(
      (l) => l.toLowerCase() == trimmed.toLowerCase(),
    );
    if (!exists) {
      locations.insert(0, trimmed);
      await _saveLocations(locations);
    }
  }

  Future<void> addEntry(TimeEntry entry) async {
    final entries = getEntries();
    entries.add(entry);
    await _saveEntries(entries);
    await _rememberLocation(entry.location);
  }

  Future<void> updateEntry(TimeEntry entry) async {
    final entries = getEntries();
    final index = entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      entries[index] = entry;
      await _saveEntries(entries);
      await _rememberLocation(entry.location);
    }
  }

  Future<void> deleteEntry(String id) async {
    final entries = getEntries();
    entries.removeWhere((e) => e.id == id);
    await _saveEntries(entries);
  }

  List<TimeEntry> getEntriesForUser(String username) {
    return getEntries()
        .where((e) => e.user.toLowerCase() == username.toLowerCase())
        .toList();
  }

  List<TimeEntry> getEntriesForDateRange({
    String? username,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return getEntries().where((e) {
      if (username != null &&
          e.user.toLowerCase() != username.toLowerCase()) {
        return false;
      }
      if (startDate != null && e.date.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && e.date.isAfter(endDate)) {
        return false;
      }
      return true;
    }).toList();
  }

  TimeEntry? getEntryForUserOnDate(String username, DateTime date) {
    final targetDate = DateTime(date.year, date.month, date.day);
    try {
      return getEntries().firstWhere((e) {
        final entryDate = DateTime(e.date.year, e.date.month, e.date.day);
        return entryDate == targetDate &&
            e.user.toLowerCase() == username.toLowerCase();
      });
    } catch (_) {
      return null;
    }
  }
}
