import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/invoice.dart';

part 'invoice_state.freezed.dart';

@freezed
sealed class InvoiceState with _$InvoiceState {
  const factory InvoiceState.initial() = InvoiceInitial;

  const factory InvoiceState.loading() = InvoiceLoading;

  const factory InvoiceState.loaded({
    required List<Invoice> invoices,
    @Default(false) bool isAdmin,
  }) = InvoiceLoaded;

  const factory InvoiceState.error({
    required String message,
    List<Invoice>? previousInvoices,
  }) = InvoiceError;

  const factory InvoiceState.pdfGenerating({
    required List<Invoice> invoices,
    required String invoiceId,
  }) = InvoicePdfGenerating;

  const factory InvoiceState.pdfGenerated({
    required List<Invoice> invoices,
    required String invoiceId,
    required String downloadUrl,
  }) = InvoicePdfGenerated;
}
