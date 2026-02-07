import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/ads/data/repositories/ad_repository_impl.dart';
import 'package:trip_wallet/features/consent/domain/entities/consent_status.dart';
import 'package:trip_wallet/features/consent/domain/repositories/consent_repository.dart';

class MockConsentRepository extends Mock implements ConsentRepository {}

void main() {
  late MockConsentRepository mockConsentRepo;
  late AdRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const ConsentStatus(
      analyticsConsent: false,
      personalizedAdsConsent: false,
      attGranted: false,
      consentDate: null,
    ));
  });

  setUp(() {
    mockConsentRepo = MockConsentRepository();
    repository = AdRepositoryImpl(mockConsentRepo);
  });

  group('AdRepositoryImpl', () {
    group('shouldShowAds', () {
      test('returns false when not initialized', () {
        expect(repository.shouldShowAds(), false);
      });
    });

    group('showInterstitialAd', () {
      test('respects frequency cap', () async {
        // First call - count 1, 1 % 3 != 0, should not show
        final result1 = await repository.showInterstitialAd();
        expect(result1, false);

        // Second call - count 2, 2 % 3 != 0, should not show
        final result2 = await repository.showInterstitialAd();
        expect(result2, false);

        // Third call - count 3, 3 % 3 == 0, should try to show
        // But will return false because ad is not loaded (not initialized)
        final result3 = await repository.showInterstitialAd();
        expect(result3, false);
      });

      test('increments counter on each call', () async {
        // Call 3 times
        await repository.showInterstitialAd();
        await repository.showInterstitialAd();
        await repository.showInterstitialAd();

        // Fourth call - count 4, 4 % 3 != 0
        final result4 = await repository.showInterstitialAd();
        expect(result4, false);

        // Fifth call - count 5, 5 % 3 != 0
        final result5 = await repository.showInterstitialAd();
        expect(result5, false);

        // Sixth call - count 6, 6 % 3 == 0, should try to show
        final result6 = await repository.showInterstitialAd();
        expect(result6, false); // Still false because not initialized
      });
    });

    group('dispose', () {
      test('can be called multiple times safely', () {
        expect(() => repository.dispose(), returnsNormally);
        expect(() => repository.dispose(), returnsNormally);
      });
    });
  });
}
