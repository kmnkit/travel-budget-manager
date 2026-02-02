import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/core/errors/exceptions.dart';

class ExchangeRateRemoteDatasource {
  final Dio _dio;

  ExchangeRateRemoteDatasource(this._dio);

  // Primary API
  static const _primaryUrl = 'https://api.exchangerate-api.com/v4/latest/';
  // Fallback API
  static const _fallbackUrl = 'https://open.er-api.com/v6/latest/';

  Future<Map<String, double>> fetchRates(String baseCurrency) async {
    try {
      return await _fetchFromPrimary(baseCurrency);
    } catch (_) {
      try {
        return await _fetchFromFallback(baseCurrency);
      } catch (e) {
        throw NetworkException('Failed to fetch exchange rates: $e');
      }
    }
  }

  Future<Map<String, double>> _fetchFromPrimary(String baseCurrency) async {
    try {
      final response = await _dio.get(
        '$_primaryUrl$baseCurrency',
        options: Options(
          validateStatus: (status) => status == 200,
        ),
      );

      final data = response.data as Map<String, dynamic>;
      final rates = data['rates'] as Map<String, dynamic>;

      return rates.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException('No internet connection');
      }
      throw NetworkException('Primary API failed: ${e.message}');
    } catch (e) {
      throw NetworkException('Failed to parse primary API response: $e');
    }
  }

  Future<Map<String, double>> _fetchFromFallback(String baseCurrency) async {
    try {
      final response = await _dio.get(
        '$_fallbackUrl$baseCurrency',
        options: Options(
          validateStatus: (status) => status == 200,
        ),
      );

      final data = response.data as Map<String, dynamic>;
      final rates = data['rates'] as Map<String, dynamic>;

      return rates.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException('No internet connection');
      }
      throw NetworkException('Fallback API failed: ${e.message}');
    } catch (e) {
      throw NetworkException('Failed to parse fallback API response: $e');
    }
  }
}

final exchangeRateRemoteDatasourceProvider =
    Provider<ExchangeRateRemoteDatasource>((ref) {
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  return ExchangeRateRemoteDatasource(dio);
});
