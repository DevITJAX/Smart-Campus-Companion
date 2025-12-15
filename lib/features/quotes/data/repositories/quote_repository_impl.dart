import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/network_info.dart';
import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quote_repository.dart';
import '../datasources/quote_local_datasource.dart';
import '../datasources/quote_remote_datasource.dart';

/// Implementation of QuoteRepository with offline-first approach
class QuoteRepositoryImpl implements QuoteRepository {
  final QuoteRemoteDataSource remoteDataSource;
  final QuoteLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  QuoteRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, QuoteEntity>> getQuoteOfTheDay() async {
    // First, check if we have a valid cached quote for today
    if (await localDataSource.isCacheValid()) {
      try {
        final cachedQuote = await localDataSource.getCachedQuote();
        return Right(cachedQuote);
      } on CacheException {
        // Cache invalid, continue to fetch from remote
      }
    }

    // Try to fetch from remote if connected
    if (await networkInfo.isConnected) {
      try {
        final remoteQuote = await remoteDataSource.getQuoteOfTheDay();
        // Cache for offline use
        await localDataSource.cacheQuote(remoteQuote);
        return Right(remoteQuote);
      } on ServerException catch (e) {
        // Remote failed, try cache as fallback
        try {
          final cachedQuote = await localDataSource.getCachedQuote();
          return Right(cachedQuote);
        } on CacheException {
          return Left(ServerFailure(message: e.message));
        }
      }
    } else {
      // Offline: return cached data
      try {
        final cachedQuote = await localDataSource.getCachedQuote();
        return Right(cachedQuote);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }
}
