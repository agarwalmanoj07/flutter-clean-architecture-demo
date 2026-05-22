import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;

  static AppException fromDio(DioException exception) {
    // First handle HTTP response codes
    final statusCode = exception.response?.statusCode;

    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return AppException('Invalid request.');

        case 401:
          return AppException('Please login again.');

        case 403:
          return AppException('Access denied.');

        case 404:
          return AppException('Data not found.');

        case 500:
          return AppException('Server error.');
      }
    }

    // Then handle network issues
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return AppException('Connection timed out.');

      case DioExceptionType.receiveTimeout:
        return AppException('Server is taking too long to respond.');

      case DioExceptionType.connectionError:
        return AppException('Please check your internet connection.');

      case DioExceptionType.cancel:
        return AppException('Request cancelled.');

      default:
        return AppException('Something went wrong.');
    }
  }
}
