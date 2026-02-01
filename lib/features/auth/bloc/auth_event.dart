import 'package:google_sign_in/google_sign_in.dart';

sealed class AuthEvent {
  const AuthEvent();
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
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

final class AuthStateChanged extends AuthEvent {
  final String? userId;

  const AuthStateChanged({this.userId});
}

final class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();
}

final class AuthUpgradeToAdminRequested extends AuthEvent {
  final String adminCode;

  const AuthUpgradeToAdminRequested({required this.adminCode});
}

final class AuthGoogleRedirectResultRequested extends AuthEvent {
  const AuthGoogleRedirectResultRequested();
}

final class AuthOneTapSignInReceived extends AuthEvent {
  final GoogleSignInAccount account;

  const AuthOneTapSignInReceived(this.account);
}
