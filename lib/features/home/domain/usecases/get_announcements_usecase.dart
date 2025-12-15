import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/announcement_entity.dart';
import '../repositories/announcement_repository.dart';

/// Use case for getting announcements
class GetAnnouncementsUseCase {
  final AnnouncementRepository repository;

  GetAnnouncementsUseCase(this.repository);

  Future<Either<Failure, List<AnnouncementEntity>>> call() {
    return repository.getAnnouncements();
  }
}
