# Task Completion Checklist

## When a Task is Completed

### 1. Code Quality
- [ ] Code follows Clean Architecture principles
- [ ] No direct cross-layer imports (presentation → data)
- [ ] Used appropriate Riverpod provider types (v3)
- [ ] Freezed used for immutable entities

### 2. Testing (MANDATORY - TDD)
- [ ] Tests written BEFORE implementation (Red-Green-Refactor)
- [ ] Domain layer: Unit tests exist
- [ ] Data layer: Unit tests with mocktail mocks exist
- [ ] Presentation: Provider tests exist (if applicable)
- [ ] Custom widgets: Widget tests exist
- [ ] All tests pass: `flutter test`

### 3. Code Generation
If changed Drift tables or Freezed models:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Localization
If added new UI strings:
```bash
flutter gen-l10n
```

### 5. Static Analysis
```bash
flutter analyze   # MUST show 0 issues
```

### 6. Final Verification
- [ ] App runs without errors: `flutter run`
- [ ] No console warnings or errors
- [ ] Feature works as expected
- [ ] Commit message in Korean

## TDD Workflow (STRICT)
1. **RED**: Write failing test describing expected behavior
2. **GREEN**: Write minimum code to pass the test
3. **REFACTOR**: Improve code quality while keeping tests green
4. **VERIFY**: Run `flutter test` and `flutter analyze`
