# TripWallet Codebase Structure

## Root Structure
```
/
├── lib/                    # Main source code
├── test/                   # Unit & widget tests
├── integration_test/       # E2E tests (4 files)
├── android/                # Android platform
├── ios/                    # iOS platform
├── assets/                 # Images, fonts, resources
├── .omc/                   # OMC configuration
├── .claude/                # Claude Code config
├── pubspec.yaml            # Dependencies
├── analysis_options.yaml   # Lint rules
└── l10n.yaml              # Localization config
```

## lib/ Structure
```
lib/
├── core/                      # Shared utilities
│   ├── constants/             # App-wide constants
│   ├── errors/                # Exception & Failure classes
│   ├── extensions/            # Dart extensions
│   ├── router/                # GoRouter setup
│   ├── theme/                 # Material Design 3 theme
│   └── utils/                 # Formatters, helpers
│
├── features/                  # Feature modules (Clean Architecture)
│   ├── trip/
│   │   ├── data/              # Datasources, repositories, models
│   │   ├── domain/            # Entities, use cases, repo interfaces
│   │   └── presentation/      # Providers, screens, widgets
│   ├── expense/
│   ├── payment_method/
│   ├── exchange_rate/
│   ├── budget/
│   ├── statistics/
│   ├── settings/
│   └── onboarding/
│
├── shared/                    # Shared across features
│   ├── data/                  # Database (Drift)
│   ├── providers/             # Global providers
│   └── widgets/               # Reusable widgets
│
├── l10n/                      # Internationalization
│   ├── app_en.arb             # English strings
│   └── app_ko.arb             # Korean strings
│
├── main.dart                  # Entry point
└── app.dart                   # Root widget
```

## Feature Module Pattern
Each feature follows Clean Architecture:
```
feature_name/
├── data/
│   ├── datasources/           # Local/Remote data sources
│   ├── repositories/          # Repository implementations
│   └── models/                # Data models (*.g.dart)
├── domain/
│   ├── entities/              # Business entities (Freezed)
│   ├── repositories/          # Repository interfaces
│   └── usecases/              # Business logic
└── presentation/
    ├── providers/             # Riverpod providers
    ├── screens/               # Full-screen pages
    └── widgets/               # Feature-specific widgets
```

## Database (Drift)
4 tables in `lib/shared/data/database.dart`:
- Trips
- Expenses
- PaymentMethods
- ExchangeRates
