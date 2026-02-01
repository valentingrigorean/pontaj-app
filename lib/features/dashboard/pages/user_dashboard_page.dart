import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/models/date_period.dart';
import '../../../data/models/time_entry.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/period_selector.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../time_entry/bloc/time_entry_bloc.dart';
import '../../time_entry/bloc/time_entry_event.dart';
import '../../time_entry/bloc/time_entry_state.dart';
import '../bloc/dashboard_cubit.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/distribution_pie_chart.dart';
import '../widgets/stat_card.dart';
import '../widgets/trend_line_chart.dart';
import '../widgets/weekly_chart.dart';

class UserDashboardPage extends StatefulWidget {
  final bool embedded;

  const UserDashboardPage({super.key, this.embedded = true});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  late DashboardCubit _dashboardCubit;

  @override
  void initState() {
    super.initState();
    _dashboardCubit = DashboardCubit();
    _loadEntries();
  }

  @override
  void dispose() {
    _dashboardCubit.close();
    super.dispose();
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
          builder: (context, timeEntryState) {
            if (timeEntryState is TimeEntryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (timeEntryState is! TimeEntryLoaded) {
              return Center(child: Text(l10n.couldNotLoadData));
            }

            final entries = timeEntryState.entries.toList()
              ..sort((a, b) => b.date.compareTo(a.date));

            _dashboardCubit.setEntries(entries);

            return BlocBuilder<DashboardCubit, DashboardState>(
              bloc: _dashboardCubit,
              builder: (context, dashState) {
                return SingleChildScrollView(
                  padding: ResponsiveSpacing.pagePadding(context),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildGreeting(context, l10n, userName),
                          const SizedBox(height: 20),
                          PeriodSelector(
                            selectedPeriod: dashState.selectedPeriod,
                            onPeriodChanged: _dashboardCubit.setPeriod,
                          ),
                          const SizedBox(height: 20),
                          _buildStatCards(context, l10n, dashState),
                          const SizedBox(height: 24),
                          _buildTrendChart(context, l10n, dashState),
                          const SizedBox(height: 24),
                          _buildLocationChart(context, l10n, dashState),
                          const SizedBox(height: 24),
                          if (dashState.selectedPeriod.type == PeriodType.week)
                            WeeklyChart(
                              hoursPerDay: dashState.weeklyHours,
                              targetHours: 8.0,
                            ),
                          if (dashState.selectedPeriod.type == PeriodType.week)
                            const SizedBox(height: 24),
                          _buildRecentEntries(context, l10n, entries),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards(
    BuildContext context,
    AppLocalizations l10n,
    DashboardState state,
  ) {
    return ResponsiveGrid(
      mobileColumns: 2,
      tabletColumns: 4,
      desktopColumns: 4,
      spacing: 12,
      runSpacing: 12,
      children: [
        StatCard(
          icon: Icons.access_time,
          label: l10n.thisPeriod,
          value: '${state.totalHoursThisPeriod.toStringAsFixed(1)}h',
          color: Colors.blue,
          trailing: state.periodTrend != 0
              ? TrendIndicator(
                  percentage: state.periodTrend,
                  isPositive: state.periodTrend > 0,
                )
              : null,
        ),
        StatCard(
          icon: Icons.compare_arrows,
          label: l10n.vsLastPeriod,
          value: '${state.totalHoursLastPeriod.toStringAsFixed(1)}h',
          color: Colors.green,
          subtitle: l10n.lastPeriod,
        ),
        StatCard(
          icon: Icons.trending_up,
          label: l10n.averagePerDay,
          value: '${state.avgHoursPerDay.toStringAsFixed(1)}h',
          color: Colors.orange,
        ),
        StatCard(
          icon: Icons.calendar_today,
          label: l10n.daysWorked,
          value: '${state.daysWorkedThisPeriod}',
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildTrendChart(
    BuildContext context,
    AppLocalizations l10n,
    DashboardState state,
  ) {
    final dailyData = state.dailyHours.entries.map((e) {
      return TrendDataPoint(date: e.key, hours: e.value);
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return TrendLineChart(
      title: l10n.weeklyHours,
      targetHours: 8.0,
      series: [
        TrendLineSeries(
          label: l10n.totalHours,
          data: dailyData,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildLocationChart(
    BuildContext context,
    AppLocalizations l10n,
    DashboardState state,
  ) {
    final locationData = state.hoursByLocation;
    final colors = generateChartColors(locationData.length);
    var colorIndex = 0;

    final items = locationData.entries.map((e) {
      return DistributionItem(
        label: e.key,
        value: e.value,
        color: colors[colorIndex++ % colors.length],
      );
    }).toList();

    return DistributionPieChart(
      title: l10n.hoursByLocation,
      items: items,
      centerText: '${state.totalHoursThisPeriod.toStringAsFixed(1)}h',
      centerSubtext: l10n.total,
    );
  }

  Widget _buildRecentEntries(
    BuildContext context,
    AppLocalizations l10n,
    List<TimeEntry> entries,
  ) {
    final recentEntries = entries.take(5).toList();

    return GlassCard(
      padding: const EdgeInsets.all(20),
      enableBlur: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.recentActivity,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (recentEntries.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${entry.date.day}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.location, style: const TextStyle(fontWeight: FontWeight.w600)),
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
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
