import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/ads/domain/repositories/ad_repository.dart';
import 'package:trip_wallet/features/ads/data/repositories/ad_repository_impl.dart';
import 'package:trip_wallet/features/consent/presentation/providers/consent_providers.dart';

/// Ad repository provider
final adRepositoryProvider = Provider<AdRepository>((ref) {
  final consentRepo = ref.watch(consentRepositoryProvider);
  return AdRepositoryImpl(consentRepo);
});

/// Provider to initialize ads
final adInitializerProvider = FutureProvider<void>((ref) async {
  final adRepo = ref.read(adRepositoryProvider);
  await adRepo.initialize();
});
