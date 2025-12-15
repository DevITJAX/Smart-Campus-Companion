import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/network_info.dart';
import '../../domain/entities/announcement_entity.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../datasources/announcement_local_datasource.dart';
import '../datasources/announcement_remote_datasource.dart';

/// Implementation of AnnouncementRepository with offline-first approach
class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDataSource remoteDataSource;
  final AnnouncementLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AnnouncementRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AnnouncementEntity>>> getAnnouncements() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAnnouncements = await remoteDataSource.getAnnouncements();
        // Cache for offline use
        await localDataSource.cacheAnnouncements(remoteAnnouncements);
        return Right(remoteAnnouncements);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      try {
        final localAnnouncements = await localDataSource.getCachedAnnouncements();
        return Right(localAnnouncements);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, AnnouncementEntity>> getAnnouncementById(String id) async {
    try {
      final announcement = await remoteDataSource.getAnnouncementById(id);
      return Right(announcement);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
