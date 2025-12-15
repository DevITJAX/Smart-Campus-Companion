import 'package:equatable/equatable.dart';

/// REST Announcement entity representing a post from JSONPlaceholder API.
/// 
/// This entity is part of the Domain layer and has NO dependencies on
/// Flutter, Dio, or any external packages (except Equatable for value equality).
/// 
/// Used to demonstrate REST API integration for academic evaluation.
class RestAnnouncementEntity extends Equatable {
  /// Unique identifier from the API
  final int id;
  
  /// ID of the user who created this announcement
  final int userId;
  
  /// Title of the announcement
  final String title;
  
  /// Body/content of the announcement
  final String body;

  const RestAnnouncementEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  @override
  List<Object?> get props => [id, userId, title, body];
}
