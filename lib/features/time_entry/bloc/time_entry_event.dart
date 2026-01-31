import '../../../data/models/time_entry.dart';

sealed class TimeEntryEvent {
  const TimeEntryEvent();
}

/// Load entries with optional userId filter
/// If userId is null and isAdmin is true, loads all entries
final class LoadEntries extends TimeEntryEvent {
  final String? userId;
  final bool isAdmin;

  const LoadEntries({this.userId, this.isAdmin = false});
}

/// Event fired when Firestore stream emits new entries
final class EntriesUpdated extends TimeEntryEvent {
  final List<TimeEntry> entries;

  const EntriesUpdated(this.entries);
}

/// Event fired when Firestore stream emits new locations
final class LocationsUpdated extends TimeEntryEvent {
  final List<String> locations;

  const LocationsUpdated(this.locations);
}

final class AddEntry extends TimeEntryEvent {
  final TimeEntry entry;

  const AddEntry(this.entry);
}

final class UpdateEntry extends TimeEntryEvent {
  final TimeEntry entry;

  const UpdateEntry(this.entry);
}

final class DeleteEntry extends TimeEntryEvent {
  final String id;

  const DeleteEntry(this.id);
}

/// Add a new location
final class AddLocation extends TimeEntryEvent {
  final String name;

  const AddLocation(this.name);
}
