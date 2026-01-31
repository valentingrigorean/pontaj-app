import 'package:flutter/material.dart';

import '../../../shared/widgets/glass_card.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? subtitle;
  final Widget? trailing;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const .all(16),
      enableBlur: false,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Container(
                padding: const .all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: .circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: .bold),
          ),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(color: Colors.grey[500], fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}

class TrendIndicator extends StatelessWidget {
  final double percentage;
  final bool isPositive;

  const TrendIndicator({
    super.key,
    required this.percentage,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? Colors.green : Colors.red;
    final icon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Container(
      padding: const .symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: .circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            '${percentage.abs().toStringAsFixed(0)}%',
            style: TextStyle(color: color, fontWeight: .bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
