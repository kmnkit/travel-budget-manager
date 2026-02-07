# Code Style and Conventions

## Architecture Pattern: Clean Architecture

### Layer Rules (CRITICAL)
- `domain/` MUST NOT import from `data/` or `presentation/`
- `presentation/` MUST NOT import from `data/` directly
- `data/` imports `domain/` for interfaces only
- Dependencies flow: `presentation → domain ← data`

### Feature Structure
```
lib/features/{feature_name}/
├── data/
│   ├── datasources/     # Local/remote data sources
│   ├── repositories/    # Repository implementations
│   └── models/          # Data models (DTOs)
├── domain/
│   ├── entities/        # Business entities (Freezed)
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Business logic
└── presentation/
    ├── providers/       # Riverpod providers
    ├── screens/         # Full-page widgets
    └── widgets/         # Reusable UI components
```

## Naming Conventions

### Files
- snake_case for all Dart files: `trip_repository.dart`
- Suffix by type: `*_screen.dart`, `*_widget.dart`, `*_provider.dart`, `*_usecase.dart`

### Classes
- PascalCase: `TripRepository`, `CreateTripUseCase`
- Repository implementations: `TripRepositoryImpl`
- Providers: `tripRepositoryProvider`, `tripsProvider`

### Variables and Functions
- camelCase: `getUserTrips()`, `currentTrip`
- Private members: `_privateMethod()`

## Dart/Flutter Conventions

### Type Hints
- Always use explicit types for public APIs
- Use `var` or `final` for local variables where type is obvious
- Prefer `final` over `var` for immutable values

### Null Safety
- Use null-aware operators: `?.`, `??`, `??=`
- Use required parameters: `required this.tripId`
- Avoid `!` operator unless absolutely necessary

### Imports
- Use relative imports within the same feature
- Use package imports for cross-feature dependencies
- Order: dart:, package:, relative imports

## Riverpod v3 Patterns

### Provider Definition
```dart
// Notifier pattern (NOT StateNotifier)
class TripsNotifier extends Notifier<AsyncValue<List<Trip>>> {
  @override
  AsyncValue<List<Trip>> build() => const AsyncValue.loading();
}

final tripsProvider = NotifierProvider<TripsNotifier, AsyncValue<List<Trip>>>(
  TripsNotifier.new,
);
```

### StreamProvider for Drift
```dart
final tripsStreamProvider = StreamProvider<List<Trip>>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.watchAllTrips();
});
```

## Freezed Patterns

### Entity Definition
```dart
@freezed
class Trip with _$Trip {
  const factory Trip({
    required String id,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required String baseCurrency,
    double? budget,
  }) = _Trip;
}
```

## Testing Conventions

### Use mocktail (NOT mockito)
```dart
class MockTripRepository extends Mock implements TripRepository {}

// Setup
when(() => mockRepo.getTrips()).thenAnswer((_) async => trips);

// For Freezed objects, use any() matcher
when(() => mockRepo.createTrip(any())).thenAnswer((_) async {});
```

### Test File Structure
- Mirror lib/ structure in test/
- Name: `{source_file}_test.dart`

## Linting
- Uses `package:lints/recommended.yaml`
- Excludes generated files: `**/*.g.dart`, `**/*.freezed.dart`
- `invalid_annotation_target` errors are ignored
