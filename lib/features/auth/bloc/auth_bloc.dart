import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/env.dart';
import '../../../data/models/enums.dart';
import '../../../data/repositories/firebase_auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthRepository _authRepository;
  StreamSubscription<firebase_auth.User?>? _authStateSubscription;

  AuthBloc({required FirebaseAuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthStateChanged>(_onAuthStateChanged);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthUpgradeToAdminRequested>(_onUpgradeToAdminRequested);
    on<AuthGoogleRedirectResultRequested>(_onGoogleRedirectResultRequested);

    // Listen to Firebase auth state changes
    _authStateSubscription = _authRepository.authStateChanges.listen((user) {
      add(AuthStateChanged(userId: user?.uid));
    });
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    // On web, check for pending Google Sign-In redirect result first
    if (kIsWeb) {
      try {
        final redirectUser = await _authRepository.getGoogleRedirectResult();
        if (redirectUser != null) {
          if (redirectUser.banned) {
            await _authRepository.signOut();
            emit(const AuthFailure('Account suspended. Please contact support.'));
            return;
          }
          emit(AuthAuthenticated(redirectUser));
          return;
        }
      } catch (_) {
        // Redirect result check failed, continue with normal auth check
      }
    }

    final firebaseUser = _authRepository.currentFirebaseUser;
    if (firebaseUser != null) {
      final user = await _authRepository.getUserProfile(firebaseUser.uid);
      if (user != null) {
        if (user.banned) {
          await _authRepository.signOut();
          emit(const AuthFailure('Account suspended. Please contact support.'));
          return;
        }
        emit(AuthAuthenticated(user));
        return;
      }
    }

    emit(const AuthUnauthenticated());
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await _authRepository.signIn(event.email, event.password);

      if (user != null) {
        // Check if user is banned
        if (user.banned) {
          await _authRepository.signOut();
          emit(const AuthFailure('Account suspended. Please contact support.'));
          return;
        }
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthFailure('Authentication failed'));
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      emit(AuthFailure(FirebaseAuthRepository.getErrorMessage(e)));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await _authRepository.register(
        event.email,
        event.password,
        adminCode: event.adminCode,
        displayName: event.displayName,
      );

      if (user != null) {
        emit(const AuthRegistrationSuccess());
      } else {
        emit(const AuthFailure('Registration failed'));
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      emit(AuthFailure(FirebaseAuthRepository.getErrorMessage(e)));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.signOut();
    emit(const AuthUnauthenticated());
  }

  Future<void> _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) async {
    // Only handle sign out from this event
    // Sign in is handled by login/register events
    if (event.userId == null && state is AuthAuthenticated) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await _authRepository.signInWithGoogle();

      if (user != null) {
        // Check if user is banned
        if (user.banned) {
          await _authRepository.signOut();
          emit(const AuthFailure('Account suspended. Please contact support.'));
          return;
        }
        emit(AuthAuthenticated(user));
      } else {
        // User cancelled the sign-in
        emit(const AuthUnauthenticated());
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      emit(AuthFailure(FirebaseAuthRepository.getErrorMessage(e)));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onUpgradeToAdminRequested(
    AuthUpgradeToAdminRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AuthAuthenticated) {
      emit(const AuthFailure('You must be logged in to upgrade'));
      return;
    }

    // Validate admin code - use generic error message to prevent enumeration
    final adminSecretCode = Env.adminCode;
    if (adminSecretCode.isEmpty ||
        event.adminCode.isEmpty ||
        event.adminCode != adminSecretCode) {
      emit(const AuthFailure('Invalid admin code'));
      // Re-emit authenticated state so user stays logged in
      emit(currentState);
      return;
    }

    try {
      // Update user role to admin
      final updatedUser = currentState.user.copyWith(role: Role.admin);
      await _authRepository.updateUserProfile(updatedUser);

      // Emit success state with updated user - triggers router redirect to /admin
      emit(AuthAuthenticated(updatedUser));
    } catch (e) {
      emit(const AuthFailure('Failed to upgrade account'));
      // Re-emit authenticated state so user stays logged in
      emit(currentState);
    }
  }

  Future<void> _onGoogleRedirectResultRequested(
    AuthGoogleRedirectResultRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await _authRepository.getGoogleRedirectResult();

      if (user != null) {
        if (user.banned) {
          await _authRepository.signOut();
          emit(const AuthFailure('Account suspended. Please contact support.'));
          return;
        }
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      emit(AuthFailure(FirebaseAuthRepository.getErrorMessage(e)));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
