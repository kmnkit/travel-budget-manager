import 'package:trip_wallet/features/trip/domain/entities/trip.dart';

/// Abstract repository interface for Trip operations.
///
/// This interface defines the contract for data operations on Trip entities.
/// Implementations should handle data persistence and retrieval.
abstract class TripRepository {
  /// Retrieves all trips from the data source.
  ///
  /// Returns a list of all trips, ordered by creation date descending.
  Future<List<Trip>> getAllTrips();

  /// Retrieves a single trip by its ID.
  ///
  /// Returns the trip if found, null otherwise.
  Future<Trip?> getTripById(int id);

  /// Creates a new trip with the given parameters.
  ///
  /// Returns the created trip with generated ID and timestamps.
  Future<Trip> createTrip({
    required String title,
    required String baseCurrency,
    required double budget,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Updates an existing trip.
  ///
  /// Returns the updated trip with new updatedAt timestamp.
  Future<Trip> updateTrip(Trip trip);

  /// Deletes a trip by its ID.
  ///
  /// Throws an exception if the trip doesn't exist.
  Future<void> deleteTrip(int id);

  /// Watches all trips for changes.
  ///
  /// Returns a stream that emits the list of all trips whenever the data changes.
  Stream<List<Trip>> watchAllTrips();
}
