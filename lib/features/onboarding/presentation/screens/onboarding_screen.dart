import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';
import '../providers/onboarding_providers.dart';
import '../widgets/onboarding_page_widget.dart';
import '../widgets/page_indicator.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({
    super.key,
    required this.onComplete,
  });

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    ref.read(currentPageProvider.notifier).setPage(page);
  }

  void _nextPage() {
    final currentPage = ref.read(currentPageProvider);
    if (currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    _completeOnboarding();
  }

  void _completeOnboarding() async {
    await ref.read(onboardingRepositoryProvider).setOnboardingCompleted(true);
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentPage = ref.watch(currentPageProvider);

    final pages = [
      OnboardingPageWidget(
        icon: Icons.flight_takeoff,
        title: l10n.onboardingWelcomeTitle,
        description: l10n.onboardingWelcomeDescription,
      ),
      OnboardingPageWidget(
        icon: Icons.receipt_long,
        title: l10n.onboardingFeaturesTitle,
        description: l10n.onboardingFeaturesDescription,
      ),
      OnboardingPageWidget(
        icon: Icons.rocket_launch,
        title: l10n.onboardingGetStartedTitle,
        description: l10n.onboardingGetStartedDescription,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _skip,
                  child: Text(l10n.onboardingSkip),
                ),
              ),
            ),
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: pages,
              ),
            ),
            // Page indicator
            PageIndicator(
              currentPage: currentPage,
              pageCount: pages.length,
            ),
            const SizedBox(height: 24),
            // Action button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: currentPage == 2 ? _completeOnboarding : _nextPage,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    currentPage == 2
                        ? l10n.onboardingGetStarted
                        : l10n.onboardingNext,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
