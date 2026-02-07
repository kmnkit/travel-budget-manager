import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/premium/domain/entities/premium_status.dart';
import 'package:trip_wallet/features/premium/domain/repositories/premium_repository.dart';
import 'package:trip_wallet/features/premium/presentation/providers/premium_providers.dart';

class MockPremiumRepository extends Mock implements PremiumRepository {}

void main() {
  group('Premium Providers', () {
    late ProviderContainer container;
    late MockPremiumRepository mockRepository;

    setUp(() {
      mockRepository = MockPremiumRepository();
      container = ProviderContainer(
        overrides: [
          premiumRepositoryProvider
              .overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('premiumStatusProvider', () {
      test('should return premium status from repository', () async {
        final status = PremiumStatus(
          isPremium: true,
          purchaseId: 'purchase_123',
          expiryDate: DateTime(2099, 12, 31),
          autoRenewal: true,
        );

        when(() => mockRepository.getPremiumStatus())
            .thenAnswer((_) async => status);

        final result = await container.read(premiumStatusProvider.future);

        expect(result.isPremium, true);
        expect(result.purchaseId, 'purchase_123');
        verify(() => mockRepository.getPremiumStatus()).called(1);
      });

      test('should handle repository error', () async {
        when(() => mockRepository.getPremiumStatus())
            .thenAnswer((_) => Future<PremiumStatus>.error(Exception('Error')));

        // Listen to capture state changes
        AsyncValue<PremiumStatus>? capturedValue;
        container.listen<AsyncValue<PremiumStatus>>(
          premiumStatusProvider,
          (previous, next) {
            capturedValue = next;
          },
          fireImmediately: true,
        );

        // Allow microtasks to process the future error
        await Future<void>.delayed(Duration.zero);

        expect(capturedValue, isNotNull);
        expect(capturedValue!.hasError, true);
      });
    });

    group('shouldShowAdsProvider', () {
      test('should return false when user is premium and not expired',
          () async {
        final status = PremiumStatus(
          isPremium: true,
          purchaseId: 'purchase_123',
          expiryDate: DateTime(2099, 12, 31),
          autoRenewal: true,
        );

        when(() => mockRepository.getPremiumStatus())
            .thenAnswer((_) async => status);

        // Wait for premiumStatusProvider to load
        await container.read(premiumStatusProvider.future);

        final result = container.read(shouldShowAdsProvider);

        expect(result, false);
      });

      test('should return true when user is not premium', () async {
        final status = PremiumStatus(
          isPremium: false,
          purchaseId: null,
          expiryDate: null,
          autoRenewal: false,
        );

        when(() => mockRepository.getPremiumStatus())
            .thenAnswer((_) async => status);

        // Wait for premiumStatusProvider to load
        await container.read(premiumStatusProvider.future);

        final result = container.read(shouldShowAdsProvider);

        expect(result, true);
      });

      test('should return true when premium is expired', () async {
        final status = PremiumStatus(
          isPremium: true,
          purchaseId: 'purchase_123',
          expiryDate: DateTime(2024, 1, 1),
          autoRenewal: false,
        );

        when(() => mockRepository.getPremiumStatus())
            .thenAnswer((_) async => status);

        // Wait for premiumStatusProvider to load
        await container.read(premiumStatusProvider.future);

        final result = container.read(shouldShowAdsProvider);

        expect(result, true);
      });
    });
  });
}
