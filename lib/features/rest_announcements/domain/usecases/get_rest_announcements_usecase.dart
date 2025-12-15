import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/rest_announcement_entity.dart';
import '../repositories/rest_announcements_repository.dart';

/// Use case for fetching REST announcements.
/// 
/// This class encapsulates the business logic for getting announcements.
/// It depends only on the repository interface, not the implementation.
/// 
/// Following the Single Responsibility Principle - this use case does ONE thing:
/// fetches the list of announcements.
class GetRestAnnouncementsUseCase {
  final RestAnnouncementsRepository repository;

  GetRestAnnouncementsUseCase(this.repository);

  /// Executes the use case to fetch announcements.
  /// 
  /// Returns [Either]:
  /// - [Left] with [Failure] containing error details
  /// - [Right] with [List<RestAnnouncementEntity>] on success
  Future<Either<Failure, List<RestAnnouncementEntity>>> call() async {
    return await repository.getAnnouncements();
  }
}
