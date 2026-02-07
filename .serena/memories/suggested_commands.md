# Suggested Commands

## Before Every Commit (MANDATORY)
```bash
flutter analyze   # MUST pass with zero warnings
flutter test      # MUST pass with zero failures
```

## Development Commands

### Testing
```bash
flutter test                              # Run all tests
flutter test test/features/trip/         # Run specific feature tests
flutter test --coverage                   # Generate coverage report
```

### Code Generation
```bash
dart run build_runner build --delete-conflicting-outputs  # After Drift/Freezed changes
flutter gen-l10n                                          # Regenerate localization after ARB changes
```

### Dependencies
```bash
flutter pub get                           # Install dependencies
flutter pub upgrade                       # Upgrade dependencies
```

### Running the App
```bash
flutter run                               # Run on connected device
flutter run -d ios                        # Run on iOS simulator
flutter run -d android                    # Run on Android emulator
```

### Linting & Analysis
```bash
flutter analyze                           # Run static analysis
dart fix --dry-run                        # Preview available fixes
dart fix --apply                          # Apply automated fixes
```

## macOS-Specific Notes
- System: Darwin (macOS)
- Standard Unix commands available: git, ls, cd, grep, find, cat, etc.
- Use `open .` to open current directory in Finder
- Use `open -a Xcode ios/Runner.xcworkspace` to open iOS project in Xcode
