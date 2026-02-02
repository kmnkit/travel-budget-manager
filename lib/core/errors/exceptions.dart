class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class DatabaseException extends AppException {
  const DatabaseException([super.message = 'Database error']);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Cache error']);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}
