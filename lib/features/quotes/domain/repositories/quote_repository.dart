import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote_entity.dart';

/// Repository interface for quotes
abstract class QuoteRepository {
  /// Get today's motivational quote
  Future<Either<Failure, QuoteEntity>> getQuoteOfTheDay();
}
