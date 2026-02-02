import 'package:trip_wallet/features/payment_method/data/datasources/payment_method_local_datasource.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method_type.dart';
import 'package:trip_wallet/features/payment_method/domain/repositories/payment_method_repository.dart';

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  final PaymentMethodLocalDatasource _localDatasource;

  PaymentMethodRepositoryImpl(this._localDatasource);

  @override
  Future<List<PaymentMethod>> getAllPaymentMethods() {
    return _localDatasource.getAllPaymentMethods();
  }

  @override
  Future<PaymentMethod?> getPaymentMethodById(int id) {
    return _localDatasource.getPaymentMethodById(id);
  }

  @override
  Future<PaymentMethod> createPaymentMethod({
    required String name,
    required PaymentMethodType type,
  }) {
    return _localDatasource.createPaymentMethod(name: name, type: type);
  }

  @override
  Future<PaymentMethod> updatePaymentMethod(PaymentMethod method) {
    return _localDatasource.updatePaymentMethod(method);
  }

  @override
  Future<void> deletePaymentMethod(int id) {
    return _localDatasource.deletePaymentMethod(id);
  }

  @override
  Future<void> setDefault(int id) {
    return _localDatasource.setDefault(id);
  }
}
