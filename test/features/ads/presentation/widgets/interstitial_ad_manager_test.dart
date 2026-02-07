import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/ads/domain/repositories/ad_repository.dart';
import 'package:trip_wallet/features/ads/presentation/providers/ad_providers.dart';
import 'package:trip_wallet/features/ads/presentation/widgets/interstitial_ad_manager.dart';

class MockAdRepository extends Mock implements AdRepository {}

void main() {
  group('InterstitialAdManager', () {
    late ProviderContainer container;
    late MockAdRepository mockAdRepo;

    setUp(() {
      mockAdRepo = MockAdRepository();
      container = ProviderContainer(
        overrides: [
          adRepositoryProvider.overrideWithValue(mockAdRepo),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('showAd calls repository showInterstitialAd', () async {
      when(() => mockAdRepo.showInterstitialAd()).thenAnswer((_) async => true);

      final manager = container.read(interstitialAdManagerProvider);
      final result = await manager.showAd();

      expect(result, isTrue);
      verify(() => mockAdRepo.showInterstitialAd()).called(1);
    });

    test('showAd returns false when ad not shown', () async {
      when(() => mockAdRepo.showInterstitialAd()).thenAnswer((_) async => false);

      final manager = container.read(interstitialAdManagerProvider);
      final result = await manager.showAd();

      expect(result, isFalse);
      verify(() => mockAdRepo.showInterstitialAd()).called(1);
    });

    test('preloadAd calls repository loadInterstitialAd', () async {
      when(() => mockAdRepo.loadInterstitialAd()).thenAnswer((_) async => null);

      final manager = container.read(interstitialAdManagerProvider);
      await manager.preloadAd();

      verify(() => mockAdRepo.loadInterstitialAd()).called(1);
    });
  });
}
