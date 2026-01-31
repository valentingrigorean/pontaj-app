// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationPrefs _$NotificationPrefsFromJson(Map<String, dynamic> json) =>
    _NotificationPrefs(
      dailyReminder: json['dailyReminder'] as bool? ?? true,
      weeklyReport: json['weeklyReport'] as bool? ?? true,
      invoiceAlerts: json['invoiceAlerts'] as bool? ?? true,
    );

Map<String, dynamic> _$NotificationPrefsToJson(_NotificationPrefs instance) =>
    <String, dynamic>{
      'dailyReminder': instance.dailyReminder,
      'weeklyReport': instance.weeklyReport,
      'invoiceAlerts': instance.invoiceAlerts,
    };

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String?,
  email: json['email'] as String,
  displayName: json['displayName'] as String?,
  role: $enumDecodeNullable(_$RoleEnumMap, json['role']) ?? Role.user,
  salaryAmount: (json['salaryAmount'] as num?)?.toDouble(),
  salaryType:
      $enumDecodeNullable(_$SalaryTypeEnumMap, json['salaryType']) ??
      SalaryType.hourly,
  currency:
      $enumDecodeNullable(_$CurrencyEnumMap, json['currency']) ?? Currency.lei,
  fcmToken: json['fcmToken'] as String?,
  notificationPrefs: json['notificationPrefs'] == null
      ? null
      : NotificationPrefs.fromJson(
          json['notificationPrefs'] as Map<String, dynamic>,
        ),
  createdAt: const ServerTimestampConverter().fromJson(json['createdAt']),
  updatedAt: const ServerTimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'displayName': instance.displayName,
  'role': _$RoleEnumMap[instance.role]!,
  'salaryAmount': instance.salaryAmount,
  'salaryType': _$SalaryTypeEnumMap[instance.salaryType]!,
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'fcmToken': instance.fcmToken,
  'notificationPrefs': instance.notificationPrefs,
  'createdAt': const ServerTimestampConverter().toJson(instance.createdAt),
  'updatedAt': const ServerTimestampConverter().toJson(instance.updatedAt),
};

const _$RoleEnumMap = {Role.user: 'user', Role.admin: 'admin'};

const _$SalaryTypeEnumMap = {
  SalaryType.hourly: 'hourly',
  SalaryType.monthly: 'monthly',
};

const _$CurrencyEnumMap = {Currency.lei: 'lei', Currency.euro: 'euro'};
