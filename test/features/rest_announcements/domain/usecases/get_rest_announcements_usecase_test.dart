import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

// Domain imports
import 'package:smart_campus_companion/features/rest_announcements/domain/entities/rest_announcement_entity.dart';
import 'package:smart_campus_companion/features/rest_announcements/domain/repositories/rest_announcements_repository.dart';
import 'package:smart_campus_companion/features/rest_announcements/domain/usecases/get_rest_announcements_usecase.dart';
import 'package:smart_campus_companion/core/errors/failures.dart';

/// Mock implementation of the repository for testing
class MockRestAnnouncementsRepository implements RestAnnouncementsRepository {
  final bool shouldSucceed;
  final List<RestAnnouncementEntity> mockAnnouncements;

  MockRestAnnouncementsRepository({
    this.shouldSucceed = true,
    this.mockAnnouncements = const [],
  });

  @override
  Future<Either<Failure, List<RestAnnouncementEntity>>> getAnnouncements() async {
    if (shouldSucceed) {
      return Right(mockAnnouncements);
    } else {
      return const Left(ServerFailure(message: 'Test error'));
    }
  }
}

void main() {
  group('GetRestAnnouncementsUseCase', () {
    // Test data
    final testAnnouncements = [
      const RestAnnouncementEntity(
        id: 1,
        userId: 1,
        title: 'Test Announcement',
        body: 'This is a test announcement body.',
      ),
      const RestAnnouncementEntity(
        id: 2,
        userId: 1,
        title: 'Second Announcement',
        body: 'This is the second announcement.',
      ),
    ];

    test('should return list of announcements on success', () async {
      // Arrange
      final mockRepository = MockRestAnnouncementsRepository(
        shouldSucceed: true,
        mockAnnouncements: testAnnouncements,
      );
      final useCase = GetRestAnnouncementsUseCase(mockRepository);

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (announcements) {
          expect(announcements.length, 2);
          expect(announcements[0].id, 1);
          expect(announcements[0].title, 'Test Announcement');
          expect(announcements[1].id, 2);
        },
      );
    });

    test('should return failure when repository fails', () async {
      // Arrange
      final mockRepository = MockRestAnnouncementsRepository(
        shouldSucceed: false,
      );
      final useCase = GetRestAnnouncementsUseCase(mockRepository);

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Test error');
        },
        (announcements) => fail('Should not return announcements'),
      );
    });

    test('should return empty list when no announcements', () async {
      // Arrange
      final mockRepository = MockRestAnnouncementsRepository(
        shouldSucceed: true,
        mockAnnouncements: [],
      );
      final useCase = GetRestAnnouncementsUseCase(mockRepository);

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (announcements) {
          expect(announcements, isEmpty);
        },
      );
    });
  });
}
