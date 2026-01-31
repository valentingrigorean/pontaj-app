import 'package:equatable/equatable.dart';

import '../../models/time_entry.dart';

sealed class TimeEntryEvent extends Equatable {
  const TimeEntryEvent();

  @override
  List<Object?> get props => [];
}

final class LoadEntries extends TimeEntryEvent {
  final String? username;

  const LoadEntries({this.username});

  @override
  List<Object?> get props => [username];
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
