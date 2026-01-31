# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Pontaj PRO** - A Flutter time-tracking/timesheet application for managing work hours, employee entries, invoices, and salary calculations. Uses Firebase backend with real-time sync. Supports iOS, Android, Web, and Desktop.

## Common Commands

```bash
# Get dependencies
flutter pub get

# Generate code (Freezed models, localizations)
flutter pub run build_runner build --delete-conflicting-outputs

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
- **BLoC pattern** using `flutter_bloc` package
- Feature-specific blocs: `AuthBloc`, `TimeEntryBloc`, `InvoiceBloc`
- Theme management via `ThemeCubit` with SharedPreferences persistence

### Code Organization
```
lib/
├── core/
│   ├── config/           # Environment config (envied)
│   ├── l10n/             # Localizations (EN, IT, RO)
│   ├── router/           # GoRouter navigation
│   ├── theme/            # ThemeCubit + theme definitions
│   └── responsive/       # Responsive utilities
│
├── features/             # Feature modules
│   ├── auth/
│   │   ├── bloc/         # AuthBloc, AuthEvent, AuthState
│   │   └── pages/        # LoginPage, RegisterPage, SplashPage
│   ├── time_entry/
│   │   ├── bloc/         # TimeEntryBloc
│   │   └── pages/        # PontajPage
│   ├── admin/
│   │   └── pages/        # Dashboard, AllEntriesPage, SalaryPage
│   ├── invoice/
│   │   ├── bloc/         # InvoiceBloc
│   │   └── pages/        # InvoiceListPage, CreateInvoicePage
│   └── settings/
│
├── data/
│   ├── models/           # Freezed models (User, TimeEntry, Invoice)
│   │   └── converters/   # Custom JSON converters
│   └── repositories/     # Firebase data access
│       ├── firebase_auth_repository.dart
│       ├── firestore_time_entry_repository.dart
│       └── firestore_invoice_repository.dart
│
├── services/
│   ├── notification_service.dart  # FCM push notifications
│   ├── pdf_service.dart           # Invoice PDF generation
│   └── storage_service.dart       # Firebase Storage
│
└── shared/widgets/       # Reusable UI components
```

### Key Models (Freezed)
- `User` - email, role (user/admin), salaryType, currency, fcmToken
- `TimeEntry` - userName, location, intervalText, breakMinutes, totalWorked, date
- `Invoice` - userId, periodStart/End, totalHours, hourlyRate, status, pdfDownloadUrl

### Enums
- `Role`: user, admin
- `SalaryType`: hourly, monthly
- `Currency`: lei (RON), euro (€)
- `InvoiceStatus`: draft, sent, paid, overdue, cancelled

### Firebase Collections
- `users` - User profiles
- `entries` - Time entries
- `invoices` - Invoice documents with PDF URLs
- `locations` - Available work locations

### BLoC Pattern
```dart
// Events trigger state changes
bloc.add(AddEntry(entry));

// States are emitted
yield TimeEntrySaved(entry);

// Repositories use Firestore streams for real-time updates
Stream<List<TimeEntry>> getEntriesStream(String? userId);
```

### Navigation (GoRouter)
- `/splash` - Initial loading
- `/login`, `/register` - Authentication
- `/admin` - Admin dashboard (role-protected)
- `/pontaj` - Time entry page
- `/entries` - All entries list
- `/invoices` - Invoice management
- `/invoices/create` - Create invoice
- `/invoices/:id` - Invoice details
- `/settings` - App settings

### Services Pattern
Singleton services for cross-cutting concerns:
```dart
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
}
```

## Key Dependencies
- `flutter_bloc` - State management
- `go_router` - Navigation
- `freezed` / `json_annotation` - Immutable models
- `firebase_core/auth/firestore/storage/messaging` - Firebase backend
- `google_sign_in` - Google authentication
- `pdf` / `printing` - PDF generation
- `fl_chart` - Dashboard charts
- `shared_preferences` - Local settings
- `envied` - Environment configuration
- `flutter_animate` - Animations

## Environment Setup
Create `.env` file with:
```
ADMIN_SECRET_CODE=your_secret_code
```
Used for admin registration validation.
