import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/consent_repository_impl.dart';
import '../../domain/entities/consent_record.dart';
import '../../domain/repositories/consent_repository.dart';
import '../../../settings/presentation/providers/settings_providers.dart';

/// Provider for ConsentRepository instance
///
/// Uses SharedPreferences to persist consent data.
/// This provider depends on sharedPreferencesProvider which must be
/// overridden in main.dart.
final consentRepositoryProvider = Provider<ConsentRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ConsentRepositoryImpl(prefs);
});

/// Provider for current consent record
///
/// Returns a FutureProvider that loads the consent record from repository.
/// - Data: ConsentRecord with isAccepted, acceptedAt, and policyVersion
/// - Loading: While fetching from SharedPreferences
/// - Error: If repository operation fails
final consentRecordProvider = FutureProvider<ConsentRecord>((ref) async {
  final repository = ref.watch(consentRepositoryProvider);
  return repository.getConsentRecord();
});
