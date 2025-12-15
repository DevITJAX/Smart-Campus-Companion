import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../core/errors/exceptions.dart';
import '../models/quote_model.dart';

/// Local data source for quotes using SharedPreferences
abstract class QuoteLocalDataSource {
  /// Get cached quote
  Future<QuoteModel> getCachedQuote();

  /// Cache a quote
  Future<void> cacheQuote(QuoteModel quote);

  /// Check if cache is still valid (same day)
  Future<bool> isCacheValid();
}

/// Implementation using SharedPreferences for simple key-value storage
class QuoteLocalDataSourceImpl implements QuoteLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _cachedQuoteKey = 'CACHED_QUOTE';
  static const String _cacheDateKey = 'CACHED_QUOTE_DATE';

  QuoteLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<QuoteModel> getCachedQuote() async {
    final jsonString = sharedPreferences.getString(_cachedQuoteKey);
    
    if (jsonString == null) {
      throw const CacheException(
        message: 'No cached quote available',
        code: 1,
      );
    }

    try {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return QuoteModel.fromCacheJson(jsonMap);
    } catch (e) {
      throw CacheException(
        message: 'Failed to parse cached quote: $e',
        code: 2,
      );
    }
  }

  @override
  Future<void> cacheQuote(QuoteModel quote) async {
    try {
      final jsonString = json.encode(quote.toJson());
      await sharedPreferences.setString(_cachedQuoteKey, jsonString);
      
      // Store cache date
      final today = DateTime.now().toIso8601String().split('T')[0];
      await sharedPreferences.setString(_cacheDateKey, today);
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache quote: $e',
        code: 3,
      );
    }
  }

  @override
  Future<bool> isCacheValid() async {
    final cacheDate = sharedPreferences.getString(_cacheDateKey);
    if (cacheDate == null) return false;

    final today = DateTime.now().toIso8601String().split('T')[0];
    return cacheDate == today;
  }
}
