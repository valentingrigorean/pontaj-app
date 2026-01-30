import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import '../store.dart';
import 'database_service.dart';

/// Professional import/export service for Excel and CSV
class ImportExportService {
  static final ImportExportService _instance = ImportExportService._internal();
  factory ImportExportService() => _instance;
  ImportExportService._internal();

  final DatabaseService _db = DatabaseService();

  // ==================== IMPORT ====================

  /// Import pontaj entries from Excel file
  Future<ImportResult> importFromExcel() async {
    try {
      // Pick file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result == null || result.files.isEmpty) {
        return ImportResult(success: false, message: 'No file selected');
      }

      final filePath = result.files.first.path;
      if (filePath == null) {
        return ImportResult(success: false, message: 'Invalid file path');
      }

      return await _parseExcelFile(filePath);
    } catch (e) {
      return ImportResult(success: false, message: 'Error: $e');
    }
  }

  Future<ImportResult> _parseExcelFile(String filePath) async {
    try {
      final bytes = File(filePath).readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      int imported = 0;
      int skipped = 0;
      int errors = 0;
      final errorMessages = <String>[];

      for (final table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null) continue;

        // Skip header row
        for (int i = 1; i < sheet.maxRows; i++) {
          try {
            final row = sheet.rows[i];

            // Expected columns: User, Location, Date, Interval, Break, Total Hours
            if (row.length < 5) {
              skipped++;
              continue;
            }

            final user = row[0]?.value?.toString().trim();
            final location = row[1]?.value?.toString().trim();
            final dateStr = row[2]?.value?.toString().trim();
            final interval = row[3]?.value?.toString().trim();
            final breakMinStr = row[4]?.value?.toString().trim();

            if (user == null || location == null || dateStr == null || interval == null) {
              skipped++;
              continue;
            }

            // Parse date
            DateTime? date;
            try {
              // Try various date formats
              if (dateStr.contains('/')) {
                final parts = dateStr.split('/');
                if (parts.length == 3) {
                  date = DateTime(
                    int.parse(parts[2]),
                    int.parse(parts[1]),
                    int.parse(parts[0]),
                  );
                }
              } else if (dateStr.contains('-')) {
                date = DateTime.parse(dateStr);
              }
            } catch (e) {
              errorMessages.add('Row $i: Invalid date format "$dateStr"');
              errors++;
              continue;
            }

            if (date == null) {
              errorMessages.add('Row $i: Could not parse date "$dateStr"');
              errors++;
              continue;
            }

            // Parse break minutes
            int breakMinutes = 0;
            if (breakMinStr != null && breakMinStr.isNotEmpty) {
              try {
                breakMinutes = int.parse(breakMinStr);
              } catch (e) {
                breakMinutes = 0;
              }
            }

            // Calculate total worked time from interval
            Duration totalWorked = Duration.zero;
            try {
              // Parse interval like "08:00 - 16:00"
              final intervalParts = interval.split('-');
              if (intervalParts.length == 2) {
                final startParts = intervalParts[0].trim().split(':');
                final endParts = intervalParts[1].trim().split(':');

                if (startParts.length == 2 && endParts.length == 2) {
                  final startHour = int.parse(startParts[0]);
                  final startMin = int.parse(startParts[1]);
                  final endHour = int.parse(endParts[0]);
                  final endMin = int.parse(endParts[1]);

                  final startMinutes = startHour * 60 + startMin;
                  final endMinutes = endHour * 60 + endMin;
                  final workedMinutes = endMinutes - startMinutes - breakMinutes;

                  totalWorked = Duration(minutes: workedMinutes);
                }
              }
            } catch (e) {
              errorMessages.add('Row $i: Invalid interval format "$interval"');
              errors++;
              continue;
            }

            // Create entry
            final entry = PontajEntry(
              user: user,
              locatie: location,
              intervalText: interval,
              breakMinutes: breakMinutes,
              date: date,
              totalWorked: totalWorked,
            );

            // Check for duplicates
            final duplicate = await _db.findDuplicateEntry(user, date);
            if (duplicate != null) {
              skipped++;
              continue;
            }

            // Insert into database
            await _db.insertPontajEntry(entry);
            await _db.recordLocationUsage(location);
            imported++;

          } catch (e) {
            errorMessages.add('Row $i: $e');
            errors++;
          }
        }
      }

      final message = 'Imported: $imported, Skipped: $skipped, Errors: $errors';
      return ImportResult(
        success: true,
        message: message,
        imported: imported,
        skipped: skipped,
        errors: errors,
        errorMessages: errorMessages,
      );

    } catch (e) {
      return ImportResult(success: false, message: 'Failed to parse Excel: $e');
    }
  }

  /// Import pontaj entries from CSV file
  Future<ImportResult> importFromCSV() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result == null || result.files.isEmpty) {
        return ImportResult(success: false, message: 'No file selected');
      }

      final filePath = result.files.first.path;
      if (filePath == null) {
        return ImportResult(success: false, message: 'Invalid file path');
      }

      return await _parseCSVFile(filePath);
    } catch (e) {
      return ImportResult(success: false, message: 'Error: $e');
    }
  }

  Future<ImportResult> _parseCSVFile(String filePath) async {
    try {
      final file = File(filePath);
      final lines = await file.readAsLines();

      int imported = 0;
      int skipped = 0;
      int errors = 0;
      final errorMessages = <String>[];

      // Skip header
      for (int i = 1; i < lines.length; i++) {
        try {
          final line = lines[i].trim();
          if (line.isEmpty) continue;

          final parts = _parseCSVLine(line);
          if (parts.length < 5) {
            skipped++;
            continue;
          }

          final user = parts[0].trim();
          final location = parts[1].trim();
          final dateStr = parts[2].trim();
          final interval = parts[3].trim();
          final breakMinStr = parts[4].trim();

          if (user.isEmpty || location.isEmpty || dateStr.isEmpty || interval.isEmpty) {
            skipped++;
            continue;
          }

          // Parse date
          DateTime? date;
          try {
            if (dateStr.contains('/')) {
              final dateParts = dateStr.split('/');
              if (dateParts.length == 3) {
                date = DateTime(
                  int.parse(dateParts[2]),
                  int.parse(dateParts[1]),
                  int.parse(dateParts[0]),
                );
              }
            } else if (dateStr.contains('-')) {
              date = DateTime.parse(dateStr);
            }
          } catch (e) {
            errorMessages.add('Line $i: Invalid date "$dateStr"');
            errors++;
            continue;
          }

          if (date == null) {
            errorMessages.add('Line $i: Could not parse date "$dateStr"');
            errors++;
            continue;
          }

          int breakMinutes = 0;
          if (breakMinStr.isNotEmpty) {
            try {
              breakMinutes = int.parse(breakMinStr);
            } catch (e) {
              breakMinutes = 0;
            }
          }

          // Calculate total worked
          Duration totalWorked = Duration.zero;
          try {
            final intervalParts = interval.split('-');
            if (intervalParts.length == 2) {
              final startParts = intervalParts[0].trim().split(':');
              final endParts = intervalParts[1].trim().split(':');

              if (startParts.length == 2 && endParts.length == 2) {
                final startHour = int.parse(startParts[0]);
                final startMin = int.parse(startParts[1]);
                final endHour = int.parse(endParts[0]);
                final endMin = int.parse(endParts[1]);

                final startMinutes = startHour * 60 + startMin;
                final endMinutes = endHour * 60 + endMin;
                final workedMinutes = endMinutes - startMinutes - breakMinutes;

                totalWorked = Duration(minutes: workedMinutes);
              }
            }
          } catch (e) {
            errorMessages.add('Line $i: Invalid interval "$interval"');
            errors++;
            continue;
          }

          final entry = PontajEntry(
            user: user,
            locatie: location,
            intervalText: interval,
            breakMinutes: breakMinutes,
            date: date,
            totalWorked: totalWorked,
          );

          final duplicate = await _db.findDuplicateEntry(user, date);
          if (duplicate != null) {
            skipped++;
            continue;
          }

          await _db.insertPontajEntry(entry);
          await _db.recordLocationUsage(location);
          imported++;

        } catch (e) {
          errorMessages.add('Line $i: $e');
          errors++;
        }
      }

      final message = 'Imported: $imported, Skipped: $skipped, Errors: $errors';
      return ImportResult(
        success: true,
        message: message,
        imported: imported,
        skipped: skipped,
        errors: errors,
        errorMessages: errorMessages,
      );

    } catch (e) {
      return ImportResult(success: false, message: 'Failed to parse CSV: $e');
    }
  }

  List<String> _parseCSVLine(String line) {
    final result = <String>[];
    final buffer = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        result.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    result.add(buffer.toString());
    return result;
  }

  // ==================== EXPORT ====================

  /// Export pontaj entries to Excel
  Future<ExportResult> exportToExcel(List<PontajEntry> entries, String fileName) async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Pontaj'];

      // Add headers with styling
      sheet.appendRow([
        TextCellValue('User'),
        TextCellValue('Location'),
        TextCellValue('Date'),
        TextCellValue('Interval'),
        TextCellValue('Break (min)'),
        TextCellValue('Total Hours'),
      ]);

      // Add data rows
      for (final entry in entries) {
        final hours = entry.totalWorked.inHours;
        final minutes = entry.totalWorked.inMinutes % 60;
        final totalStr = '${hours}h ${minutes}m';

        sheet.appendRow([
          TextCellValue(entry.user),
          TextCellValue(entry.locatie),
          TextCellValue('${entry.date.day.toString().padLeft(2, '0')}/${entry.date.month.toString().padLeft(2, '0')}/${entry.date.year}'),
          TextCellValue(entry.intervalText),
          IntCellValue(entry.breakMinutes),
          TextCellValue(totalStr),
        ]);
      }

      // Save file
      final outputPath = await _getExportPath('$fileName.xlsx');
      final fileBytes = excel.encode();
      if (fileBytes != null) {
        File(outputPath).writeAsBytesSync(fileBytes);
        return ExportResult(success: true, filePath: outputPath);
      }

      return ExportResult(success: false, message: 'Failed to encode Excel file');
    } catch (e) {
      return ExportResult(success: false, message: 'Export failed: $e');
    }
  }

  /// Export pontaj entries to CSV
  Future<ExportResult> exportToCSV(List<PontajEntry> entries, String fileName) async {
    try {
      final buffer = StringBuffer();

      // Add header
      buffer.writeln('User,Location,Date,Interval,Break (min),Total Hours');

      // Add data rows
      for (final entry in entries) {
        final hours = entry.totalWorked.inHours;
        final minutes = entry.totalWorked.inMinutes % 60;
        final totalStr = '${hours}h ${minutes}m';

        final dateStr = '${entry.date.day.toString().padLeft(2, '0')}/${entry.date.month.toString().padLeft(2, '0')}/${entry.date.year}';

        buffer.writeln(
          '"${_escapeCSV(entry.user)}","${_escapeCSV(entry.locatie)}","$dateStr","${_escapeCSV(entry.intervalText)}",${entry.breakMinutes},"$totalStr"',
        );
      }

      // Save file
      final outputPath = await _getExportPath('$fileName.csv');
      File(outputPath).writeAsStringSync(buffer.toString());

      return ExportResult(success: true, filePath: outputPath);
    } catch (e) {
      return ExportResult(success: false, message: 'Export failed: $e');
    }
  }

  String _escapeCSV(String value) {
    return value.replaceAll('"', '""');
  }

  Future<String> _getExportPath(String fileName) async {
    // Get user's Desktop or Downloads folder
    final home = Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'];
    final desktop = path.join(home!, 'Desktop');
    return path.join(desktop, fileName);
  }
}

class ImportResult {
  final bool success;
  final String message;
  final int imported;
  final int skipped;
  final int errors;
  final List<String> errorMessages;

  ImportResult({
    required this.success,
    required this.message,
    this.imported = 0,
    this.skipped = 0,
    this.errors = 0,
    this.errorMessages = const [],
  });
}

class ExportResult {
  final bool success;
  final String? filePath;
  final String? message;

  ExportResult({
    required this.success,
    this.filePath,
    this.message,
  });
}
