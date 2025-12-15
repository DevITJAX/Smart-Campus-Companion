import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing up a new user
class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String displayName,
    String? studentId,
  }) {
    return repository.signUp(
      email: email,
      password: password,
      displayName: displayName,
      studentId: studentId,
    );
  }
}
