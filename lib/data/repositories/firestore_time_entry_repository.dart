import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/time_entry.dart';

/// Firestore repository for time entries with real-time sync support.
class FirestoreTimeEntryRepository {
  final FirebaseFirestore _firestore;

  FirestoreTimeEntryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _entriesCollection =>
      _firestore.collection('entries');

  CollectionReference<Map<String, dynamic>> get _locationsCollection =>
      _firestore.collection('locations');

  /// Get entries stream with optional user filter
  /// Real-time updates for instant sync across devices
  Stream<List<TimeEntry>> getEntriesStream({String? userId}) {
    Query<Map<String, dynamic>> query = _entriesCollection;

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    return query.orderBy('date', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TimeEntry.fromFirestore(doc)).toList();
    });
  }

  /// Get entries for a specific date range
  Stream<List<TimeEntry>> getEntriesForDateRangeStream({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Query<Map<String, dynamic>> query = _entriesCollection;

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    if (startDate != null) {
      query = query.where('date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
    }

    if (endDate != null) {
      query =
          query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    }

    return query.orderBy('date', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TimeEntry.fromFirestore(doc)).toList();
    });
  }

  /// Get all entries (one-time fetch)
  Future<List<TimeEntry>> getEntries({String? userId}) async {
    Query<Map<String, dynamic>> query = _entriesCollection;

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    final snapshot = await query.orderBy('date', descending: true).get();
    return snapshot.docs.map((doc) => TimeEntry.fromFirestore(doc)).toList();
  }

  /// Get entries for a date range (one-time fetch)
  Future<List<TimeEntry>> getEntriesForDateRange({
    String? userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    Query<Map<String, dynamic>> query = _entriesCollection;

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    query = query
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));

    final snapshot = await query.orderBy('date', descending: true).get();
    return snapshot.docs.map((doc) => TimeEntry.fromFirestore(doc)).toList();
  }

  /// Add a new time entry
  Future<TimeEntry> addEntry(TimeEntry entry) async {
    final docRef = await _entriesCollection.add(entry.toFirestore());

    // Add location if it doesn't exist
    if (entry.location.isNotEmpty) {
      await _addLocationIfNotExists(entry.location);
    }

    return entry.copyWith(id: docRef.id);
  }

  /// Update an existing time entry
  Future<void> updateEntry(TimeEntry entry) async {
    await _entriesCollection.doc(entry.id).update(entry.toFirestoreUpdate());

    // Add location if it doesn't exist
    if (entry.location.isNotEmpty) {
      await _addLocationIfNotExists(entry.location);
    }
  }

  /// Delete a time entry
  Future<void> deleteEntry(String id) async {
    await _entriesCollection.doc(id).delete();
  }

  /// Get locations stream for real-time updates
  Stream<List<String>> getLocationsStream() {
    return _locationsCollection.orderBy('name').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data()['name'] as String? ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    });
  }

  /// Get all locations (one-time fetch)
  Future<List<String>> getLocations() async {
    final snapshot = await _locationsCollection.orderBy('name').get();
    return snapshot.docs
        .map((doc) => doc.data()['name'] as String? ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
  }

  /// Add a new location
  Future<void> addLocation(String name) async {
    if (name.isEmpty) return;
    await _addLocationIfNotExists(name);
  }

  /// Delete a location (admin only)
  Future<void> deleteLocation(String name) async {
    final snapshot = await _locationsCollection
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  /// Helper to add location if it doesn't already exist
  Future<void> _addLocationIfNotExists(String name) async {
    final existing = await _locationsCollection
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    if (existing.docs.isEmpty) {
      await _locationsCollection.add({
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Get entries grouped by user (for admin dashboard)
  Future<Map<String, List<TimeEntry>>> getEntriesGroupedByUser() async {
    final entries = await getEntries();
    final map = <String, List<TimeEntry>>{};

    for (final entry in entries) {
      map.putIfAbsent(entry.userName, () => []).add(entry);
    }

    return map;
  }

  /// Get total hours worked by user for a date range
  Future<Duration> getTotalWorkedForUser({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    Query<Map<String, dynamic>> query =
        _entriesCollection.where('userId', isEqualTo: userId);

    if (startDate != null) {
      query = query.where('date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
    }

    if (endDate != null) {
      query =
          query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    }

    final snapshot = await query.get();

    int totalMinutes = 0;
    for (final doc in snapshot.docs) {
      totalMinutes += (doc.data()['totalWorkedMinutes'] as int?) ?? 0;
    }

    return Duration(minutes: totalMinutes);
  }
}
