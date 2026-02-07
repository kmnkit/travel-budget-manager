import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/dashboard_config.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final SharedPreferences _prefs;
  static const _key = 'dashboard_config';

  DashboardRepositoryImpl(this._prefs);

  @override
  Future<DashboardConfig> loadDashboardConfig() async {
    final jsonString = _prefs.getString(_key);
    if (jsonString == null) {
      return DashboardConfig.defaultConfig();
    }
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return DashboardConfig.fromJson(json);
    } catch (_) {
      return DashboardConfig.defaultConfig();
    }
  }

  @override
  Future<void> saveDashboardConfig(DashboardConfig config) async {
    final jsonString = jsonEncode(config.toJson());
    await _prefs.setString(_key, jsonString);
  }

  @override
  Future<void> resetToDefault() async {
    await _prefs.remove(_key);
  }
}
