# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Pontaj PRO** - A Flutter time-tracking/timesheet application for managing work hours, employee entries, and salary calculations. Supports multiple platforms (iOS, Android, Desktop).

## Common Commands

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Run on specific platform
flutter run -d macos
flutter run -d chrome
flutter run -d ios

# Analyze code
flutter analyze

# Run tests
flutter test

# Run single test file
flutter test test/widget_test.dart

# Build for release
flutter build apk
flutter build ios
flutter build macos
```

## Architecture

### State Management
- **ChangeNotifier pattern** with global singleton `AppStore` in `lib/store.dart`
- Screens use `ListenableBuilder` to listen to `appStore` changes
- Theme management via separate `ThemeProvider` ChangeNotifier

### Code Organization
```
lib/
├── main.dart              # Entry point, route definitions
├── store.dart             # AppStore (ChangeNotifier) + data models (UserRec, PontajEntry)
├── theme_provider.dart    # Theme state management
├── app_theme.dart         # Static theme definitions
├── splash_screen.dart     # Initialization screen
│
├── Services (Business Logic)
│   ├── auth_service.dart           # Authentication with bcrypt
│   ├── database_service.dart       # SQLite operations
│   ├── biometric_service.dart      # Fingerprint/Face auth
│   ├── pdf_service.dart            # PDF report generation
│   ├── backup_service.dart         # Data backup/restore
│   ├── import_export_service.dart  # Excel/CSV handling
│   └── ...
│
├── Pages (Screens)
│   ├── login_page.dart, register_page.dart
│   ├── pontaj_page_new.dart        # Time entry recording
│   ├── dashboard_page_new.dart     # Admin analytics
│   ├── salary_page.dart            # Salary calculations
│   └── ...
│
├── Widgets (Reusable Components)
│   ├── glass_card.dart             # Glassmorphism card
│   ├── gradient_background.dart    # Animated gradient
│   └── ...
│
└── Storage (Platform Abstraction)
    ├── storage_driver.dart         # Abstract interface
    ├── storage_driver_io.dart      # Desktop implementation
    └── storage_driver_web.dart     # Web stub
```

### Key Models (in store.dart)
- `UserRec` - User with username, password, role (user/admin), salary info
- `PontajEntry` - Work entry with user, location, time interval, break minutes, date
- `Role` enum: user, admin
- `SalaryType` enum: hourly, monthly
- `Currency` enum: lei, euro

### Storage Strategy
- **SQLite** via `DatabaseService` for production data (`pontaj_pro.db`)
- **JSON file** via `StorageDriver` for AppStore persistence
- Platform-specific paths:
  - Windows: `%APPDATA%\Local\PontajApp\pontaj_data.json`
  - Mac/Linux: `~/.pontaj_app/pontaj_data.json`

### Services Pattern
All services use Singleton pattern:
```dart
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
}
```

### Navigation Routes
- `/login` - LoginPage
- `/admin` - AdminHomePage (DashboardPageNew)
- `/pontaj` - PontajPageNew (with arguments: user, adminMode, lockName)
- `/entries` - AllEntriesPage
- `/userEntries` - UserEntriesPage
- `/settings` - SettingsPage
- `/register` - RegisterPage
- `/splash` - SplashScreen

## Key Dependencies
- `sqflite` - SQLite database
- `fl_chart` - Charts for dashboard
- `pdf`/`printing` - PDF generation
- `mobile_scanner`/`qr_flutter` - QR code functionality
- `bcrypt` - Password hashing
- `local_auth` - Biometric authentication
- `excel` - Excel import/export
- `flutter_animate` - Animation library
