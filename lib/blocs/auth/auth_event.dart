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
  final String username;
  final String password;

  const AuthLoginRequested({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

final class AuthRegisterRequested extends AuthEvent {
  final String username;
  final String password;

  const AuthRegisterRequested({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
