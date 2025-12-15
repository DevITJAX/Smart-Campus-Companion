import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Server-related failures (Firebase, API errors)
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});

  factory AuthFailure.invalidEmail() =>
      const AuthFailure(message: 'Invalid email address', code: 1);

  factory AuthFailure.wrongPassword() =>
      const AuthFailure(message: 'Wrong password', code: 2);

  factory AuthFailure.userNotFound() =>
      const AuthFailure(message: 'User not found', code: 3);

  factory AuthFailure.emailAlreadyInUse() =>
      const AuthFailure(message: 'Email already in use', code: 4);

  factory AuthFailure.weakPassword() =>
      const AuthFailure(message: 'Password is too weak', code: 5);

  factory AuthFailure.userDisabled() =>
      const AuthFailure(message: 'User account is disabled', code: 6);

  factory AuthFailure.unknown() =>
      const AuthFailure(message: 'An unknown error occurred', code: -1);
}

/// Cache/Local storage failures
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});

  factory CacheFailure.notFound() =>
      const CacheFailure(message: 'Data not found in cache', code: 1);

  factory CacheFailure.writeError() =>
      const CacheFailure(message: 'Failed to write to cache', code: 2);
}

/// Network connectivity failures
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection', super.code});
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}
