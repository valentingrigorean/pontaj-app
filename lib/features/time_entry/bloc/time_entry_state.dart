import '../../../data/models/time_entry.dart';

sealed class TimeEntryState {
  const TimeEntryState();
}

final class TimeEntryInitial extends TimeEntryState {
  const TimeEntryInitial();
}

final class TimeEntryLoading extends TimeEntryState {
  const TimeEntryLoading();
}

final class TimeEntrySaving extends TimeEntryState {
  const TimeEntrySaving();
}

final class TimeEntrySaved extends TimeEntryState {
  final TimeEntry entry;

  const TimeEntrySaved(this.entry);
}

final class TimeEntryLoaded extends TimeEntryState {
  final List<TimeEntry> entries;
  final List<String> locations;

  const TimeEntryLoaded({
    required this.entries,
    required this.locations,
  });

  Duration get totalWorked => entries.fold(
        Duration.zero,
        (sum, e) => sum + e.totalWorked,
      );

  Map<String, List<TimeEntry>> get entriesByUser {
    final map = <String, List<TimeEntry>>{};
    for (final entry in entries) {
      map.putIfAbsent(entry.userName, () => []).add(entry);
    }
    return map;
  }
}

final class TimeEntryFailure extends TimeEntryState {
  final String message;

  const TimeEntryFailure(this.message);
}
