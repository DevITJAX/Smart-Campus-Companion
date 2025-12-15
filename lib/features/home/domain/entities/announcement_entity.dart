import 'package:equatable/equatable.dart';

/// Announcement entity representing campus announcements
class AnnouncementEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime publishedAt;
  final bool isPinned;
  final String? imageUrl;

  const AnnouncementEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.publishedAt,
    this.isPinned = false,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, title, content, category, publishedAt, isPinned, imageUrl];
}
