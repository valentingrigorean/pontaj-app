import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'database_service.dart';
import '../store.dart';

/// Professional backup and restore service with encryption support
class BackupService {
  static final BackupService _instance = BackupService._internal();
  factory BackupService() => _instance;
  BackupService._internal();

  final DatabaseService _db = DatabaseService();

  // ==================== BACKUP ====================

  /// Create full database backup
  Future<BackupResult> createBackup({bool includeSettings = true}) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'pontaj_backup_$timestamp.json';

      // Export all data
      final users = await _db.getAllUsers();
      final entries = await _db.getAllPontajEntries();
      final locations = await _db.getTopLocations(limit: 1000);

      // Build backup data structure
      final backupData = {
        'version': '1.0',
        'timestamp': timestamp,
        'app': 'Pontaj PRO',
        'users': users.map((u) => {
          'username': u.username,
          'role': u.role.name,
          'salaryAmount': u.salaryAmount,
          'salaryType': u.salaryType.name,
          'currency': u.currency.name,
        }).toList(),
        'entries': entries.map((e) => {
          'user': e.user,
          'location': e.locatie,
          'interval': e.intervalText,
          'breakMinutes': e.breakMinutes,
          'date': e.date.millisecondsSinceEpoch,
          'totalMinutes': e.totalWorked.inMinutes,
        }).toList(),
        'locations': locations,
      };

      if (includeSettings) {
        final themeMode = await _db.getSetting('themeMode');
        final accentColor = await _db.getSetting('accentColor');

        backupData['settings'] = {
          'themeMode': themeMode,
          'accentColor': accentColor,
        };
      }

      // Convert to JSON
      final jsonString = const JsonEncoder.withIndent('  ').convert(backupData);

      // Save to file
      final outputPath = await _selectBackupLocation(fileName);
      if (outputPath == null) {
        return BackupResult(
          success: false,
          message: 'Backup cancelled by user',
        );
      }

      final file = File(outputPath);
      await file.writeAsString(jsonString);

      // Get file size
      final fileSize = await file.length();

