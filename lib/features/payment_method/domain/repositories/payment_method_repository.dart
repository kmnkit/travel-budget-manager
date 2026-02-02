import 'package:trip_wallet/features/payment_method/domain/entities/payment_method.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method_type.dart';

abstract class PaymentMethodRepository {
  Future<List<PaymentMethod>> getAllPaymentMethods();
  Future<PaymentMethod?> getPaymentMethodById(int id);
  Future<PaymentMethod> createPaymentMethod({
    required String name,
    required PaymentMethodType type,
  });
  Future<PaymentMethod> updatePaymentMethod(PaymentMethod method);
  Future<void> deletePaymentMethod(int id);
  Future<void> setDefault(int id);
}
