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

/// Event fired when Firebase auth state changes (user signs in/out externally)
final class AuthStateChanged extends AuthEvent {
  final String? userId;

  const AuthStateChanged({this.userId});
}

/// Event fired when user requests Google Sign-In
final class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();
}

/// Event fired when authenticated user wants to upgrade to admin role
final class AuthUpgradeToAdminRequested extends AuthEvent {
  final String adminCode;

  const AuthUpgradeToAdminRequested({required this.adminCode});
}

/// Event fired to check for pending Google Sign-In redirect result (mobile web)
final class AuthGoogleRedirectResultRequested extends AuthEvent {
  const AuthGoogleRedirectResultRequested();
}
