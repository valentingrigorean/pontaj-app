import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'enums.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final Role role;
  final double? salaryAmount;
  final SalaryType salaryType;
  final Currency currency;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    required this.role,
    this.salaryAmount,
    this.salaryType = .hourly,
    this.currency = .lei,
  });

  /// Returns display name or email prefix for UI display
  String get displayNameOrEmail => displayName ?? email.split('@').first;

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        role,
        salaryAmount,
        salaryType,
        currency,
      ];

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        if (displayName != null) 'displayName': displayName,
        'role': role.name,
        if (salaryAmount != null) 'salaryAmount': salaryAmount,
        'salaryType': salaryType.name,
        'currency': currency.name,
      };

  Map<String, dynamic> toFirestore() => {
        'email': email,
        if (displayName != null) 'displayName': displayName,
        'role': role.name,
        if (salaryAmount != null) 'salaryAmount': salaryAmount,
        'salaryType': salaryType.name,
        'currency': currency.name,
        'createdAt': FieldValue.serverTimestamp(),
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String? ?? '',
        email: json['email'] as String? ?? json['username'] as String? ?? '',
        displayName: json['displayName'] as String?,
        role: (json['role'] as String?) == 'admin' ? .admin : .user,
        salaryAmount: (json['salaryAmount'] as num?)?.toDouble() ??
            (json['hourlyRate'] as num?)?.toDouble(),
        salaryType: (json['salaryType'] as String?) == 'monthly'
            ? .monthly
            : .hourly,
        currency: (json['currency'] as String?) == 'euro'
            ? .euro
            : .lei,
      );

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String?,
      role: (data['role'] as String?) == 'admin' ? .admin : .user,
      salaryAmount: (data['salaryAmount'] as num?)?.toDouble(),
      salaryType: (data['salaryType'] as String?) == 'monthly'
          ? .monthly
          : .hourly,
      currency: (data['currency'] as String?) == 'euro'
          ? .euro
          : .lei,
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    Role? role,
    double? salaryAmount,
    SalaryType? salaryType,
    Currency? currency,
  }) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        displayName: displayName ?? this.displayName,
        role: role ?? this.role,
        salaryAmount: salaryAmount ?? this.salaryAmount,
        salaryType: salaryType ?? this.salaryType,
        currency: currency ?? this.currency,
      );

  bool get isAdmin => role == .admin;
}
