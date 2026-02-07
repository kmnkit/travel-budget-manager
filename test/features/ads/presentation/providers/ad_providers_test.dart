import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/ads/domain/repositories/ad_repository.dart';
import 'package:trip_wallet/features/ads/presentation/providers/ad_providers.dart';
import 'package:trip_wallet/features/consent/domain/repositories/consent_repository.dart';
import 'package:trip_wallet/features/consent/presentation/providers/consent_providers.dart';

class MockAdRepository extends Mock implements AdRepository {}
class MockConsentRepository extends Mock implements ConsentRepository {}

void main() {
  group('Ad Providers', () {
    late ProviderContainer container;
    late MockConsentRepository mockConsentRepo;

    setUp(() {
      mockConsentRepo = MockConsentRepository();
      container = ProviderContainer(
        overrides: [
          consentRepositoryProvider.overrideWithValue(mockConsentRepo),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('adRepositoryProvider provides AdRepository instance', () {
      final adRepo = container.read(adRepositoryProvider);
      expect(adRepo, isA<AdRepository>());
    });

    test('adInitializerProvider calls repository initialize', () async {
      final mockAdRepo = MockAdRepository();
      when(() => mockAdRepo.initialize()).thenAnswer((_) async {});

      container = ProviderContainer(
        overrides: [
          consentRepositoryProvider.overrideWithValue(mockConsentRepo),
          adRepositoryProvider.overrideWithValue(mockAdRepo),
        ],
      );

      final future = container.read(adInitializerProvider.future);
      await future;

      verify(() => mockAdRepo.initialize()).called(1);
    });
  });
}
