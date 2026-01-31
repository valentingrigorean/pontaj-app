import 'package:equatable/equatable.dart';

import 'enums.dart';

class User extends Equatable {
  final String username;
  final String password;
  final Role role;
  final double? salaryAmount;
  final SalaryType salaryType;
  final Currency currency;

  const User({
    required this.username,
    required this.password,
    required this.role,
    this.salaryAmount,
    this.salaryType = SalaryType.hourly,
    this.currency = Currency.lei,
  });

  @override
  List<Object?> get props => [
        username,
        password,
        role,
        salaryAmount,
        salaryType,
        currency,
      ];

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'role': role.name,
        if (salaryAmount != null) 'salaryAmount': salaryAmount,
        'salaryType': salaryType.name,
        'currency': currency.name,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json['username'] as String? ?? '',
        password: json['password'] as String? ?? '',
        role: (json['role'] as String?) == 'admin' ? Role.admin : Role.user,
        salaryAmount: (json['salaryAmount'] as num?)?.toDouble() ??
            (json['hourlyRate'] as num?)?.toDouble(),
        salaryType: (json['salaryType'] as String?) == 'monthly'
            ? SalaryType.monthly
            : SalaryType.hourly,
        currency: (json['currency'] as String?) == 'euro'
            ? Currency.euro
            : Currency.lei,
      );

  User copyWith({
    String? username,
    String? password,
    Role? role,
    double? salaryAmount,
    SalaryType? salaryType,
    Currency? currency,
  }) =>
      User(
        username: username ?? this.username,
        password: password ?? this.password,
        role: role ?? this.role,
        salaryAmount: salaryAmount ?? this.salaryAmount,
        salaryType: salaryType ?? this.salaryType,
        currency: currency ?? this.currency,
      );

  bool get isAdmin => role == Role.admin;
}
