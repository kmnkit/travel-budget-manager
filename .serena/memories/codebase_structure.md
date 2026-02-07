# Codebase Structure

## Root Directory
```
travel-budget-manager/
├── lib/                    # Application source code
├── test/                   # Unit and widget tests
├── integration_test/       # Integration tests
├── android/                # Android native configuration
├── ios/                    # iOS native configuration
├── .claude/                # Claude AI configuration
├── .omc/                   # Planning documents, PRD, progress
├── .serena/                # Serena MCP configuration
├── pubspec.yaml            # Dependencies and Flutter config
├── analysis_options.yaml   # Dart analyzer rules
├── l10n.yaml               # Localization configuration
├── AGENTS.md               # AI agent documentation
└── README.md               # Project readme
```

## lib/ Structure
```
lib/
├── main.dart               # App entry point
├── app.dart                # MaterialApp.router setup
├── AGENTS.md               # lib-specific agent docs
│
├── core/                   # Shared utilities and constants
│   ├── constants/          # App constants, currency constants
│   ├── utils/              # Currency formatter, date formatter
│   ├── extensions/         # Context extensions
│   ├── theme/              # App theme, colors, text styles
│   ├── errors/             # Exceptions and failures
│   └── router/             # GoRouter configuration
│
├── features/               # Feature modules (Clean Architecture)
│   ├── trip/               # Trip management
│   ├── expense/            # Expense tracking
│   ├── payment_method/     # Payment method management
│   ├── exchange_rate/      # Currency exchange rates
│   ├── budget/             # Budget tracking
│   ├── statistics/         # Charts and analytics
│   └── settings/           # App settings
│
├── shared/                 # Shared components
│   ├── providers/          # Shared Riverpod providers
│   ├── data/               # Database (Drift)
│   └── widgets/            # Reusable widgets
│
└── l10n/                   # Localization
    ├── app_en.arb          # English strings
    ├── app_ko.arb          # Korean strings
    └── generated/          # Generated localization code
```

## Feature Module Structure (Clean Architecture)
Each feature in `lib/features/` follows this pattern:
```
{feature}/
├── data/
│   ├── datasources/        # TripLocalDataSource
│   ├── repositories/       # TripRepositoryImpl
│   └── models/             # TripModel (Drift table)
├── domain/
│   ├── entities/           # Trip (Freezed)
│   ├── repositories/       # TripRepository (interface)
│   └── usecases/           # CreateTrip, GetTrips, etc.
└── presentation/
    ├── providers/          # Riverpod providers
    ├── screens/            # HomeScreen, TripDetailScreen
    └── widgets/            # TripCard, TripStatusBadge
```

## test/ Structure
Mirrors lib/ structure:
```
test/
├── core/                   # Core utilities tests
├── features/               # Feature tests
│   ├── trip/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── ... (other features)
├── shared/                 # Shared component tests
├── AGENTS.md               # Test-specific agent docs
└── widget_test.dart        # Basic widget test
```

## Key Files

| File | Purpose |
|------|---------|
| `lib/shared/data/database.dart` | Drift database definition (4 tables) |
| `lib/shared/data/database.g.dart` | Generated Drift code |
| `lib/core/router/app_router.dart` | GoRouter route definitions |
| `lib/core/theme/app_theme.dart` | Material 3 theme configuration |
| `lib/l10n/app_*.arb` | Localization strings |
| `.omc/prd.json` | Product Requirements Document |
| `.omc/plans/stitch-design-implementation.md` | Implementation plan |

## Database Tables (Drift)
1. **Trips** - Trip information
2. **Expenses** - Expense records
3. **PaymentMethods** - Payment method definitions
4. **ExchangeRates** - Currency exchange rates
