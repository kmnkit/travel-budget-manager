# TripWallet Code Style & Conventions

## Linting
- Uses `package:lints/recommended.yaml`
- Excludes: `**/*.g.dart`, `**/*.freezed.dart`
- Ignores: `invalid_annotation_target`

## Code Style
- **Immutability**: Use Freezed for entities/models
- **Naming**: 
  - Files: snake_case (e.g., `expense_repository.dart`)
  - Classes: PascalCase (e.g., `ExpenseRepository`)
  - Variables/Functions: camelCase (e.g., `getExpenses`)
- **State Management**: Riverpod v3
  - Use `NotifierProvider` for state with logic
  - Use `StreamProvider` for Drift reactive queries
  - Use `FutureProvider.family` for parameterized async
  - ❌ NO `StateProvider` or `StateNotifier` (removed in v3)

## Architecture Rules
- ❌ `domain/` MUST NOT import from `data/` or `presentation/`
- ❌ `presentation/` MUST NOT import from `data/` directly
- ✅ `presentation/` → `domain/`
- ✅ `data/` → `domain/` (interfaces only)

## Dependencies Flow
```
presentation → domain ← data
```

## Testing Style
- Use `mocktail` (NOT mockito)
- Test file naming: `*_test.dart`
- Mock class naming: `Mock{ClassName}` (e.g., `MockExpenseRepository`)
- For Freezed objects: use `any()` matcher
- Register fallback values: `registerFallbackValue(AsyncValue.data(...))`

## Commit Messages
- **Language**: Korean (한글)
- **Format**: 
  - `feat: 기능 추가`
  - `fix: 버그 수정`
  - `refactor: 리팩토링`
  - `test: 테스트 추가`
  - `docs: 문서 수정`
