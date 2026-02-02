import 'package:drift/drift.dart';

class ExchangeRates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tripId => integer().nullable()();
  TextColumn get baseCurrency => text().withLength(min: 3, max: 3)();
  TextColumn get targetCurrency => text().withLength(min: 3, max: 3)();
  RealColumn get rate => real()();
  BoolColumn get isManual => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();
}
