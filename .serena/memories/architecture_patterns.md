# Architecture & Code Patterns

## Clean Architecture Structure

Each feature follows this directory structure:
```
lib/features/{feature_name}/
  ├── domain/
  │   ├── entities/        # Freezed immutable classes
  │   ├── repositories/    # Abstract repository interfaces
  │   └── usecases/        # Business logic (optional)
  ├── data/
  │   ├── datasources/     # Database/API access
  │   ├── models/          # Data models (optional)
  │   └── repositories/    # Repository implementations
  └── presentation/
      ├── providers/       # Riverpod providers
      ├── screens/         # Full-page widgets
      └── widgets/         # Reusable components
```

## Dependency Rules (STRICT)
- `domain/` MUST NOT import from `data/` or `presentation/`
- `presentation/` MUST NOT import from `data/` directly
- `data/` imports `domain/` for interfaces only
- Dependencies flow: `presentation → domain ← data`

## Naming Conventions
- **Entities**: Freezed classes with `.freezed.dart` suffix
- **Repositories**: Interface in `domain/`, implementation in `data/` with `_impl` suffix
- **Datasources**: `{feature}_local_datasource.dart` or `{feature}_remote_datasource.dart`
- **Providers**: `{feature}_providers.dart` using Riverpod annotations
- **Tests**: Mirror source structure with `_test.dart` suffix

## Code Generation
After changing Drift tables or Freezed models:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Riverpod v3 Patterns
- Use `Notifier`/`NotifierProvider` (NOT StateNotifier - removed in v3)
- Use `StreamProvider` for reactive Drift queries
- Use `FutureProvider.family` for parameterized queries
- No `valueOrNull` → use `.value` directly after null check
