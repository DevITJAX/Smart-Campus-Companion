import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/announcement_model.dart';

/// Remote data source for announcements
abstract class AnnouncementRemoteDataSource {
  /// Get all announcements from Firestore
  Future<List<AnnouncementModel>> getAnnouncements();

  /// Get announcement by ID
  Future<AnnouncementModel> getAnnouncementById(String id);
}

/// Implementation of AnnouncementRemoteDataSource
class AnnouncementRemoteDataSourceImpl implements AnnouncementRemoteDataSource {
  final FirebaseFirestore firestore;

  AnnouncementRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<AnnouncementModel>> getAnnouncements() async {
    try {
      // Simple query without orderBy to avoid index requirement
      final querySnapshot = await firestore
          .collection(AppConstants.announcementsCollection)
          .get();

      final announcements = querySnapshot.docs
          .map((doc) => AnnouncementModel.fromFirestore(doc))
          .toList();

      // Sort by publishedAt in memory (descending - newest first)
      announcements.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

      return announcements;
    } catch (e) {
      debugPrint('Error fetching announcements: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AnnouncementModel> getAnnouncementById(String id) async {
    try {
      final doc = await firestore
          .collection(AppConstants.announcementsCollection)
          .doc(id)
          .get();

      if (!doc.exists) {
        throw const ServerException(message: 'Announcement not found');
      }

      return AnnouncementModel.fromFirestore(doc);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
