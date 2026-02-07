import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/premium/data/datasources/iap_datasource.dart';
import 'package:trip_wallet/features/premium/data/datasources/premium_local_datasource.dart';
import 'package:trip_wallet/features/premium/data/repositories/premium_repository_impl.dart';
import 'package:trip_wallet/features/premium/domain/entities/premium_status.dart';

class MockPremiumLocalDatasource extends Mock
    implements PremiumLocalDatasource {}

class MockIapDatasource extends Mock implements IapDatasource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PremiumRepositoryImpl', () {
    late MockPremiumLocalDatasource mockLocalDatasource;
    late MockIapDatasource mockIapDatasource;
    late PremiumRepositoryImpl repository;

    setUp(() {
      mockLocalDatasource = MockPremiumLocalDatasource();
      mockIapDatasource = MockIapDatasource();
      repository = PremiumRepositoryImpl(
        mockLocalDatasource,
        iapDatasource: mockIapDatasource,
      );
    });

    group('getPremiumStatus', () {
      test('should return premium status from local storage', () async {
        final localStatus = PremiumStatus(
          isPremium: true,
          purchaseId: 'purchase_123',
          expiryDate: DateTime(2025, 12, 31),
          autoRenewal: true,
        );

        when(() => mockLocalDatasource.getPremiumStatus())
            .thenAnswer((_) async => localStatus);

        final result = await repository.getPremiumStatus();

        expect(result, localStatus);
        verify(() => mockLocalDatasource.getPremiumStatus()).called(1);
      });

      test('should return non-premium status when not purchased', () async {
        final localStatus = PremiumStatus(
          isPremium: false,
          purchaseId: null,
          expiryDate: null,
          autoRenewal: false,
        );

        when(() => mockLocalDatasource.getPremiumStatus())
            .thenAnswer((_) async => localStatus);

        final result = await repository.getPremiumStatus();

        expect(result, localStatus);
        verify(() => mockLocalDatasource.getPremiumStatus()).called(1);
      });
    });

    group('savePremiumStatus', () {
      test('should save premium status via local datasource', () async {
        final status = PremiumStatus(
          isPremium: true,
          purchaseId: 'purchase_123',
          expiryDate: DateTime(2025, 12, 31),
          autoRenewal: true,
        );

        when(() => mockLocalDatasource.savePremiumStatus(status))
            .thenAnswer((_) async => {});

        await repository.savePremiumStatus(status);

        verify(() => mockLocalDatasource.savePremiumStatus(status))
            .called(1);
      });

      test('should propagate exception from datasource', () async {
        final status = PremiumStatus(
          isPremium: true,
          purchaseId: 'purchase_123',
          expiryDate: DateTime(2025, 12, 31),
          autoRenewal: true,
        );

        when(() => mockLocalDatasource.savePremiumStatus(status))
            .thenThrow(Exception('Save failed'));

        expect(
          () => repository.savePremiumStatus(status),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('clearPremiumStatus', () {
      test('should clear premium status via local datasource', () async {
        when(() => mockLocalDatasource.clearPremiumStatus())
            .thenAnswer((_) async => {});

        await repository.clearPremiumStatus();

        verify(() => mockLocalDatasource.clearPremiumStatus()).called(1);
      });

      test('should propagate exception from datasource', () async {
        when(() => mockLocalDatasource.clearPremiumStatus())
            .thenThrow(Exception('Clear failed'));

        expect(
          () => repository.clearPremiumStatus(),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
