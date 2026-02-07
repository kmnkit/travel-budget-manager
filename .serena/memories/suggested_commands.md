# Suggested Commands for TripWallet

## Essential Development Commands

### Testing (MANDATORY before commits)
```bash
# Run all tests - MUST pass with zero failures
flutter test

# Run specific test file
flutter test test/features/trip/domain/usecases/create_trip_test.dart

# Run tests with coverage
flutter test --coverage
```

### Static Analysis (MANDATORY before commits)
```bash
# Analyze code - MUST pass with zero warnings
flutter analyze
```

### Code Generation
```bash
# After changing Drift tables or Freezed models
dart run build_runner build --delete-conflicting-outputs

# Watch mode for continuous generation
dart run build_runner watch --delete-conflicting-outputs
```

### Localization
```bash
# Regenerate localization after ARB file changes
flutter gen-l10n
```

### Dependencies
```bash
# Get dependencies after modifying pubspec.yaml
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated
```

### Running the App
```bash
# Run on connected device/emulator
flutter run

# Run in debug mode with hot reload
flutter run --debug

# Run in release mode
flutter run --release
```

### Building
```bash
# Build Android APK
flutter build apk

# Build Android App Bundle
flutter build appbundle

# Build iOS (macOS only)
flutter build ios
```

### Integration Tests
```bash
# Run integration tests
flutter test integration_test/
```

## System Commands (Darwin/macOS)

### Git Operations
```bash
git status
git add <files>
git commit -m "commit message"
git push origin ralph/trip-wallet-v2
git pull origin ralph/trip-wallet-v2
```

### File System
```bash
ls -la                    # List files with details
find . -name "*.dart"     # Find Dart files
grep -r "pattern" lib/    # Search in lib directory
```

## Pre-Commit Checklist
1. `flutter analyze` - zero warnings
2. `flutter test` - zero failures
3. Code generation up to date (if Drift/Freezed changed)
