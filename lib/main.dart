import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';
import 'package:trip_wallet/features/consent/presentation/providers/consent_providers.dart';
import 'package:trip_wallet/features/consent/data/repositories/consent_repository_impl.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize MobileAds
  await MobileAds.instance.initialize();

  // Initialize MobileAds
  await MobileAds.instance.initialize();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize consent repository
  final consentRepository = ConsentRepositoryImpl(prefs);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        consentRepositoryProvider.overrideWithValue(consentRepository),
      ],
      child: const TripWalletApp(),
    ),
  );
}
