import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../pages/splash_page.dart';
import '../../pages/login_page.dart';
import '../../pages/register_page.dart';
import '../../pages/admin_home_page.dart';
import '../../pages/pontaj_page.dart';
import '../../pages/all_entries_page.dart';
import '../../pages/user_entries_page.dart';
import '../../pages/settings_page.dart';

class AppRouter {
  final AuthBloc authBloc;
  late final GoRouter router;

  AppRouter({required this.authBloc}) {
    router = GoRouter(
      initialLocation: '/splash',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: _guard,
      routes: [
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/admin',
          name: 'admin',
          builder: (context, state) => const AdminHomePage(),
        ),
        GoRoute(
          path: '/pontaj',
          name: 'pontaj',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return PontajPage(
              userName: extra?['user'] as String? ?? 'Utilizator',
              adminMode: extra?['adminMode'] as bool? ?? false,
              lockName: extra?['lockName'] as bool? ?? false,
            );
          },
        ),
        GoRoute(
          path: '/entries',
          name: 'entries',
          builder: (context, state) => const AllEntriesPage(),
        ),
        GoRoute(
          path: '/userEntries',
          name: 'userEntries',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return UserEntriesPage(
              userName: extra?['user'] as String? ?? 'Utilizator',
            );
          },
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
      errorBuilder: (context, state) => _UnknownRouteScreen(
        error: state.error?.toString(),
      ),
    );
  }

  String? _guard(BuildContext context, GoRouterState state) {
    final authState = authBloc.state;
    final isOnSplash = state.matchedLocation == '/splash';
    final isOnLogin = state.matchedLocation == '/login';
    final isOnRegister = state.matchedLocation == '/register';

    if (authState is AuthInitial || authState is AuthLoading) {
      return isOnSplash ? null : '/splash';
    }

    if (authState is AuthUnauthenticated || authState is AuthFailure) {
      if (isOnLogin || isOnRegister || isOnSplash) return null;
      return '/login';
    }

    if (authState is AuthRegistrationSuccess) {
      return '/login';
    }

    if (authState is AuthAuthenticated) {
      if (isOnSplash || isOnLogin || isOnRegister) {
        return authState.user.isAdmin ? '/admin' : '/pontaj';
      }
    }

    return null;
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class _UnknownRouteScreen extends StatelessWidget {
  final String? error;

  const _UnknownRouteScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruta necunoscuta')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ruta solicitata nu este definita.'),
            if (error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  error!,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Inapoi la Login'),
            ),
          ],
        ),
      ),
    );
  }
}
