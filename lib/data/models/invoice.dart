import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters/timestamp_converter.dart';
import 'converters/server_timestamp_converter.dart';
import 'enums.dart';

part 'invoice.freezed.dart';
part 'invoice.g.dart';

@freezed
abstract class Invoice with _$Invoice {
  const Invoice._();

  const factory Invoice({
    String? id,
    required String userId,
    required String userName,
    @TimestampConverter() required DateTime periodStart,
    @TimestampConverter() required DateTime periodEnd,
    required double totalHours,
    required double hourlyRate,
    required double totalAmount,
    @Default(Currency.lei) Currency currency,
    @Default(InvoiceStatus.draft) InvoiceStatus status,
    required String invoiceNumber,
    @NullableTimestampConverter() DateTime? dueDate,
    String? pdfStoragePath,
    String? pdfDownloadUrl,
    @Default([]) List<String> entryIds,
    @ServerTimestampConverter() DateTime? createdAt,
    required String createdBy,
    String? notes,
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);

  factory Invoice.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Invoice.fromJson({...data, 'id': doc.id});
  }

  // Getters
  bool get canEdit => !status.isFinal;
  bool get canCancel => status != InvoiceStatus.cancelled && status != InvoiceStatus.paid;
  String get formattedAmount => '${totalAmount.toStringAsFixed(2)} ${currency.symbol}';
  String get periodDisplay =>
      '${periodStart.day}/${periodStart.month}/${periodStart.year} - '
      '${periodEnd.day}/${periodEnd.month}/${periodEnd.year}';

  // Firestore
  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'userName': userName,
        'periodStart': Timestamp.fromDate(periodStart),
        'periodEnd': Timestamp.fromDate(periodEnd),
        'totalHours': totalHours,
        'hourlyRate': hourlyRate,
        'totalAmount': totalAmount,
        'currency': currency.name,
        'status': status.name,
        'invoiceNumber': invoiceNumber,
        if (dueDate != null) 'dueDate': Timestamp.fromDate(dueDate!),
        if (pdfStoragePath != null) 'pdfStoragePath': pdfStoragePath,
        if (pdfDownloadUrl != null) 'pdfDownloadUrl': pdfDownloadUrl,
        'entryIds': entryIds,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': createdBy,
        if (notes != null) 'notes': notes,
      };
}
