# Integration Tests

This directory contains integration tests for TripWallet that verify end-to-end user flows.

## Test Files

### 1. app_test.dart
Basic app smoke tests:
- App launches successfully
- Home screen displays correctly
- Navigation to settings works
- Settings sections are visible

**Status**: ✅ Fully functional

### 2. trip_flow_test.dart
Trip CRUD lifecycle tests:
- Create a new trip from home screen
- Fill in trip details (title, currency, budget, dates)
- Save trip and verify it appears in list
- Navigate to trip detail screen
- Cancel trip creation flow

**Status**: ⚠️ Partially implemented (database-dependent tests are TODO)

### 3. expense_flow_test.dart
Expense CRUD operation tests:
- Create a trip first
- Navigate to trip detail
- Verify empty expense state
- Add new expense with category and payment method
- Verify expense appears in list

**Status**: ⚠️ Partially implemented (database-dependent tests are TODO)

### 4. multi_currency_test.dart
Multi-currency functionality tests:
- Create KRW trip
- Add expenses in different currencies
- Verify currency conversion is displayed
- Navigate to exchange rate tab
- Test currency symbol display

**Status**: ⚠️ Partially implemented (database-dependent tests are TODO)

## Running Integration Tests

### Prerequisites

1. **Device/Emulator**: Integration tests require a running device or emulator
2. **Database**: Tests use real Drift database, not mocks

### Run All Integration Tests

```bash
# Run on connected device
flutter test integration_test/

# Run on specific device
flutter test integration_test/ -d <device_id>
```

### Run Specific Test File

```bash
flutter test integration_test/app_test.dart
```

### Run with Integration Test Driver

For more advanced testing (performance, screenshots):

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart
```

## Test Structure

All tests follow this pattern:

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Test Group Name', () {
    testWidgets('test description', (tester) async {
      // 1. Initialize SharedPreferences
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      // 2. Pump the app with provider overrides
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const TripWalletApp(),
        ),
      );
      await tester.pumpAndSettle();

      // 3. Perform test actions
      expect(find.text('TripWallet'), findsOneWidget);
    });
  });
}
```

## Key Testing Patterns

### Finding Widgets

```dart
// By text
find.text('TripWallet')

// By widget type
find.byType(FloatingActionButton)

// By icon
find.byIcon(Icons.settings)

// By label in TextFormField
find.widgetWithText(TextFormField, '여행 제목')
```

### User Interactions

```dart
// Tap
await tester.tap(find.byType(FloatingActionButton));
await tester.pumpAndSettle();

// Enter text
await tester.enterText(titleField, '도쿄 여행');
await tester.pumpAndSettle();

// Scroll
await tester.ensureVisible(find.text('저장'));
await tester.pumpAndSettle();

// Navigate back
await tester.pageBack();
await tester.pumpAndSettle();
```

### Assertions

```dart
// Verify widget exists
expect(find.text('TripWallet'), findsOneWidget);

// Verify widget doesn't exist
expect(find.text('Error'), findsNothing);

// Verify multiple widgets
expect(find.byIcon(Icons.category), findsNWidgets(8));
```

## Current Limitations

1. **Database Tests**: Tests that require database persistence are marked as TODO and will only work when run on actual device/emulator
2. **Network Tests**: Exchange rate API tests require network connectivity
3. **State Persistence**: Some tests need to verify data persists between app restarts

## Future Enhancements

- [ ] Add test driver for advanced scenarios
- [ ] Add screenshot testing
- [ ] Add performance profiling tests
- [ ] Mock Drift database for unit-style integration tests
- [ ] Add tests for error scenarios
- [ ] Add tests for offline functionality
- [ ] Add tests for data backup/restore

## Debugging Tests

### Enable verbose logging

```bash
flutter test integration_test/ --verbose
```

### Run with coverage

```bash
flutter test integration_test/ --coverage
```

### View test output

Tests print to console. Use `debugPrint()` in test code for debugging:

```dart
debugPrint('Current route: ${GoRouter.of(context).location}');
```

## CI/CD Integration

For CI pipelines, use Firebase Test Lab or similar:

```bash
# Firebase Test Lab example
gcloud firebase test android run \
  --type instrumentation \
  --app build/app/outputs/apk/debug/app-debug.apk \
  --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk
```

## Notes

- All tests follow TDD principles
- Tests use Korean text to match the app's primary language
- Tests are structured to be maintainable and readable
- Each test is independent and can run in isolation
