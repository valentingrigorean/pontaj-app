import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/time_entry.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/firebase_auth_repository.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../invoice/cubit/users_cubit.dart';
import '../../time_entry/bloc/time_entry_bloc.dart';
import '../../time_entry/bloc/time_entry_state.dart';

class SalaryPage extends StatefulWidget {
  final bool embedded;

  const SalaryPage({super.key, this.embedded = false});

  @override
  State<SalaryPage> createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  late UsersCubit _usersCubit;

  @override
  void initState() {
    super.initState();
    _usersCubit = UsersCubit(
      authRepository: context.read<FirebaseAuthRepository>(),
    )..loadUsers();
  }

  @override
  void dispose() {
    _usersCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<TimeEntryBloc, TimeEntryState>(
      builder: (context, timeEntryState) {
        return BlocBuilder<UsersCubit, UsersState>(
          bloc: _usersCubit,
          builder: (context, usersState) {
            if (timeEntryState is! TimeEntryLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            final entriesByUser = timeEntryState.entriesByUser;
            final users = usersState is UsersLoaded
                ? usersState.users
                : <User>[];

            if (entriesByUser.isEmpty) {
              return GradientBackground(
                animated: false,
                child: Center(
                  child: GlassCard(
                    padding: const .all(40),
                    enableBlur: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noPontajForSalary,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return GradientBackground(
              animated: false,
              child: SingleChildScrollView(
                padding: ResponsiveSpacing.pagePadding(context),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        GlassCard(
                          padding: const .all(20),
                          enableBlur: false,
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.attach_money,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    l10n.salarySummary,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: .bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.calculationBasedOnPontaj,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...entriesByUser.entries.map((entry) {
                          final userName = entry.key;
                          final entries = entry.value;
                          final totalDuration = entries.fold<Duration>(
                            Duration.zero,
                            (sum, e) => sum + e.totalWorked,
                          );
                          final totalHours = totalDuration.inMinutes / 60.0;

                          final userProfile = users.firstWhere(
                            (u) => u.displayNameOrEmail == userName,
                            orElse: () => User(email: userName),
                          );

                          return _SalaryUserCard(
                            userName: userName,
                            userProfile: userProfile,
                            entries: entries,
                            totalDuration: totalDuration,
                            totalHours: totalHours,
                            l10n: l10n,
                            onUserUpdated: () => _usersCubit.loadUsers(),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SalaryUserCard extends StatefulWidget {
  final String userName;
  final User userProfile;
  final List<TimeEntry> entries;
  final Duration totalDuration;
  final double totalHours;
  final AppLocalizations l10n;
  final VoidCallback onUserUpdated;

  const _SalaryUserCard({
    required this.userName,
    required this.userProfile,
    required this.entries,
    required this.totalDuration,
    required this.totalHours,
    required this.l10n,
    required this.onUserUpdated,
  });

  @override
  State<_SalaryUserCard> createState() => _SalaryUserCardState();
}

class _SalaryUserCardState extends State<_SalaryUserCard> {
  bool _isEditing = false;
  late TextEditingController _rateController;
  late SalaryType _selectedSalaryType;
  late Currency _selectedCurrency;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _rateController = TextEditingController(
      text: widget.userProfile.salaryAmount?.toStringAsFixed(2) ?? '',
    );
    _selectedSalaryType = widget.userProfile.salaryType;
    _selectedCurrency = widget.userProfile.currency;
  }

  @override
  void dispose() {
    _rateController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (widget.userProfile.id == null) return;

    setState(() => _isSaving = true);

    try {
      final rate = double.tryParse(_rateController.text);
      final updatedUser = widget.userProfile.copyWith(
        salaryAmount: rate,
        salaryType: _selectedSalaryType,
        currency: _selectedCurrency,
      );

      await context.read<FirebaseAuthRepository>().updateUserProfile(
        updatedUser,
      );

      if (mounted) {
        setState(() {
          _isEditing = false;
          _isSaving = false;
        });
        widget.onUserUpdated();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.l10n.saveChanges),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String _getCurrencySymbol(Currency currency) {
    return switch (currency) {
      Currency.lei => 'RON',
      Currency.euro => '€',
    };
  }

  String _getSalaryTypeLabel(SalaryType type) {
    return switch (type) {
      SalaryType.hourly => widget.l10n.hourlyRate,
      SalaryType.monthly => widget.l10n.salarySettings,
    };
  }

  @override
  Widget build(BuildContext context) {
    final rate = widget.userProfile.salaryAmount ?? 0;
    final estimatedSalary = widget.userProfile.salaryType == SalaryType.hourly
        ? rate * widget.totalHours
        : rate;

    return GlassCard(
      margin: const .only(bottom: 12),
      padding: const .all(16),
      enableBlur: false,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.userName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: .bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(fontWeight: .bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.l10n.nDaysWorked(widget.entries.length),
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              if (widget.userProfile.id != null)
                IconButton(
                  icon: Icon(_isEditing ? Icons.close : Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                      if (!_isEditing) {
                        _rateController.text =
                            widget.userProfile.salaryAmount?.toStringAsFixed(
                              2,
                            ) ??
                            '';
                        _selectedSalaryType = widget.userProfile.salaryType;
                        _selectedCurrency = widget.userProfile.currency;
                      }
                    });
                  },
                  tooltip: widget.l10n.editRate,
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isEditing) ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _rateController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: widget.l10n.hourlyRate,
                      prefixText: _getCurrencySymbol(_selectedCurrency),
                      filled: true,
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<Currency>(
                  value: _selectedCurrency,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedCurrency = value);
                    }
                  },
                  items: Currency.values.map((c) {
                    return DropdownMenuItem(
                      value: c,
                      child: Text(_getCurrencySymbol(c)),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<SalaryType>(
              segments: SalaryType.values.map((type) {
                return ButtonSegment(
                  value: type,
                  label: Text(_getSalaryTypeLabel(type)),
                );
              }).toList(),
              selected: {_selectedSalaryType},
              onSelectionChanged: (Set<SalaryType> selected) {
                setState(() => _selectedSalaryType = selected.first);
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _saveChanges,
                icon: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(widget.l10n.saveChanges),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Container(
            padding: const .all(12),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: .circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          widget.l10n.totalHours,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          TimeEntry.formatDuration(widget.totalDuration),
                          style: TextStyle(
                            fontWeight: .bold,
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: .end,
                      children: [
                        Text(
                          widget.l10n.hoursDecimal,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${widget.totalHours.toStringAsFixed(2)}h',
                          style: const TextStyle(
                            fontWeight: .bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (rate > 0) ...[
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        '${widget.l10n.hourlyRate}: ${_getCurrencySymbol(widget.userProfile.currency)} ${rate.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      Text(
                        '${_getCurrencySymbol(widget.userProfile.currency)} ${estimatedSalary.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: .bold,
                          fontSize: 18,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
