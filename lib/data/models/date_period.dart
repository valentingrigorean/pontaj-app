import 'package:freezed_annotation/freezed_annotation.dart';

part 'date_period.freezed.dart';

enum PeriodType { week, month, year, custom }

@freezed
abstract class DatePeriod with _$DatePeriod {
  const DatePeriod._();

  const factory DatePeriod({
    required DateTime startDate,
    required DateTime endDate,
    required PeriodType type,
  }) = _DatePeriod;

  factory DatePeriod.week([DateTime? referenceDate]) {
    final date = referenceDate ?? DateTime.now();
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return DatePeriod(
      startDate: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      endDate: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59),
      type: PeriodType.week,
    );
  }

  factory DatePeriod.month([DateTime? referenceDate]) {
    final date = referenceDate ?? DateTime.now();
    final startOfMonth = DateTime(date.year, date.month, 1);
    final endOfMonth = DateTime(date.year, date.month + 1, 0, 23, 59, 59);
    return DatePeriod(
      startDate: startOfMonth,
      endDate: endOfMonth,
      type: PeriodType.month,
    );
  }

  factory DatePeriod.year([DateTime? referenceDate]) {
    final date = referenceDate ?? DateTime.now();
    final startOfYear = DateTime(date.year, 1, 1);
    final endOfYear = DateTime(date.year, 12, 31, 23, 59, 59);
    return DatePeriod(
      startDate: startOfYear,
      endDate: endOfYear,
      type: PeriodType.year,
    );
  }

  factory DatePeriod.custom(DateTime start, DateTime end) {
    return DatePeriod(
      startDate: DateTime(start.year, start.month, start.day),
      endDate: DateTime(end.year, end.month, end.day, 23, 59, 59),
      type: PeriodType.custom,
    );
  }

  DatePeriod get previous {
    switch (type) {
      case PeriodType.week:
        return DatePeriod.week(startDate.subtract(const Duration(days: 7)));
      case PeriodType.month:
        return DatePeriod.month(DateTime(startDate.year, startDate.month - 1, 1));
      case PeriodType.year:
        return DatePeriod.year(DateTime(startDate.year - 1, 1, 1));
      case PeriodType.custom:
        final duration = endDate.difference(startDate);
        return DatePeriod.custom(
          startDate.subtract(duration + const Duration(days: 1)),
          startDate.subtract(const Duration(days: 1)),
        );
    }
  }

  DatePeriod get next {
    switch (type) {
      case PeriodType.week:
        return DatePeriod.week(startDate.add(const Duration(days: 7)));
      case PeriodType.month:
        return DatePeriod.month(DateTime(startDate.year, startDate.month + 1, 1));
      case PeriodType.year:
        return DatePeriod.year(DateTime(startDate.year + 1, 1, 1));
      case PeriodType.custom:
        final duration = endDate.difference(startDate);
        return DatePeriod.custom(
          endDate.add(const Duration(days: 1)),
          endDate.add(duration + const Duration(days: 1)),
        );
    }
  }

  bool contains(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return !normalizedDate.isBefore(startDate) && !normalizedDate.isAfter(endDate);
  }

  int get dayCount => endDate.difference(startDate).inDays + 1;

  String formatRange() {
    if (startDate.year == endDate.year) {
      if (startDate.month == endDate.month) {
        return '${startDate.day} - ${endDate.day}/${startDate.month}/${startDate.year}';
      }
      return '${startDate.day}/${startDate.month} - ${endDate.day}/${endDate.month}/${startDate.year}';
    }
    return '${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}';
  }
}
