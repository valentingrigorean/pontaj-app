import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'app.dart';
import 'core/platform/url_strategy.dart';
import 'data/repositories/firebase_auth_repository.dart';
import 'data/repositories/firestore_time_entry_repository.dart';
import 'firebase_options.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    providerWeb: ReCaptchaEnterpriseProvider(
      '6LfnX1wsAAAAACvw99E-e3JQ8wjvUBlLp9uB_8DR',
    ),
    providerAndroid: kDebugMode
        ? const AndroidDebugProvider()
        : const AndroidPlayIntegrityProvider(),
    providerApple: kDebugMode
        ? const AppleDebugProvider()
        : const AppleDeviceCheckProvider(),
  );

  if (kIsWeb) {
    await GoogleSignIn.instance.initialize(
      clientId:
          '986562521840-mqlbhtdm63rhm9cfesr9l6gomuoi2dek.apps.googleusercontent.com',
    );
  }

  final authRepository = FirebaseAuthRepository();
  final timeEntryRepository = FirestoreTimeEntryRepository();

  runApp(
    PontajApp(
      authRepository: authRepository,
      timeEntryRepository: timeEntryRepository,
    ),
  );
}
