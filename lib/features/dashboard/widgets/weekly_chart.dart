import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/glass_card.dart';

class WeeklyChart extends StatelessWidget {
  final Map<int, double> hoursPerDay;
  final double targetHours;

  const WeeklyChart({
    super.key,
    required this.hoursPerDay,
    this.targetHours = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final maxY = hoursPerDay.values.isEmpty
        ? targetHours + 2
        : (hoursPerDay.values.reduce((a, b) => a > b ? a : b) * 1.2).clamp(
            targetHours,
            double.infinity,
          );

    return GlassCard(
      padding: const .all(20),
      enableBlur: false,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.weeklyHours,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toStringAsFixed(1)}h',
                        const TextStyle(color: Colors.white, fontWeight: .bold),
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
                        final days = _getDayNames(context);
                        if (value.toInt() >= days.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const .only(top: 8),
                          child: Text(
                            days[value.toInt()],
                            style: const TextStyle(fontSize: 11),
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
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: targetHours,
                  getDrawingHorizontalLine: (value) {
                    if (value == targetHours) {
                      return FlLine(
                        color: Colors.orange.withValues(alpha: 0.5),
                        strokeWidth: 2,
                        dashArray: [5, 5],
                      );
                    }
                    return FlLine(
                      color: Colors.grey.withValues(alpha: 0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: List.generate(7, (index) {
                  final hours = hoursPerDay[index] ?? 0.0;
                  final isToday = DateTime.now().weekday - 1 == index;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: hours,
                        color: isToday
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.6),
                        width: 24,
                        borderRadius: const .only(
                          topLeft: .circular(6),
                          topRight: .circular(6),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: .center,
            children: [
              Container(
                width: 12,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.5),
                  borderRadius: .circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${l10n.dailyTarget}: ${targetHours.toInt()}h',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<String> _getDayNames(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return switch (locale) {
      'ro' => ['L', 'Ma', 'Mi', 'J', 'V', 'S', 'D'],
      'it' => ['L', 'Ma', 'Me', 'G', 'V', 'S', 'D'],
      _ => ['M', 'Tu', 'W', 'Th', 'F', 'Sa', 'Su'],
    };
  }
}
