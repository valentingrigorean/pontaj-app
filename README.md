# Pontaj PRO

A Flutter time-tracking application for managing work hours, employee entries, invoices, and salary calculations. Supports iOS, Android, Web, and Desktop platforms.

## Features

- **Time Entry Management** - Track work hours with location, time intervals, and breaks
- **Invoice Generation** - Create and manage invoices with PDF export
- **Admin Dashboard** - Analytics and user management for administrators
- **Multi-language Support** - English, Italian, and Romanian
- **Push Notifications** - Firebase Cloud Messaging for invoice alerts
- **Real-time Sync** - Live updates across devices via Firestore

## Getting Started

### Prerequisites

- Flutter SDK (3.x or later)
- Firebase project configured
- `.env` file with required environment variables

### Installation

```bash
# Get dependencies
flutter pub get

# Generate code (Freezed models, l10n)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Environment Setup

Create a `.env` file in the project root:

```
ADMIN_SECRET_CODE=your_admin_registration_code
```

## How It Works

This section explains the core workflows and data flow within the application.

### Authentication Flow

```
┌─────────────┐     ┌──────────────┐     ┌─────────────────┐
│  SplashPage │────▶│  AuthBloc    │────▶│ Firebase Auth   │
└─────────────┘     └──────────────┘     └─────────────────┘
                           │
                    ┌──────┴──────┐
                    ▼             ▼
              ┌──────────┐  ┌───────────┐
              │ LoginPage│  │ AdminHome │
              │ (guest)  │  │ or Pontaj │
              └──────────┘  └───────────┘
```

1. **Splash Screen** checks authentication state via `AuthBloc`
2. **AuthBloc** listens to Firebase Auth state changes
3. Authenticated users are routed based on role (admin → dashboard, user → time entry)
4. Admin registration requires a secret code from environment config

### Time Entry Flow

```
┌─────────────┐     ┌────────────────┐     ┌─────────────────────┐
│ PontajPage  │────▶│ TimeEntryBloc  │────▶│ FirestoreRepository │
└─────────────┘     └────────────────┘     └─────────────────────┘
      ▲                    │                         │
      │                    ▼                         ▼
      │              ┌───────────┐            ┌───────────┐
      └──────────────│  States   │◀───────────│ Firestore │
                     └───────────┘  (stream)  └───────────┘
```

1. User enters time entry details (location, time interval, break)
2. `TimeEntryBloc` receives `AddEntry` event
3. Repository writes to Firestore and auto-adds new locations
4. Firestore stream triggers real-time UI updates
5. All connected devices see changes immediately

### Invoice Generation Flow

```
┌─────────────────┐     ┌─────────────┐     ┌─────────────┐
│CreateInvoicePage│────▶│ InvoiceBloc │────▶│ PdfService  │
└─────────────────┘     └─────────────┘     └─────────────┘
                               │                   │
                               ▼                   ▼
                        ┌─────────────┐     ┌─────────────────┐
                        │  Firestore  │     │ Firebase Storage│
                        │  (invoice)  │     │    (PDF file)   │
                        └─────────────┘     └─────────────────┘
                               │
                               ▼
                        ┌─────────────────┐
                        │NotificationSvc  │
                        │ (FCM to user)   │
                        └─────────────────┘
```

1. Admin selects user and date range for invoice
2. System calculates total hours from time entries
3. `PdfService` generates PDF document client-side
4. PDF uploads to Firebase Storage
5. Invoice document saved to Firestore with PDF download URL
6. Push notification sent to user via FCM

### State Management (BLoC Pattern)

```
┌─────────┐    ┌───────────┐    ┌─────────────┐    ┌────────┐
│  Event  │───▶│   BLoC    │───▶│ Repository  │───▶│ State  │
└─────────┘    └───────────┘    └─────────────┘    └────────┘
                    │                                   │
                    └───────────────────────────────────┘
                              (emits new state)
```

- **Events**: User actions (login, add entry, create invoice)
- **BLoC**: Business logic processing and side effects
- **Repository**: Data access abstraction over Firebase
- **State**: Immutable UI state triggering rebuilds

### Data Models

All models use Freezed for immutability:

| Model | Purpose | Key Fields |
|-------|---------|------------|
| `User` | User profile | email, role, salaryType, fcmToken |
| `TimeEntry` | Work hours record | location, intervalText, breakMinutes, totalWorked |
| `Invoice` | Billing document | periodStart/End, totalHours, status, pdfUrl |

### Real-time Updates

```
┌──────────┐                    ┌───────────┐
│ Device A │◀───────────────────│           │
└──────────┘    Firestore       │ Firestore │
                Streams         │  Server   │
┌──────────┐                    │           │
│ Device B │◀───────────────────│           │
└──────────┘                    └───────────┘
```

- Repositories expose Firestore streams
- BLoCs subscribe and emit new states on changes
- UI rebuilds automatically via `BlocBuilder`

## Project Structure

```
lib/
├── core/                 # Config, routing, theme, l10n
├── features/             # Feature modules (auth, time_entry, admin, invoice)
│   └── <feature>/
│       ├── bloc/         # BLoC, events, states
│       └── pages/        # UI screens
├── data/
│   ├── models/           # Freezed data models
│   └── repositories/     # Firebase data access
├── services/             # Notification, PDF, Storage services
└── shared/widgets/       # Reusable UI components
```

## Commands

```bash
# Run on specific platform
flutter run -d macos
flutter run -d chrome
flutter run -d ios

# Analyze code
flutter analyze

# Run tests
flutter test

# Build for release
flutter build apk
flutter build ios
flutter build macos
```

## Tech Stack

- **State Management**: flutter_bloc
- **Routing**: go_router
- **Backend**: Firebase (Auth, Firestore, Storage, Messaging)
- **Models**: Freezed + json_serializable
- **PDF**: pdf + printing packages
- **Charts**: fl_chart
- **Localization**: flutter_localizations + intl
