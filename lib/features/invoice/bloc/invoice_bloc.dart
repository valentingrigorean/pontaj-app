import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/invoice.dart';
import '../../../data/repositories/firestore_invoice_repository.dart';
import '../../../services/notification_service.dart';
import '../../../services/pdf_service.dart';
import '../../../services/storage_service.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final FirestoreInvoiceRepository _invoiceRepository;
  final PdfService _pdfService;
  final StorageService _storageService;
  final NotificationService _notificationService;

  StreamSubscription<List<Invoice>>? _invoicesSubscription;

  InvoiceBloc({
    required FirestoreInvoiceRepository invoiceRepository,
    required PdfService pdfService,
    required StorageService storageService,
    required NotificationService notificationService,
  })  : _invoiceRepository = invoiceRepository,
        _pdfService = pdfService,
        _storageService = storageService,
        _notificationService = notificationService,
        super(const InvoiceState.initial()) {
    on<LoadInvoices>(_onLoadInvoices);
    on<CreateInvoice>(_onCreateInvoice);
    on<UpdateInvoiceStatus>(_onUpdateStatus);
    on<GenerateInvoicePdf>(_onGeneratePdf);
    on<DeleteInvoice>(_onDeleteInvoice);
    on<SendInvoice>(_onSendInvoice);
  }

  Future<void> _onLoadInvoices(
    LoadInvoices event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(const InvoiceState.loading());

    await _invoicesSubscription?.cancel();

    final stream = event.isAdmin
        ? _invoiceRepository.getAllInvoicesStream()
        : _invoiceRepository.getInvoicesForUserStream(event.userId!);

    _invoicesSubscription = stream.listen(
      (invoices) {
        add(LoadInvoices(userId: event.userId, isAdmin: event.isAdmin));
      },
      onError: (error) {
        emit(InvoiceState.error(message: error.toString()));
      },
    );

    // For initial load, get snapshot
    try {
      await emit.forEach(
        stream,
        onData: (invoices) => InvoiceState.loaded(
          invoices: invoices,
          isAdmin: event.isAdmin,
        ),
        onError: (error, _) => InvoiceState.error(message: error.toString()),
      );
    } catch (e) {
      emit(InvoiceState.error(message: e.toString()));
    }
  }

  Future<void> _onCreateInvoice(
    CreateInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    final currentState = state;
    final currentInvoices = currentState is InvoiceLoaded
        ? currentState.invoices
        : <Invoice>[];

    try {
      final invoiceNumber = await _invoiceRepository.generateInvoiceNumber();

      final invoice = Invoice(
        id: '', // Will be set by Firestore
        userId: event.summary.userId,
        userName: event.summary.userName,
        periodStart: event.summary.periodStart,
        periodEnd: event.summary.periodEnd,
        totalHours: event.summary.totalHours,
        hourlyRate: event.summary.hourlyRate ?? 0,
        totalAmount: event.summary.totalAmount ?? 0,
        currency: event.summary.currency,
        status: InvoiceStatus.draft,
        invoiceNumber: invoiceNumber,
        dueDate: event.dueDate,
        entryIds: event.summary.entryIds,
        createdBy: event.createdBy,
        notes: event.notes,
      );

      await _invoiceRepository.createInvoice(invoice);
      // Stream will update the state automatically
    } catch (e) {
      emit(InvoiceState.error(
        message: 'Failed to create invoice: $e',
        previousInvoices: currentInvoices,
      ));
    }
  }

  Future<void> _onUpdateStatus(
    UpdateInvoiceStatus event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      await _invoiceRepository.updateStatus(event.invoiceId, event.status);
      // Stream will update the state automatically
    } catch (e) {
      final currentState = state;
      emit(InvoiceState.error(
        message: 'Failed to update status: $e',
        previousInvoices:
            currentState is InvoiceLoaded ? currentState.invoices : null,
      ));
    }
  }

  Future<void> _onGeneratePdf(
    GenerateInvoicePdf event,
    Emitter<InvoiceState> emit,
  ) async {
    final currentState = state;
    if (currentState is! InvoiceLoaded) return;
    final invoiceId = event.invoice.id;
    if (invoiceId == null) return;

    emit(InvoiceState.pdfGenerating(
      invoices: currentState.invoices,
      invoiceId: invoiceId,
    ));

    try {
      final pdfBytes = await _pdfService.generateInvoicePdf(event.invoice);
      final storagePath = 'invoices/${event.invoice.userId}/$invoiceId.pdf';
      final downloadUrl = await _storageService.uploadFile(
        path: storagePath,
        data: pdfBytes,
        contentType: 'application/pdf',
      );

      await _invoiceRepository.updatePdfInfo(invoiceId, storagePath, downloadUrl);

      emit(InvoiceState.pdfGenerated(
        invoices: currentState.invoices,
        invoiceId: invoiceId,
        downloadUrl: downloadUrl,
      ));
    } catch (e) {
      emit(InvoiceState.error(
        message: 'Failed to generate PDF: $e',
        previousInvoices: currentState.invoices,
      ));
    }
  }

  Future<void> _onDeleteInvoice(
    DeleteInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      await _invoiceRepository.deleteInvoice(event.invoiceId);
      // Stream will update the state automatically
    } catch (e) {
      final currentState = state;
      emit(InvoiceState.error(
        message: 'Failed to delete invoice: $e',
        previousInvoices:
            currentState is InvoiceLoaded ? currentState.invoices : null,
      ));
    }
  }

  Future<void> _onSendInvoice(
    SendInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    final invoiceId = event.invoice.id;
    if (invoiceId == null) return;

    try {
      await _invoiceRepository.updateStatus(invoiceId, InvoiceStatus.sent);

      // Send notification to worker
      await _notificationService.sendInvoiceNotification(
        userId: event.invoice.userId,
        invoiceId: invoiceId,
        invoiceNumber: event.invoice.invoiceNumber,
        amount: event.invoice.formattedAmount,
      );
    } catch (e) {
      final currentState = state;
      emit(InvoiceState.error(
        message: 'Failed to send invoice: $e',
        previousInvoices:
            currentState is InvoiceLoaded ? currentState.invoices : null,
      ));
    }
  }

  @override
  Future<void> close() {
    _invoicesSubscription?.cancel();
    return super.close();
  }
}
