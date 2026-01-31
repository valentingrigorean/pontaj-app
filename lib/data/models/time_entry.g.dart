// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimeEntry _$TimeEntryFromJson(Map<String, dynamic> json) => _TimeEntry(
  id: json['id'] as String?,
  userId: json['userId'] as String?,
  userName: json['userName'] as String,
  location: json['location'] as String,
  intervalText: json['intervalText'] as String,
  breakMinutes: (json['breakMinutes'] as num?)?.toInt() ?? 0,
  date: const TimestampConverter().fromJson(json['date']),
  totalWorked: const DurationConverter().fromJson(
    (json['totalWorked'] as num).toInt(),
  ),
  createdAt: const ServerTimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$TimeEntryToJson(_TimeEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'location': instance.location,
      'intervalText': instance.intervalText,
      'breakMinutes': instance.breakMinutes,
      'date': const TimestampConverter().toJson(instance.date),
      'totalWorked': const DurationConverter().toJson(instance.totalWorked),
      'createdAt': const ServerTimestampConverter().toJson(instance.createdAt),
    };
