import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/l10n/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/theme_cubit.dart';
import 'data/repositories/firebase_auth_repository.dart';
import 'data/repositories/firestore_invoice_repository.dart';
import 'data/repositories/firestore_time_entry_repository.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/invoice/bloc/invoice_bloc.dart';
import 'features/time_entry/bloc/time_entry_bloc.dart';
import 'services/notification_service.dart';
import 'services/pdf_service.dart';
import 'services/storage_service.dart';

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
  late final InvoiceBloc _invoiceBloc;
  late final ThemeCubit _themeCubit;
  late final AppRouter _appRouter;
  late final NotificationService _notificationService;
  late final FirestoreInvoiceRepository _invoiceRepository;
  late final PdfService _pdfService;
  late final StorageService _storageService;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(authRepository: widget.authRepository);
    _timeEntryBloc = TimeEntryBloc(repository: widget.timeEntryRepository);
    _notificationService = NotificationService();
    _invoiceRepository = FirestoreInvoiceRepository();
    _pdfService = PdfService();
    _storageService = StorageService();
    _invoiceBloc = InvoiceBloc(
      invoiceRepository: _invoiceRepository,
      pdfService: _pdfService,
      storageService: _storageService,
      notificationService: _notificationService,
    );
    _themeCubit = ThemeCubit()..loadTheme();
    _appRouter = AppRouter(authBloc: _authBloc);

    // Set notification callbacks
    _notificationService.setOnForegroundMessage(_showInAppNotification);
    _notificationService.setOnMessageOpened(_handleNotificationTap);

    // Initialize notification service
    _initializeNotifications();
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    // Navigate based on notification data
    final invoiceId = data['invoiceId'] as String?;
    if (invoiceId != null) {
      _appRouter.router.go('/invoices/$invoiceId');
    }
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
  }

  void _showInAppNotification(String? title, String? body, Map<String, dynamic> data) {
    // Show in-app notification using a global key or BuildContext
    // This will be called when a notification arrives while the app is in foreground
    final context = _appRouter.router.routerDelegate.navigatorKey.currentContext;
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (body != null) Text(body),
            ],
          ),
          action: data['invoiceId'] != null
              ? SnackBarAction(
                  label: 'View',
                  onPressed: () => _appRouter.router.go('/invoices/${data['invoiceId']}'),
                )
              : null,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  void dispose() {
    _authBloc.close();
    _timeEntryBloc.close();
    _invoiceBloc.close();
    _themeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FirebaseAuthRepository>.value(value: widget.authRepository),
        RepositoryProvider<FirestoreTimeEntryRepository>.value(value: widget.timeEntryRepository),
        RepositoryProvider<NotificationService>.value(value: _notificationService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: _authBloc),
          BlocProvider<TimeEntryBloc>.value(value: _timeEntryBloc),
          BlocProvider<InvoiceBloc>.value(value: _invoiceBloc),
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
