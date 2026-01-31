import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/invoice.dart';
import '../../../data/models/period_summary.dart';

part 'invoice_event.freezed.dart';

@freezed
sealed class InvoiceEvent with _$InvoiceEvent {
  /// Load all invoices (admin) or user's invoices.
  const factory InvoiceEvent.loadInvoices({
    String? userId,
    @Default(false) bool isAdmin,
  }) = LoadInvoices;

  /// Create a new invoice from period summary.
  const factory InvoiceEvent.createInvoice({
    required PeriodSummary summary,
    required String createdBy,
    DateTime? dueDate,
    String? notes,
  }) = CreateInvoice;

  /// Update invoice status.
  const factory InvoiceEvent.updateStatus({
    required String invoiceId,
    required InvoiceStatus status,
  }) = UpdateInvoiceStatus;

  /// Generate and upload PDF for invoice.
  const factory InvoiceEvent.generatePdf({
    required Invoice invoice,
  }) = GenerateInvoicePdf;

  /// Delete a draft invoice.
  const factory InvoiceEvent.deleteInvoice({
    required String invoiceId,
  }) = DeleteInvoice;

  /// Mark invoice as sent and notify worker.
  const factory InvoiceEvent.sendInvoice({
    required Invoice invoice,
  }) = SendInvoice;
}
