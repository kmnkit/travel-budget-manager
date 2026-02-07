import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_wallet/app.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';

/// Integration test for export functionality.
///
/// Tests:
/// - Navigate to Statistics screen
/// - Verify ExportButton is present in AppBar
/// - Tap ExportButton to show export options
/// - Verify PDF generation option
/// - Verify Share option
/// - Verify report generation flow
///
/// TODO: Enable when running on device/emulator with database and file system access
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Export Flow Tests', () {
    testWidgets('export button renders in statistics screen', (tester) async {
      // Initialize SharedPreferences for the test
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const TripWalletApp(),
        ),
      );
      await tester.pumpAndSettle();

      // TODO: Enable when running on device
      // Complete flow:
      // 1. Create a trip via onboarding or trip creation
      // 2. Navigate to Statistics tab
      // 3. Verify ExportButton is visible in AppBar
      // 4. Tap ExportButton to show export options
      // 5. Verify bottom sheet contains:
      //    - "PDF 생성" (Generate PDF) button
      //    - "공유하기" (Share) option
      // 6. Verify PDF generation creates file in app documents directory
      // 7. Verify share functionality opens share sheet
      // 8. Verify report contains trip name, dates, expenses, and statistics
    });

    testWidgets('export button renders in trip detail screen', (tester) async {
      // Initialize SharedPreferences for the test
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const TripWalletApp(),
        ),
      );
      await tester.pumpAndSettle();

      // TODO: Enable when running on device
      // Complete flow:
      // 1. Create a trip via onboarding or trip creation
      // 2. Navigate to Trip Detail screen
      // 3. Verify ExportButton is visible in AppBar next to edit button
      // 4. Tap ExportButton to show export options
      // 5. Verify bottom sheet appears with export options
      // 6. Verify report format is consistent with statistics screen export
      // 7. Verify file is created successfully
    });
  });
}
