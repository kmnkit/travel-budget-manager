# TripWallet Special Guidelines

## TDD Enforcement (CRITICAL)
This project follows **strict Test-Driven Development**. ALL code changes MUST follow:

### Red-Green-Refactor Cycle
1. **RED**: Write failing test (expected behavior)
2. **GREEN**: Write MINIMUM code to pass test
3. **REFACTOR**: Improve quality while keeping tests green

### Rules
- NEVER write `lib/` code without corresponding `test/` file
- NEVER skip tests - tests ARE the specification
- Use `mocktail` for all mocking (NOT mockito)

## Riverpod v3 Migration Notes
- ❌ NO `StateProvider` → use `NotifierProvider` with custom Notifier
- ❌ NO `StateNotifier` → removed in v3
- ❌ NO `.valueOrNull` → use `.value` after null check
- Testing: Call `container.listen()` BEFORE reading `StreamProvider` state

## Drift Database Quirks
- `selectOnly()` with `intEnum` returns raw `int`, NOT enum
  - Manual cast: `final status = ExpenseStatus.values[int_value]`
- `.watch()` returns `Stream<List<T>>`, not single item
- Budget aggregation: Use SQL SUM function

## Flutter 3.x Deprecations
- ❌ `surfaceVariant` (removed) → use `surfaceContainerHighest`
- ❌ Switch `activeColor` (deprecated) → use `activeTrackColor`
- `bodyMedium`/`labelSmall` are nullable → add null coalescing

## Design System (Stitch)
- Stitch Project ID: `1536195772045761405`
- Primary color: Teal `#00897B` (NOT sky blue)
- Font: Lexend via google_fonts
- Border radius: 8px / 12px
- Material Design 3

## Mocking & Testing Patterns
```dart
// Freezed object mocking
when(() => mockRepo.getExpenses()).thenAnswer((_) => Future.value([]));

// Fallback values
registerFallbackValue(AsyncValue.data([]));

// Drift mock
class MockDatabase extends Mock implements AppDatabase {}
```

## Code Generation Triggers
Run `dart run build_runner build --delete-conflicting-outputs` after:
- Changing Drift table schemas
- Modifying Freezed models
- Adding/changing Riverpod generators

## i18n Process
1. Add string to `lib/l10n/app_en.arb`
2. Add translation to `lib/l10n/app_ko.arb`
3. Run `flutter gen-l10n`
4. Use in code: `context.l10n.stringKey`

## Branch & Commits
- Working branch: `analytics`
- Commit messages: Korean (한글) only
- Format: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`
