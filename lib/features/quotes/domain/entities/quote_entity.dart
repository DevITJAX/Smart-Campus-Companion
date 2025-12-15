import 'package:equatable/equatable.dart';

/// Quote entity representing a motivational quote
class QuoteEntity extends Equatable {
  final String id;
  final String content;
  final String author;
  final DateTime fetchedAt;

  const QuoteEntity({
    required this.id,
    required this.content,
    required this.author,
    required this.fetchedAt,
  });

  @override
  List<Object?> get props => [id, content, author, fetchedAt];
}
