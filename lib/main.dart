import 'package:flutter/material.dart';

import 'app.dart';
import 'core/storage/local_storage.dart';
import 'repositories/auth_repository.dart';
import 'repositories/time_entry_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  final storage = LocalStorage();
  await storage.init();

  // Create repositories
  final authRepository = AuthRepository(storage: storage);
  final timeEntryRepository = TimeEntryRepository(storage: storage);

  runApp(PontajApp(
    authRepository: authRepository,
    timeEntryRepository: timeEntryRepository,
  ));
}
