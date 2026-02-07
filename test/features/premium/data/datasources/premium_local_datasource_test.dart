import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_wallet/features/premium/data/datasources/premium_local_datasource.dart';
import 'package:trip_wallet/features/premium/domain/entities/premium_status.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('PremiumLocalDatasource', () {
    late MockSharedPreferences mockSharedPreferences;
    late PremiumLocalDatasourceImpl datasource;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      datasource = PremiumLocalDatasourceImpl(mockSharedPreferences);
    });

    group('getPremiumStatus', () {
      test('should return premium status when stored data exists', () async {
        const jsonString =
            '{"isPremium":true,"purchaseId":"purchase_123","expiryDate":"2025-12-31T00:00:00.000Z","autoRenewal":true}';

        when(() => mockSharedPreferences.getString('premium_status'))
            .thenReturn(jsonString);

        final result = await datasource.getPremiumStatus();

        expect(result.isPremium, true);
        expect(result.purchaseId, 'purchase_123');
        expect(result.autoRenewal, true);
        verify(() => mockSharedPreferences.getString('premium_status'))
            .called(1);
      });

      test('should return default premium status when no data is stored',
          () async {
        when(() => mockSharedPreferences.getString('premium_status'))
            .thenReturn(null);

        final result = await datasource.getPremiumStatus();

        expect(result.isPremium, false);
        expect(result.purchaseId, null);
        expect(result.autoRenewal, false);
        verify(() => mockSharedPreferences.getString('premium_status'))
            .called(1);
      });

      test('should throw exception when stored JSON is invalid', () async {
        when(() => mockSharedPreferences.getString('premium_status'))
            .thenReturn('invalid json');

        expect(
          () => datasource.getPremiumStatus(),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('savePremiumStatus', () {
      test('should save premium status to shared preferences', () async {
        final status = PremiumStatus(
          isPremium: true,
          purchaseId: 'purchase_123',
          expiryDate: DateTime(2025, 12, 31),
          autoRenewal: true,
        );

        when(() => mockSharedPreferences.setString(
              'premium_status',
              any(),
            )).thenAnswer((_) async => true);

        await datasource.savePremiumStatus(status);

        verify(() => mockSharedPreferences.setString(
          'premium_status',
          any(),
        )).called(1);
      });

      test('should throw exception when save fails', () async {
        final status = PremiumStatus(
          isPremium: true,
          purchaseId: 'purchase_123',
          expiryDate: DateTime(2025, 12, 31),
          autoRenewal: true,
        );

        when(() => mockSharedPreferences.setString(
              'premium_status',
              any(),
            )).thenAnswer((_) async => false);

        expect(
          () => datasource.savePremiumStatus(status),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('clearPremiumStatus', () {
      test('should remove premium status from shared preferences', () async {
        when(() => mockSharedPreferences.remove('premium_status'))
            .thenAnswer((_) async => true);

        await datasource.clearPremiumStatus();

        verify(() => mockSharedPreferences.remove('premium_status'))
            .called(1);
      });

      test('should throw exception when clear fails', () async {
        when(() => mockSharedPreferences.remove('premium_status'))
            .thenAnswer((_) async => false);

        expect(
          () => datasource.clearPremiumStatus(),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
