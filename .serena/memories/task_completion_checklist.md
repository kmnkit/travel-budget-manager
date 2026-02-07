# Task Completion Checklist

## TDD Enforcement (MANDATORY)

This project follows strict Test-Driven Development. ALL code changes MUST follow this cycle:

### Red-Green-Refactor
1. **RED**: Write a failing test that describes the expected behavior
2. **GREEN**: Write the MINIMUM code to make the test pass
3. **REFACTOR**: Improve code quality while keeping all tests green

## Before Every Task Completion

### 1. Code Quality Checks
```bash
# MUST pass with zero warnings
flutter analyze

# MUST pass with zero failures
flutter test
```

### 2. Code Generation (if applicable)
If you modified Drift tables or Freezed models:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Localization (if applicable)
If you modified ARB files:
```bash
flutter gen-l10n
```

### 4. Test Coverage Requirements

| Layer | Requirement |
|-------|-------------|
| Domain (entities, use cases) | MUST have unit tests |
| Data (repositories, datasources) | MUST have unit tests with mocktail mocks |
| Presentation (providers) | SHOULD have unit tests |
| Custom widgets with interaction | MUST have widget tests |
| Key user flows | SHOULD have integration tests |

### 5. Architecture Compliance
- [ ] Domain layer has NO imports from data/ or presentation/
- [ ] Presentation layer has NO direct imports from data/
- [ ] New entities use Freezed annotations
- [ ] Repository interfaces are in domain/, implementations in data/

### 6. Style Compliance
- [ ] Files use snake_case naming
- [ ] Classes use PascalCase naming
- [ ] Providers use camelCase naming
- [ ] Explicit types on public APIs
- [ ] No unused imports or variables

## Before Every Commit

1. `flutter analyze` - zero warnings
2. `flutter test` - zero failures
3. Code generation up to date
4. Commit message in Korean (per project convention)

## Testing Rules

- NEVER write implementation code without a corresponding test
- NEVER skip tests "to save time"
- Use `mocktail` for mocking (NOT mockito)
- For Freezed objects: use `any()` matcher
- For AsyncValue types: `registerFallbackValue(AsyncValue.data(...))`
