import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/period_summary.dart';
import '../../../data/models/time_entry.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/firebase_auth_repository.dart';
import '../../../data/repositories/firestore_time_entry_repository.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_event.dart';
import '../cubit/users_cubit.dart';

class CreateInvoicePage extends StatelessWidget {
  const CreateInvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final currentUserId = authState is AuthAuthenticated ? authState.user.id : null;

    return BlocProvider(
      create: (context) => UsersCubit(
        authRepository: context.read<FirebaseAuthRepository>(),
        excludeUserId: currentUserId,
      )..loadUsers(),
      child: const _CreateInvoiceView(),
    );
  }
}

class _CreateInvoiceView extends StatefulWidget {
  const _CreateInvoiceView();

  @override
  State<_CreateInvoiceView> createState() => _CreateInvoiceViewState();
}

class _CreateInvoiceViewState extends State<_CreateInvoiceView> {
  User? _selectedUser;
  DateTime _periodStart = DateTime.now().subtract(const Duration(days: 30));
  DateTime _periodEnd = DateTime.now();
  DateTime? _dueDate;
  final _notesController = TextEditingController();

  List<TimeEntry> _entries = [];
  bool _isLoadingEntries = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    if (_selectedUser == null) return;

    setState(() => _isLoadingEntries = true);

    try {
      final repository = context.read<FirestoreTimeEntryRepository>();
      final entries = await repository.getEntries(userId: _selectedUser!.id);

      final filteredEntries = entries.where((e) {
        return !e.date.isBefore(_periodStart) && !e.date.isAfter(_periodEnd);
      }).toList();

      setState(() {
        _entries = filteredEntries;
        _isLoadingEntries = false;
      });
    } catch (e) {
      setState(() => _isLoadingEntries = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading entries: $e')),
        );
      }
    }
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _periodStart, end: _periodEnd),
    );

    if (picked != null) {
      setState(() {
        _periodStart = picked.start;
        _periodEnd = picked.end;
      });
      _loadEntries();
    }
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _createInvoice() {
    if (_selectedUser == null || _entries.isEmpty) return;
    final userId = _selectedUser!.id;
    if (userId == null) return;

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;
    final creatorId = authState.user.id;
    if (creatorId == null) return;

    final summary = PeriodSummary.fromEntries(
      userId: userId,
      userName: _selectedUser!.displayNameOrEmail,
      periodStart: _periodStart,
      periodEnd: _periodEnd,
      entries: _entries,
      hourlyRate: _selectedUser!.salaryAmount,
      currency: _selectedUser!.currency,
    );

    context.read<InvoiceBloc>().add(
      CreateInvoice(
        summary: summary,
        createdBy: creatorId,
        dueDate: _dueDate,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Invoice')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Worker', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    BlocBuilder<UsersCubit, UsersState>(
                      builder: (context, state) {
                        if (state is UsersLoading || state is UsersInitial) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (state is UsersError) {
                          return Text(
                            'Error: ${state.message}',
                            style: TextStyle(color: theme.colorScheme.error),
                          );
                        }
                        if (state is UsersLoaded) {
                          if (state.users.isEmpty) {
                            return const Text('No workers found');
                          }
                          return DropdownButtonFormField<User>(
                            initialValue: _selectedUser,
                            decoration: const InputDecoration(
                              hintText: 'Select a worker',
                              border: OutlineInputBorder(),
                            ),
                            items: state.users.map((user) {
                              return DropdownMenuItem(
                                value: user,
                                child: Text(user.displayNameOrEmail),
                              );
                            }).toList(),
                            onChanged: (user) {
                              setState(() => _selectedUser = user);
                              _loadEntries();
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Period', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _selectDateRange,
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        '${_formatDate(_periodStart)} - ${_formatDate(_periodEnd)}',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Due Date (Optional)',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _selectDueDate,
                      icon: const Icon(Icons.event),
                      label: Text(
                        _dueDate != null
                            ? _formatDate(_dueDate!)
                            : 'Select due date',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoadingEntries)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
            else if (_selectedUser != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Summary', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 16),
                      _buildSummaryRow('Entries', '${_entries.length}'),
                      _buildSummaryRow(
                        'Total Hours',
                        _totalHours.toStringAsFixed(2),
                      ),
                      if (_selectedUser!.salaryAmount != null) ...[
                        _buildSummaryRow(
                          'Hourly Rate',
                          '${_selectedUser!.salaryAmount!.toStringAsFixed(2)} ${_selectedUser!.currency.symbol}',
                        ),
                        const Divider(),
                        _buildSummaryRow(
                          'Total Amount',
                          '${_totalAmount.toStringAsFixed(2)} ${_selectedUser!.currency.symbol}',
                          isTotal: true,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes (Optional)',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        hintText: 'Add notes to the invoice...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _selectedUser != null && _entries.isNotEmpty
                  ? _createInvoice
                  : null,
              icon: const Icon(Icons.receipt),
              label: const Text('Create Invoice'),
            ),
          ],
        ),
      ),
    );
  }

  double get _totalHours {
    final totalMinutes = _entries.fold<int>(
      0,
      (sum, e) => sum + e.totalWorked.inMinutes,
    );
    return totalMinutes / 60.0;
  }

  double get _totalAmount {
    if (_selectedUser?.salaryAmount == null) return 0;
    return _totalHours * _selectedUser!.salaryAmount!;
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                : null,
          ),
          Text(
            value,
            style: isTotal
                ? TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
