import '../../../data/models/user.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);
}

final class AuthRegistrationSuccess extends AuthState {
  const AuthRegistrationSuccess();
}
