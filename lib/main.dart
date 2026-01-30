import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'pontaj_page_new.dart';
import 'all_entries_page.dart';
import 'register_page.dart';
import 'user_entries_page.dart';
import 'splash_screen.dart';
import 'settings_page.dart';
import 'store.dart';
import 'theme_provider.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
final ThemeProvider themeProvider = ThemeProvider();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await appStore.load(); // load users + entries
  } catch (e, stack) {
    debugPrint('Error loading app data: $e\n$stack');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, _) {
        return Listener(
          onPointerDown: _handlePointerDown,
          child: MaterialApp(
            navigatorKey: appNavigatorKey,
            scrollBehavior: const _AppScrollBehavior(),
            debugShowCheckedModeBanner: false,
            title: 'Pontaj PRO',
            themeMode: themeProvider.effectiveThemeMode,
            theme: themeProvider.getLightTheme(),
            darkTheme: themeProvider.getDarkTheme(),
            initialRoute: '/splash',

            // Static routes
            routes: {
              '/login': (context) => const LoginPage(),
              '/admin': (context) => const AdminHomePage(),
              '/entries': (context) => const AllEntriesPage(),
              '/register': (context) => const RegisterPage(),
              '/userEntries': (context) => const UserEntriesPage(),
              '/splash': (context) => const SplashScreen(),
              '/settings': (context) => SettingsPage(themeProvider: themeProvider),
            },

            // Dynamic / argumented routes
            onGenerateRoute: (settings) {
              debugPrint('NAV -> ${settings.name}  ARGS -> ${settings.arguments}');
              switch (settings.name) {
                case '/pontaj':
                  final args = settings.arguments;
                  final Map safeArgs = (args is Map) ? args : {};

                  final String user = safeArgs['user']?.toString() ?? 'Utilizator';
                  final bool adminMode = safeArgs['adminMode'] is bool
                      ? safeArgs['adminMode']
                      : false;
                  final bool lockName = safeArgs['lockName'] is bool
                      ? safeArgs['lockName']
                      : false;

                  return MaterialPageRoute(
                    builder: (_) => PontajPageNew(
                      userName: user,
                      adminMode: adminMode,
                      lockName: lockName,
                    ),
                    settings: settings,
                  );

                default:
                  return MaterialPageRoute(
                    builder: (_) => const _UnknownRouteScreen(),
                    settings: settings,
                  );
              }
            },
          ),
        );
      },
    );
  }

  void _handlePointerDown(PointerDownEvent event) {
    if ((event.buttons & kBackMouseButton) != 0) {
      final navigator = appNavigatorKey.currentState;
      if (navigator != null && navigator.canPop()) navigator.pop();
    }
  }
}

class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruta necunoscuta')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ruta solicitata nu este definita.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Inapoi la Login'),
            ),
          ],
        ),
      ),
    );
  }
}
