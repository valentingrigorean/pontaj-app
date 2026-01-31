import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/enums.dart';
import '../models/invoice.dart';

/// Firestore repository for invoices.
class FirestoreInvoiceRepository {
  final FirebaseFirestore _firestore;

  FirestoreInvoiceRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _invoicesCollection =>
      _firestore.collection('invoices');

  /// Get all invoices stream (admin only).
  Stream<List<Invoice>> getAllInvoicesStream() {
    return _invoicesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Invoice.fromFirestore(doc)).toList();
    });
  }

  /// Get invoices for a specific user.
  Stream<List<Invoice>> getInvoicesForUserStream(String userId) {
    return _invoicesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Invoice.fromFirestore(doc)).toList();
    });
  }

  /// Get single invoice by ID.
  Future<Invoice?> getInvoice(String id) async {
    final doc = await _invoicesCollection.doc(id).get();
    if (!doc.exists) return null;
    return Invoice.fromFirestore(doc);
  }

  /// Create a new invoice.
  Future<Invoice> createInvoice(Invoice invoice) async {
    final docRef = await _invoicesCollection.add(invoice.toFirestore());
    return invoice.copyWith(id: docRef.id);
  }

  /// Update invoice status.
  Future<void> updateStatus(String id, InvoiceStatus status) async {
    await _invoicesCollection.doc(id).update({'status': status.name});
  }

  /// Update invoice with PDF info.
  Future<void> updatePdfInfo(
    String id,
    String storagePath,
    String downloadUrl,
  ) async {
    await _invoicesCollection.doc(id).update({
      'pdfStoragePath': storagePath,
      'pdfDownloadUrl': downloadUrl,
    });
  }

  /// Delete an invoice (draft only).
  Future<void> deleteInvoice(String id) async {
    await _invoicesCollection.doc(id).delete();
  }

  /// Generate next invoice number for the year.
  Future<String> generateInvoiceNumber() async {
    final year = DateTime.now().year;
    final prefix = 'INV-$year-';

    // Get the highest invoice number for this year
    final snapshot = await _invoicesCollection
        .where('invoiceNumber', isGreaterThanOrEqualTo: prefix)
        .where('invoiceNumber', isLessThan: '$prefix\uf8ff')
        .orderBy('invoiceNumber', descending: true)
        .limit(1)
        .get();

    int nextNumber = 1;
    if (snapshot.docs.isNotEmpty) {
      final lastNumber = snapshot.docs.first.data()['invoiceNumber'] as String;
      final parts = lastNumber.split('-');
      if (parts.length == 3) {
        nextNumber = (int.tryParse(parts[2]) ?? 0) + 1;
      }
    }

    return '$prefix${nextNumber.toString().padLeft(3, '0')}';
  }

  /// Get invoices by status.
  Stream<List<Invoice>> getInvoicesByStatusStream(InvoiceStatus status) {
    return _invoicesCollection
        .where('status', isEqualTo: status.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Invoice.fromFirestore(doc)).toList();
    });
  }

  /// Get overdue invoices (past due date with status 'sent').
  Future<List<Invoice>> getOverdueInvoices() async {
    final now = DateTime.now();
    final snapshot = await _invoicesCollection
        .where('status', isEqualTo: InvoiceStatus.sent.name)
        .where('dueDate', isLessThan: Timestamp.fromDate(now))
        .get();

    return snapshot.docs.map((doc) => Invoice.fromFirestore(doc)).toList();
  }
}
