# Code Style & Conventions

## Linting
- Uses `package:lints/recommended.yaml` (NOT deprecated flutter_lints)
- Excludes generated files: `**/*.g.dart`, `**/*.freezed.dart`
- Ignores `invalid_annotation_target` error (Freezed/JSON serialization)

## Naming Conventions

### Files
- Snake_case for all file names: `trip_repository.dart`
- Test files: `{filename}_test.dart`
- Generated files: `{filename}.freezed.dart`, `{filename}.g.dart`

### Classes
- PascalCase: `TripRepository`, `TripModel`
- Abstract classes: `TripRepository` (interface in domain)
- Implementations: `TripRepositoryImpl` (implementation in data)
- Mocks: `MockTripRepository` (in test files)

### Variables & Functions
- camelCase: `createTrip`, `tripList`, `isLoading`
- Private members: `_internalMethod`, `_privateField`

## Freezed Entities
```dart
@freezed
class Trip with _$Trip {
  const factory Trip({
    required String id,
    required String name,
    // ... other fields
  }) = _Trip;
}
```

## Repository Pattern
```dart
// domain/repositories/trip_repository.dart
abstract class TripRepository {
  Future<Trip> createTrip(Trip trip);
  Stream<List<Trip>> watchTrips();
}

// data/repositories/trip_repository_impl.dart
class TripRepositoryImpl implements TripRepository {
  final TripLocalDataSource _localDataSource;
  
  TripRepositoryImpl(this._localDataSource);
  
  @override
  Future<Trip> createTrip(Trip trip) => _localDataSource.insertTrip(trip);
}
```

## Riverpod Providers
```dart
@riverpod
class TripNotifier extends _$TripNotifier {
  @override
  FutureOr<List<Trip>> build() async {
    // initialization
  }
  
  Future<void> createTrip(Trip trip) async {
    // business logic
  }
}
```

## Import Order
1. Dart SDK imports
2. Flutter SDK imports
3. External package imports
4. Internal project imports (relative)

## Flutter 3.x Compatibility
- Use `surfaceContainerHighest` instead of removed `surfaceVariant`
- Use `activeTrackColor` instead of deprecated `activeColor` on Switch
- Add null coalescing for nullable text styles: `bodyMedium ?? const TextStyle()`
