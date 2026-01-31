import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/time_entry_repository.dart';
import 'time_entry_event.dart';
import 'time_entry_state.dart';

class TimeEntryBloc extends Bloc<TimeEntryEvent, TimeEntryState> {
  final TimeEntryRepository _repository;
  String? _currentUserFilter;

  TimeEntryBloc({required TimeEntryRepository repository})
      : _repository = repository,
        super(const TimeEntryInitial()) {
    on<LoadEntries>(_onLoadEntries);
    on<AddEntry>(_onAddEntry);
    on<UpdateEntry>(_onUpdateEntry);
    on<DeleteEntry>(_onDeleteEntry);
  }

  Future<void> _onLoadEntries(
    LoadEntries event,
    Emitter<TimeEntryState> emit,
  ) async {
    emit(const TimeEntryLoading());
    _currentUserFilter = event.username;

    try {
      final entries = event.username != null
          ? _repository.getEntriesForUser(event.username!)
          : _repository.getEntries();
      final locations = _repository.getLocations();

      emit(TimeEntryLoaded(
        entries: entries,
        locations: locations,
      ));
    } catch (e) {
      emit(TimeEntryFailure(e.toString()));
    }
  }

  Future<void> _onAddEntry(
    AddEntry event,
    Emitter<TimeEntryState> emit,
  ) async {
    try {
      await _repository.addEntry(event.entry);
      add(LoadEntries(username: _currentUserFilter));
    } catch (e) {
      emit(TimeEntryFailure(e.toString()));
    }
  }

  Future<void> _onUpdateEntry(
    UpdateEntry event,
    Emitter<TimeEntryState> emit,
  ) async {
    try {
      await _repository.updateEntry(event.entry);
      add(LoadEntries(username: _currentUserFilter));
    } catch (e) {
      emit(TimeEntryFailure(e.toString()));
    }
  }

  Future<void> _onDeleteEntry(
    DeleteEntry event,
    Emitter<TimeEntryState> emit,
  ) async {
    try {
      await _repository.deleteEntry(event.id);
      add(LoadEntries(username: _currentUserFilter));
    } catch (e) {
      emit(TimeEntryFailure(e.toString()));
    }
  }
}
