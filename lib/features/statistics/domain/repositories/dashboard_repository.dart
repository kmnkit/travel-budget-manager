import 'package:trip_wallet/features/statistics/domain/entities/dashboard_config.dart';

abstract class DashboardRepository {
  Future<DashboardConfig> loadDashboardConfig();
  Future<void> saveDashboardConfig(DashboardConfig config);
  Future<void> resetToDefault();
}
