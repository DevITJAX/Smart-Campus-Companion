import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/announcement_entity.dart';

part 'announcement_model.g.dart';

/// Announcement model for Firebase and Hive storage
@HiveType(typeId: 0)
class AnnouncementModel extends AnnouncementEntity {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String title;

  @HiveField(2)
  @override
  final String content;

  @HiveField(3)
  @override
  final String category;

  @HiveField(4)
  @override
  final DateTime publishedAt;

  @HiveField(5)
  @override
  final bool isPinned;

  @HiveField(6)
  @override
  final String? imageUrl;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.publishedAt,
    this.isPinned = false,
    this.imageUrl,
  }) : super(
          id: id,
          title: title,
          content: content,
          category: category,
          publishedAt: publishedAt,
          isPinned: isPinned,
          imageUrl: imageUrl,
        );

  /// Create from Firestore document
  factory AnnouncementModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AnnouncementModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? 'General',
      publishedAt: data['publishedAt'] != null
          ? (data['publishedAt'] as Timestamp).toDate()
          : DateTime.now(),
      isPinned: data['isPinned'] ?? false,
      imageUrl: data['imageUrl'],
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'publishedAt': Timestamp.fromDate(publishedAt),
      'isPinned': isPinned,
      'imageUrl': imageUrl,
    };
  }

  /// Create from entity
  factory AnnouncementModel.fromEntity(AnnouncementEntity entity) {
    return AnnouncementModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      category: entity.category,
      publishedAt: entity.publishedAt,
      isPinned: entity.isPinned,
      imageUrl: entity.imageUrl,
    );
  }
}
