import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'data/repositories/firebase_auth_repository.dart';
import 'data/repositories/firestore_time_entry_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Create repositories
  final authRepository = FirebaseAuthRepository();
  final timeEntryRepository = FirestoreTimeEntryRepository();

  runApp(PontajApp(
    authRepository: authRepository,
    timeEntryRepository: timeEntryRepository,
  ));
}
