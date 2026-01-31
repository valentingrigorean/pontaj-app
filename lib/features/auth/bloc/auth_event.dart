import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

final class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

final class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String? displayName;
  final String? adminCode;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    this.displayName,
    this.adminCode,
  });

  @override
  List<Object?> get props => [email, password, displayName, adminCode];
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Event fired when Firebase auth state changes (user signs in/out externally)
final class AuthStateChanged extends AuthEvent {
  final String? userId;

  const AuthStateChanged({this.userId});

  @override
  List<Object?> get props => [userId];
}
