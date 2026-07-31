import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Typed failures surfaced to ViewModels. Every repository catches raw
/// errors (Dio, platform, parsing) and rethrows one of these so the
/// presentation layer can map failures to loading/error/offline states.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  /// Maps a [DioException] to the matching domain failure.
  factory AppException.fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return TimeoutException(
          _withTarget('The request timed out. Please try again.', error),
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          _withTarget(
            'No internet connection. Please check your network.',
            error,
          ),
        );
      case DioExceptionType.cancel:
        return const RequestCancelledException();
      case DioExceptionType.badResponse:
        return _fromResponse(error);
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return UnknownException(error.message ?? 'Something went wrong.');
    }
  }

  /// In debug builds, names the host that could not be reached. "No internet
  /// connection" is indistinguishable from "wrong API base URL" without it,
  /// which is exactly the case a phone on a LAN hits.
  static String _withTarget(String message, DioException error) {
    if (!kDebugMode) return message;
    final uri = error.requestOptions.uri;
    if (uri.host.isEmpty) return message;
    return '$message\n\n(debug: could not reach ${uri.scheme}://${uri.authority})';
  }

  static AppException _fromResponse(DioException error) {
    final statusCode = error.response?.statusCode ?? 0;
    final data = error.response?.data;
    final message = data is Map<String, dynamic>
        ? (data['message'] as String? ?? 'Request failed.')
        : 'Request failed.';

    if (statusCode == 401) return UnauthorizedException(message);
    if (statusCode == 404) return NotFoundException(message);
    if (statusCode == 422 || statusCode == 400) {
      final errors = data is Map<String, dynamic>
          ? (data['errors'] as Map<String, dynamic>?)
          : null;
      return ValidationException(message, fieldErrors: errors);
    }
    return ServerException(message, statusCode: statusCode);
  }

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends AppException {
  const NetworkException([
    super.message = 'No internet connection. Please check your network.',
  ]);
}

class TimeoutException extends AppException {
  const TimeoutException([
    super.message = 'The request timed out. Please try again.',
  ]);
}

class ServerException extends AppException {
  const ServerException(super.message, {this.statusCode});

  final int? statusCode;
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Session expired.']);
}

/// The resource genuinely does not exist, as opposed to a server fault.
/// Callers branch on this — a scanned barcode with no match is an expected
/// outcome with its own screen, not an error.
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Not found.']);
}

class ValidationException extends AppException {
  const ValidationException(super.message, {this.fieldErrors});

  final Map<String, dynamic>? fieldErrors;
}

class RequestCancelledException extends AppException {
  const RequestCancelledException() : super('Request was cancelled.');
}

class CacheException extends AppException {
  const CacheException([super.message = 'Local data error.']);
}

class UnknownException extends AppException {
  const UnknownException([super.message = 'Something went wrong.']);
}
