import 'database_service.dart';
import 'auth_service.dart';
import '../store.dart';

/// Migration service to move data from old JSON storage to new SQLite database
class MigrationService {
  static final MigrationService _instance = MigrationService._internal();
  factory MigrationService() => _instance;
  MigrationService._internal();

  final DatabaseService _db = DatabaseService();
  final AuthService _auth = AuthService();

  bool _isMigrated = false;
  bool get isMigrated => _isMigrated;

  /// Check if migration is needed
  Future<bool> needsMigration() async {
    try {
      // Check if database has any data
      final stats = await _db.getStats();
      return stats['users'] == 0 && stats['entries'] == 0;
    } catch (e) {
      return true; // Assume migration needed if check fails
    }
  }

  /// Migrate all data from AppStore to SQLite database
  Future<MigrationResult> migrateFromAppStore(AppStore appStore) async {
    try {
      int migratedUsers = 0;
      int migratedEntries = 0;
      int migratedLocations = 0;
      int failedUsers = 0;
      int failedEntries = 0;
      final errors = <String>[];

      // Migrate users
      for (final user in appStore.users) {
        try {
          // Check if user already exists
          final existing = await _db.getUserByUsername(user.username);
          if (existing != null) {
            continue; // Skip existing users
          }

          // Hash the password
          final passwordHash = await _auth.hashPassword(user.password);

          // Insert user
          await _db.insertUser(user, passwordHash);
          migratedUsers++;

        } catch (e) {
          failedUsers++;
          errors.add('Failed to migrate user ${user.username}: $e');
        }
      }

      // Migrate pontaj entries
      for (final entry in appStore.entries) {
        try {
          // Check for duplicates
          final duplicate = await _db.findDuplicateEntry(entry.user, entry.date);
          if (duplicate != null) {
            continue; // Skip duplicates
          }

          // Insert entry
          await _db.insertPontajEntry(entry);
          migratedEntries++;

        } catch (e) {
          failedEntries++;
          errors.add('Failed to migrate entry for ${entry.user} on ${entry.date}: $e');
        }
      }

      // Migrate locations
      for (final location in appStore.locatii) {
        try {
          await _db.recordLocationUsage(location);
          migratedLocations++;
        } catch (e) {
          // Ignore location migration errors
        }
      }

      _isMigrated = true;

      return MigrationResult(
        success: true,
        message: 'Migration completed successfully',
        migratedUsers: migratedUsers,
        migratedEntries: migratedEntries,
        migratedLocations: migratedLocations,
        failedUsers: failedUsers,
        failedEntries: failedEntries,
        errors: errors,
      );

    } catch (e) {
      return MigrationResult(
        success: false,
        message: 'Migration failed: $e',
        errors: ['Critical error: $e'],
      );
    }
  }

  /// Auto-migrate on app start if needed
  Future<MigrationResult> autoMigrate(AppStore appStore) async {
    final needsMig = await needsMigration();
    if (!needsMig) {
      _isMigrated = true;
      return MigrationResult(
        success: true,
        message: 'Database already populated, no migration needed',
      );
    }

    // Check if AppStore has data
    if (appStore.users.isEmpty && appStore.entries.isEmpty) {
      _isMigrated = true;
      return MigrationResult(
        success: true,
        message: 'No data to migrate',
      );
    }

    return await migrateFromAppStore(appStore);
  }

  /// Create initial admin user if none exists
  Future<bool> ensureAdminExists() async {
    try {
      final adminUser = await _db.getUserByUsername('Ilie');
      if (adminUser != null) {
        return true; // Admin already exists
      }

      // Create default admin
      final admin = UserRec(
        username: 'Ilie',
        password: '', // Not used
        role: Role.admin,
        salaryAmount: null,
        salaryType: SalaryType.hourly,
        currency: Currency.lei,
      );

      final passwordHash = await _auth.hashPassword('1234');
      await _db.insertUser(admin, passwordHash);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Verify migration integrity
  Future<MigrationVerification> verifyMigration(AppStore appStore) async {
    try {
      final dbStats = await _db.getStats();
      final issues = <String>[];

      // Check user count
      if (dbStats['users'] != appStore.users.length) {
        issues.add('User count mismatch: DB has ${dbStats['users']}, AppStore has ${appStore.users.length}');
      }

      // Check entry count
      if (dbStats['entries'] != appStore.entries.length) {
        issues.add('Entry count mismatch: DB has ${dbStats['entries']}, AppStore has ${appStore.entries.length}');
      }

      // Verify each user exists
      for (final user in appStore.users) {
        final dbUser = await _db.getUserByUsername(user.username);
        if (dbUser == null) {
          issues.add('User ${user.username} missing from database');
        }
      }

      // Sample check some entries
      if (appStore.entries.isNotEmpty) {
        final sampleSize = (appStore.entries.length * 0.1).ceil();
        for (int i = 0; i < sampleSize && i < appStore.entries.length; i++) {
          final entry = appStore.entries[i];
          final dbEntry = await _db.findDuplicateEntry(entry.user, entry.date);
          if (dbEntry == null) {
            issues.add('Entry for ${entry.user} on ${entry.date} missing from database');
          }
        }
      }

      return MigrationVerification(
        isValid: issues.isEmpty,
        dbUserCount: dbStats['users']!,
        dbEntryCount: dbStats['entries']!,
        originalUserCount: appStore.users.length,
        originalEntryCount: appStore.entries.length,
        issues: issues,
      );

    } catch (e) {
      return MigrationVerification(
        isValid: false,
        dbUserCount: 0,
        dbEntryCount: 0,
        originalUserCount: appStore.users.length,
        originalEntryCount: appStore.entries.length,
        issues: ['Verification error: $e'],
      );
    }
  }

  /// Rollback migration (clear database)
  Future<bool> rollbackMigration() async {
    try {
      await _db.clearAllData();
      _isMigrated = false;
      return true;
    } catch (e) {
      return false;
    }
  }
}

class MigrationResult {
  final bool success;
  final String message;
  final int migratedUsers;
  final int migratedEntries;
  final int migratedLocations;
  final int failedUsers;
  final int failedEntries;
  final List<String> errors;

  MigrationResult({
    required this.success,
    required this.message,
    this.migratedUsers = 0,
    this.migratedEntries = 0,
    this.migratedLocations = 0,
    this.failedUsers = 0,
    this.failedEntries = 0,
    this.errors = const [],
  });

  String get summary {
    if (!success) return message;

    final parts = <String>[];
    if (migratedUsers > 0) parts.add('$migratedUsers users');
    if (migratedEntries > 0) parts.add('$migratedEntries entries');
    if (migratedLocations > 0) parts.add('$migratedLocations locations');

    if (parts.isEmpty) return message;

    var result = 'Migrated: ${parts.join(', ')}';
    if (failedUsers > 0 || failedEntries > 0) {
      result += ' (Failed: $failedUsers users, $failedEntries entries)';
    }

    return result;
  }
}

class MigrationVerification {
  final bool isValid;
  final int dbUserCount;
  final int dbEntryCount;
  final int originalUserCount;
  final int originalEntryCount;
  final List<String> issues;

  MigrationVerification({
    required this.isValid,
    required this.dbUserCount,
    required this.dbEntryCount,
    required this.originalUserCount,
    required this.originalEntryCount,
    required this.issues,
  });

  String get summary {
    if (isValid) {
      return 'Migration verified: All $dbUserCount users and $dbEntryCount entries migrated successfully';
    } else {
      return 'Migration issues found: ${issues.join(', ')}';
    }
  }
}
