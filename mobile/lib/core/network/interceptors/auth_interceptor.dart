import 'package:dio/dio.dart';

import '../../storage/secure_storage_service.dart';

/// Attaches the bearer token to every request. 401 handling (refresh
/// rotation, session expiry) belongs to [RefreshInterceptor] — clearing
/// the session here would race it and break silent token renewal.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final SecureStorageService _storage;

  static const _publicPaths = {
    '/auth/register',
    '/auth/login',
    '/auth/refresh',
    '/auth/forgot-password',
    '/auth/reset-password',
    '/health',
  };

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_publicPaths.contains(options.path)) {
      final token = await _storage.readAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}
