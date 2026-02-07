import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:trip_wallet/features/ads/domain/repositories/ad_repository.dart';
import 'package:trip_wallet/features/ads/presentation/providers/ad_providers.dart';
import 'package:trip_wallet/features/ads/presentation/widgets/banner_ad_widget.dart';

class MockAdRepository extends Mock implements AdRepository {}
class MockBannerAd extends Mock implements BannerAd {}
class FakeAdSize extends Fake implements AdSize {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeAdSize());
    registerFallbackValue((Ad ad) {});
    registerFallbackValue((Ad ad, LoadAdError error) {});
  });

  group('BannerAdWidget', () {
    late MockAdRepository mockAdRepo;

    setUp(() {
      mockAdRepo = MockAdRepository();
      when(() => mockAdRepo.initialize()).thenAnswer((_) async {});
    });

    testWidgets('shows empty space when ad fails to load', (tester) async {
      when(() => mockAdRepo.loadBannerAd(
        adSize: any(named: 'adSize'),
        onAdLoaded: any(named: 'onAdLoaded'),
        onAdFailedToLoad: any(named: 'onAdFailedToLoad'),
      )).thenAnswer((_) async => null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            adRepositoryProvider.overrideWithValue(mockAdRepo),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: BannerAdWidget(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(BannerAdWidget), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('shows empty space with correct dimensions on error', (tester) async {
      when(() => mockAdRepo.loadBannerAd(
        adSize: any(named: 'adSize'),
        onAdLoaded: any(named: 'onAdLoaded'),
        onAdFailedToLoad: any(named: 'onAdFailedToLoad'),
      )).thenAnswer((_) async => null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            adRepositoryProvider.overrideWithValue(mockAdRepo),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: BannerAdWidget(adSize: AdSize.banner),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, equals(AdSize.banner.width.toDouble()));
      expect(sizedBox.height, equals(AdSize.banner.height.toDouble()));
    });
  });
}
