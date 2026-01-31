// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PeriodSummary _$PeriodSummaryFromJson(Map<String, dynamic> json) =>
    _PeriodSummary(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      periodStart: DateTime.parse(json['periodStart'] as String),
      periodEnd: DateTime.parse(json['periodEnd'] as String),
      totalWorked: const DurationConverter().fromJson(
        (json['totalWorked'] as num).toInt(),
      ),
      entryCount: (json['entryCount'] as num).toInt(),
      entryIds: (json['entryIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble(),
      currency:
          $enumDecodeNullable(_$CurrencyEnumMap, json['currency']) ??
          Currency.lei,
    );

Map<String, dynamic> _$PeriodSummaryToJson(_PeriodSummary instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'periodStart': instance.periodStart.toIso8601String(),
      'periodEnd': instance.periodEnd.toIso8601String(),
      'totalWorked': const DurationConverter().toJson(instance.totalWorked),
      'entryCount': instance.entryCount,
      'entryIds': instance.entryIds,
      'hourlyRate': instance.hourlyRate,
      'currency': _$CurrencyEnumMap[instance.currency]!,
    };

const _$CurrencyEnumMap = {Currency.lei: 'lei', Currency.euro: 'euro'};
