import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'app.dart';
import 'data/repositories/firebase_auth_repository.dart';
import 'data/repositories/firestore_time_entry_repository.dart';
import 'firebase_options.dart';

void main() async {
  usePathUrlStrategy(); // Enable clean URLs (no hash)
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase App Check
  await FirebaseAppCheck.instance.activate(
    providerWeb: ReCaptchaV3Provider(
      '6LfnX1wsAAAAACvw99E-e3JQ8wjvUBlLp9uB_8DR',
    ),
    providerAndroid: kDebugMode
        ? const AndroidDebugProvider()
        : const AndroidPlayIntegrityProvider(),
    providerApple: kDebugMode
        ? const AppleDebugProvider()
        : const AppleDeviceCheckProvider(),
  );

  // Initialize Google Sign-In for web
  // Client ID is public (visible in browser), not a secret
  if (kIsWeb) {
    await GoogleSignIn.instance.initialize(
      clientId:
          '986562521840-mqlbhtdm63rhm9cfesr9l6gomuoi2dek.apps.googleusercontent.com',
    );
  }

  // Create repositories
  final authRepository = FirebaseAuthRepository();
  final timeEntryRepository = FirestoreTimeEntryRepository();

  runApp(
    PontajApp(
      authRepository: authRepository,
      timeEntryRepository: timeEntryRepository,
    ),
  );
}
