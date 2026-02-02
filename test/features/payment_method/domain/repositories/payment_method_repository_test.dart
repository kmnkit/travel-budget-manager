import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method_type.dart';
import 'package:trip_wallet/features/payment_method/domain/repositories/payment_method_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockPaymentMethodRepository extends Mock
    implements PaymentMethodRepository {}

void main() {
  late MockPaymentMethodRepository repository;

  setUp(() {
    repository = MockPaymentMethodRepository();
  });

  group('PaymentMethodRepository Interface', () {
    test('should have getAllPaymentMethods method', () {
      final methods = [
        PaymentMethod(
          id: 1,
          name: 'Cash',
          type: PaymentMethodType.cash,
          isDefault: true,
          createdAt: DateTime(2024, 1, 1),
        ),
      ];

      when(() => repository.getAllPaymentMethods())
          .thenAnswer((_) async => methods);

      expect(repository.getAllPaymentMethods(), completes);
    });

    test('should have getPaymentMethodById method', () {
      final method = PaymentMethod(
        id: 1,
        name: 'Cash',
        type: PaymentMethodType.cash,
        isDefault: true,
        createdAt: DateTime(2024, 1, 1),
      );

      when(() => repository.getPaymentMethodById(1))
          .thenAnswer((_) async => method);

      expect(repository.getPaymentMethodById(1), completes);
    });

    test('should have createPaymentMethod method', () {
      final method = PaymentMethod(
        id: 1,
        name: 'New Card',
        type: PaymentMethodType.creditCard,
        isDefault: false,
        createdAt: DateTime(2024, 1, 1),
      );

      when(() => repository.createPaymentMethod(
            name: 'New Card',
            type: PaymentMethodType.creditCard,
          )).thenAnswer((_) async => method);

      expect(
        repository.createPaymentMethod(
          name: 'New Card',
          type: PaymentMethodType.creditCard,
        ),
        completes,
      );
    });

    test('should have updatePaymentMethod method', () {
      final method = PaymentMethod(
        id: 1,
        name: 'Updated Cash',
        type: PaymentMethodType.cash,
        isDefault: true,
        createdAt: DateTime(2024, 1, 1),
      );

      when(() => repository.updatePaymentMethod(method))
          .thenAnswer((_) async => method);

      expect(repository.updatePaymentMethod(method), completes);
    });

    test('should have deletePaymentMethod method', () {
      when(() => repository.deletePaymentMethod(1))
          .thenAnswer((_) async => {});

      expect(repository.deletePaymentMethod(1), completes);
    });

    test('should have setDefault method', () {
      when(() => repository.setDefault(1)).thenAnswer((_) async => {});

      expect(repository.setDefault(1), completes);
    });
  });
}
