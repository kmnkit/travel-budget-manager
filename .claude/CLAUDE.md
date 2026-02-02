# TripWallet Project Instructions

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

- **Pattern**: Clean Architecture (domain/data/presentation)
- **State**: Riverpod (`flutter_riverpod`)
- **Database**: Drift (SQLite) - NOT Isar (incompatible with Dart 3.10)
- **Routing**: GoRouter
- **i18n**: intl + ARB (Korean/English)
- **Design**: Material Design 3, Teal #00897B, Lexend font, 12px radius

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

## Design Reference

- Stitch Project ID: `1536195772045761405`
- Use `get_screen` MCP tool to view screen designs
- Primary color: Teal `#00897B` (NOT sky blue)
- Font: Lexend via `google_fonts`
- 8 expense categories, 5 payment types, 7 currencies

## Key Documents

- PRD: `.omc/prd.json`
- Implementation Plan: `.omc/plans/stitch-design-implementation.md`
- Root AGENTS.md: `AGENTS.md`

## Branch

Work on branch: `ralph/trip-wallet-v2`
