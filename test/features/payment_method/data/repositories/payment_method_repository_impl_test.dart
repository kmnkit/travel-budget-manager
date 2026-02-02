import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/payment_method/data/datasources/payment_method_local_datasource.dart';
import 'package:trip_wallet/features/payment_method/data/repositories/payment_method_repository_impl.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method_type.dart';
import 'package:trip_wallet/core/errors/exceptions.dart';

class MockPaymentMethodLocalDatasource extends Mock
    implements PaymentMethodLocalDatasource {}

void main() {
  late PaymentMethodRepositoryImpl repository;
  late MockPaymentMethodLocalDatasource mockLocalDatasource;

  setUp(() {
    mockLocalDatasource = MockPaymentMethodLocalDatasource();
    repository = PaymentMethodRepositoryImpl(mockLocalDatasource);
  });

  group('getAllPaymentMethods', () {
    final tPaymentMethods = [
      PaymentMethod(
        id: 1,
        name: 'Cash',
        type: PaymentMethodType.cash,
        isDefault: true,
        createdAt: DateTime(2024, 1, 1),
      ),
      PaymentMethod(
        id: 2,
        name: 'Credit Card',
        type: PaymentMethodType.creditCard,
        isDefault: false,
        createdAt: DateTime(2024, 1, 2),
      ),
    ];

    test('should return all payment methods from local datasource', () async {
      // arrange
      when(() => mockLocalDatasource.getAllPaymentMethods())
          .thenAnswer((_) async => tPaymentMethods);

      // act
      final result = await repository.getAllPaymentMethods();

      // assert
      expect(result, tPaymentMethods);
      verify(() => mockLocalDatasource.getAllPaymentMethods()).called(1);
    });

    test('should throw DatabaseException when datasource fails', () async {
      // arrange
      when(() => mockLocalDatasource.getAllPaymentMethods())
          .thenAnswer((_) async => throw const DatabaseException('Failed to fetch'));

      // act & assert
      await expectLater(
        repository.getAllPaymentMethods(),
        throwsA(isA<DatabaseException>()),
      );
    });
  });

  group('getPaymentMethodById', () {
    const tId = 1;
    final tPaymentMethod = PaymentMethod(
      id: tId,
      name: 'Cash',
      type: PaymentMethodType.cash,
      isDefault: true,
      createdAt: DateTime(2024, 1, 1),
    );

    test('should return payment method when found', () async {
      // arrange
      when(() => mockLocalDatasource.getPaymentMethodById(tId))
          .thenAnswer((_) async => tPaymentMethod);

      // act
      final result = await repository.getPaymentMethodById(tId);

      // assert
      expect(result, tPaymentMethod);
      verify(() => mockLocalDatasource.getPaymentMethodById(tId)).called(1);
    });

    test('should return null when payment method not found', () async {
      // arrange
      when(() => mockLocalDatasource.getPaymentMethodById(tId))
          .thenAnswer((_) async => null);

      // act
      final result = await repository.getPaymentMethodById(tId);

      // assert
      expect(result, null);
    });
  });

  group('createPaymentMethod', () {
    const tName = 'New Card';
    const tType = PaymentMethodType.creditCard;
    final tCreatedMethod = PaymentMethod(
      id: 3,
      name: tName,
      type: tType,
      isDefault: false,
      createdAt: DateTime(2024, 1, 3),
    );

    test('should create and return new payment method', () async {
      // arrange
      when(() => mockLocalDatasource.createPaymentMethod(
            name: tName,
            type: tType,
          )).thenAnswer((_) async => tCreatedMethod);

      // act
      final result = await repository.createPaymentMethod(
        name: tName,
        type: tType,
      );

      // assert
      expect(result, tCreatedMethod);
      verify(() => mockLocalDatasource.createPaymentMethod(
            name: tName,
            type: tType,
          )).called(1);
    });

    test('should throw ValidationException for empty name', () async {
      // arrange
      when(() => mockLocalDatasource.createPaymentMethod(
            name: '',
            type: tType,
          )).thenAnswer((_) async => throw const ValidationException('Name cannot be empty'));

      // act & assert
      await expectLater(
        repository.createPaymentMethod(
          name: '',
          type: tType,
        ),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('updatePaymentMethod', () {
    final tPaymentMethod = PaymentMethod(
      id: 1,
      name: 'Updated Cash',
      type: PaymentMethodType.cash,
      isDefault: true,
      createdAt: DateTime(2024, 1, 1),
    );

    test('should update and return payment method', () async {
      // arrange
      when(() => mockLocalDatasource.updatePaymentMethod(tPaymentMethod))
          .thenAnswer((_) async => tPaymentMethod);

      // act
      final result = await repository.updatePaymentMethod(tPaymentMethod);

      // assert
      expect(result, tPaymentMethod);
      verify(() => mockLocalDatasource.updatePaymentMethod(tPaymentMethod))
          .called(1);
    });

    test('should throw DatabaseException when update fails', () async {
      // arrange
      when(() => mockLocalDatasource.updatePaymentMethod(tPaymentMethod))
          .thenAnswer((_) async => throw const DatabaseException('Update failed'));

      // act & assert
      await expectLater(
        repository.updatePaymentMethod(tPaymentMethod),
        throwsA(isA<DatabaseException>()),
      );
    });
  });

  group('deletePaymentMethod', () {
    const tId = 1;

    test('should delete payment method successfully', () async {
      // arrange
      when(() => mockLocalDatasource.deletePaymentMethod(tId))
          .thenAnswer((_) async => {});

      // act
      await repository.deletePaymentMethod(tId);

      // assert
      verify(() => mockLocalDatasource.deletePaymentMethod(tId)).called(1);
    });

    test('should throw DatabaseException when delete fails', () async {
      // arrange
      when(() => mockLocalDatasource.deletePaymentMethod(tId))
          .thenAnswer((_) async => throw const DatabaseException('Cannot delete default method'));

      // act & assert
      await expectLater(
        repository.deletePaymentMethod(tId),
        throwsA(isA<DatabaseException>()),
      );
    });
  });

  group('setDefault', () {
    const tId = 2;

    test('should set payment method as default', () async {
      // arrange
      when(() => mockLocalDatasource.setDefault(tId))
          .thenAnswer((_) async => {});

      // act
      await repository.setDefault(tId);

      // assert
      verify(() => mockLocalDatasource.setDefault(tId)).called(1);
    });

    test('should throw DatabaseException when setting default fails',
        () async {
      // arrange
      when(() => mockLocalDatasource.setDefault(tId))
          .thenAnswer((_) async => throw const DatabaseException('Failed to set default'));

      // act & assert
      await expectLater(
        repository.setDefault(tId),
        throwsA(isA<DatabaseException>()),
      );
    });
  });
}
