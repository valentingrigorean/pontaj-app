import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/date_period.dart';
import '../../../data/models/time_entry.dart';

part 'admin_dashboard_state.freezed.dart';

@freezed
abstract class UserPeriodComparison with _$UserPeriodComparison {
  const factory UserPeriodComparison({
    required String userName,
    required double hoursThisPeriod,
    required double hoursLastPeriod,
    required double changePercent,
  }) = _UserPeriodComparison;
}

@freezed
abstract class AdminDashboardState with _$AdminDashboardState {
  const AdminDashboardState._();

  const factory AdminDashboardState({
    required DatePeriod selectedPeriod,
    @Default([]) List<TimeEntry> allEntries,
    @Default(false) bool isLoading,
  }) = _AdminDashboardState;

  factory AdminDashboardState.initial() => AdminDashboardState(
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

  int get activeUsersCount {
    return periodEntries.map((e) => e.userName).toSet().length;
  }

  double get avgHoursPerUser {
    if (activeUsersCount == 0) return 0;
    return totalHoursThisPeriod / activeUsersCount;
  }

  String get topUser {
    final hoursPerUser = <String, double>{};
    for (final entry in periodEntries) {
      hoursPerUser[entry.userName] =
          (hoursPerUser[entry.userName] ?? 0) + entry.totalWorked.inMinutes / 60;
    }
    if (hoursPerUser.isEmpty) return '';
    var topName = '';
    var maxHours = 0.0;
    for (final entry in hoursPerUser.entries) {
      if (entry.value > maxHours) {
        maxHours = entry.value;
        topName = entry.key;
      }
    }
    return topName;
  }

  Map<String, double> get hoursByUser {
    final result = <String, double>{};
    for (final entry in periodEntries) {
      result[entry.userName] =
          (result[entry.userName] ?? 0) + entry.totalWorked.inMinutes / 60;
    }
    return result;
  }

  Map<String, double> get hoursByLocation {
    final result = <String, double>{};
    for (final entry in periodEntries) {
      result[entry.location] =
          (result[entry.location] ?? 0) + entry.totalWorked.inMinutes / 60;
    }
    return result;
  }

  List<UserPeriodComparison> get userComparisons {
    final currentHours = <String, double>{};
    final previousHours = <String, double>{};

    for (final entry in periodEntries) {
      currentHours[entry.userName] =
          (currentHours[entry.userName] ?? 0) + entry.totalWorked.inMinutes / 60;
    }

    for (final entry in previousPeriodEntries) {
      previousHours[entry.userName] =
          (previousHours[entry.userName] ?? 0) + entry.totalWorked.inMinutes / 60;
    }

    final allUsers = {...currentHours.keys, ...previousHours.keys};
    final comparisons = <UserPeriodComparison>[];

    for (final userName in allUsers) {
      final current = currentHours[userName] ?? 0;
      final previous = previousHours[userName] ?? 0;
      final change = previous > 0 ? ((current - previous) / previous) * 100 : 0.0;

      comparisons.add(UserPeriodComparison(
        userName: userName,
        hoursThisPeriod: current,
        hoursLastPeriod: previous,
        changePercent: change,
      ));
    }

    comparisons.sort((a, b) => b.hoursThisPeriod.compareTo(a.hoursThisPeriod));
    return comparisons;
  }

  Map<DateTime, double> get dailyTeamHours {
    final result = <DateTime, double>{};
    for (final entry in periodEntries) {
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      result[date] = (result[date] ?? 0) + entry.totalWorked.inMinutes / 60;
    }
    return result;
  }

  Map<String, Map<DateTime, double>> get dailyHoursByUser {
    final result = <String, Map<DateTime, double>>{};
    for (final entry in periodEntries) {
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      result.putIfAbsent(entry.userName, () => {});
      result[entry.userName]![date] =
          (result[entry.userName]![date] ?? 0) + entry.totalWorked.inMinutes / 60;
    }
    return result;
  }
}
