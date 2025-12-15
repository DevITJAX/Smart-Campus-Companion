/// Base exception for all application exceptions
class AppException implements Exception {
  final String message;
  final int? code;

  const AppException({required this.message, this.code});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Server/API exceptions
class ServerException extends AppException {
  const ServerException({required super.message, super.code});
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException({required super.message, super.code});
}

/// Cache/Local storage exceptions
class CacheException extends AppException {
  const CacheException({required super.message, super.code});
}

/// Network exceptions
class NetworkException extends AppException {
  const NetworkException({super.message = 'No internet connection', super.code});
}
