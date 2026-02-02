import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method.dart';
import 'package:trip_wallet/features/payment_method/domain/repositories/payment_method_repository.dart';
import 'package:trip_wallet/features/payment_method/domain/usecases/get_payment_methods.dart';
import 'package:trip_wallet/features/payment_method/domain/usecases/create_payment_method.dart';
import 'package:trip_wallet/features/payment_method/domain/usecases/delete_payment_method.dart';
import 'package:trip_wallet/features/payment_method/data/repositories/payment_method_repository_impl.dart';
import 'package:trip_wallet/features/payment_method/data/datasources/payment_method_local_datasource.dart';

// Repository provider
final paymentMethodRepositoryProvider = Provider<PaymentMethodRepository>((ref) {
  final datasource = ref.watch(paymentMethodLocalDatasourceProvider);
  return PaymentMethodRepositoryImpl(datasource);
});

// Use case providers
final getPaymentMethodsProvider = Provider<GetPaymentMethods>((ref) {
  final repository = ref.watch(paymentMethodRepositoryProvider);
  return GetPaymentMethods(repository);
});

final createPaymentMethodProvider = Provider<CreatePaymentMethod>((ref) {
  final repository = ref.watch(paymentMethodRepositoryProvider);
  return CreatePaymentMethod(repository);
});

final deletePaymentMethodProvider = Provider<DeletePaymentMethod>((ref) {
  final repository = ref.watch(paymentMethodRepositoryProvider);
  return DeletePaymentMethod(repository);
});

// Data providers
final paymentMethodListProvider = FutureProvider<List<PaymentMethod>>((ref) {
  final useCase = ref.watch(getPaymentMethodsProvider);
  return useCase();
});

// Computed provider for default payment method
final defaultPaymentMethodProvider = Provider<AsyncValue<PaymentMethod?>>((ref) {
  final methods = ref.watch(paymentMethodListProvider);
  return methods.whenData((list) => list.where((m) => m.isDefault).firstOrNull);
});
