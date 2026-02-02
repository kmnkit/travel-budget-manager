import 'package:trip_wallet/features/trip/domain/entities/trip.dart';
import 'package:trip_wallet/features/trip/domain/repositories/trip_repository.dart';

/// Use case for creating a new trip.
///
/// Validates input parameters before creating the trip.
class CreateTrip {
  final TripRepository _repository;

  const CreateTrip(this._repository);

  /// Executes the use case to create a new trip.
  ///
  /// Throws [ArgumentError] if validation fails:
  /// - Title must not be empty and must be 100 characters or less
  /// - Base currency must be a 3-letter code
  /// - Budget must be positive
  /// - End date must be after start date
  Future<Trip> call({
    required String title,
    required String baseCurrency,
    required double budget,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Validate title
    if (title.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }
    if (title.length > 100) {
      throw ArgumentError('Title must be 100 characters or less');
    }

    // Validate base currency
    if (baseCurrency.length != 3) {
      throw ArgumentError('Base currency must be a 3-letter code');
    }

    // Validate budget
    if (budget <= 0) {
      throw ArgumentError('Budget must be positive');
    }

    // Validate dates
    if (!endDate.isAfter(startDate)) {
      throw ArgumentError('End date must be after start date');
    }

    return _repository.createTrip(
      title: title,
      baseCurrency: baseCurrency,
      budget: budget,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
