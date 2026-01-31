import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/models/time_entry.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../bloc/time_entry_bloc.dart';
import '../bloc/time_entry_event.dart';
import '../bloc/time_entry_state.dart';

class MyEntriesPage extends StatefulWidget {
  const MyEntriesPage({super.key});

  @override
  State<MyEntriesPage> createState() => _MyEntriesPageState();
}

class _MyEntriesPageState extends State<MyEntriesPage> {
  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<TimeEntryBloc>().add(LoadEntries(
            userId: authState.user.id,
            isAdmin: false,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myEntries),
        centerTitle: true,
      ),
      body: GradientBackground(
        animated: false,
        child: BlocBuilder<TimeEntryBloc, TimeEntryState>(
          builder: (context, state) {
            if (state is TimeEntryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is! TimeEntryLoaded) {
              return Center(child: Text(l10n.couldNotLoadData));
            }

            final entries = state.entries.toList()
              ..sort((a, b) => b.date.compareTo(a.date));

            if (entries.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noPontaj,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                ),
              );
            }

            final total = entries.fold<Duration>(
              Duration.zero,
              (sum, e) => sum + e.totalWorked,
            );

            final groupedEntries = _groupEntriesByMonth(entries);

            return SingleChildScrollView(
              padding: ResponsiveSpacing.pagePadding(context),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GlassCard(
                        enableBlur: false,
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _SummaryItem(
                              icon: Icons.calendar_today,
                              label: l10n.totalDays,
                              value: entries.length.toString(),
                            ),
                            _SummaryItem(
                              icon: Icons.schedule,
                              label: l10n.totalHours,
                              value: TimeEntry.formatDuration(total),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...groupedEntries.entries.map((group) {
                        return _MonthSection(
                          monthYear: group.key,
                          entries: group.value,
                          l10n: l10n,
                        );
                      }),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Map<String, List<TimeEntry>> _groupEntriesByMonth(List<TimeEntry> entries) {
    final grouped = <String, List<TimeEntry>>{};
    for (final entry in entries) {
      final key = '${entry.date.month}/${entry.date.year}';
      grouped.putIfAbsent(key, () => []).add(entry);
    }
    return grouped;
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}

class _MonthSection extends StatelessWidget {
  final String monthYear;
  final List<TimeEntry> entries;
  final AppLocalizations l10n;

  const _MonthSection({
    required this.monthYear,
    required this.entries,
    required this.l10n,
  });

  String _getMonthName(int month, String locale) {
    const monthsRo = [
      'Ianuarie', 'Februarie', 'Martie', 'Aprilie', 'Mai', 'Iunie',
      'Iulie', 'August', 'Septembrie', 'Octombrie', 'Noiembrie', 'Decembrie'
    ];
    const monthsEn = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const monthsIt = [
      'Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno',
      'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'
    ];

    final months = switch (locale) {
      'en' => monthsEn,
      'it' => monthsIt,
      _ => monthsRo,
    };

    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final parts = monthYear.split('/');
    final month = int.parse(parts[0]);
    final year = parts[1];
    final locale = Localizations.localeOf(context).languageCode;
    final monthName = _getMonthName(month, locale);

    final monthTotal = entries.fold<Duration>(
      Duration.zero,
      (sum, e) => sum + e.totalWorked,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text(
                '$monthName $year',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const Spacer(),
              Text(
                '${entries.length} ${l10n.days} - ${TimeEntry.formatDuration(monthTotal)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
        GlassCard(
          padding: EdgeInsets.zero,
          enableBlur: false,
          child: Column(
            children: entries.asMap().entries.map((indexed) {
              final entry = indexed.value;
              final isLast = indexed.key == entries.length - 1;
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '${entry.date.day}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                        ),
                      ),
                    ),
                    title: Text(
                      entry.location,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(entry.intervalText),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          TimeEntry.formatDuration(entry.totalWorked),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                        ),
                        if (entry.breakMinutes > 0)
                          Text(
                            '${l10n.breakTime}: ${entry.breakMinutes}m',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ),
                      ],
                    ),
                  ),
                  if (!isLast) const Divider(height: 1),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
