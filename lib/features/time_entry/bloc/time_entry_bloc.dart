import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/time_entry.dart';
import '../../../data/repositories/firestore_time_entry_repository.dart';
import 'time_entry_event.dart';
import 'time_entry_state.dart';

class TimeEntryBloc extends Bloc<TimeEntryEvent, TimeEntryState> {
  final FirestoreTimeEntryRepository _repository;

  StreamSubscription<List<TimeEntry>>? _entriesSubscription;
  StreamSubscription<List<String>>? _locationsSubscription;

  bool _isAdmin = false;
  List<String> _currentLocations = [];

  TimeEntryBloc({required FirestoreTimeEntryRepository repository})
    : _repository = repository,
      super(const TimeEntryInitial()) {
    on<LoadEntries>(_onLoadEntries);
    on<EntriesUpdated>(_onEntriesUpdated);
    on<LocationsUpdated>(_onLocationsUpdated);
    on<AddEntry>(_onAddEntry);
    on<UpdateEntry>(_onUpdateEntry);
    on<DeleteEntry>(_onDeleteEntry);
    on<AddLocation>(_onAddLocation);
  }

  @override
  Future<void> close() {
    _entriesSubscription?.cancel();
    _locationsSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadEntries(
    LoadEntries event,
    Emitter<TimeEntryState> emit,
  ) async {
    emit(const TimeEntryLoading());

    _isAdmin = event.isAdmin;

    await _entriesSubscription?.cancel();
    await _locationsSubscription?.cancel();

    final entriesStream = (_isAdmin && event.userId == null)
        ? _repository.getEntriesStream()
        : _repository.getEntriesStream(userId: event.userId);

    _entriesSubscription = entriesStream.listen(
      (entries) => add(EntriesUpdated(entries)),
      onError: (error) {},
    );

    _locationsSubscription = _repository.getLocationsStream().listen(
      (locations) => add(LocationsUpdated(locations)),
    );
  }

  void _onEntriesUpdated(EntriesUpdated event, Emitter<TimeEntryState> emit) {
    emit(TimeEntryLoaded(entries: event.entries, locations: _currentLocations));
  }

  void _onLocationsUpdated(
    LocationsUpdated event,
    Emitter<TimeEntryState> emit,
  ) {
    _currentLocations = event.locations;

    if (state is TimeEntryLoaded) {
      final current = state as TimeEntryLoaded;
      emit(
        TimeEntryLoaded(entries: current.entries, locations: event.locations),
      );
    }
  }

  Future<void> _onAddEntry(AddEntry event, Emitter<TimeEntryState> emit) async {
    List<TimeEntry> currentEntries = [];
    if (state is TimeEntryLoaded) {
      currentEntries = (state as TimeEntryLoaded).entries.toList();
    }

    emit(const TimeEntrySaving());
    try {
      final savedEntry = await _repository.addEntry(event.entry);
      emit(TimeEntrySaved(savedEntry));
      emit(
        TimeEntryLoaded(
          entries: [savedEntry, ...currentEntries],
          locations: _currentLocations,
        ),
      );
    } catch (e) {
      emit(TimeEntryFailure(e.toString()));
      if (currentEntries.isNotEmpty || _currentLocations.isNotEmpty) {
        emit(
          TimeEntryLoaded(
            entries: currentEntries,
            locations: _currentLocations,
          ),
        );
      }
    }
  }

  Future<void> _onUpdateEntry(
    UpdateEntry event,
    Emitter<TimeEntryState> emit,
  ) async {
    try {
      await _repository.updateEntry(event.entry);
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
    } catch (e) {
      emit(TimeEntryFailure(e.toString()));
    }
  }

  Future<void> _onAddLocation(
    AddLocation event,
    Emitter<TimeEntryState> emit,
  ) async {
    try {
      await _repository.addLocation(event.name);
    } catch (e) {
      emit(TimeEntryFailure(e.toString()));
    }
  }
}
