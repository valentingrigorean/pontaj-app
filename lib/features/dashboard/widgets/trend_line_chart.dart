import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/glass_card.dart';

class TrendDataPoint {
  final DateTime date;
  final double hours;

  const TrendDataPoint({required this.date, required this.hours});
}

class TrendLineSeries {
  final String label;
  final List<TrendDataPoint> data;
  final Color color;
  final bool isDashed;

  const TrendLineSeries({
    required this.label,
    required this.data,
    required this.color,
    this.isDashed = false,
  });
}

class TrendLineChart extends StatelessWidget {
  final List<TrendLineSeries> series;
  final String? title;
  final double? targetHours;

  const TrendLineChart({
    super.key,
    required this.series,
    this.title,
    this.targetHours,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (series.isEmpty || series.every((s) => s.data.isEmpty)) {
      return GlassCard(
        padding: const EdgeInsets.all(20),
        enableBlur: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Text(
                title!,
                style: theme.textTheme.titleMedium?.copyWith(
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

    final allPoints = series.expand((s) => s.data).toList();
    final maxY = _calculateMaxY(allPoints);
    final minDate = allPoints.map((p) => p.date).reduce((a, b) => a.isBefore(b) ? a : b);
    final maxDate = allPoints.map((p) => p.date).reduce((a, b) => a.isAfter(b) ? a : b);

    return GlassCard(
      padding: const EdgeInsets.all(20),
      enableBlur: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
          ],
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (value) {
                    if (targetHours != null && (value - targetHours!).abs() < 0.1) {
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
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${date.day}/${date.month}',
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                      interval: _calculateInterval(minDate, maxDate),
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
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final seriesData = series[spot.barIndex];
                        return LineTooltipItem(
                          '${seriesData.label}: ${spot.y.toStringAsFixed(1)}h',
                          TextStyle(
                            color: seriesData.color,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: series.asMap().entries.map((entry) {
                  final seriesData = entry.value;
                  return LineChartBarData(
                    spots: seriesData.data.map((point) {
                      return FlSpot(
                        point.date.millisecondsSinceEpoch.toDouble(),
                        point.hours,
                      );
                    }).toList(),
                    isCurved: true,
                    color: seriesData.color,
                    barWidth: 2,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: seriesData.color,
                          strokeWidth: 1,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: !seriesData.isDashed,
                      gradient: LinearGradient(
                        colors: [
                          seriesData.color.withValues(alpha: 0.3),
                          seriesData.color.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    dashArray: seriesData.isDashed ? [5, 5] : null,
                  );
                }).toList(),
                minX: minDate.millisecondsSinceEpoch.toDouble(),
                maxX: maxDate.millisecondsSinceEpoch.toDouble(),
                minY: 0,
                maxY: maxY,
              ),
            ),
          ),
          if (series.length > 1) ...[
            const SizedBox(height: 12),
            _buildLegend(context),
          ],
          if (targetHours != null) ...[
            const SizedBox(height: 8),
            _buildTargetLegend(context, l10n),
          ],
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: series.map((s) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 3,
              decoration: BoxDecoration(
                color: s.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              s.label,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTargetLegend(BuildContext context, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${l10n.dailyTarget}: ${targetHours!.toInt()}h',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  double _calculateMaxY(List<TrendDataPoint> points) {
    if (points.isEmpty) return 10;
    final maxHours = points.map((p) => p.hours).reduce((a, b) => a > b ? a : b);
    final target = targetHours ?? 8;
    return (maxHours > target ? maxHours : target) * 1.2;
  }

  double _calculateInterval(DateTime minDate, DateTime maxDate) {
    final diff = maxDate.difference(minDate).inDays;
    if (diff <= 7) return const Duration(days: 1).inMilliseconds.toDouble();
    if (diff <= 31) return const Duration(days: 7).inMilliseconds.toDouble();
    return const Duration(days: 30).inMilliseconds.toDouble();
  }
}
