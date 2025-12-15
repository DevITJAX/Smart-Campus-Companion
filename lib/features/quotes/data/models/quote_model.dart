import 'package:hive/hive.dart';
import '../../domain/entities/quote_entity.dart';

part 'quote_model.g.dart';

/// Quote model for data layer with Hive support
@HiveType(typeId: 2)
class QuoteModel extends QuoteEntity {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String content;

  @HiveField(2)
  @override
  final String author;

  @HiveField(3)
  @override
  final DateTime fetchedAt;

  const QuoteModel({
    required this.id,
    required this.content,
    required this.author,
    required this.fetchedAt,
  }) : super(
          id: id,
          content: content,
          author: author,
          fetchedAt: fetchedAt,
        );

  /// Create from API JSON response (ZenQuotes API format)
  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: json['q'] as String? ?? json['content'] as String? ?? '',
      author: json['a'] as String? ?? json['author'] as String? ?? 'Unknown',
      fetchedAt: DateTime.now(),
    );
  }

  /// Convert to JSON for caching
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'author': author,
      'fetchedAt': fetchedAt.toIso8601String(),
    };
  }

  /// Create from cached JSON
  factory QuoteModel.fromCacheJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] as String,
      content: json['content'] as String,
      author: json['author'] as String,
      fetchedAt: DateTime.parse(json['fetchedAt'] as String),
    );
  }
}
