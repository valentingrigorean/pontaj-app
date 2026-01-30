import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../store.dart';

/// Professional SQLite database service for blazing fast performance
/// Replaces inefficient JSON storage with indexed database
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pontaj_pro.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Users table with encrypted passwords
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        role TEXT NOT NULL,
        salary_amount REAL,
        salary_type TEXT,
        currency TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Create index on username for fast lookups
    await db.execute('CREATE INDEX idx_users_username ON users(username)');

    // Pontaj entries table with full indexing
    await db.execute('''
      CREATE TABLE pontaj_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user TEXT NOT NULL,
        location TEXT NOT NULL,
        interval_text TEXT NOT NULL,
        break_minutes INTEGER NOT NULL,
        date INTEGER NOT NULL,
        total_worked_minutes INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (user) REFERENCES users(username) ON DELETE CASCADE
      )
    ''');

    // Create composite index for fast queries
    await db.execute('CREATE INDEX idx_pontaj_user_date ON pontaj_entries(user, date)');
    await db.execute('CREATE INDEX idx_pontaj_date ON pontaj_entries(date)');
    await db.execute('CREATE INDEX idx_pontaj_location ON pontaj_entries(location)');
    await db.execute('CREATE INDEX idx_pontaj_user ON pontaj_entries(user)');

    // Locations table for autocomplete
    await db.execute('''
      CREATE TABLE locations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL,
        usage_count INTEGER DEFAULT 1,
        last_used INTEGER NOT NULL
      )
    ''');

    await db.execute('CREATE INDEX idx_locations_usage ON locations(usage_count DESC)');

    // Settings table for app configuration
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Analytics cache table for performance
    await db.execute('''
      CREATE TABLE analytics_cache (
        cache_key TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        expires_at INTEGER NOT NULL
      )
    ''');

    // Backup log table
    await db.execute('''
      CREATE TABLE backup_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        backup_path TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        size_bytes INTEGER NOT NULL
      )
    ''');

    print('✅ Database tables created successfully with indexes');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
    print('Upgrading database from version $oldVersion to $newVersion');
  }

  // ==================== USER OPERATIONS ====================

  Future<int> insertUser(UserRec user, String passwordHash) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;

    return await db.insert('users', {
      'username': user.username,
      'password_hash': passwordHash,
      'role': user.role.name,
      'salary_amount': user.salaryAmount,
      'salary_type': user.salaryType.name,
      'currency': user.currency.name,
      'created_at': now,
      'updated_at': now,
    });
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    return results.isEmpty ? null : results.first;
  }

  Future<List<UserRec>> getAllUsers() async {
    final db = await database;
    final results = await db.query('users', orderBy: 'username ASC');

    return results.map((row) {
      final salaryTypeStr = row['salary_type'] as String?;
      final currencyStr = row['currency'] as String?;

      return UserRec(
        username: row['username'] as String,
        password: '', // Never return actual password
        role: Role.values.firstWhere((r) => r.name == row['role']),
        salaryAmount: row['salary_amount'] as double?,
        salaryType: salaryTypeStr != null
            ? SalaryType.values.firstWhere((s) => s.name == salaryTypeStr)
            : SalaryType.hourly,
        currency: currencyStr != null
            ? Currency.values.firstWhere((c) => c.name == currencyStr)
            : Currency.lei,
      );
    }).toList();
  }

  Future<int> updateUser(UserRec user, {String? passwordHash}) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;

    final data = <String, dynamic>{
      'role': user.role.name,
      'salary_amount': user.salaryAmount,
      'salary_type': user.salaryType.name,
      'currency': user.currency.name,
      'updated_at': now,
    };

    if (passwordHash != null) {
      data['password_hash'] = passwordHash;
    }

    return await db.update(
      'users',
      data,
      where: 'username = ?',
      whereArgs: [user.username],
    );
  }

  Future<int> deleteUser(String username) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  // ==================== PONTAJ ENTRY OPERATIONS ====================

  Future<int> insertPontajEntry(PontajEntry entry) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;

    return await db.insert('pontaj_entries', {
      'user': entry.user,
      'location': entry.locatie,
      'interval_text': entry.intervalText,
      'break_minutes': entry.breakMinutes,
      'date': entry.date.millisecondsSinceEpoch,
      'total_worked_minutes': entry.totalWorked.inMinutes,
      'created_at': now,
      'updated_at': now,
    });
  }

  Future<List<PontajEntry>> getAllPontajEntries() async {
    final db = await database;
    final results = await db.query('pontaj_entries', orderBy: 'date DESC');

    return results.map((row) => PontajEntry(
      user: row['user'] as String,
      locatie: row['location'] as String,
      intervalText: row['interval_text'] as String,
      breakMinutes: row['break_minutes'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(row['date'] as int),
      totalWorked: Duration(minutes: row['total_worked_minutes'] as int),
    )).toList();
  }

  Future<List<PontajEntry>> getPontajEntriesByUser(String username) async {
    final db = await database;
    final results = await db.query(
      'pontaj_entries',
      where: 'user = ?',
      whereArgs: [username],
      orderBy: 'date DESC',
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

  Future<List<PontajEntry>> getPontajEntriesByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    final results = await db.query(
      'pontaj_entries',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
      orderBy: 'date DESC',
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

  Future<PontajEntry?> findDuplicateEntry(String username, DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59).millisecondsSinceEpoch;

    final results = await db.query(
      'pontaj_entries',
      where: 'user = ? AND date >= ? AND date <= ?',
      whereArgs: [username, startOfDay, endOfDay],
      limit: 1,
    );

    if (results.isEmpty) return null;

    final row = results.first;
    return PontajEntry(
      user: row['user'] as String,
      locatie: row['location'] as String,
      intervalText: row['interval_text'] as String,
      breakMinutes: row['break_minutes'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(row['date'] as int),
      totalWorked: Duration(minutes: row['total_worked_minutes'] as int),
    );
  }

  Future<int> deletePontajEntry(String username, DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59).millisecondsSinceEpoch;

    return await db.delete(
      'pontaj_entries',
      where: 'user = ? AND date >= ? AND date <= ?',
      whereArgs: [username, startOfDay, endOfDay],
    );
  }

  // ==================== LOCATION OPERATIONS ====================

  Future<void> recordLocationUsage(String location) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;

    final existing = await db.query(
      'locations',
      where: 'name = ?',
      whereArgs: [location],
      limit: 1,
    );

    if (existing.isEmpty) {
      await db.insert('locations', {
        'name': location,
        'usage_count': 1,
        'last_used': now,
      });
    } else {
      await db.update(
        'locations',
        {
          'usage_count': (existing.first['usage_count'] as int) + 1,
          'last_used': now,
        },
        where: 'name = ?',
        whereArgs: [location],
      );
    }
  }

  Future<List<String>> getTopLocations({int limit = 10}) async {
    final db = await database;
    final results = await db.query(
      'locations',
      orderBy: 'usage_count DESC, last_used DESC',
      limit: limit,
    );

    return results.map((row) => row['name'] as String).toList();
  }

  Future<List<String>> searchLocations(String query) async {
    final db = await database;
    final results = await db.query(
      'locations',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'usage_count DESC',
      limit: 10,
    );

    return results.map((row) => row['name'] as String).toList();
  }

  // ==================== ANALYTICS OPERATIONS ====================

  Future<Map<String, dynamic>> getAnalytics(DateTime start, DateTime end) async {
    final db = await database;
    final startMs = start.millisecondsSinceEpoch;
    final endMs = end.millisecondsSinceEpoch;

    // Total hours worked
    final totalResult = await db.rawQuery('''
      SELECT SUM(total_worked_minutes) as total_minutes
      FROM pontaj_entries
      WHERE date >= ? AND date <= ?
    ''', [startMs, endMs]);

    final totalMinutes = totalResult.first['total_minutes'] as int? ?? 0;

    // Total unique days worked
    final daysResult = await db.rawQuery('''
      SELECT COUNT(DISTINCT date(date / 1000, 'unixepoch')) as days
      FROM pontaj_entries
      WHERE date >= ? AND date <= ?
    ''', [startMs, endMs]);

    final totalDays = daysResult.first['days'] as int? ?? 0;

    // Total unique employees
    final employeesResult = await db.rawQuery('''
      SELECT COUNT(DISTINCT user) as count
      FROM pontaj_entries
      WHERE date >= ? AND date <= ?
    ''', [startMs, endMs]);

    final totalEmployees = employeesResult.first['count'] as int? ?? 0;

    // Hours per employee
    final perUserResult = await db.rawQuery('''
      SELECT user, SUM(total_worked_minutes) as total_minutes
      FROM pontaj_entries
      WHERE date >= ? AND date <= ?
      GROUP BY user
      ORDER BY total_minutes DESC
    ''', [startMs, endMs]);

    // Location distribution
    final locationResult = await db.rawQuery('''
      SELECT location, COUNT(*) as count
      FROM pontaj_entries
      WHERE date >= ? AND date <= ?
      GROUP BY location
      ORDER BY count DESC
    ''', [startMs, endMs]);

    return {
      'totalMinutes': totalMinutes,
      'totalDays': totalDays,
      'totalEmployees': totalEmployees,
      'perUser': perUserResult,
      'locations': locationResult,
    };
  }

  Future<List<Map<String, dynamic>>> getTopWorkers({int limit = 3}) async {
    final db = await database;

    return await db.rawQuery('''
      SELECT
        user,
        SUM(total_worked_minutes) as total_minutes,
        COUNT(*) as entry_count
      FROM pontaj_entries
      GROUP BY user
      ORDER BY total_minutes DESC
      LIMIT ?
    ''', [limit]);
  }

  Future<List<Map<String, dynamic>>> getRecentEntries({int limit = 5}) async {
    final db = await database;

    return await db.rawQuery('''
      SELECT *
      FROM pontaj_entries
      ORDER BY created_at DESC
      LIMIT ?
    ''', [limit]);
  }

  // ==================== SETTINGS OPERATIONS ====================

  Future<void> saveSetting(String key, String value) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.insert(
      'settings',
      {
        'key': key,
        'value': value,
        'updated_at': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    final results = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );

    return results.isEmpty ? null : results.first['value'] as String;
  }

  // ==================== BACKUP OPERATIONS ====================

  Future<String> createBackup() async {
    final db = await database;
    final dbPath = await getDatabasesPath();
    final backupPath = join(
      dbPath,
      'backups',
      'pontaj_pro_${DateTime.now().millisecondsSinceEpoch}.db',
    );

    // Record in backup log
    await db.insert('backup_log', {
      'backup_path': backupPath,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'size_bytes': 0, // Will be updated after copy
    });

    return backupPath;
  }

  // ==================== UTILITY OPERATIONS ====================

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('pontaj_entries');
    await db.delete('users');
    await db.delete('locations');
    await db.delete('analytics_cache');
    print('✅ All data cleared from database');
  }

  Future<void> vacuum() async {
    final db = await database;
    await db.execute('VACUUM');
    print('✅ Database optimized');
  }

  Future<Map<String, int>> getStats() async {
    final db = await database;

    final usersCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM users')
    ) ?? 0;

    final entriesCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM pontaj_entries')
    ) ?? 0;

    final locationsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM locations')
    ) ?? 0;

    return {
      'users': usersCount,
      'entries': entriesCount,
      'locations': locationsCount,
    };
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
