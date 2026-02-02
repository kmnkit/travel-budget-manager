<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# TripWallet

## Purpose
A Flutter mobile app for tracking travel expenses with multi-currency support, budget management, exchange rate tracking, and statistics. Targets iOS 13+ and Android API 24+.

## Architecture
- **Pattern**: Clean Architecture (domain/data/presentation separation)
- **State Management**: Riverpod (flutter_riverpod)
- **Database**: Drift (SQLite) — type-safe, reactive `.watch()` streams
- **Routing**: GoRouter
- **i18n**: intl + ARB files (Korean/English)
- **Charts**: fl_chart
- **Design System**: Material Design 3, Teal #00897B, Lexend font, 12px border radius

## Key Files

| File | Description |
|------|-------------|
| `pubspec.yaml` | Project dependencies and Flutter configuration |
| `analysis_options.yaml` | Dart analyzer rules (use `lints` package, not deprecated `flutter_lints`) |
| `lib/main.dart` | App entry point — Isar init, ProviderScope |
| `lib/app.dart` | MaterialApp.router with theme, routing, localization |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `lib/` | Application source code (see `lib/AGENTS.md`) |
| `test/` | Unit and widget tests (see `test/AGENTS.md`) |
| `android/` | Android native configuration |
| `ios/` | iOS native configuration |
| `.omc/` | Planning documents, PRD, progress tracking |

## For AI Agents

### TDD ENFORCEMENT (MANDATORY)

**This project uses strict Test-Driven Development. Every code change MUST follow the Red-Green-Refactor cycle:**

1. **RED**: Write a failing test FIRST
2. **GREEN**: Write the minimum code to make the test pass
3. **REFACTOR**: Clean up while keeping tests green

**Rules:**
- NEVER write implementation code without a corresponding test
- NEVER skip tests "to save time" — tests ARE the implementation specification
- Domain layer (entities, use cases) MUST have unit tests
- Data layer (repositories, datasources) MUST have unit tests with mocktail mocks
- Presentation layer (providers) SHOULD have unit tests
- Widget tests for all custom widgets with user interaction
- Integration tests for key user flows
- Run `flutter test` before every commit — zero failures allowed
- Run `flutter analyze` before every commit — zero warnings allowed

### Working In This Directory
- Use `flutter pub get` after modifying `pubspec.yaml`
- Use `dart run build_runner build --delete-conflicting-outputs` after changing Drift tables or Freezed models
- Branch: `ralph/trip-wallet-v2`
- Stitch Project ID: `1536195772045761405` (use `get_screen` MCP tool for design reference)

### Design System (from Stitch)
- **Primary Color**: Teal `#00897B`
- **Font**: Lexend (via `google_fonts` package)
- **Border Radius**: 12px on all cards/containers
- **Material Design 3**: `useMaterial3: true`
- **Trip Status Colors**: upcoming=blue `#2196F3`, ongoing=green `#4CAF50`, completed=gray `#9E9E9E`
- **Budget Status Colors**: comfortable=teal, caution=orange `#FFA726`, warning=red `#EF5350`, exceeded=dark red `#D32F2F`

### Supported Currencies
KRW, USD, EUR, JPY, GBP, AUD, CAD (7 currencies)

### Expense Categories (8)
food, transport, accommodation, shopping, entertainment, sightseeing, communication, other

### Payment Method Types (5)
cash, creditCard, debitCard, transitCard, other

## Dependencies

### External (Key Packages)
- `flutter_riverpod` — State management
- `drift` + `drift_flutter` — SQLite database
- `go_router` — Navigation
- `google_fonts` — Lexend font
- `fl_chart` — Statistics charts
- `dio` — HTTP client for exchange rate API
- `freezed_annotation` — Immutable data classes
- `intl` — Internationalization
- `mocktail` — Test mocking

## Reference Documents

| Document | Location |
|----------|----------|
| PRD (Product Requirements) | `.omc/prd.json` |
| Implementation Plan | `.omc/plans/stitch-design-implementation.md` |
| Stitch Designs | Stitch Project ID `1536195772045761405` |

<!-- MANUAL: -->
