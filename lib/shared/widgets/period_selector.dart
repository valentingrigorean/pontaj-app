import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../data/models/date_period.dart';

class PeriodSelector extends StatelessWidget {
  final DatePeriod selectedPeriod;
  final ValueChanged<DatePeriod> onPeriodChanged;
  final bool showNavigation;

  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    this.showNavigation = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: [
        SegmentedButton<PeriodType>(
          segments: [
            ButtonSegment(
              value: PeriodType.week,
              label: Text(l10n.week),
              icon: const Icon(Icons.view_week, size: 18),
            ),
            ButtonSegment(
              value: PeriodType.month,
              label: Text(l10n.thisMonth),
              icon: const Icon(Icons.calendar_month, size: 18),
            ),
            ButtonSegment(
              value: PeriodType.year,
              label: Text(l10n.year),
              icon: const Icon(Icons.calendar_today, size: 18),
            ),
            ButtonSegment(
              value: PeriodType.custom,
              label: Text(l10n.custom),
              icon: const Icon(Icons.date_range, size: 18),
            ),
          ],
          selected: {selectedPeriod.type},
          onSelectionChanged: (selection) => _onTypeChanged(context, selection.first),
          showSelectedIcon: false,
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            textStyle: WidgetStateProperty.all(
              theme.textTheme.labelMedium,
            ),
          ),
        ),
        if (showNavigation) ...[
          const SizedBox(height: 12),
          _buildNavigationRow(context, l10n),
        ],
      ],
    );
  }

  Widget _buildNavigationRow(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final canGoNext = !_isCurrentPeriod();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => onPeriodChanged(selectedPeriod.previous),
            icon: const Icon(Icons.chevron_left),
            tooltip: l10n.lastWeek,
            visualDensity: VisualDensity.compact,
          ),
          Expanded(
            child: GestureDetector(
              onTap: selectedPeriod.type == PeriodType.custom
                  ? () => _showDateRangePicker(context)
                  : null,
              child: Column(
                children: [
                  Text(
                    _getPeriodLabel(l10n),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    selectedPeriod.formatRange(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: canGoNext ? () => onPeriodChanged(selectedPeriod.next) : null,
            icon: const Icon(Icons.chevron_right),
            tooltip: l10n.thisWeek,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  String _getPeriodLabel(AppLocalizations l10n) {
    switch (selectedPeriod.type) {
      case PeriodType.week:
        if (_isCurrentPeriod()) return l10n.thisWeek;
        return l10n.week;
      case PeriodType.month:
        if (_isCurrentPeriod()) return l10n.thisMonth;
        return _getMonthName(selectedPeriod.startDate.month);
      case PeriodType.year:
        return selectedPeriod.startDate.year.toString();
      case PeriodType.custom:
        return l10n.custom;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  bool _isCurrentPeriod() {
    final now = DateTime.now();
    final currentPeriod = switch (selectedPeriod.type) {
      PeriodType.week => DatePeriod.week(now),
      PeriodType.month => DatePeriod.month(now),
      PeriodType.year => DatePeriod.year(now),
      PeriodType.custom => selectedPeriod,
    };
    return selectedPeriod.startDate.year == currentPeriod.startDate.year &&
           selectedPeriod.startDate.month == currentPeriod.startDate.month &&
           selectedPeriod.startDate.day == currentPeriod.startDate.day;
  }

  void _onTypeChanged(BuildContext context, PeriodType type) {
    final now = DateTime.now();
    final newPeriod = switch (type) {
      PeriodType.week => DatePeriod.week(now),
      PeriodType.month => DatePeriod.month(now),
      PeriodType.year => DatePeriod.year(now),
      PeriodType.custom => () {
        _showDateRangePicker(context);
        return selectedPeriod.copyWith(type: PeriodType.custom);
      }(),
    };
    if (type != PeriodType.custom) {
      onPeriodChanged(newPeriod);
    }
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: selectedPeriod.startDate,
        end: selectedPeriod.endDate,
      ),
      helpText: l10n.selectDateRange,
      saveText: l10n.ok,
      cancelText: l10n.cancel,
    );

    if (picked != null) {
      onPeriodChanged(DatePeriod.custom(picked.start, picked.end));
    }
  }
}
