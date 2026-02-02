import 'package:trip_wallet/features/trip/domain/entities/trip.dart';
import 'package:trip_wallet/features/trip/domain/repositories/trip_repository.dart';

/// Use case for updating an existing trip.
///
/// Validates input parameters before updating the trip.
class UpdateTrip {
  final TripRepository _repository;

  const UpdateTrip(this._repository);

  /// Executes the use case to update an existing trip.
  ///
  /// Throws [ArgumentError] if validation fails:
  /// - Title must not be empty and must be 100 characters or less
  /// - Base currency must be a 3-letter code
  /// - Budget must be positive
  /// - End date must be after start date
  Future<Trip> call(Trip trip) async {
    // Validate title
    if (trip.title.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }
    if (trip.title.length > 100) {
      throw ArgumentError('Title must be 100 characters or less');
    }

    // Validate base currency
    if (trip.baseCurrency.length != 3) {
      throw ArgumentError('Base currency must be a 3-letter code');
    }

    // Validate budget
    if (trip.budget <= 0) {
      throw ArgumentError('Budget must be positive');
    }

    // Validate dates
    if (!trip.endDate.isAfter(trip.startDate)) {
      throw ArgumentError('End date must be after start date');
    }

    return _repository.updateTrip(trip);
  }
}
