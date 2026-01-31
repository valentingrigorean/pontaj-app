import 'package:equatable/equatable.dart';

import '../../../data/models/time_entry.dart';

sealed class TimeEntryEvent extends Equatable {
  const TimeEntryEvent();

  @override
  List<Object?> get props => [];
}

/// Load entries with optional userId filter
/// If userId is null and isAdmin is true, loads all entries
final class LoadEntries extends TimeEntryEvent {
  final String? userId;
  final bool isAdmin;

  const LoadEntries({this.userId, this.isAdmin = false});

  @override
  List<Object?> get props => [userId, isAdmin];
}

/// Event fired when Firestore stream emits new entries
final class EntriesUpdated extends TimeEntryEvent {
  final List<TimeEntry> entries;

  const EntriesUpdated(this.entries);

  @override
  List<Object?> get props => [entries];
}

/// Event fired when Firestore stream emits new locations
final class LocationsUpdated extends TimeEntryEvent {
  final List<String> locations;

  const LocationsUpdated(this.locations);

  @override
  List<Object?> get props => [locations];
}

final class AddEntry extends TimeEntryEvent {
  final TimeEntry entry;

  const AddEntry(this.entry);

  @override
  List<Object?> get props => [entry];
}

final class UpdateEntry extends TimeEntryEvent {
  final TimeEntry entry;

  const UpdateEntry(this.entry);

  @override
  List<Object?> get props => [entry];
}

final class DeleteEntry extends TimeEntryEvent {
  final String id;

  const DeleteEntry(this.id);

  @override
  List<Object?> get props => [id];
}

/// Add a new location
final class AddLocation extends TimeEntryEvent {
  final String name;

  const AddLocation(this.name);

  @override
  List<Object?> get props => [name];
}
