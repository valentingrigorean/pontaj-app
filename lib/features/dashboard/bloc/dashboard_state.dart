import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/date_period.dart';
import '../../../data/models/time_entry.dart';

part 'dashboard_state.freezed.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const DashboardState._();

  const factory DashboardState({
    required DatePeriod selectedPeriod,
    @Default([]) List<TimeEntry> allEntries,
    @Default(false) bool isLoading,
  }) = _DashboardState;

  factory DashboardState.initial() => DashboardState(
    selectedPeriod: DatePeriod.week(),
  );

  List<TimeEntry> get periodEntries {
    return allEntries.where((entry) {
      return selectedPeriod.contains(entry.date);
    }).toList();
  }

  List<TimeEntry> get previousPeriodEntries {
    final prevPeriod = selectedPeriod.previous;
    return allEntries.where((entry) {
      return prevPeriod.contains(entry.date);
    }).toList();
  }

  double get totalHoursThisPeriod {
    return periodEntries.fold<double>(
      0,
      (sum, e) => sum + e.totalWorked.inMinutes / 60,
    );
  }

  double get totalHoursLastPeriod {
    return previousPeriodEntries.fold<double>(
      0,
      (sum, e) => sum + e.totalWorked.inMinutes / 60,
    );
  }

  double get periodTrend {
    if (totalHoursLastPeriod == 0) return 0;
    return ((totalHoursThisPeriod - totalHoursLastPeriod) / totalHoursLastPeriod) * 100;
  }

  int get daysWorkedThisPeriod {
    final uniqueDays = <String>{};
    for (final entry in periodEntries) {
      uniqueDays.add('${entry.date.year}-${entry.date.month}-${entry.date.day}');
    }
    return uniqueDays.length;
  }

  double get avgHoursPerDay {
    if (daysWorkedThisPeriod == 0) return 0;
    return totalHoursThisPeriod / daysWorkedThisPeriod;
  }

  Map<String, double> get hoursByLocation {
    final result = <String, double>{};
    for (final entry in periodEntries) {
      result[entry.location] = (result[entry.location] ?? 0) + entry.totalWorked.inMinutes / 60;
    }
    return result;
  }

  String get topLocation {
    if (hoursByLocation.isEmpty) return '';
    var maxLocation = '';
    var maxHours = 0.0;
    for (final entry in hoursByLocation.entries) {
      if (entry.value > maxHours) {
        maxHours = entry.value;
        maxLocation = entry.key;
      }
    }
    return maxLocation;
  }

  Map<int, double> get weeklyHours {
    final result = <int, double>{};
    for (final entry in periodEntries) {
      final dayIndex = entry.date.weekday - 1;
      result[dayIndex] = (result[dayIndex] ?? 0) + entry.totalWorked.inMinutes / 60;
    }
    return result;
  }

  Map<DateTime, double> get dailyHours {
    final result = <DateTime, double>{};
    for (final entry in periodEntries) {
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      result[date] = (result[date] ?? 0) + entry.totalWorked.inMinutes / 60;
    }
    return result;
  }
}
