import 'package:drift/drift.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tripId => integer()();
  RealColumn get amount => real()();
  TextColumn get currency => text().withLength(min: 3, max: 3)();
  RealColumn get convertedAmount => real()();
  IntColumn get category => intEnum<ExpenseCategory>()();
  IntColumn get paymentMethodId => integer()();
  TextColumn get memo => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
}
