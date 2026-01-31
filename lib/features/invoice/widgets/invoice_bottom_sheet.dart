import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../data/models/period_summary.dart';
import '../../../data/models/time_entry.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/firebase_auth_repository.dart';
import '../../../data/repositories/firestore_time_entry_repository.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_event.dart';
import '../cubit/users_cubit.dart';

class InvoiceBottomSheet extends StatelessWidget {
  const InvoiceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersCubit(
        authRepository: context.read<FirebaseAuthRepository>(),
      )..loadUsers(),
      child: const _InvoiceBottomSheetView(),
    );
  }
}

class _InvoiceBottomSheetView extends StatefulWidget {
  const _InvoiceBottomSheetView();

  @override
  State<_InvoiceBottomSheetView> createState() => _InvoiceBottomSheetViewState();
}

class _InvoiceBottomSheetViewState extends State<_InvoiceBottomSheetView> {
  User? _selectedUser;
  DateTime _periodStart = DateTime.now().subtract(const Duration(days: 30));
  DateTime _periodEnd = DateTime.now();
  DateTime? _dueDate;
  final _notesController = TextEditingController();

  List<TimeEntry> _entries = [];
  bool _isLoadingEntries = false;
  bool _isSubmitting = false;

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

    setState(() => _isSubmitting = true);

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

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Invoice created successfully'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              _buildHandle(),
              _buildHeader(l10n),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildUserSelector(l10n),
                      const SizedBox(height: 16),
                      _buildPeriodSelector(l10n),
                      const SizedBox(height: 16),
                      _buildDueDateSelector(l10n),
                      const SizedBox(height: 16),
                      if (_isLoadingEntries)
                        const GlassCard(
                          enableBlur: false,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      else if (_selectedUser != null)
                        _buildSummary(l10n),
                      const SizedBox(height: 16),
                      _buildNotesField(l10n),
                      const SizedBox(height: 24),
                      _buildSubmitButton(l10n),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(
            Icons.receipt_long,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            l10n.createInvoice,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSelector(AppLocalizations l10n) {
    return GlassCard(
      enableBlur: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.user,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<UsersCubit, UsersState>(
            builder: (context, state) {
              if (state is UsersLoading || state is UsersInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is UsersError) {
                return Text(
                  'Error: ${state.message}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                );
              }
              if (state is UsersLoaded) {
                if (state.users.isEmpty) {
                  return const Text('No workers found');
                }
                return DropdownButtonFormField<User>(
                  initialValue: _selectedUser,
                  decoration: InputDecoration(
                    hintText: 'Select a worker',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.primary,
                    ),
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
    );
  }

  Widget _buildPeriodSelector(AppLocalizations l10n) {
    return GlassCard(
      enableBlur: false,
      child: Row(
        children: [
          Icon(
            Icons.date_range,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.period,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${_formatDate(_periodStart)} - ${_formatDate(_periodEnd)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _selectDateRange,
            child: Text(l10n.change),
          ),
        ],
      ),
    );
  }

  Widget _buildDueDateSelector(AppLocalizations l10n) {
    return GlassCard(
      enableBlur: false,
      child: Row(
        children: [
          Icon(
            Icons.event,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dueDate,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  _dueDate != null ? _formatDate(_dueDate!) : l10n.notSet,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _selectDueDate,
            child: Text(l10n.change),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(AppLocalizations l10n) {
    final theme = Theme.of(context);

    return GlassCard(
      enableBlur: false,
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.summary,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(l10n.entries, '${_entries.length}'),
          _buildSummaryRow(l10n.totalHours, _totalHours.toStringAsFixed(2)),
          if (_selectedUser!.salaryAmount != null) ...[
            _buildSummaryRow(
              l10n.hourlyRate,
              '${_selectedUser!.salaryAmount!.toStringAsFixed(2)} ${_selectedUser!.currency.symbol}',
            ),
            const Divider(),
            _buildSummaryRow(
              l10n.totalAmount,
              '${_totalAmount.toStringAsFixed(2)} ${_selectedUser!.currency.symbol}',
              isTotal: true,
            ),
          ],
          if (_entries.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l10n.noEntriesForPeriod,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
        ],
      ),
    );
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

  Widget _buildNotesField(AppLocalizations l10n) {
    return GlassCard(
      enableBlur: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.notes,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              hintText: l10n.addNotesToInvoice,
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(AppLocalizations l10n) {
    final isValid = _selectedUser != null && _entries.isNotEmpty;

    return FilledButton.icon(
      onPressed: isValid && !_isSubmitting ? _createInvoice : null,
      icon: _isSubmitting
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.receipt),
      label: Text(l10n.createInvoice),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
