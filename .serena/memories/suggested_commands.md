# TripWallet - Essential Commands

## Pre-Commit (MANDATORY)
```bash
flutter analyze   # MUST pass with 0 warnings
flutter test      # MUST pass with 0 failures
```

## Development Commands
```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Code generation (after Drift/Freezed changes)
dart run build_runner build --delete-conflicting-outputs

# Generate localization (after ARB file changes)
flutter gen-l10n

# Clean build artifacts
flutter clean
dart run build_runner clean
```

## Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/expense/domain/usecases/add_expense_usecase_test.dart

# Verbose output
flutter test -v

# Coverage report
flutter test --coverage
```

## Build Commands
```bash
# Android
flutter build apk              # APK
flutter build appbundle        # Play Store AAB

# iOS
flutter build ios              # iOS app
flutter build ipa              # App Store IPA
```

## System Commands (macOS/Darwin)
- `git` - Version control
- `ls` - List files
- `cd` - Change directory
- `grep` - Search text patterns
- `find` - Find files