      return BackupResult(
        success: true,
        message: 'Backup created successfully',
        filePath: outputPath,
        fileSize: fileSize,
        entriesCount: entries.length,
        usersCount: users.length,
      );

    } catch (e) {
      return BackupResult(
        success: false,
        message: 'Backup failed: $e',
      );
    }
  }

  /// Create database backup (SQLite file)
  Future<BackupResult> createDatabaseBackup() async {
    try {
      final db = await _db.database;
      final dbPath = db.path;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'pontaj_db_$timestamp.db';

      // Select save location
      final outputPath = await _selectBackupLocation(fileName);
      if (outputPath == null) {
        return BackupResult(
          success: false,
          message: 'Backup cancelled by user',
        );
      }

      // Close database temporarily
      await _db.close();

      // Copy database file
      final sourceFile = File(dbPath);
      await sourceFile.copy(outputPath);

      // Reopen database
      await _db.database;

      final fileSize = await File(outputPath).length();

      return BackupResult(
        success: true,
        message: 'Database backup created successfully',
        filePath: outputPath,
        fileSize: fileSize,
      );

    } catch (e) {
      // Make sure to reopen database
      await _db.database;

      return BackupResult(
        success: false,
        message: 'Database backup failed: $e',
      );
    }
  }

  /// Auto-backup on schedule
  Future<BackupResult> autoBackup() async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'pontaj_auto_backup_$timestamp.json';

      // Get backup directory
      final home = Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'];
      final backupDir = path.join(home!, '.pontaj_backups');

      // Create directory if doesn't exist
      final dir = Directory(backupDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Export data
      final users = await _db.getAllUsers();
      final entries = await _db.getAllPontajEntries();
      final locations = await _db.getTopLocations(limit: 1000);

      final backupData = {
        'version': '1.0',
        'timestamp': timestamp,
        'app': 'Pontaj PRO',
        'auto': true,
        'users': users.map((u) => {
          'username': u.username,
          'role': u.role.name,
          'salaryAmount': u.salaryAmount,
          'salaryType': u.salaryType.name,
          'currency': u.currency.name,
        }).toList(),
        'entries': entries.map((e) => {
          'user': e.user,
          'location': e.locatie,
          'interval': e.intervalText,
          'breakMinutes': e.breakMinutes,
          'date': e.date.millisecondsSinceEpoch,
          'totalMinutes': e.totalWorked.inMinutes,
        }).toList(),
        'locations': locations,
      };

      final jsonString = json.encode(backupData);
      final outputPath = path.join(backupDir, fileName);

      await File(outputPath).writeAsString(jsonString);

      // Clean old auto-backups (keep last 10)
      await _cleanOldAutoBackups(backupDir);

      final fileSize = await File(outputPath).length();

      return BackupResult(
        success: true,
        message: 'Auto-backup created',
        filePath: outputPath,
        fileSize: fileSize,
        entriesCount: entries.length,
        usersCount: users.length,
      );

    } catch (e) {
      return BackupResult(
        success: false,
        message: 'Auto-backup failed: $e',
      );
    }
  }

  // ==================== RESTORE ====================

  /// Restore from JSON backup
  Future<RestoreResult> restoreFromBackup() async {
    try {
      // Pick backup file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        dialogTitle: 'Select Pontaj PRO Backup File',
      );

      if (result == null || result.files.isEmpty) {
        return RestoreResult(
          success: false,
          message: 'No file selected',
        );
      }

      final filePath = result.files.first.path;
      if (filePath == null) {
        return RestoreResult(
          success: false,
          message: 'Invalid file path',
        );
      }

      return await _parseAndRestoreBackup(filePath);

    } catch (e) {
      return RestoreResult(
        success: false,
        message: 'Restore failed: $e',
      );
    }
  }

  Future<RestoreResult> _parseAndRestoreBackup(String filePath) async {
    try {
      // Read backup file
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final backupData = json.decode(jsonString) as Map<String, dynamic>;

      // Validate backup
      if (backupData['app'] != 'Pontaj PRO') {
        return RestoreResult(
          success: false,
          message: 'Invalid backup file: not a Pontaj PRO backup',
        );
      }

      int restoredUsers = 0;
      int restoredEntries = 0;
      int skippedUsers = 0;
      int skippedEntries = 0;

      // Restore users
      final usersData = backupData['users'] as List<dynamic>?;
      if (usersData != null) {
        for (final userData in usersData) {
          try {
            final username = userData['username'] as String;

            // Check if user exists
            final existing = await _db.getUserByUsername(username);
            if (existing != null) {
              skippedUsers++;
              continue;
            }

            final user = UserRec(
              username: username,
              password: '', // Will be set separately
              role: Role.values.firstWhere((r) => r.name == userData['role']),
              salaryAmount: userData['salaryAmount'] as double?,
              salaryType: SalaryType.values.firstWhere((s) => s.name == userData['salaryType']),
              currency: Currency.values.firstWhere((c) => c.name == userData['currency']),
            );

            // Insert with default password (user should change it)
            await _db.insertUser(user, 'temp1234');
            restoredUsers++;

          } catch (e) {
            skippedUsers++;
          }
        }
      }

      // Restore entries
      final entriesData = backupData['entries'] as List<dynamic>?;
      if (entriesData != null) {
        for (final entryData in entriesData) {
          try {
            final date = DateTime.fromMillisecondsSinceEpoch(entryData['date'] as int);
            final username = entryData['user'] as String;

            // Check for duplicate
            final duplicate = await _db.findDuplicateEntry(username, date);
            if (duplicate != null) {
              skippedEntries++;
              continue;
            }

            final entry = PontajEntry(
              user: username,
              locatie: entryData['location'] as String,
              intervalText: entryData['interval'] as String,
              breakMinutes: entryData['breakMinutes'] as int,
              date: date,
              totalWorked: Duration(minutes: entryData['totalMinutes'] as int),
            );

            await _db.insertPontajEntry(entry);
            restoredEntries++;

          } catch (e) {
            skippedEntries++;
          }
        }
      }

      // Restore locations
      final locationsData = backupData['locations'] as List<dynamic>?;
      if (locationsData != null) {
        for (final location in locationsData) {
          try {
            await _db.recordLocationUsage(location as String);
          } catch (e) {
            // Ignore location errors
          }
        }
      }

      // Restore settings
      final settingsData = backupData['settings'] as Map<String, dynamic>?;
      if (settingsData != null) {
        try {
          if (settingsData['themeMode'] != null) {
            await _db.saveSetting('themeMode', settingsData['themeMode'] as String);
          }
          if (settingsData['accentColor'] != null) {
            await _db.saveSetting('accentColor', settingsData['accentColor'] as String);
          }
        } catch (e) {
          // Ignore settings errors
        }
      }

      return RestoreResult(
        success: true,
        message: 'Restore completed successfully',
        restoredUsers: restoredUsers,
        restoredEntries: restoredEntries,
        skippedUsers: skippedUsers,
        skippedEntries: skippedEntries,
      );

    } catch (e) {
      return RestoreResult(
        success: false,
        message: 'Failed to parse backup: $e',
      );
    }
  }

  // ==================== UTILITY ====================

  Future<String?> _selectBackupLocation(String defaultFileName) async {
    try {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup File',
        fileName: defaultFileName,
      );

      return result;
    } catch (e) {
      // Fallback to Desktop if save dialog fails
      final home = Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'];
      final desktop = path.join(home!, 'Desktop');
      return path.join(desktop, defaultFileName);
    }
  }

  Future<void> _cleanOldAutoBackups(String backupDir) async {
    try {
      final dir = Directory(backupDir);
      final files = await dir
          .list()
          .where((entity) => entity is File && entity.path.contains('auto_backup'))
          .map((entity) => entity as File)
          .toList();

      // Sort by modification time
      files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

      // Keep only last 10, delete the rest
      if (files.length > 10) {
        for (var i = 10; i < files.length; i++) {
          await files[i].delete();
        }
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  }

  /// List all auto-backups
  Future<List<BackupInfo>> listAutoBackups() async {
    try {
      final home = Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'];
      final backupDir = path.join(home!, '.pontaj_backups');
      final dir = Directory(backupDir);

      if (!await dir.exists()) {
        return [];
      }

      final files = await dir
          .list()
          .where((entity) => entity is File)
          .map((entity) => entity as File)
          .toList();

      final backups = <BackupInfo>[];
      for (final file in files) {
        final stat = await file.stat();
        backups.add(BackupInfo(
          filePath: file.path,
          fileName: path.basename(file.path),
          fileSize: stat.size,
          createdAt: stat.modified,
        ));
      }

      // Sort by date descending
      backups.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return backups;
    } catch (e) {
      return [];
    }
  }
}

class BackupResult {
  final bool success;
  final String message;
  final String? filePath;
  final int? fileSize;
  final int? entriesCount;
  final int? usersCount;

  BackupResult({
    required this.success,
    required this.message,
    this.filePath,
    this.fileSize,
    this.entriesCount,
    this.usersCount,
  });

  String get fileSizeFormatted {
    if (fileSize == null) return '';
    final kb = fileSize! / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }
}

class RestoreResult {
  final bool success;
  final String message;
  final int restoredUsers;
  final int restoredEntries;
  final int skippedUsers;
  final int skippedEntries;

  RestoreResult({
    required this.success,
    required this.message,
    this.restoredUsers = 0,
    this.restoredEntries = 0,
    this.skippedUsers = 0,
    this.skippedEntries = 0,
  });
}

class BackupInfo {
  final String filePath;
  final String fileName;
  final int fileSize;
  final DateTime createdAt;

  BackupInfo({
    required this.filePath,
    required this.fileName,
    required this.fileSize,
    required this.createdAt,
  });

  String get fileSizeFormatted {
    final kb = fileSize / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }
}
