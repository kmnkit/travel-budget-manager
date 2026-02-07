import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/monetization/data/datasources/ad_datasource.dart';
import 'package:trip_wallet/features/monetization/data/repositories/ad_repository_impl.dart';
import 'package:trip_wallet/features/monetization/domain/repositories/ad_repository.dart';

final adDataSourceProvider = Provider<AdDataSource>((ref) {
  return AdDataSource();
});

final adRepositoryProvider = Provider<AdRepository>((ref) {
  return AdRepositoryImpl();
});
