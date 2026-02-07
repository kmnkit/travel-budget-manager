import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';
import 'package:trip_wallet/features/consent/presentation/providers/consent_providers.dart';
import 'package:trip_wallet/features/consent/data/datasources/consent_local_datasource.dart';
import 'package:trip_wallet/features/consent/data/repositories/consent_repository_impl.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize consent data source and repository
  final consentDataSource = ConsentLocalDataSource(prefs);
  final consentRepository = ConsentRepositoryImpl(consentDataSource);

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
