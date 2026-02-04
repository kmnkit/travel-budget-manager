import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_wallet/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('currentPageProvider', () {
    test('initial value is 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final page = container.read(currentPageProvider);

      expect(page, 0);
    });

    test('setPage updates state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(currentPageProvider.notifier).setPage(2);

      expect(container.read(currentPageProvider), 2);
    });

    test('nextPage increments state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(currentPageProvider.notifier).nextPage();

      expect(container.read(currentPageProvider), 1);
    });

    test('nextPage does not exceed 2', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(currentPageProvider.notifier).setPage(2);
      container.read(currentPageProvider.notifier).nextPage();

      expect(container.read(currentPageProvider), 2);
    });

    test('previousPage decrements state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(currentPageProvider.notifier).setPage(2);
      container.read(currentPageProvider.notifier).previousPage();

      expect(container.read(currentPageProvider), 1);
    });

    test('previousPage does not go below 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(currentPageProvider.notifier).previousPage();

      expect(container.read(currentPageProvider), 0);
    });
  });

  group('onboardingCompletedProvider', () {
    test('returns false for new users', () async {
      final mockPrefs = MockSharedPreferences();
      when(() => mockPrefs.getBool('onboarding_completed')).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(onboardingCompletedProvider.future);

      expect(result, false);
    });

    test('returns true when onboarding completed', () async {
      final mockPrefs = MockSharedPreferences();
      when(() => mockPrefs.getBool('onboarding_completed')).thenReturn(true);

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(onboardingCompletedProvider.future);

      expect(result, true);
    });
  });
}
