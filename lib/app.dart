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

class TripWalletApp extends ConsumerWidget {
  const TripWalletApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingAsync = ref.watch(onboardingCompletedProvider);
    final locale = ref.watch(localeProvider);

    return onboardingAsync.when(
      loading: () => MaterialApp(
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
      ),
      error: (error, stack) => _buildMainApp(ref, locale),
      data: (completed) {
        if (!completed) {
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

        // Check consent after onboarding
        final consentAsync = ref.watch(consentRecordProvider);
        return consentAsync.when(
          loading: () => MaterialApp(
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
          ),
          error: (error, stack) => _buildMainApp(ref, locale),
          data: (consentRecord) {
            if (!consentRecord.hasValidConsent) {
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
                  onConsentGiven: () {
                    ref.invalidate(consentRecordProvider);
                  },
                ),
              );
            }
            return _buildMainApp(ref, locale);
          },
        );
      },
    );
  }

  Widget _buildMainApp(WidgetRef ref, Locale? locale) {
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
