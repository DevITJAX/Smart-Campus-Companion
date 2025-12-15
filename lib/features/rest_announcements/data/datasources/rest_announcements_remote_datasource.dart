import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/rest_announcement_model.dart';

/// Remote data source for fetching announcements via REST API.
/// 
/// This class handles all HTTP communication with the JSONPlaceholder API.
/// It uses Dio for making HTTP requests and handles various error scenarios.
abstract class RestAnnouncementsRemoteDataSource {
  /// Fetches all announcements from the REST API.
  /// 
  /// Throws [ServerException] if the request fails due to:
  /// - Client error (4xx status codes)
  /// - Server error (5xx status codes)
  /// - Network/connection issues
  /// - Timeout
  Future<List<RestAnnouncementModel>> getAnnouncements();
}

/// Implementation of [RestAnnouncementsRemoteDataSource] using Dio.
/// 
/// This implementation demonstrates proper REST API error handling
/// for academic evaluation purposes.
class RestAnnouncementsRemoteDataSourceImpl
    implements RestAnnouncementsRemoteDataSource {
  final Dio dio;

  /// Base URL for JSONPlaceholder API
  /// This is a free, public REST API for testing and prototyping.
  /// Documentation: https://jsonplaceholder.typicode.com/
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  RestAnnouncementsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<RestAnnouncementModel>> getAnnouncements() async {
    try {
      // ========================================
      // REST API CALL: GET /posts
      // ========================================
      // This demonstrates a standard GET request using async/await.
      // The Dio package handles HTTP communication and JSON parsing.
      
      final response = await dio.get(
        '$_baseUrl/posts',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          // Timeout configuration to prevent hanging requests
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      // ========================================
      // SUCCESS HANDLING (HTTP 200)
      // ========================================
      // On success, the API returns an array of post objects.
      // We parse each object into our data model.
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        
        // Convert each JSON object to our model
        // Limit to first 20 posts for better UX
        return data
            .take(20)
            .map((json) => RestAnnouncementModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      // ========================================
      // CLIENT ERROR HANDLING (4xx)
      // ========================================
      // 4xx errors indicate client-side issues:
      // - 400 Bad Request: Invalid request format
      // - 401 Unauthorized: Missing/invalid authentication
      // - 403 Forbidden: Access denied
      // - 404 Not Found: Resource doesn't exist
      
      if (response.statusCode != null && response.statusCode! >= 400 && response.statusCode! < 500) {
        throw ServerException(
          message: _getClientErrorMessage(response.statusCode!),
          code: response.statusCode,
        );
      }

      // ========================================
      // SERVER ERROR HANDLING (5xx)
      // ========================================
      // 5xx errors indicate server-side issues:
      // - 500 Internal Server Error
      // - 502 Bad Gateway
      // - 503 Service Unavailable
      // - 504 Gateway Timeout
      
      if (response.statusCode != null && response.statusCode! >= 500) {
        throw ServerException(
          message: 'Server error. Please try again later.',
          code: response.statusCode,
        );
      }

      // Unexpected status code
      throw ServerException(
        message: 'Unexpected response: ${response.statusCode}',
        code: response.statusCode,
      );
      
    } on DioException catch (e) {
      // ========================================
      // DIO EXCEPTION HANDLING
      // ========================================
      // Dio throws DioException for network-level errors:
      // - Connection timeout
      // - Send/receive timeout
      // - Connection errors (no internet)
      // - Bad response (non-2xx status already handled above)
      // - Request cancellation
      
      throw ServerException(
        message: _mapDioExceptionToMessage(e),
        code: e.response?.statusCode,
      );
    } catch (e) {
      // Re-throw ServerException as-is
      if (e is ServerException) rethrow;
      
      // Wrap any other exception
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  /// Maps DioException types to user-friendly error messages.
  /// 
  /// This provides clear feedback to users about what went wrong
  /// and potentially how to fix it.
  String _mapDioExceptionToMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        // The connection to the server took too long to establish
        return 'Connection timeout. Please check your internet connection.';
        
      case DioExceptionType.sendTimeout:
        // The request data took too long to send
        return 'Request timeout. Please try again.';
        
      case DioExceptionType.receiveTimeout:
        // The server took too long to respond
        return 'Server is taking too long to respond. Please try again.';
        
      case DioExceptionType.badResponse:
        // Server returned an error response (4xx/5xx)
        final statusCode = e.response?.statusCode;
        if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          return _getClientErrorMessage(statusCode);
        }
        return 'Server error: ${statusCode ?? 'unknown'}';
        
      case DioExceptionType.connectionError:
        // No internet connection or server unreachable
        return 'No internet connection. Please check your network.';
        
      case DioExceptionType.cancel:
        // Request was cancelled (rare in normal usage)
        return 'Request was cancelled.';
        
      case DioExceptionType.badCertificate:
        // SSL/TLS certificate issue
        return 'Security certificate error. Please try again.';
        
      case DioExceptionType.unknown:
        // Fallback for unknown errors
        return e.message ?? 'Network error occurred. Please try again';
    }
  }

  /// Returns user-friendly messages for HTTP 4xx client errors.
  String _getClientErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please try again.';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return 'Access forbidden.';
      case 404:
        return 'Announcements not found.';
      case 429:
        return 'Too many requests. Please wait and try again.';
      default:
        return 'Request failed (Error $statusCode).';
    }
  }
}
