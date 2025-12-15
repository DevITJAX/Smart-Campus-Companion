import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/quote_model.dart';

/// Remote data source for quotes using Dio
abstract class QuoteRemoteDataSource {
  /// Fetch quote of the day from REST API
  Future<QuoteModel> getQuoteOfTheDay();
}

/// Implementation using ZenQuotes API (free, no API key required)
class QuoteRemoteDataSourceImpl implements QuoteRemoteDataSource {
  final Dio dio;

  QuoteRemoteDataSourceImpl({required this.dio});

  @override
  Future<QuoteModel> getQuoteOfTheDay() async {
    try {
      // Using ZenQuotes API - free and no API key required
      // Documentation: https://zenquotes.io/
      final response = await dio.get(
        'https://zenquotes.io/api/today',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // ZenQuotes returns an array with one quote
        if (data is List && data.isNotEmpty) {
          return QuoteModel.fromJson(data[0] as Map<String, dynamic>);
        }
        
        throw const ServerException(
          message: 'Invalid response format from quotes API',
        );
      } else {
        throw ServerException(
          message: 'Failed to fetch quote: ${response.statusCode}',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: _mapDioError(e),
        code: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  /// Map Dio errors to user-friendly messages
  String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server took too long to respond.';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return e.message ?? 'Network error occurred.';
    }
  }
}
