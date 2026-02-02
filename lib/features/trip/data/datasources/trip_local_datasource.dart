import 'package:drift/drift.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart' as domain;
import 'package:trip_wallet/shared/data/database.dart';

/// Local datasource for Trip operations using Drift.
class TripLocalDataSource {
  final AppDatabase _database;

  const TripLocalDataSource(this._database);

  /// Retrieves all trips from the database.
  Future<List<domain.Trip>> getAllTrips() async {
    final rows = await (_database.select(_database.trips)
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .get();
    return rows.map(_toEntity).toList();
  }

  /// Retrieves a trip by its ID.
  Future<domain.Trip?> getTripById(int id) async {
    final row = await (_database.select(_database.trips)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _toEntity(row) : null;
  }

  /// Creates a new trip in the database.
  Future<domain.Trip> createTrip({
    required String title,
    required String baseCurrency,
    required double budget,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final now = DateTime.now();
    final id = await _database.into(_database.trips).insert(
          TripsCompanion.insert(
            title: title,
            baseCurrency: baseCurrency,
            budget: budget,
            startDate: startDate,
            endDate: endDate,
            createdAt: now,
            updatedAt: now,
          ),
        );

    final created = await getTripById(id);
    return created!;
  }

  /// Updates an existing trip in the database.
  Future<domain.Trip> updateTrip(domain.Trip trip) async {
    final now = DateTime.now();
    await (_database.update(_database.trips)
          ..where((t) => t.id.equals(trip.id)))
        .write(
      TripsCompanion(
        title: Value(trip.title),
        baseCurrency: Value(trip.baseCurrency),
        budget: Value(trip.budget),
        startDate: Value(trip.startDate),
        endDate: Value(trip.endDate),
        updatedAt: Value(now),
      ),
    );

    final updated = await getTripById(trip.id);
    return updated!;
  }

  /// Deletes a trip from the database.
  Future<void> deleteTrip(int id) async {
    await (_database.delete(_database.trips)..where((t) => t.id.equals(id)))
        .go();
  }

  /// Watches all trips for changes.
  Stream<List<domain.Trip>> watchAllTrips() {
    return (_database.select(_database.trips)
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .watch()
        .map((rows) => rows.map(_toEntity).toList());
  }

  /// Converts a Drift Trip row to a domain Trip entity.
  domain.Trip _toEntity(Trip row) {
    return domain.Trip(
      id: row.id,
      title: row.title,
      baseCurrency: row.baseCurrency,
      budget: row.budget,
      startDate: row.startDate,
      endDate: row.endDate,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
