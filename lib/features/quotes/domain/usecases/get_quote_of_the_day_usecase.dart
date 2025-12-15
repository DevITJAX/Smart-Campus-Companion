import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote_entity.dart';
import '../repositories/quote_repository.dart';

/// Use case to get the quote of the day
class GetQuoteOfTheDayUseCase {
  final QuoteRepository repository;

  GetQuoteOfTheDayUseCase(this.repository);

  Future<Either<Failure, QuoteEntity>> call() async {
    return await repository.getQuoteOfTheDay();
  }
}
