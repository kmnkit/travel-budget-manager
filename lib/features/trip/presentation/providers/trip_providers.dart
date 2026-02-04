import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/trip/data/datasources/trip_local_datasource.dart';
import 'package:trip_wallet/features/trip/data/repositories/trip_repository_impl.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';
import 'package:trip_wallet/features/trip/domain/repositories/trip_repository.dart';
import 'package:trip_wallet/features/trip/domain/usecases/create_trip.dart';
import 'package:trip_wallet/features/trip/domain/usecases/delete_trip.dart';
import 'package:trip_wallet/features/trip/domain/usecases/get_trips.dart';
import 'package:trip_wallet/features/trip/domain/usecases/update_trip.dart';
import 'package:trip_wallet/shared/data/database.dart' as db;

// ============================================================================
// Data Layer Providers
// ============================================================================

/// Provides the local data source for trip operations
final tripLocalDataSourceProvider = Provider<TripLocalDataSource>((ref) {
  final database = ref.watch(db.databaseProvider);
  return TripLocalDataSource(database);
});

/// Provides the trip repository implementation
final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final dataSource = ref.watch(tripLocalDataSourceProvider);
  return TripRepositoryImpl(dataSource);
});

// ============================================================================
// Use Case Providers
// ============================================================================

/// Provides the GetTrips use case
final getTripsProvider = Provider<GetTrips>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return GetTrips(repository);
});

/// Provides the CreateTrip use case
final createTripProvider = Provider<CreateTrip>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return CreateTrip(repository);
});

/// Provides the UpdateTrip use case
final updateTripProvider = Provider<UpdateTrip>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return UpdateTrip(repository);
});

/// Provides the DeleteTrip use case
final deleteTripProvider = Provider<DeleteTrip>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return DeleteTrip(repository);
});

// ============================================================================
// State Providers
// ============================================================================

/// Provides a reactive stream of all trips
///
/// This provider watches the database for changes and automatically updates
/// when trips are created, updated, or deleted.
final tripListProvider = StreamProvider<List<Trip>>((ref) {
  final dataSource = ref.watch(tripLocalDataSourceProvider);
  return dataSource.watchAllTrips();
});

/// Provides a single trip by ID
///
/// This is a FutureProvider.family that fetches a specific trip.
/// Use this for trip detail screens.
final tripDetailProvider = FutureProvider.family<Trip?, int>((ref, tripId) {
  final dataSource = ref.watch(tripLocalDataSourceProvider);
  return dataSource.getTripById(tripId);
});

/// Provides the trip CRUD notifier
///
/// This notifier handles create, update, and delete operations with proper
/// cache invalidation.
final tripNotifierProvider = NotifierProvider<TripNotifier, void>(
  TripNotifier.new,
);

/// Notifier for trip CRUD operations
///
/// Handles creating, updating, and deleting trips with automatic invalidation
/// of related providers.
class TripNotifier extends Notifier<void> {
  @override
  void build() {
    // No state needed for CRUD operations
  }

  /// Creates a new trip
  ///
  /// Returns the created trip with generated ID and timestamps.
  /// Invalidates tripListProvider to trigger a refresh.
  Future<Trip> createTrip({
    required String title,
    required String baseCurrency,
    required double budget,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final repository = ref.read(tripRepositoryProvider);

    final trip = await repository.createTrip(
      title: title,
      baseCurrency: baseCurrency,
      budget: budget,
      startDate: startDate,
      endDate: endDate,
    );

    // Invalidate providers to refresh UI
    ref.invalidate(tripListProvider);

    return trip;
  }

  /// Updates an existing trip
  ///
  /// Returns the updated trip with new updatedAt timestamp.
  /// Invalidates tripListProvider and tripDetailProvider for this trip.
  Future<Trip> updateTrip(Trip trip) async {
    final repository = ref.read(tripRepositoryProvider);

    final updated = await repository.updateTrip(trip);

    // Invalidate providers to refresh UI
    ref.invalidate(tripListProvider);
    ref.invalidate(tripDetailProvider(trip.id));

    return updated;
  }

  /// Deletes a trip by ID
  ///
  /// Invalidates tripListProvider and tripDetailProvider for this trip.
  Future<void> deleteTrip(int id) async {
    final repository = ref.read(tripRepositoryProvider);

    await repository.deleteTrip(id);

    // Invalidate providers to refresh UI
    ref.invalidate(tripListProvider);
    ref.invalidate(tripDetailProvider(id));
  }
}

// ============================================================================
// Filter Providers
// ============================================================================

/// Trip filter options for the home screen
enum TripFilter { all, active, past }

/// Notifier for the currently selected trip filter
class TripFilterNotifier extends Notifier<TripFilter> {
  @override
  TripFilter build() => TripFilter.all;

  void setFilter(TripFilter filter) {
    state = filter;
  }
}

/// Holds the currently selected trip filter
final tripFilterProvider = NotifierProvider<TripFilterNotifier, TripFilter>(
  TripFilterNotifier.new,
);

/// Provides filtered trip list based on selected filter
final filteredTripListProvider = Provider<AsyncValue<List<Trip>>>((ref) {
  final filter = ref.watch(tripFilterProvider);
  final tripsAsync = ref.watch(tripListProvider);
  return tripsAsync.whenData((trips) {
    return switch (filter) {
      TripFilter.all => trips,
      TripFilter.active => trips.where((t) => t.status == TripStatus.ongoing).toList(),
      TripFilter.past => trips.where((t) => t.status == TripStatus.completed).toList(),
    };
  });
});
