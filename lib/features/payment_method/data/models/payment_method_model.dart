import 'package:drift/drift.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method_type.dart';

class PaymentMethods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get type => intEnum<PaymentMethodType>()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}
