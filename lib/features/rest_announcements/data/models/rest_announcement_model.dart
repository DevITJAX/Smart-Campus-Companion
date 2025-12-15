import '../../domain/entities/rest_announcement_entity.dart';

/// Data model for REST Announcements from JSONPlaceholder API.
/// 
/// This model extends the domain entity and adds JSON serialization
/// capabilities for the Data layer.
/// 
/// JSONPlaceholder API returns posts in this format:
/// ```json
/// {
///   "userId": 1,
///   "id": 1,
///   "title": "sunt aut facere...",
///   "body": "quia et suscipit..."
/// }
/// ```
class RestAnnouncementModel extends RestAnnouncementEntity {
  const RestAnnouncementModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
  });

  /// Creates a model from JSON response.
  /// 
  /// This factory handles the conversion from the API's JSON format
  /// to our domain model.
  factory RestAnnouncementModel.fromJson(Map<String, dynamic> json) {
    return RestAnnouncementModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  /// Converts the model to JSON (useful for caching or debugging).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}
