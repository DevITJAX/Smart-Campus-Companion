import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/announcement_model.dart';

/// Local data source for announcements using Hive
abstract class AnnouncementLocalDataSource {
  /// Get cached announcements
  Future<List<AnnouncementModel>> getCachedAnnouncements();

  /// Cache announcements
  Future<void> cacheAnnouncements(List<AnnouncementModel> announcements);
}

/// Implementation of AnnouncementLocalDataSource
class AnnouncementLocalDataSourceImpl implements AnnouncementLocalDataSource {
  Box<AnnouncementModel>? _box;

  Future<Box<AnnouncementModel>> get box async {
    _box ??= await Hive.openBox<AnnouncementModel>(AppConstants.announcementsBox);
    return _box!;
  }

  @override
  Future<List<AnnouncementModel>> getCachedAnnouncements() async {
    try {
      final announcementsBox = await box;
      final announcements = announcementsBox.values.toList();
      
      if (announcements.isEmpty) {
        throw const CacheException(message: 'Data not found in cache', code: 1);
      }

      // Sort by publishedAt descending
      announcements.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      return announcements;
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> cacheAnnouncements(List<AnnouncementModel> announcements) async {
    try {
      final announcementsBox = await box;
      await announcementsBox.clear();
      
      for (final announcement in announcements) {
        await announcementsBox.put(announcement.id, announcement);
      }
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
