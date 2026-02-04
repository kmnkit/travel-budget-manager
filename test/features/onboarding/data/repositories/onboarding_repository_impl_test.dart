import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_wallet/features/onboarding/data/repositories/onboarding_repository_impl.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;
  late OnboardingRepositoryImpl repository;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    repository = OnboardingRepositoryImpl(mockPrefs);
  });

  group('OnboardingRepositoryImpl', () {
    group('isOnboardingCompleted', () {
      test('returns false when key does not exist', () async {
        when(() => mockPrefs.getBool('onboarding_completed')).thenReturn(null);

        final result = await repository.isOnboardingCompleted();

        expect(result, false);
        verify(() => mockPrefs.getBool('onboarding_completed')).called(1);
      });

      test('returns false when value is false', () async {
        when(() => mockPrefs.getBool('onboarding_completed')).thenReturn(false);

        final result = await repository.isOnboardingCompleted();

        expect(result, false);
      });

      test('returns true when value is true', () async {
        when(() => mockPrefs.getBool('onboarding_completed')).thenReturn(true);

        final result = await repository.isOnboardingCompleted();

        expect(result, true);
      });
    });

    group('setOnboardingCompleted', () {
      test('persists true value', () async {
        when(() => mockPrefs.setBool('onboarding_completed', true))
            .thenAnswer((_) async => true);

        await repository.setOnboardingCompleted(true);

        verify(() => mockPrefs.setBool('onboarding_completed', true)).called(1);
      });

      test('persists false value', () async {
        when(() => mockPrefs.setBool('onboarding_completed', false))
            .thenAnswer((_) async => true);

        await repository.setOnboardingCompleted(false);

        verify(() => mockPrefs.setBool('onboarding_completed', false)).called(1);
      });
    });
  });
}
