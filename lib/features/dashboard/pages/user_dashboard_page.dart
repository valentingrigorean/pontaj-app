import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/models/time_entry.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../time_entry/bloc/time_entry_bloc.dart';
import '../../time_entry/bloc/time_entry_event.dart';
import '../../time_entry/bloc/time_entry_state.dart';
import '../widgets/stat_card.dart';
import '../widgets/weekly_chart.dart';

class UserDashboardPage extends StatefulWidget {
  final bool embedded;

  const UserDashboardPage({super.key, this.embedded = true});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<TimeEntryBloc>().add(
        LoadEntries(userId: authState.user.id, isAdmin: false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;
    final userName = authState is AuthAuthenticated
        ? authState.user.displayNameOrEmail
        : 'User';

    return Scaffold(
      appBar: widget.embedded
          ? null
          : AppBar(title: Text(l10n.dashboard), centerTitle: true),
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

            final stats = _calculateStats(entries);

            return SingleChildScrollView(
              padding: ResponsiveSpacing.pagePadding(context),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      _buildGreeting(context, l10n, userName),
                      const SizedBox(height: 24),
                      ResponsiveGrid(
                        mobileColumns: 2,
                        tabletColumns: 4,
                        desktopColumns: 4,
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          StatCard(
                            icon: Icons.access_time,
                            label: l10n.thisWeek,
                            value: '${stats.hoursThisWeek.toStringAsFixed(1)}h',
                            color: Colors.blue,
                            trailing: stats.weekTrend != 0
                                ? TrendIndicator(
                                    percentage: stats.weekTrend,
                                    isPositive: stats.weekTrend > 0,
                                  )
                                : null,
                          ),
                          StatCard(
                            icon: Icons.calendar_month,
                            label: l10n.thisMonth,
                            value:
                                '${stats.hoursThisMonth.toStringAsFixed(1)}h',
                            color: Colors.green,
                            subtitle: '${stats.daysThisMonth} ${l10n.days}',
                          ),
                          StatCard(
                            icon: Icons.trending_up,
                            label: l10n.averagePerDay,
                            value:
                                '${stats.avgHoursPerDay.toStringAsFixed(1)}h',
                            color: Colors.orange,
                          ),
                          StatCard(
                            icon: Icons.location_on,
                            label: l10n.topLocation,
                            value: stats.topLocation.isNotEmpty
                                ? stats.topLocation
                                : '-',
                            color: Colors.purple,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      WeeklyChart(
                        hoursPerDay: stats.weeklyHours,
                        targetHours: 8.0,
                      ),
                      const SizedBox(height: 24),
                      _buildRecentEntries(context, l10n, entries),
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

  Widget _buildGreeting(
    BuildContext context,
    AppLocalizations l10n,
    String name,
  ) {
    final hour = DateTime.now().hour;
    String greeting;
    IconData icon;

    if (hour < 12) {
      greeting = l10n.goodMorning;
      icon = Icons.wb_sunny;
    } else if (hour < 18) {
      greeting = l10n.goodAfternoon;
      icon = Icons.wb_cloudy;
    } else {
      greeting = l10n.goodEvening;
      icon = Icons.nights_stay;
    }

    return GlassCard(
      enableBlur: false,
      color: Theme.of(
        context,
      ).colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
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
                name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: .bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 20, color: Colors.amber[600]),
                    const SizedBox(width: 8),
                    Text(
                      greeting,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: .bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentEntries(
    BuildContext context,
    AppLocalizations l10n,
    List<TimeEntry> entries,
  ) {
    final recentEntries = entries.take(5).toList();

    return GlassCard(
      padding: const .all(20),
      enableBlur: false,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.recentActivity,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
          ),
          const SizedBox(height: 16),
          if (recentEntries.isEmpty)
            Center(
              child: Padding(
                padding: const .all(20),
                child: Column(
                  children: [
                    Icon(Icons.history, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text(
                      l10n.noActivity,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          else
            ...recentEntries.map((e) => _buildEntryTile(context, e)),
        ],
      ),
    );
  }

  Widget _buildEntryTile(BuildContext context, TimeEntry entry) {
    return Padding(
      padding: const .symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.5),
              borderRadius: .circular(12),
            ),
            child: Center(
              child: Text(
                '${entry.date.day}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: .bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(entry.location, style: const TextStyle(fontWeight: .w600)),
                Text(
                  entry.intervalText,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            TimeEntry.formatDuration(entry.totalWorked),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: .bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  _DashboardStats _calculateStats(List<TimeEntry> entries) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfLastWeek = startOfWeek.subtract(const Duration(days: 7));
    final startOfMonth = DateTime(now.year, now.month, 1);

    double hoursThisWeek = 0;
    double hoursLastWeek = 0;
    double hoursThisMonth = 0;
    int daysThisMonth = 0;
    final weeklyHours = <int, double>{};
    final locationCount = <String, int>{};

    for (final entry in entries) {
      final entryDate = DateTime(
        entry.date.year,
        entry.date.month,
        entry.date.day,
      );
      final hours = entry.totalWorked.inMinutes / 60;

      locationCount[entry.location] = (locationCount[entry.location] ?? 0) + 1;

      if (entryDate.isAfter(startOfWeek.subtract(const Duration(days: 1)))) {
        hoursThisWeek += hours;
        final dayIndex = entry.date.weekday - 1;
        weeklyHours[dayIndex] = (weeklyHours[dayIndex] ?? 0) + hours;
      }

      if (entryDate.isAfter(
            startOfLastWeek.subtract(const Duration(days: 1)),
          ) &&
          entryDate.isBefore(startOfWeek)) {
        hoursLastWeek += hours;
      }

      if (entryDate.isAfter(startOfMonth.subtract(const Duration(days: 1)))) {
        hoursThisMonth += hours;
        daysThisMonth++;
      }
    }

    double weekTrend = 0;
    if (hoursLastWeek > 0) {
      weekTrend = ((hoursThisWeek - hoursLastWeek) / hoursLastWeek) * 100;
    }

    final avgHoursPerDay = entries.isEmpty
        ? 0.0
        : entries.fold<double>(
                0,
                (sum, e) => sum + e.totalWorked.inMinutes / 60,
              ) /
              entries.length;

    String topLocation = '';
    int maxCount = 0;
    for (final entry in locationCount.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        topLocation = entry.key;
      }
    }

    if (topLocation.length > 10) {
      topLocation = '${topLocation.substring(0, 10)}...';
    }

    return _DashboardStats(
      hoursThisWeek: hoursThisWeek,
      hoursLastWeek: hoursLastWeek,
      hoursThisMonth: hoursThisMonth,
      daysThisMonth: daysThisMonth,
      avgHoursPerDay: avgHoursPerDay,
      weekTrend: weekTrend,
      weeklyHours: weeklyHours,
      topLocation: topLocation,
    );
  }
}

class _DashboardStats {
  final double hoursThisWeek;
  final double hoursLastWeek;
  final double hoursThisMonth;
  final int daysThisMonth;
  final double avgHoursPerDay;
  final double weekTrend;
  final Map<int, double> weeklyHours;
  final String topLocation;

  _DashboardStats({
    required this.hoursThisWeek,
    required this.hoursLastWeek,
    required this.hoursThisMonth,
    required this.daysThisMonth,
    required this.avgHoursPerDay,
    required this.weekTrend,
    required this.weeklyHours,
    required this.topLocation,
  });
}
