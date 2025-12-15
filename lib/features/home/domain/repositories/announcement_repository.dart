import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/announcement_entity.dart';

/// Repository interface for announcements
abstract class AnnouncementRepository {
  /// Get all announcements
  Future<Either<Failure, List<AnnouncementEntity>>> getAnnouncements();

  /// Get announcement by ID
  Future<Either<Failure, AnnouncementEntity>> getAnnouncementById(String id);
}
