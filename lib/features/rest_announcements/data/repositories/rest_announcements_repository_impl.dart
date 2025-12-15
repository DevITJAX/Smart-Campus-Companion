import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/rest_announcement_entity.dart';
import '../../domain/repositories/rest_announcements_repository.dart';
import '../datasources/rest_announcements_remote_datasource.dart';

/// Implementation of [RestAnnouncementsRepository].
/// 
/// This class bridges the Data and Domain layers by:
/// 1. Calling the remote data source
/// 2. Converting exceptions to [Failure] objects
/// 3. Returning results wrapped in [Either] for functional error handling
class RestAnnouncementsRepositoryImpl implements RestAnnouncementsRepository {
  final RestAnnouncementsRemoteDataSource remoteDataSource;

  RestAnnouncementsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<RestAnnouncementEntity>>> getAnnouncements() async {
    try {
      // Call the remote data source to fetch announcements
      final announcements = await remoteDataSource.getAnnouncements();
      
      // Return success with the list of announcements
      // The models are automatically cast to entities (they extend the entity class)
      return Right(announcements);
      
    } on ServerException catch (e) {
      // Convert ServerException to ServerFailure
      // This keeps the Domain layer clean of implementation details
      return Left(ServerFailure(message: e.message, code: e.code));
      
    } on NetworkException catch (e) {
      // Handle network-specific exceptions
      return Left(NetworkFailure(message: e.message));
      
    } catch (e) {
      // Catch-all for unexpected errors
      return Left(ServerFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
