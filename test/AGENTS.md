<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# test/

## Purpose
All unit tests, widget tests, and test utilities for the TripWallet app. Mirrors the `lib/` directory structure exactly.

## Key Files

| File | Description |
|------|-------------|
| `widget_test.dart` | Default Flutter widget test (to be replaced with real tests) |

## Planned Directory Structure

| Directory | Purpose |
|-----------|---------|
| `core/` | Tests for utilities, formatters, extensions |
| `features/trip/` | Trip entity, repository, use case, provider, widget tests |
| `features/expense/` | Expense entity, repository, use case, provider, widget tests |
| `features/payment_method/` | PaymentMethod repository, use case tests |
| `features/exchange_rate/` | ExchangeRate repository, use case, API datasource tests |
| `features/budget/` | Budget calculation use case tests |
| `features/statistics/` | Statistics use case tests |
| `shared/` | IsarService/AppDatabase tests |

## For AI Agents

### TDD ENFORCEMENT (MANDATORY)

**Tests are written BEFORE implementation code. This is non-negotiable.**

### Red-Green-Refactor Cycle

```
1. RED:      Write a test that describes expected behavior → run → FAILS
2. GREEN:    Write MINIMUM code in lib/ to pass the test → run → PASSES
3. REFACTOR: Improve code quality while tests stay GREEN
4. REPEAT
```

### Test File Naming
- Unit tests: `*_test.dart` (mirrors the source file name)
- Example: `lib/features/trip/domain/usecases/create_trip.dart` → `test/features/trip/domain/usecases/create_trip_test.dart`

### Mocking Strategy
- Use `mocktail` for creating mocks (NOT `mockito`)
- Mock repository interfaces, NOT implementations
- Mock external services (Dio, SharedPreferences)
- Use `FakeAsync` for time-dependent tests

### Test Patterns
```dart
// Standard test structure
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTripRepository extends Mock implements TripRepository {}

void main() {
  late CreateTrip useCase;
  late MockTripRepository mockRepo;

  setUp(() {
    mockRepo = MockTripRepository();
    useCase = CreateTrip(mockRepo);
  });

  group('CreateTrip', () {
    test('should create trip when input is valid', () async {
      // Arrange
      when(() => mockRepo.createTrip(any())).thenAnswer((_) async => testTrip);
      // Act
      final result = await useCase(testTripParams);
      // Assert
      expect(result, testTrip);
      verify(() => mockRepo.createTrip(any())).called(1);
    });
  });
}
```

### What to Test

| Layer | What to Test | How |
|-------|-------------|-----|
| Entities | Computed properties, equality, serialization | Unit test |
| Use Cases | Business logic, validation, error cases | Unit test with mocked repos |
| Repositories | CRUD operations, query logic | Unit test with mocked datasources |
| Providers | State transitions, invalidation | Unit test with ProviderContainer |
| Widgets | Rendering, interaction, state display | Widget test with pumpWidget |

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/trip/domain/usecases/create_trip_test.dart

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

### Quality Gates
- All tests MUST pass before any commit
- `flutter analyze` MUST pass with zero warnings
- Test names should describe the expected behavior in English

## Dependencies

### Internal
- `lib/` — Source code under test

### External
- `flutter_test` — Flutter testing framework
- `mocktail` — Mocking library
- `integration_test` — Integration testing SDK

<!-- MANUAL: -->
