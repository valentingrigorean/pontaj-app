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

  String? _currentUserFilter;
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

    _currentUserFilter = event.userId;
    _isAdmin = event.isAdmin;

    // Cancel existing subscriptions
    await _entriesSubscription?.cancel();
    await _locationsSubscription?.cancel();

    // Subscribe to entries stream
    // Admin sees all entries if no userId filter is set
    final entriesStream = (_isAdmin && event.userId == null)
        ? _repository.getEntriesStream()
        : _repository.getEntriesStream(userId: event.userId);

    _entriesSubscription = entriesStream.listen(
      (entries) => add(EntriesUpdated(entries)),
      onError: (error) {
        // Don't emit failure for stream errors, just log
        // The bloc will continue trying to receive updates
      },
    );

    // Subscribe to locations stream
    _locationsSubscription = _repository.getLocationsStream().listen(
      (locations) => add(LocationsUpdated(locations)),
    );
  }

  void _onEntriesUpdated(
    EntriesUpdated event,
    Emitter<TimeEntryState> emit,
  ) {
    emit(TimeEntryLoaded(
      entries: event.entries,
      locations: _currentLocations,
    ));
  }

  void _onLocationsUpdated(
    LocationsUpdated event,
    Emitter<TimeEntryState> emit,
  ) {
    _currentLocations = event.locations;

    // If we already have a loaded state, update it with new locations
    if (state is TimeEntryLoaded) {
      final current = state as TimeEntryLoaded;
      emit(TimeEntryLoaded(
        entries: current.entries,
        locations: event.locations,
      ));
    }
  }

  Future<void> _onAddEntry(
    AddEntry event,
    Emitter<TimeEntryState> emit,
  ) async {
    emit(const TimeEntrySaving());
    try {
      final savedEntry = await _repository.addEntry(event.entry);
      emit(TimeEntrySaved(savedEntry));
      // Don't need to reload - the stream will update automatically
    } catch (e) {
      emit(TimeEntryFailure(e.toString()));
      // Re-emit loaded state so UI can continue working
      if (_currentLocations.isNotEmpty) {
        final entries = await _repository.getEntries(userId: _currentUserFilter);
        emit(TimeEntryLoaded(entries: entries, locations: _currentLocations));
      }
    }
  }

  Future<void> _onUpdateEntry(
    UpdateEntry event,
    Emitter<TimeEntryState> emit,
  ) async {
    try {
      await _repository.updateEntry(event.entry);
      // Don't need to reload - the stream will update automatically
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
      // Don't need to reload - the stream will update automatically
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
      // Location stream will update automatically
    } catch (e) {
      // Silently fail for location additions
    }
  }
}
