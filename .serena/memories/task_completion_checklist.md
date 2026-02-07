# Task Completion Checklist

When a task is marked as complete, verify ALL of these:

## Code Quality
- [ ] All new code has corresponding tests (TDD Red-Green-Refactor)
- [ ] Tests follow the same directory structure as source code
- [ ] `flutter analyze` passes with ZERO warnings
- [ ] `flutter test` passes with ZERO failures
- [ ] Code follows Clean Architecture dependency rules
- [ ] No direct imports from `data/` layer in `presentation/` layer
- [ ] No imports from `data/` or `presentation/` in `domain/` layer

## Code Generation (if applicable)
- [ ] Run `dart run build_runner build --delete-conflicting-outputs` after Drift/Freezed changes
- [ ] Run `flutter gen-l10n` after ARB file changes
- [ ] Generated files (*.g.dart, *.freezed.dart) are properly excluded in analysis_options.yaml

## Testing Requirements
- [ ] Domain entities have unit tests
- [ ] Repository interfaces have unit tests (mock implementations)
- [ ] Repository implementations have unit tests (with mocktail mocks)
- [ ] Datasources have unit tests (with mocktail mocks)
- [ ] Providers have unit tests (if applicable)
- [ ] Custom widgets have widget tests (if interactive)

## Documentation
- [ ] Code has meaningful comments where complexity warrants
- [ ] Public APIs have dartdoc comments (if creating new APIs)
- [ ] AGENTS.md updated if new patterns/conventions introduced

## Git
- [ ] Commits written in Korean (한글)
- [ ] Working on branch: ralph/trip-wallet-v2
- [ ] No debug code or commented-out code left in commit
