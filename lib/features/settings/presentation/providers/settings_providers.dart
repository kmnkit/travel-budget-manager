import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for SharedPreferences instance
///
/// This should be overridden in main.dart with the actual instance:
/// ```dart
/// ProviderScope(
///   overrides: [
///     sharedPreferencesProvider.overrideWithValue(prefs),
///   ],
///   child: MyApp(),
/// )
/// ```
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

/// Provider for app locale (language setting)
///
/// Persists to SharedPreferences with key 'locale'.
/// Defaults to Korean ('ko') if not set.
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

/// Notifier for managing app locale
class LocaleNotifier extends Notifier<Locale> {
  static const _key = 'locale';

  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final localeCode = prefs.getString(_key);

    if (localeCode == null) {
      return const Locale('ko');
    }

    return Locale(localeCode);
  }

  /// Sets the app locale and persists to SharedPreferences
  Future<void> setLocale(Locale locale) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, locale.languageCode);
    state = locale;
  }
}

/// Provider for default currency setting
///
/// Persists to SharedPreferences with key 'defaultCurrency'.
/// Defaults to 'KRW' if not set.
final defaultCurrencyProvider = NotifierProvider<DefaultCurrencyNotifier, String>(
  DefaultCurrencyNotifier.new,
);

/// Notifier for managing default currency
class DefaultCurrencyNotifier extends Notifier<String> {
  static const _key = 'defaultCurrency';

  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString(_key) ?? 'KRW';
  }

  /// Sets the default currency and persists to SharedPreferences
  Future<void> setCurrency(String currency) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, currency);
    state = currency;
  }
}
