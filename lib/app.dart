import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/l10n/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/theme_cubit.dart';
import 'data/repositories/firebase_auth_repository.dart';
import 'data/repositories/firestore_time_entry_repository.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/time_entry/bloc/time_entry_bloc.dart';

class PontajApp extends StatefulWidget {
  final FirebaseAuthRepository authRepository;
  final FirestoreTimeEntryRepository timeEntryRepository;

  const PontajApp({
    super.key,
    required this.authRepository,
    required this.timeEntryRepository,
  });

  @override
  State<PontajApp> createState() => _PontajAppState();
}

class _PontajAppState extends State<PontajApp> {
  late final AuthBloc _authBloc;
  late final TimeEntryBloc _timeEntryBloc;
  late final ThemeCubit _themeCubit;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authBloc = .new(authRepository: widget.authRepository);
    _timeEntryBloc = .new(repository: widget.timeEntryRepository);
    _themeCubit = .new()..loadTheme();
    _appRouter = .new(authBloc: _authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    _timeEntryBloc.close();
    _themeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<TimeEntryBloc>.value(value: _timeEntryBloc),
        BlocProvider<ThemeCubit>.value(value: _themeCubit),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            routerConfig: _appRouter.router,
            scrollBehavior: const _AppScrollBehavior(),
            debugShowCheckedModeBanner: false,
            title: 'Pontaj PRO',
            themeMode: themeState.effectiveThemeMode,
            theme: _themeCubit.getLightTheme(),
            darkTheme: _themeCubit.getDarkTheme(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: themeState.locale,
          );
        },
      ),
    );
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
