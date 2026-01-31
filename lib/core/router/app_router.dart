import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../../features/admin/pages/admin_home_page.dart';
import '../../features/admin/pages/all_entries_page.dart';
import '../../features/admin/pages/user_entries_page.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/bloc/auth_state.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/auth/pages/splash_page.dart';
import '../../features/invoice/pages/create_invoice_page.dart';
import '../../features/invoice/pages/invoice_detail_page.dart';
import '../../features/invoice/pages/invoice_list_page.dart';
import '../../features/settings/pages/settings_page.dart';
import '../../features/time_entry/pages/pontaj_page.dart';

class AppRouter {
  final AuthBloc authBloc;
  late final GoRouter router;

  AppRouter({required this.authBloc}) {
    router = GoRouter(
      initialLocation: '/',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: _guard,
      routes: [
        GoRoute(
          path: '/',
          name: 'splash',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const LoginPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const RegisterPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/admin',
          name: 'admin',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const AdminHomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/pontaj',
          name: 'pontaj',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            // Get userName from extras, or from authBloc if not provided
            String userName = extra?['user'] as String? ?? '';
            if (userName.isEmpty) {
              final authState = authBloc.state;
              if (authState is AuthAuthenticated) {
                userName = authState.user.displayNameOrEmail;
              } else {
                userName = 'User';
              }
            }
            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: PontajPage(
                userName: userName,
                adminMode: extra?['adminMode'] as bool? ?? false,
                lockName: extra?['lockName'] as bool? ?? false,
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/entries',
          name: 'entries',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return AllEntriesPage(
              initialTab: extra?['initialTab'] as int? ?? 0,
            );
          },
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
        GoRoute(
          path: '/invoices',
          name: 'invoices',
          builder: (context, state) {
            final authState = authBloc.state;
            final isAdmin = authState is AuthAuthenticated && authState.user.isAdmin;
            return InvoiceListPage(isAdmin: isAdmin);
          },
          routes: [
            GoRoute(
              path: 'create',
              name: 'create-invoice',
              builder: (context, state) => const CreateInvoicePage(),
            ),
            GoRoute(
              path: ':invoiceId',
              name: 'invoice-detail',
              builder: (context, state) {
                final invoiceId = state.pathParameters['invoiceId']!;
                final authState = authBloc.state;
                final isAdmin = authState is AuthAuthenticated && authState.user.isAdmin;
                return InvoiceDetailPage(
                  invoiceId: invoiceId,
                  isAdmin: isAdmin,
                );
              },
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => _UnknownRouteScreen(
        error: state.error?.toString(),
      ),
    );
  }

  String? _guard(BuildContext context, GoRouterState state) {
    final authState = authBloc.state;
    final isOnSplash = state.matchedLocation == '/';
    final isOnLogin = state.matchedLocation == '/login';
    final isOnRegister = state.matchedLocation == '/register';

    if (authState is AuthInitial || authState is AuthLoading) {
      // Allow staying on auth pages during loading (login/register submission)
      if (isOnLogin || isOnRegister) return null;
      return isOnSplash ? null : '/';
    }

    if (authState is AuthUnauthenticated || authState is AuthFailure) {
      if (isOnLogin || isOnRegister) return null;
      return '/login';
    }

    if (authState is AuthRegistrationSuccess) {
      return '/login';
    }

    if (authState is AuthAuthenticated) {
      if (isOnSplash || isOnLogin || isOnRegister) {
        if (authState.user.isAdmin) {
          return '/admin';
        }
        // Regular user - go to pontaj with their info
        return '/pontaj';
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.unknownRoute)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.routeNotDefined),
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
              child: Text(l10n.backToLogin),
            ),
          ],
        ),
      ),
    );
  }
}
