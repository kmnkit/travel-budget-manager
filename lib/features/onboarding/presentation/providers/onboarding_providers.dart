import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/repositories/onboarding_repository.dart';

/// Repository provider for onboarding persistence
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingRepositoryImpl(prefs);
});

/// FutureProvider to check if onboarding is completed
final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(onboardingRepositoryProvider);
  return repo.isOnboardingCompleted();
});

/// Notifier for current page in onboarding flow
class CurrentPageNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setPage(int page) => state = page;

  void nextPage() {
    if (state < 2) state++;
  }

  void previousPage() {
    if (state > 0) state--;
  }
}

final currentPageProvider = NotifierProvider<CurrentPageNotifier, int>(
  CurrentPageNotifier.new,
);
