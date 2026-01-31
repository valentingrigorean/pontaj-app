import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/invoice.dart';
import '../../../services/pdf_service.dart';
import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_event.dart';
import '../bloc/invoice_state.dart';

class InvoiceDetailPage extends StatelessWidget {
  final String invoiceId;
  final bool isAdmin;

  const InvoiceDetailPage({
    super.key,
    required this.invoiceId,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        Invoice? invoice;

        if (state is InvoiceLoaded) {
          invoice = state.invoices.where((i) => i.id == invoiceId).firstOrNull;
        } else if (state is InvoicePdfGenerating) {
          invoice = state.invoices.where((i) => i.id == invoiceId).firstOrNull;
        } else if (state is InvoicePdfGenerated) {
          invoice = state.invoices.where((i) => i.id == invoiceId).firstOrNull;
        }

        if (invoice == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Invoice')),
            body: const Center(child: Text('Invoice not found')),
          );
        }

        final isPdfGenerating =
            state is InvoicePdfGenerating && state.invoiceId == invoiceId;

        return Scaffold(
          appBar: AppBar(
            title: Text(invoice.invoiceNumber),
            actions: [
              if (invoice.pdfDownloadUrl != null)
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => _downloadPdf(context, invoice!),
                  tooltip: 'Download PDF',
                ),
              IconButton(
                icon: const Icon(Icons.print),
                onPressed: isPdfGenerating
                    ? null
                    : () => _printInvoice(context, invoice!),
                tooltip: 'Print',
              ),
              if (isAdmin && invoice.canEdit)
                PopupMenuButton<String>(
                  onSelected: (value) =>
                      _handleMenuAction(context, invoice!, value),
                  itemBuilder: (context) => [
                    if (invoice!.status == InvoiceStatus.draft)
                      const PopupMenuItem(
                        value: 'send',
                        child: ListTile(
                          leading: Icon(Icons.send),
                          title: Text('Send Invoice'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    if (invoice.status == InvoiceStatus.sent)
                      const PopupMenuItem(
                        value: 'paid',
                        child: ListTile(
                          leading: Icon(Icons.check_circle),
                          title: Text('Mark as Paid'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    if (invoice.canCancel)
                      const PopupMenuItem(
                        value: 'cancel',
                        child: ListTile(
                          leading: Icon(Icons.cancel),
                          title: Text('Cancel Invoice'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    if (invoice.status == InvoiceStatus.draft)
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title:
                              Text('Delete', style: TextStyle(color: Colors.red)),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                  ],
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatusBanner(context, invoice),
                const SizedBox(height: 16),
                _buildInfoCard(context, invoice),
                const SizedBox(height: 16),
                _buildAmountCard(context, invoice),
                if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildNotesCard(context, invoice),
                ],
                if (isPdfGenerating) ...[
                  const SizedBox(height: 16),
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Generating PDF...'),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBanner(BuildContext context, Invoice invoice) {
    final (color, icon, message) = switch (invoice.status) {
      InvoiceStatus.draft => (
          Colors.grey,
          Icons.edit_outlined,
          'This invoice is a draft'
        ),
      InvoiceStatus.sent => (
          Colors.blue,
          Icons.send_outlined,
          'Invoice sent to worker'
        ),
      InvoiceStatus.paid => (
          Colors.green,
          Icons.check_circle_outlined,
          'Invoice has been paid'
        ),
      InvoiceStatus.overdue => (
          Colors.orange,
          Icons.warning_outlined,
          'Payment is overdue'
        ),
      InvoiceStatus.cancelled => (
          Colors.red,
          Icons.cancel_outlined,
          'Invoice was cancelled'
        ),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, Invoice invoice) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice Details',
              style: theme.textTheme.titleMedium,
            ),
            const Divider(),
            _buildDetailRow('Worker', invoice.userName),
            _buildDetailRow('Period', invoice.periodDisplay),
            _buildDetailRow('Total Hours', invoice.totalHours.toStringAsFixed(2)),
            _buildDetailRow(
              'Hourly Rate',
              '${invoice.hourlyRate.toStringAsFixed(2)} ${invoice.currency.symbol}',
            ),
            if (invoice.dueDate != null)
              _buildDetailRow('Due Date', _formatDate(invoice.dueDate!)),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard(BuildContext context, Invoice invoice) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Total Amount',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              invoice.formattedAmount,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context, Invoice invoice) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(invoice.notes!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _handleMenuAction(BuildContext context, Invoice invoice, String action) {
    final invoiceId = invoice.id;
    if (invoiceId == null) return;

    final bloc = context.read<InvoiceBloc>();

    switch (action) {
      case 'send':
        bloc.add(SendInvoice(invoice: invoice));
        break;
      case 'paid':
        bloc.add(UpdateInvoiceStatus(invoiceId: invoiceId, status: InvoiceStatus.paid));
        break;
      case 'cancel':
        _showConfirmDialog(
          context,
          'Cancel Invoice',
          'Are you sure you want to cancel this invoice?',
          () => bloc.add(UpdateInvoiceStatus(invoiceId: invoiceId, status: InvoiceStatus.cancelled)),
        );
        break;
      case 'delete':
        _showConfirmDialog(
          context,
          'Delete Invoice',
          'Are you sure you want to delete this draft invoice?',
          () {
            bloc.add(DeleteInvoice(invoiceId: invoiceId));
            context.pop();
          },
        );
        break;
    }
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _printInvoice(BuildContext context, Invoice invoice) async {
    final pdfService = PdfService();
    final pdfBytes = await pdfService.generateInvoicePdf(invoice);

    await Printing.layoutPdf(
      onLayout: (_) => pdfBytes,
      name: invoice.invoiceNumber,
    );
  }

  Future<void> _downloadPdf(BuildContext context, Invoice invoice) async {
    if (invoice.pdfDownloadUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF not available')),
      );
      return;
    }

    final url = Uri.parse(invoice.pdfDownloadUrl!);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open PDF')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening PDF: $e')),
        );
      }
    }
  }
}
