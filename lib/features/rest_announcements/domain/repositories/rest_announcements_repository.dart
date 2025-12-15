import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/rest_announcement_entity.dart';

/// Repository interface for REST Announcements.
/// 
/// This is an abstract class that defines the contract for fetching
/// announcements via REST API. The implementation is in the Data layer.
/// 
/// Domain layer should NOT know about Dio, HTTP, or any implementation details.
abstract class RestAnnouncementsRepository {
  /// Fetches a list of announcements from the REST API.
  /// 
  /// Returns [Either]:
  /// - [Left] with [Failure] if an error occurs (network, server, etc.)
  /// - [Right] with [List<RestAnnouncementEntity>] on success
  Future<Either<Failure, List<RestAnnouncementEntity>>> getAnnouncements();
}
