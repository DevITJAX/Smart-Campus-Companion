import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/schedule_class_entity.dart';
import '../datasources/schedule_remote_datasource.dart';

/// Repository for schedule data
abstract class ScheduleRepository {
  Future<Either<Failure, List<ScheduleClassEntity>>> getScheduleByClassId(String classId);
  Stream<List<ScheduleClassEntity>> watchScheduleByClassId(String classId);
}

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ScheduleClassEntity>>> getScheduleByClassId(String classId) async {
    try {
      final schedule = await remoteDataSource.getScheduleByClassId(classId);
      return Right(schedule);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load schedule: $e'));
    }
  }

  @override
  Stream<List<ScheduleClassEntity>> watchScheduleByClassId(String classId) {
    return remoteDataSource.watchScheduleByClassId(classId);
  }
}
