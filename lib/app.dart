import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/settings/presentation/providers/settings_providers.dart';
import 'features/onboarding/presentation/providers/onboarding_providers.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/consent/presentation/providers/consent_providers.dart';
import 'features/consent/presentation/screens/consent_screen.dart';
import 'features/analytics/presentation/providers/analytics_providers.dart';

class TripWalletApp extends ConsumerWidget {
  const TripWalletApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consentAsync = ref.watch(consentCompletedProvider);
    final onboardingAsync = ref.watch(onboardingCompletedProvider);
    final locale = ref.watch(localeProvider);

    // 1. Loading state - both consent and onboarding loading
    if (consentAsync.isLoading || onboardingAsync.isLoading) {
      return _buildLoadingApp(locale);
    }

    // 2. Consent not completed -> Show consent screen
    final consentCompleted = consentAsync.value ?? false;
    if (!consentCompleted) {
      return _buildConsentApp(ref, locale);
    }

    // 3. Onboarding not completed -> Show onboarding screen
    final onboardingCompleted = onboardingAsync.value ?? false;
    if (!onboardingCompleted) {
      return _buildOnboardingApp(ref, locale);
    }

    // 4. Main app
    return _buildMainApp(ref, locale);
  }

  Widget _buildLoadingApp(Locale? locale) {
    return MaterialApp(
      title: 'TripWallet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildConsentApp(WidgetRef ref, Locale? locale) {
    return MaterialApp(
      title: 'TripWallet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: ConsentScreen(
        onComplete: () {
          ref.invalidate(consentCompletedProvider);
        },
      ),
    );
  }

  Widget _buildOnboardingApp(WidgetRef ref, Locale? locale) {
    return MaterialApp(
      title: 'TripWallet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: OnboardingScreen(
        onComplete: () async {
          await ref.read(onboardingRepositoryProvider).setOnboardingCompleted(true);
          ref.invalidate(onboardingCompletedProvider);
        },
      ),
    );
  }

  Widget _buildMainApp(WidgetRef ref, Locale? locale) {
    // Initialize analytics based on consent status
    ref.watch(analyticsInitializerProvider);

    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'TripWallet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
