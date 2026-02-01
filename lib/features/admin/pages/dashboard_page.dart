import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/models/time_entry.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/period_selector.dart';
import '../../dashboard/widgets/distribution_pie_chart.dart';
import '../../dashboard/widgets/stat_card.dart';
import '../../dashboard/widgets/trend_line_chart.dart';
import '../../time_entry/bloc/time_entry_bloc.dart';
import '../../time_entry/bloc/time_entry_state.dart';
import '../bloc/admin_dashboard_cubit.dart';
import '../bloc/admin_dashboard_state.dart';

class DashboardPage extends StatefulWidget {
  final bool embedded;

  const DashboardPage({super.key, this.embedded = false});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late AdminDashboardCubit _dashboardCubit;

  @override
  void initState() {
    super.initState();
    _dashboardCubit = AdminDashboardCubit();
  }

  @override
  void dispose() {
    _dashboardCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<TimeEntryBloc, TimeEntryState>(
      builder: (context, timeEntryState) {
        if (timeEntryState is! TimeEntryLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final entries = timeEntryState.entries.toList()
          ..sort((a, b) => b.date.compareTo(a.date));
        _dashboardCubit.setEntries(entries);

        return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
          bloc: _dashboardCubit,
          builder: (context, dashState) {
            return GradientBackground(
              animated: false,
              child: SingleChildScrollView(
                padding: ResponsiveSpacing.pagePadding(context),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PeriodSelector(
                          selectedPeriod: dashState.selectedPeriod,
                          onPeriodChanged: _dashboardCubit.setPeriod,
                        ),
                        const SizedBox(height: 20),
                        _buildStatCards(context, l10n, dashState),
                        const SizedBox(height: 24),
                        _buildTeamTrendChart(context, l10n, dashState),
                        const SizedBox(height: 24),
                        _buildChartsRow(context, l10n, dashState),
                        const SizedBox(height: 24),
                        _buildComparisonTable(context, l10n, dashState),
                        const SizedBox(height: 24),
                        _buildRecentActivity(context, l10n, entries),
                        const SizedBox(height: 80),
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

  Widget _buildStatCards(
    BuildContext context,
    AppLocalizations l10n,
    AdminDashboardState state,
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
          label: l10n.totalHours,
          value: '${state.totalHoursThisPeriod.toStringAsFixed(1)}h',
          color: Colors.blue,
        ),
        StatCard(
          icon: Icons.people,
          label: l10n.activeUsers,
          value: '${state.activeUsersCount}',
          color: Colors.green,
        ),
        StatCard(
          icon: Icons.trending_up,
          label: l10n.averagePerDay,
          value: '${state.avgHoursPerUser.toStringAsFixed(1)}h',
          color: Colors.orange,
          subtitle: 'per user',
        ),
        StatCard(
          icon: Icons.star,
          label: l10n.topUser,
          value: state.topUser.isNotEmpty
              ? (state.topUser.length > 10
                  ? '${state.topUser.substring(0, 10)}...'
                  : state.topUser)
              : '-',
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildTeamTrendChart(
    BuildContext context,
    AppLocalizations l10n,
    AdminDashboardState state,
  ) {
    final dailyData = state.dailyTeamHours.entries.map((e) {
      return TrendDataPoint(date: e.key, hours: e.value);
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return TrendLineChart(
      title: l10n.teamTrend,
      targetHours: 8.0 * state.activeUsersCount,
      series: [
        TrendLineSeries(
          label: l10n.totalHours,
          data: dailyData,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildChartsRow(
    BuildContext context,
    AppLocalizations l10n,
    AdminDashboardState state,
  ) {
    final isWide = context.isDesktop || context.isTablet;

    final userChart = _buildUserHoursChart(context, l10n, state);
    final locationChart = _buildLocationPieChart(context, l10n, state);

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: userChart),
          const SizedBox(width: 16),
          Expanded(child: locationChart),
        ],
      );
    }

    return Column(
      children: [
        userChart,
        const SizedBox(height: 16),
        locationChart,
      ],
    );
  }

  Widget _buildUserHoursChart(
    BuildContext context,
    AppLocalizations l10n,
    AdminDashboardState state,
  ) {
    final hoursPerUser = state.hoursByUser;

    if (hoursPerUser.isEmpty) {
      return GlassCard(
        padding: const EdgeInsets.all(20),
        enableBlur: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.hoursPerUser,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                l10n.noActivity,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      );
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      enableBlur: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.hoursPerUser,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: hoursPerUser.values.isEmpty
                    ? 100
                    : hoursPerUser.values.reduce((a, b) => a > b ? a : b) * 1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final users = hoursPerUser.keys.toList();
                      return BarTooltipItem(
                        '${users[group.x]}\n${rod.toY.toStringAsFixed(1)}h',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final users = hoursPerUser.keys.toList();
                        if (value.toInt() >= users.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            users[value.toInt()].length > 6
                                ? '${users[value.toInt()].substring(0, 6)}...'
                                : users[value.toInt()],
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}h',
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: hoursPerUser.entries
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.value,
                            color: Theme.of(context).colorScheme.primary,
                            width: 20,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                          ),
                        ],
                      );
                    })
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPieChart(
    BuildContext context,
    AppLocalizations l10n,
    AdminDashboardState state,
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

  Widget _buildComparisonTable(
    BuildContext context,
    AppLocalizations l10n,
    AdminDashboardState state,
  ) {
    final comparisons = state.userComparisons;

    if (comparisons.isEmpty) {
      return const SizedBox.shrink();
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      enableBlur: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.periodComparison,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
              columns: [
                DataColumn(label: Text(l10n.user)),
                DataColumn(label: Text(l10n.thisPeriod), numeric: true),
                DataColumn(label: Text(l10n.lastPeriod), numeric: true),
                DataColumn(label: Text(l10n.change), numeric: true),
              ],
              rows: comparisons.take(10).map((c) {
                final changeColor = c.changePercent > 0
                    ? Colors.green
                    : c.changePercent < 0
                        ? Colors.red
                        : Colors.grey;
                final changeIcon = c.changePercent > 0
                    ? Icons.trending_up
                    : c.changePercent < 0
                        ? Icons.trending_down
                        : Icons.remove;

                return DataRow(
                  cells: [
                    DataCell(Text(
                      c.userName.length > 15
                          ? '${c.userName.substring(0, 15)}...'
                          : c.userName,
                    )),
                    DataCell(Text('${c.hoursThisPeriod.toStringAsFixed(1)}h')),
                    DataCell(Text('${c.hoursLastPeriod.toStringAsFixed(1)}h')),
                    DataCell(Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(changeIcon, size: 16, color: changeColor),
                        const SizedBox(width: 4),
                        Text(
                          '${c.changePercent.abs().toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: changeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(
    BuildContext context,
    AppLocalizations l10n,
    List<TimeEntry> entries,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      enableBlur: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.recentActivity,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (entries.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  l10n.noActivity,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            )
          else
            ...entries.take(5).map((e) => _ActivityTile(entry: e)),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final TimeEntry entry;

  const _ActivityTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
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
                entry.userName[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  '${entry.location} • ${TimeEntry.formatDuration(entry.totalWorked)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '${entry.date.day}/${entry.date.month}',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
