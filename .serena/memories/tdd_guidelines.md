# TDD Guidelines (MANDATORY)

## Red-Green-Refactor Cycle

**STRICT ENFORCEMENT**: This project follows Test-Driven Development. ALL code changes MUST follow this cycle:

1. **RED**: Write a failing test FIRST that describes the expected behavior
2. **GREEN**: Write the MINIMUM code to make the test pass
3. **REFACTOR**: Improve code quality while keeping all tests green

## Absolute Rules

- NEVER write implementation code in `lib/` without a corresponding test in `test/`
- NEVER skip tests "to save time" — tests ARE the implementation specification
- Domain layer (entities, use cases): MUST have unit tests
- Data layer (repositories, datasources): MUST have unit tests with `mocktail` mocks
- Presentation layer (providers): SHOULD have unit tests
- Custom widgets with interaction: MUST have widget tests
- Use `mocktail` for mocking (NOT `mockito`)

## Test Structure

Mirror the source directory structure:
```
lib/features/trip/domain/entities/trip.dart
→ test/features/trip/domain/entities/trip_test.dart

lib/features/trip/data/repositories/trip_repository_impl.dart
→ test/features/trip/data/repositories/trip_repository_impl_test.dart
```

## Mocking Patterns

### Using mocktail
```dart
import 'package:mocktail/mocktail.dart';

class MockTripRepository extends Mock implements TripRepository {}

// For Freezed objects: use any() matcher
when(() => mockRepo.createTrip(any())).thenAnswer((_) async => mockTrip);

// For AsyncValue types: registerFallbackValue
registerFallbackValue(AsyncValue.data(mockTrip));
```

### Drift Mocks
```dart
class MockDatabase extends Mock implements AppDatabase {}

when(() => mockDb.watchTrips()).thenAnswer((_) => Stream.value([mockTrip]));
```

## Testing Riverpod v3
- Call `container.listen()` BEFORE reading `StreamProvider` state
- Use `ProviderContainer` for unit tests
- Use `ProviderScope` for widget tests
