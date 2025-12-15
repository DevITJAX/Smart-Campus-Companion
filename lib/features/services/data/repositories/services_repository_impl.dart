import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/service_entity.dart';
import '../datasources/services_remote_datasource.dart';

/// Repository for services data
abstract class ServicesRepository {
  Future<Either<Failure, List<ServiceEntity>>> getServices();
  Stream<List<ServiceEntity>> watchServices();
}

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDataSource remoteDataSource;

  ServicesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ServiceEntity>>> getServices() async {
    try {
      final services = await remoteDataSource.getServices();
      return Right(services);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load services: $e'));
    }
  }

  @override
  Stream<List<ServiceEntity>> watchServices() {
    return remoteDataSource.watchServices();
  }
}
