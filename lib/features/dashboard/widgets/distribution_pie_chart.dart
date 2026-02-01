import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/glass_card.dart';

class DistributionItem {
  final String label;
  final double value;
  final Color color;

  const DistributionItem({
    required this.label,
    required this.value,
    required this.color,
  });
}

class DistributionPieChart extends StatefulWidget {
  final List<DistributionItem> items;
  final String? title;
  final String? centerText;
  final String? centerSubtext;

  const DistributionPieChart({
    super.key,
    required this.items,
    this.title,
    this.centerText,
    this.centerSubtext,
  });

  @override
  State<DistributionPieChart> createState() => _DistributionPieChartState();
}

class _DistributionPieChartState extends State<DistributionPieChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final total = widget.items.fold<double>(0, (sum, item) => sum + item.value);

    if (widget.items.isEmpty || total == 0) {
      return GlassCard(
        padding: const EdgeInsets.all(20),
        enableBlur: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null)
              Text(
                widget.title!,
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

    return GlassCard(
      padding: const EdgeInsets.all(20),
      enableBlur: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Text(
              widget.title!,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          if (response == null || response.touchedSection == null) {
                            touchedIndex = null;
                          } else {
                            touchedIndex = response.touchedSection!.touchedSectionIndex;
                          }
                        });
                      },
                    ),
                    startDegreeOffset: -90,
                    sectionsSpace: 2,
                    centerSpaceRadius: 60,
                    sections: widget.items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isTouched = index == touchedIndex;
                      final percentage = (item.value / total * 100);

                      return PieChartSectionData(
                        color: item.color,
                        value: item.value,
                        title: '${percentage.toStringAsFixed(0)}%',
                        radius: isTouched ? 45 : 40,
                        titleStyle: TextStyle(
                          fontSize: isTouched ? 14 : 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        titlePositionPercentageOffset: 0.55,
                      );
                    }).toList(),
                  ),
                ),
                if (widget.centerText != null || widget.centerSubtext != null)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.centerText != null)
                        Text(
                          widget.centerText!,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (widget.centerSubtext != null)
                        Text(
                          widget.centerSubtext!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildLegend(theme, total),
        ],
      ),
    );
  }

  Widget _buildLegend(ThemeData theme, double total) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: widget.items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final percentage = (item.value / total * 100);
        final isTouched = index == touchedIndex;

        return GestureDetector(
          onTap: () {
            setState(() {
              touchedIndex = touchedIndex == index ? null : index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isTouched
                  ? item.color.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  item.label.length > 12
                      ? '${item.label.substring(0, 12)}...'
                      : item.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${percentage.toStringAsFixed(0)}%)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

List<Color> generateChartColors(int count) {
  const baseColors = [
    Color(0xFF4CAF50),
    Color(0xFF2196F3),
    Color(0xFFFF9800),
    Color(0xFF9C27B0),
    Color(0xFFE91E63),
    Color(0xFF00BCD4),
    Color(0xFFFF5722),
    Color(0xFF795548),
    Color(0xFF607D8B),
    Color(0xFFCDDC39),
  ];

  if (count <= baseColors.length) {
    return baseColors.take(count).toList();
  }

  final colors = List<Color>.from(baseColors);
  for (var i = baseColors.length; i < count; i++) {
    final baseColor = baseColors[i % baseColors.length];
    final factor = 0.7 + (0.3 * ((i ~/ baseColors.length) % 3) / 2);
    colors.add(Color.lerp(baseColor, Colors.white, 1 - factor)!);
  }
  return colors;
}
