# TripWallet Project Instructions

## Project Status

- **All 38 tasks complete** across 7 implementation phases
- **199+ unit and widget tests passing**
- **flutter analyze**: zero warnings
- **Integration tests**: 4 files created
- **Status**: Production-ready

## TDD Enforcement (MANDATORY)

**This project follows strict Test-Driven Development. ALL code changes MUST follow this cycle:**

### Red-Green-Refactor

1. **RED**: Write a failing test that describes the expected behavior
2. **GREEN**: Write the MINIMUM code to make the test pass
3. **REFACTOR**: Improve code quality while keeping all tests green

### Rules

- NEVER write implementation code in `lib/` without a corresponding test in `test/`
- NEVER skip tests. Tests are the specification, not an afterthought
- Domain layer (entities, use cases): MUST have unit tests
- Data layer (repositories, datasources): MUST have unit tests with `mocktail` mocks
- Presentation layer (providers): SHOULD have unit tests
- Custom widgets with interaction: MUST have widget tests
- Use `mocktail` for mocking (NOT `mockito`)

### Before Every Commit

```bash
flutter analyze   # MUST pass with zero warnings
flutter test      # MUST pass with zero failures
```

## Architecture

- **Pattern**: Clean Architecture (domain/data/presentation per feature)
- **State Management**: Riverpod v3 (`flutter_riverpod` ^3.1.0)
  - Uses `Notifier`/`NotifierProvider` (NOT StateNotifier - removed in v3)
  - `StreamProvider` for reactive Drift queries
  - `FutureProvider.family` for parameterized queries
- **Database**: Drift ^2.30.1 (SQLite) - NOT Isar
  - `.watch()` for reactive streams
  - SQL SUM for budget aggregation
  - 4 tables: Trips, Expenses, PaymentMethods, ExchangeRates
- **Routing**: GoRouter ^17.0.1
- **i18n**: intl + ARB (137 strings, Korean/English)
- **Charts**: fl_chart ^1.1.1
- **Code Generation**: Freezed v3 + Drift build_runner
- **Design**: Material Design 3, Teal #00897B, Lexend font, 8px/12px radius

### Layer Rules

- `domain/` MUST NOT import from `data/` or `presentation/`
- `presentation/` MUST NOT import from `data/` directly
- `data/` imports `domain/` for interfaces only
- Dependencies flow: `presentation → domain ← data`

### Code Generation

After changing Drift tables or Freezed models:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Features

- **7 supported currencies**: KRW, USD, EUR, JPY, GBP, AUD, CAD
- **8 expense categories**: Food, Transportation, Accommodation, Entertainment, Shopping, Activities, Communication, Miscellaneous
- **5 payment method types**: Cash, Credit Card, Debit Card, Mobile Payment, Other
- **Dual-currency display**: Original amount + converted amount
- **4-step exchange rate fallback**:
  1. Trip-specific rate
  2. Global rate
  3. Reverse rate (1/rate)
  4. USD pivot rate
- **Dual API fallback**: open.er-api.com → jsdelivr
- **Budget tracking**: 4 status levels (under, warning, at limit, over)
- **Statistics**: Pie chart (by category), bar chart (by date), payment method breakdown

## Key Development Notes

### Riverpod v3 Migration
- No `StateProvider` → use `NotifierProvider` with custom Notifier class
- No `valueOrNull` → use `.value` directly after null check
- Testing: Call `container.listen()` BEFORE reading `StreamProvider` state

### Mocking & Testing
- Use `mocktail` (NOT mockito) for all mocks
- For Freezed objects: use `any()` matcher
- For AsyncValue types: `registerFallbackValue(AsyncValue.data(...))`
- Drift mocks: `MockDatabase` with when/thenAnswer pattern

### Drift Quirks
- `selectOnly()` with `intEnum` returns raw `int`, not enum
- Cast manually: `final status = ExpenseStatus.values[int_value]`
- `.watch()` returns `Stream<List<T>>`, not single item

### Flutter 3.x Deprecations
- `surfaceVariant` (removed) → use `surfaceContainerHighest`
- Switch `activeColor` (deprecated) → use `activeTrackColor`
- AppBar `centerTitle` behavior changed → verify layout
- `bodyMedium`/`labelSmall` nullable → add null coalescing

## Design Reference

- Stitch Project ID: `1536195772045761405`
- Use `get_screen` MCP tool to view screen designs
- Primary color: Teal `#00897B` (NOT sky blue)
- Font: Lexend via `google_fonts`
- 8 expense categories, 5 payment types, 7 currencies

## Commands

```bash
flutter analyze                    # MUST pass with zero warnings
flutter test                       # MUST pass with zero failures
flutter gen-l10n                   # Regenerate localization after ARB changes
dart run build_runner build --delete-conflicting-outputs  # After Drift/Freezed changes
```

## Key Documents

- PRD: `.omc/prd.json`
- Implementation Plan: `.omc/plans/stitch-design-implementation.md`
- Root AGENTS.md: `AGENTS.md`
- Stitch Project: `1536195772045761405`

## Branch & Git

- **Working branch**: `ralph/trip-wallet-v2`
- **Commits**: Write in Korean (한글)
