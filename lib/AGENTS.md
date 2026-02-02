<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# lib/

## Purpose
Application source code organized by Clean Architecture with feature-based modules. Contains all Dart source files for the TripWallet app.

## Key Files

| File | Description |
|------|-------------|
| `main.dart` | App entry point — WidgetsBinding, Drift DB init, ProviderScope |
| `app.dart` | TripWalletApp — MaterialApp.router with theme, GoRouter, localization |

## Planned Directory Structure

| Directory | Purpose |
|-----------|---------|
| `core/` | Shared constants, theme, utilities, extensions, error classes, network service |
| `features/` | Feature modules: trip, expense, payment_method, exchange_rate, budget, statistics, settings |
| `shared/` | Shared widgets, providers, database service |
| `l10n/` | Localization ARB files (Korean/English) |

## For AI Agents

### TDD ENFORCEMENT (MANDATORY)
- **NEVER** create a file in `lib/` without a corresponding test in `test/`
- Domain entities/use cases → unit tests FIRST
- Data repositories → unit tests with mocktail FIRST
- Providers → unit tests FIRST
- Widgets → widget tests
- Write the test, watch it fail (RED), then implement (GREEN), then refactor

### Clean Architecture Layers

```
presentation/ → depends on → domain/ ← depends on ← data/
```

- **domain/**: Entities (freezed), repository interfaces, use cases. NO framework imports.
- **data/**: Drift models, datasources, repository implementations. Depends on domain interfaces.
- **presentation/**: Screens, widgets, Riverpod providers. Depends on domain use cases.

### Import Rules
- `domain/` MUST NOT import from `data/` or `presentation/`
- `presentation/` MUST NOT import from `data/` directly (use domain interfaces)
- `data/` imports `domain/` for repository interfaces
- `core/` and `shared/` can be imported by any layer

### Code Generation
After modifying Drift tables or Freezed models, run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Naming Conventions
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Providers: `camelCaseProvider`
- Use cases: one class per file, named after the action (e.g., `CreateTrip`)
- Screens: `*_screen.dart`
- Widgets: descriptive name (e.g., `trip_card.dart`, `budget_summary_card.dart`)

## Dependencies

### Internal
- `test/` — mirrors this directory structure for tests

### External
- All packages defined in `pubspec.yaml`

<!-- MANUAL: -->
