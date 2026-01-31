import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/time_entry/time_entry_bloc.dart';
import 'blocs/theme/theme_cubit.dart';
import 'core/l10n/app_localizations.dart';
import 'core/router/app_router.dart';
import 'repositories/auth_repository.dart';
import 'repositories/time_entry_repository.dart';

class PontajApp extends StatefulWidget {
  final AuthRepository authRepository;
  final TimeEntryRepository timeEntryRepository;

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
    _authBloc = AuthBloc(authRepository: widget.authRepository);
    _timeEntryBloc = TimeEntryBloc(repository: widget.timeEntryRepository);
    _themeCubit = ThemeCubit()..loadTheme();
    _appRouter = AppRouter(authBloc: _authBloc);
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
