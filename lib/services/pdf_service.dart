import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path/path.dart' as path;
import '../store.dart';

/// Professional PDF report generator with charts and styling
class PdfService {
  static final PdfService _instance = PdfService._internal();
  factory PdfService() => _instance;
  PdfService._internal();

  /// Generate comprehensive pontaj report with charts
  Future<File> generatePontajReport({
    required List<PontajEntry> entries,
    required String title,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? analytics,
  }) async {
    final pdf = pw.Document();

    // Load custom font
    final fontBold = await PdfGoogleFonts.robotoMedium();
    final fontRegular = await PdfGoogleFonts.robotoRegular();

    // Calculate summary statistics
    final totalHours = entries.fold<double>(
      0,
      (sum, entry) => sum + entry.totalWorked.inMinutes / 60,
    );
    final totalDays = entries.map((e) =>
      DateTime(e.date.year, e.date.month, e.date.day)
    ).toSet().length;
    final uniqueUsers = entries.map((e) => e.user).toSet().length;
    final uniqueLocations = entries.map((e) => e.locatie).toSet().length;

    // Page 1: Cover and Summary
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue700,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'PONTAJ PRO',
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 32,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      title,
                      style: pw.TextStyle(
                        font: fontRegular,
                        fontSize: 18,
                        color: PdfColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),

              // Date Range
              if (startDate != null && endDate != null)
                pw.Container(
                  padding: const pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey400),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'START DATE',
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 10,
                                color: PdfColors.grey600,
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              _formatDate(startDate),
                              style: pw.TextStyle(
                                font: fontRegular,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'END DATE',
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 10,
                                color: PdfColors.grey600,
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              _formatDate(endDate),
                              style: pw.TextStyle(
                                font: fontRegular,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              pw.SizedBox(height: 30),

              // Summary KPIs
              pw.Text(
                'SUMMARY STATISTICS',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 20,
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Row(
                children: [
                  _buildKpiCard('Total Hours', totalHours.toStringAsFixed(1), fontBold, fontRegular),
                  pw.SizedBox(width: 15),
                  _buildKpiCard('Days Worked', totalDays.toString(), fontBold, fontRegular),
                ],
              ),
              pw.SizedBox(height: 15),
              pw.Row(
                children: [
                  _buildKpiCard('Employees', uniqueUsers.toString(), fontBold, fontRegular),
                  pw.SizedBox(width: 15),
                  _buildKpiCard('Locations', uniqueLocations.toString(), fontBold, fontRegular),
                ],
              ),
              pw.SizedBox(height: 30),

              // Generated info
              pw.Spacer(),
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 10),
              pw.Text(
                'Generated on ${_formatDate(DateTime.now())} at ${_formatTime(DateTime.now())}',
                style: pw.TextStyle(
                  font: fontRegular,
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          );
        },
      ),
    );

    // Page 2+: Data Table
    final chunks = _chunkList(entries, 30); // 30 entries per page

    for (int i = 0; i < chunks.length; i++) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Page header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'TIME ENTRIES',
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 18,
                      ),
                    ),
                    pw.Text(
                      'Page ${i + 2} of ${chunks.length + 1}',
                      style: pw.TextStyle(
                        font: fontRegular,
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 15),

                // Data table
                pw.Table.fromTextArray(
                  context: context,
                  headerStyle: pw.TextStyle(
                    font: fontBold,
                    fontSize: 10,
                    color: PdfColors.white,
                  ),
                  headerDecoration: const pw.BoxDecoration(
                    color: PdfColors.blue700,
                  ),
                  cellStyle: pw.TextStyle(
                    font: fontRegular,
                    fontSize: 9,
                  ),
                  cellAlignments: {
                    0: pw.Alignment.centerLeft,
                    1: pw.Alignment.centerLeft,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                    4: pw.Alignment.center,
                    5: pw.Alignment.center,
                  },
                  headers: ['User', 'Location', 'Date', 'Interval', 'Break', 'Total'],
                  data: chunks[i].map((entry) {
                    final hours = entry.totalWorked.inHours;
                    final minutes = entry.totalWorked.inMinutes % 60;
                    return [
                      entry.user,
                      entry.locatie,
                      _formatDate(entry.date),
                      entry.intervalText,
                      '${entry.breakMinutes}m',
                      '${hours}h ${minutes}m',
                    ];
                  }).toList(),
                ),
              ],
            );
          },
        ),
      );
    }

    // Save to file
    final outputPath = await _getOutputPath('pontaj_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    final file = File(outputPath);
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  /// Generate salary report
  Future<File> generateSalaryReport({
    required List<UserRec> users,
    required Map<String, List<PontajEntry>> userEntries,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final pdf = pw.Document();
    final fontBold = await PdfGoogleFonts.robotoMedium();
    final fontRegular = await PdfGoogleFonts.robotoRegular();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColors.green700,
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'SALARY REPORT',
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 28,
                      color: PdfColors.white,
                    ),
                  ),
                  if (startDate != null && endDate != null)
                    pw.Text(
                      '${_formatDate(startDate)} - ${_formatDate(endDate)}',
                      style: pw.TextStyle(
                        font: fontRegular,
                        fontSize: 14,
                        color: PdfColors.white,
                      ),
                    ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Salary breakdown for each user
            ...users.map((user) {
              final entries = userEntries[user.username] ?? [];
              final totalHours = entries.fold<double>(
                0,
                (sum, entry) => sum + entry.totalWorked.inMinutes / 60,
              );

              double salary = 0;
              if (user.salaryType == SalaryType.hourly && user.salaryAmount != null) {
                salary = totalHours * user.salaryAmount!;
              } else if (user.salaryType == SalaryType.monthly) {
                salary = user.salaryAmount ?? 0;
              }

              final currencySymbol = user.currency == Currency.lei ? 'Lei' : '€';

              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 15),
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      user.username,
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 16,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Total Hours: ${totalHours.toStringAsFixed(1)}h',
                              style: pw.TextStyle(font: fontRegular, fontSize: 12)),
                            pw.Text('Days Worked: ${entries.length}',
                              style: pw.TextStyle(font: fontRegular, fontSize: 12)),
                            pw.Text('Salary Type: ${user.salaryType.name}',
                              style: pw.TextStyle(font: fontRegular, fontSize: 12)),
                          ],
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.green100,
                            borderRadius: pw.BorderRadius.circular(8),
                          ),
                          child: pw.Text(
                            '$currencySymbol ${salary.toStringAsFixed(2)}',
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 18,
                              color: PdfColors.green900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),

            // Total
            pw.SizedBox(height: 20),
            pw.Divider(thickness: 2),
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'GRAND TOTAL',
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 18,
                    ),
                  ),
                  pw.Text(
                    'See individual currencies above',
                    style: pw.TextStyle(
                      font: fontRegular,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    final outputPath = await _getOutputPath('salary_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    final file = File(outputPath);
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  pw.Widget _buildKpiCard(String label, String value, pw.Font fontBold, pw.Font fontRegular) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(15),
        decoration: pw.BoxDecoration(
          color: PdfColors.blue50,
          borderRadius: pw.BorderRadius.circular(8),
          border: pw.Border.all(color: PdfColors.blue200),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label.toUpperCase(),
              style: pw.TextStyle(
                font: fontBold,
                fontSize: 10,
                color: PdfColors.blue700,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              value,
              style: pw.TextStyle(
                font: fontBold,
                fontSize: 24,
                color: PdfColors.blue900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    final chunks = <List<T>>[];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  Future<String> _getOutputPath(String fileName) async {
    final home = Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'];
    final desktop = path.join(home!, 'Desktop');
    return path.join(desktop, fileName);
  }

  /// Print PDF directly
  Future<void> printPdf(File pdfFile) async {
    final bytes = await pdfFile.readAsBytes();
    await Printing.layoutPdf(onLayout: (_) => bytes);
  }

  /// Share PDF
  Future<void> sharePdf(File pdfFile) async {
    final bytes = await pdfFile.readAsBytes();
    await Printing.sharePdf(bytes: bytes, filename: path.basename(pdfFile.path));
  }
}
