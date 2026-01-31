import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters/duration_converter.dart';
import 'converters/timestamp_converter.dart';
import 'converters/server_timestamp_converter.dart';

part 'time_entry.freezed.dart';
part 'time_entry.g.dart';

@freezed
abstract class TimeEntry with _$TimeEntry {
  const TimeEntry._();

  const factory TimeEntry({
    String? id,
    String? userId,
    required String userName,
    required String location,
    required String intervalText,
    @Default(0) int breakMinutes,
    @TimestampConverter() required DateTime date,
    @DurationConverter() required Duration totalWorked,
    @ServerTimestampConverter() DateTime? createdAt,
  }) = _TimeEntry;

  factory TimeEntry.fromJson(Map<String, dynamic> json) => _$TimeEntryFromJson(json);

  factory TimeEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return TimeEntry.fromJson({
      ...data,
      'id': doc.id,
      'totalWorked': data['totalWorkedMinutes'] ?? 0,
    });
  }

  // Helpers
  static String formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  String get formattedTotalWorked => formatDuration(totalWorked);

  // Firestore
  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'userName': userName,
        'location': location,
        'intervalText': intervalText,
        'breakMinutes': breakMinutes,
        'date': Timestamp.fromDate(date),
        'totalWorkedMinutes': totalWorked.inMinutes,
        'createdAt': FieldValue.serverTimestamp(),
      };

  Map<String, dynamic> toFirestoreUpdate() => {
        'userName': userName,
        'location': location,
        'intervalText': intervalText,
        'breakMinutes': breakMinutes,
        'date': Timestamp.fromDate(date),
        'totalWorkedMinutes': totalWorked.inMinutes,
      };
}
