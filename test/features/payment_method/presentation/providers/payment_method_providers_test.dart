import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method_type.dart';
import 'package:trip_wallet/features/payment_method/domain/repositories/payment_method_repository.dart';
import 'package:trip_wallet/features/payment_method/presentation/providers/payment_method_providers.dart';

class MockPaymentMethodRepository extends Mock
    implements PaymentMethodRepository {}

void main() {
  late MockPaymentMethodRepository mockRepository;

  setUp(() {
    mockRepository = MockPaymentMethodRepository();
  });

  group('PaymentMethod Providers', () {
    test('paymentMethodListProvider returns list of payment methods', () async {
      // Arrange
      final methods = [
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

      when(() => mockRepository.getAllPaymentMethods())
          .thenAnswer((_) async => methods);

      final container = ProviderContainer(
        overrides: [
          paymentMethodRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final result = await container.read(paymentMethodListProvider.future);

      // Assert
      expect(result, methods);
      verify(() => mockRepository.getAllPaymentMethods()).called(1);
    });

    test('defaultPaymentMethodProvider returns default method', () async {
      // Arrange
      final methods = [
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

      when(() => mockRepository.getAllPaymentMethods())
          .thenAnswer((_) async => methods);

      final container = ProviderContainer(
        overrides: [
          paymentMethodRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      // Act
      await container.read(paymentMethodListProvider.future);
      final result = container.read(defaultPaymentMethodProvider);

      // Assert
      expect(result.hasValue, true);
      expect(result.value?.id, 1);
      expect(result.value?.isDefault, true);
    });

    test('defaultPaymentMethodProvider returns null when no default', () async {
      // Arrange
      final methods = [
        PaymentMethod(
          id: 1,
          name: 'Cash',
          type: PaymentMethodType.cash,
          isDefault: false,
          createdAt: DateTime(2024, 1, 1),
        ),
      ];

      when(() => mockRepository.getAllPaymentMethods())
          .thenAnswer((_) async => methods);

      final container = ProviderContainer(
        overrides: [
          paymentMethodRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      // Act
      await container.read(paymentMethodListProvider.future);
      final result = container.read(defaultPaymentMethodProvider);

      // Assert
      expect(result.hasValue, true);
      expect(result.value, null);
    });

    test('getPaymentMethodsProvider wires up correctly', () {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          paymentMethodRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final useCase = container.read(getPaymentMethodsProvider);

      // Assert
      expect(useCase, isNotNull);
    });

    test('createPaymentMethodProvider wires up correctly', () {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          paymentMethodRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final useCase = container.read(createPaymentMethodProvider);

      // Assert
      expect(useCase, isNotNull);
    });

    test('deletePaymentMethodProvider wires up correctly', () {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          paymentMethodRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final useCase = container.read(deletePaymentMethodProvider);

      // Assert
      expect(useCase, isNotNull);
    });
  });
}
