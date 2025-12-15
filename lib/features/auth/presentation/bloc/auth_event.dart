part of 'auth_bloc.dart';

/// Base class for auth events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check current authentication status
class AuthCheckRequested extends AuthEvent {}

/// Event to request sign in
class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Event to request sign up
class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String displayName;
  final String? studentId;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.displayName,
    this.studentId,
  });

  @override
  List<Object?> get props => [email, password, displayName, studentId];
}

/// Event to request sign out
class AuthSignOutRequested extends AuthEvent {}
