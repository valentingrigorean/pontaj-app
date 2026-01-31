import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters/duration_converter.dart';
import 'enums.dart';
import 'time_entry.dart';

part 'period_summary.freezed.dart';
part 'period_summary.g.dart';

@freezed
abstract class PeriodSummary with _$PeriodSummary {
  const PeriodSummary._();

  const factory PeriodSummary({
    required String userId,
    required String userName,
    required DateTime periodStart,
    required DateTime periodEnd,
    @DurationConverter() required Duration totalWorked,
    required int entryCount,
    required List<String> entryIds,
    double? hourlyRate,
    @Default(Currency.lei) Currency currency,
  }) = _PeriodSummary;

  factory PeriodSummary.fromJson(Map<String, dynamic> json) =>
      _$PeriodSummaryFromJson(json);

  factory PeriodSummary.fromEntries({
    required String userId,
    required String userName,
    required DateTime periodStart,
    required DateTime periodEnd,
    required List<TimeEntry> entries,
    double? hourlyRate,
    Currency currency = Currency.lei,
  }) {
    final totalMinutes = entries.fold<int>(0, (s, e) => s + e.totalWorked.inMinutes);
    return PeriodSummary(
      userId: userId,
      userName: userName,
      periodStart: periodStart,
      periodEnd: periodEnd,
      totalWorked: Duration(minutes: totalMinutes),
      entryCount: entries.length,
      entryIds: entries.where((e) => e.id != null).map((e) => e.id!).toList(),
      hourlyRate: hourlyRate,
      currency: currency,
    );
  }

  // Getters
  double get totalHours => totalWorked.inMinutes / 60.0;
  double? get totalAmount => hourlyRate != null ? totalHours * hourlyRate! : null;
  String get formattedHours => TimeEntry.formatDuration(totalWorked);
}
