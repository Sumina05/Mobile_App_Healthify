import 'package:dio/dio.dart';

import '../error/app_exception.dart';

/// Wraps a remote call so repositories always surface [AppException]s.
Future<T> safeApiCall<T>(Future<T> Function() run) async {
  try {
    return await run();
  } on DioException catch (error) {
    throw AppException.fromDio(error);
  }
}
