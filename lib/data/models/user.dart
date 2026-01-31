import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters/server_timestamp_converter.dart';
import 'enums.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class NotificationPrefs with _$NotificationPrefs {
  const factory NotificationPrefs({
    @Default(true) bool dailyReminder,
    @Default(true) bool weeklyReport,
    @Default(true) bool invoiceAlerts,
  }) = _NotificationPrefs;

  factory NotificationPrefs.fromJson(Map<String, dynamic> json) =>
      _$NotificationPrefsFromJson(json);
}

@freezed
abstract class User with _$User {
  const User._(); // Private constructor for custom methods

  const factory User({
    String? id,
    required String email,
    String? displayName,
    @Default(Role.user) Role role,
    double? salaryAmount,
    @Default(SalaryType.hourly) SalaryType salaryType,
    @Default(Currency.lei) Currency currency,
    String? fcmToken,
    NotificationPrefs? notificationPrefs,
    @Default(false) bool banned,
    @ServerTimestampConverter() DateTime? bannedAt,
    String? bannedReason,
    @ServerTimestampConverter() DateTime? createdAt,
    @ServerTimestampConverter() DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return User.fromJson({...data, 'id': doc.id});
  }

  // Getters
  String get displayNameOrEmail => displayName ?? email.split('@').first;
  bool get isAdmin => role == Role.admin;

  // Firestore methods
  Map<String, dynamic> toFirestore() {
    final json = toJson()..remove('id');
    if (createdAt == null) json['createdAt'] = FieldValue.serverTimestamp();
    json['updatedAt'] = FieldValue.serverTimestamp();
    return json;
  }

  Map<String, dynamic> toFirestoreUpdate() => {
        if (displayName != null) 'displayName': displayName,
        'role': role.name,
        if (salaryAmount != null) 'salaryAmount': salaryAmount,
        'salaryType': salaryType.name,
        'currency': currency.name,
        if (fcmToken != null) 'fcmToken': fcmToken,
        if (notificationPrefs != null) 'notificationPrefs': notificationPrefs!.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
}
