import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/invoice.dart';
import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_state.dart';
import '../widgets/invoice_bottom_sheet.dart';

class InvoiceListPage extends StatelessWidget {
  final bool isAdmin;
  final bool embedded;

  const InvoiceListPage({
    super.key,
    this.isAdmin = false,
    this.embedded = false,
  });

  void _showCreateInvoiceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const InvoiceBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: embedded
          ? null
          : AppBar(
              title: const Text('Invoices'),
              actions: [
                if (isAdmin)
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _showCreateInvoiceSheet(context),
                    tooltip: 'Create Invoice',
                  ),
              ],
            ),
      floatingActionButton: embedded && isAdmin
          ? FloatingActionButton(
              heroTag: 'invoice_fab',
              onPressed: () => _showCreateInvoiceSheet(context),
              child: const Icon(Icons.add),
            )
          : null,
      body: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) {
          return switch (state) {
            InvoiceInitial() || InvoiceLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            InvoiceError(:final message, :final previousInvoices) =>
              previousInvoices != null
                  ? _buildInvoiceList(context, previousInvoices, message)
                  : Center(child: Text('Error: $message')),
            InvoiceLoaded(:final invoices) ||
            InvoicePdfGenerating(:final invoices) ||
            InvoicePdfGenerated(
              :final invoices,
            ) => _buildInvoiceList(context, invoices, null),
          };
        },
      ),
    );
  }

  Widget _buildInvoiceList(
    BuildContext context,
    List<Invoice> invoices,
    String? errorMessage,
  ) {
    if (invoices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No invoices yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (isAdmin) ...[
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () => _showCreateInvoiceSheet(context),
                icon: const Icon(Icons.add),
                label: const Text('Create Invoice'),
              ),
            ],
          ],
        ),
      );
    }

    return Column(
      children: [
        if (errorMessage != null)
          MaterialBanner(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            actions: [
              TextButton(onPressed: () {}, child: const Text('Dismiss')),
            ],
          ),
        Expanded(
          child: ListView.builder(
            padding: const .all(16),
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return _InvoiceCard(
                invoice: invoice,
                isAdmin: isAdmin,
                onTap: () => context.push('/invoices/${invoice.id}'),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  final bool isAdmin;
  final VoidCallback onTap;

  const _InvoiceCard({
    required this.invoice,
    required this.isAdmin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const .only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(12),
        child: Padding(
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    invoice.invoiceNumber,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: .bold,
                    ),
                  ),
                  _StatusChip(status: invoice.status),
                ],
              ),
              const SizedBox(height: 8),
              if (isAdmin)
                Text(invoice.userName, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text(
                invoice.periodDisplay,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    '${invoice.totalHours.toStringAsFixed(1)} hours',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    invoice.formattedAmount,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: .bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final InvoiceStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (status) {
      InvoiceStatus.draft => (Colors.grey, Icons.edit_outlined),
      InvoiceStatus.sent => (Colors.blue, Icons.send_outlined),
      InvoiceStatus.paid => (Colors.green, Icons.check_circle_outlined),
      InvoiceStatus.overdue => (Colors.orange, Icons.warning_outlined),
      InvoiceStatus.cancelled => (Colors.red, Icons.cancel_outlined),
    };

    return Container(
      padding: const .symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: .circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status.name.toUpperCase(),
            style: TextStyle(fontSize: 12, fontWeight: .w500, color: color),
          ),
        ],
      ),
    );
  }
}
