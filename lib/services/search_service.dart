import '../store.dart';
import 'database_service.dart';

/// Advanced search and filtering service with multiple criteria
class SearchService {
  static final SearchService _instance = SearchService._internal();
  factory SearchService() => _instance;
  SearchService._internal();

  final DatabaseService _db = DatabaseService();

  /// Search pontaj entries with advanced filters
  Future<List<PontajEntry>> searchEntries({
    String? userQuery,
    String? locationQuery,
    DateTime? startDate,
    DateTime? endDate,
    int? minHours,
    int? maxHours,
    List<String>? locations,
    List<String>? users,
    SortBy sortBy = SortBy.dateDesc,
  }) async {
    final db = await _db.database;
    final whereConditions = <String>[];
    final whereArgs = <dynamic>[];

    // User filter
    if (userQuery != null && userQuery.isNotEmpty) {
      whereConditions.add('user LIKE ?');
      whereArgs.add('%$userQuery%');
    }

    // Location filter
    if (locationQuery != null && locationQuery.isNotEmpty) {
      whereConditions.add('location LIKE ?');
      whereArgs.add('%$locationQuery%');
    }

    // Date range filter
    if (startDate != null) {
      whereConditions.add('date >= ?');
      whereArgs.add(startDate.millisecondsSinceEpoch);
    }
    if (endDate != null) {
      whereConditions.add('date <= ?');
      whereArgs.add(endDate.millisecondsSinceEpoch);
    }

    // Hours worked filter
    if (minHours != null) {
      whereConditions.add('total_worked_minutes >= ?');
      whereArgs.add(minHours * 60);
    }
    if (maxHours != null) {
      whereConditions.add('total_worked_minutes <= ?');
      whereArgs.add(maxHours * 60);
    }

    // Specific locations filter
    if (locations != null && locations.isNotEmpty) {
      final placeholders = List.filled(locations.length, '?').join(',');
      whereConditions.add('location IN ($placeholders)');
      whereArgs.addAll(locations);
    }

    // Specific users filter
    if (users != null && users.isNotEmpty) {
      final placeholders = List.filled(users.length, '?').join(',');
      whereConditions.add('user IN ($placeholders)');
      whereArgs.addAll(users);
    }

    final whereClause = whereConditions.isEmpty ? null : whereConditions.join(' AND ');
    final orderBy = _getSortOrder(sortBy);

    final results = await db.query(
      'pontaj_entries',
      where: whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: orderBy,
    );

    return results.map((row) => PontajEntry(
      user: row['user'] as String,
      locatie: row['location'] as String,
      intervalText: row['interval_text'] as String,
      breakMinutes: row['break_minutes'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(row['date'] as int),
      totalWorked: Duration(minutes: row['total_worked_minutes'] as int),
    )).toList();
  }

  /// Get all unique users
  Future<List<String>> getAllUniqueUsers() async {
    final db = await _db.database;
    final results = await db.rawQuery('''
      SELECT DISTINCT user
      FROM pontaj_entries
      ORDER BY user ASC
    ''');
    return results.map((row) => row['user'] as String).toList();
  }

  /// Get all unique locations
  Future<List<String>> getAllUniqueLocations() async {
    final db = await _db.database;
    final results = await db.rawQuery('''
      SELECT DISTINCT location
      FROM pontaj_entries
      ORDER BY location ASC
    ''');
    return results.map((row) => row['location'] as String).toList();
  }

  /// Get date range statistics
  Future<DateRangeStats> getDateRangeStats(DateTime start, DateTime end) async {
    final db = await _db.database;
    final startMs = start.millisecondsSinceEpoch;
    final endMs = end.millisecondsSinceEpoch;

    final results = await db.rawQuery('''
      SELECT
        COUNT(*) as total_entries,
        COUNT(DISTINCT user) as unique_users,
        COUNT(DISTINCT location) as unique_locations,
        SUM(total_worked_minutes) as total_minutes,
        AVG(total_worked_minutes) as avg_minutes,
        MIN(total_worked_minutes) as min_minutes,
        MAX(total_worked_minutes) as max_minutes
      FROM pontaj_entries
      WHERE date >= ? AND date <= ?
    ''', [startMs, endMs]);

    final row = results.first;
    return DateRangeStats(
      totalEntries: row['total_entries'] as int? ?? 0,
      uniqueUsers: row['unique_users'] as int? ?? 0,
      uniqueLocations: row['unique_locations'] as int? ?? 0,
      totalMinutes: row['total_minutes'] as int? ?? 0,
      avgMinutes: (row['avg_minutes'] as num?)?.toDouble() ?? 0.0,
      minMinutes: row['min_minutes'] as int? ?? 0,
      maxMinutes: row['max_minutes'] as int? ?? 0,
    );
  }

  /// Get user statistics
  Future<UserStats> getUserStats(String username) async {
    final db = await _db.database;

    final results = await db.rawQuery('''
      SELECT
        COUNT(*) as total_entries,
        COUNT(DISTINCT location) as locations_count,
        SUM(total_worked_minutes) as total_minutes,
        AVG(total_worked_minutes) as avg_minutes,
        MIN(date) as first_entry,
        MAX(date) as last_entry
      FROM pontaj_entries
      WHERE user = ?
    ''', [username]);

    final row = results.first;
    return UserStats(
      totalEntries: row['total_entries'] as int? ?? 0,
      locationsCount: row['locations_count'] as int? ?? 0,
      totalMinutes: row['total_minutes'] as int? ?? 0,
      avgMinutes: (row['avg_minutes'] as num?)?.toDouble() ?? 0.0,
      firstEntry: row['first_entry'] != null
          ? DateTime.fromMillisecondsSinceEpoch(row['first_entry'] as int)
          : null,
      lastEntry: row['last_entry'] != null
          ? DateTime.fromMillisecondsSinceEpoch(row['last_entry'] as int)
          : null,
    );
  }

  /// Get location statistics
  Future<LocationStats> getLocationStats(String location) async {
    final db = await _db.database;

    final results = await db.rawQuery('''
      SELECT
        COUNT(*) as total_entries,
        COUNT(DISTINCT user) as users_count,
        SUM(total_worked_minutes) as total_minutes,
        AVG(total_worked_minutes) as avg_minutes
      FROM pontaj_entries
      WHERE location = ?
    ''', [location]);

    final row = results.first;
    return LocationStats(
      totalEntries: row['total_entries'] as int? ?? 0,
      usersCount: row['users_count'] as int? ?? 0,
      totalMinutes: row['total_minutes'] as int? ?? 0,
      avgMinutes: (row['avg_minutes'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Search with full-text search simulation
  Future<List<PontajEntry>> fullTextSearch(String query) async {
    final db = await _db.database;
    final results = await db.rawQuery('''
      SELECT *
      FROM pontaj_entries
      WHERE user LIKE ? OR location LIKE ? OR interval_text LIKE ?
      ORDER BY date DESC
    ''', ['%$query%', '%$query%', '%$query%']);

    return results.map((row) => PontajEntry(
      user: row['user'] as String,
      locatie: row['location'] as String,
      intervalText: row['interval_text'] as String,
      breakMinutes: row['break_minutes'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(row['date'] as int),
      totalWorked: Duration(minutes: row['total_worked_minutes'] as int),
    )).toList();
  }

  String _getSortOrder(SortBy sortBy) {
    switch (sortBy) {
      case SortBy.dateAsc:
        return 'date ASC';
      case SortBy.dateDesc:
        return 'date DESC';
      case SortBy.userAsc:
        return 'user ASC, date DESC';
      case SortBy.userDesc:
        return 'user DESC, date DESC';
      case SortBy.locationAsc:
        return 'location ASC, date DESC';
      case SortBy.locationDesc:
        return 'location DESC, date DESC';
      case SortBy.hoursAsc:
        return 'total_worked_minutes ASC';
      case SortBy.hoursDesc:
        return 'total_worked_minutes DESC';
    }
  }
}

enum SortBy {
  dateAsc,
  dateDesc,
  userAsc,
  userDesc,
  locationAsc,
  locationDesc,
  hoursAsc,
  hoursDesc,
}

class DateRangeStats {
  final int totalEntries;
  final int uniqueUsers;
  final int uniqueLocations;
  final int totalMinutes;
  final double avgMinutes;
  final int minMinutes;
  final int maxMinutes;

  DateRangeStats({
    required this.totalEntries,
    required this.uniqueUsers,
    required this.uniqueLocations,
    required this.totalMinutes,
    required this.avgMinutes,
    required this.minMinutes,
    required this.maxMinutes,
  });

  Duration get totalDuration => Duration(minutes: totalMinutes);
  Duration get avgDuration => Duration(minutes: avgMinutes.round());
  Duration get minDuration => Duration(minutes: minMinutes);
  Duration get maxDuration => Duration(minutes: maxMinutes);
}

class UserStats {
  final int totalEntries;
  final int locationsCount;
  final int totalMinutes;
  final double avgMinutes;
  final DateTime? firstEntry;
  final DateTime? lastEntry;

  UserStats({
    required this.totalEntries,
    required this.locationsCount,
    required this.totalMinutes,
    required this.avgMinutes,
    this.firstEntry,
    this.lastEntry,
  });

  Duration get totalDuration => Duration(minutes: totalMinutes);
  Duration get avgDuration => Duration(minutes: avgMinutes.round());
}

class LocationStats {
  final int totalEntries;
  final int usersCount;
  final int totalMinutes;
  final double avgMinutes;

  LocationStats({
    required this.totalEntries,
    required this.usersCount,
    required this.totalMinutes,
    required this.avgMinutes,
  });

  Duration get totalDuration => Duration(minutes: totalMinutes);
  Duration get avgDuration => Duration(minutes: avgMinutes.round());
}
