import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/models/time_entry.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../time_entry/bloc/time_entry_bloc.dart';
import '../../time_entry/bloc/time_entry_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<TimeEntryBloc, TimeEntryState>(
      builder: (context, state) {
        if (state is! TimeEntryLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final entries = state.entries;
        final totalHours =
            entries.fold<double>(0, (sum, e) => sum + e.totalWorked.inMinutes / 60);
        final totalDays = entries.length;
        final uniqueUsers =
            entries.map((e) => e.user).toSet().length;
        final avgHoursPerDay = totalDays > 0 ? totalHours / totalDays : 0.0;

        final hoursPerUser = <String, double>{};
        for (final e in entries) {
          hoursPerUser[e.user] =
              (hoursPerUser[e.user] ?? 0) + e.totalWorked.inMinutes / 60;
        }

        return GradientBackground(
          animated: false,
          child: SingleChildScrollView(
            padding: ResponsiveSpacing.pagePadding(context),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveGrid(
                      mobileColumns: 2,
                      tabletColumns: 4,
                      desktopColumns: 4,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _StatCard(
                          icon: Icons.access_time,
                          label: l10n.totalHours,
                          value: '${totalHours.toStringAsFixed(1)}h',
                          color: Colors.blue,
                        ),
                        _StatCard(
                          icon: Icons.calendar_today,
                          label: l10n.totalDays,
                          value: '$totalDays',
                          color: Colors.green,
                        ),
                        _StatCard(
                          icon: Icons.people,
                          label: l10n.users,
                          value: '$uniqueUsers',
                          color: Colors.purple,
                        ),
                        _StatCard(
                          icon: Icons.trending_up,
                          label: l10n.averagePerDay,
                          value: '${avgHoursPerDay.toStringAsFixed(1)}h',
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                if (hoursPerUser.isNotEmpty) ...[
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    enableBlur: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.hoursPerUser,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
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
                                  : hoursPerUser.values
                                          .reduce((a, b) => a > b ? a : b) *
                                      1.2,
                              barTouchData: BarTouchData(enabled: true),
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
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 20,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  enableBlur: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.recentActivity,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
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
                ),
              ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      enableBlur: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
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
                entry.user[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.user,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
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
