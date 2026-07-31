import 'package:dio/dio.dart';

import '../../storage/secure_storage_service.dart';
import '../api_endpoints.dart';

/// Transparent refresh-token rotation. QueuedInterceptor serializes error
/// handling, so concurrent 401s trigger exactly one refresh; queued
/// requests then retry with the new access token.
class RefreshInterceptor extends QueuedInterceptor {
  RefreshInterceptor(
    this._storage, {
    required this.baseUrl,
    required this.onSessionExpired,
  });

  final SecureStorageService _storage;

  /// Injected rather than read from [ApiEndpoints] so the refresh and retry
  /// clients always target the same origin as the main client.
  final String baseUrl;

  /// Notifies the app (auth controller) that re-login is required.
  final void Function() onSessionExpired;

  static const _retriedKey = 'refresh.retried';

  static const _publicPaths = {
    ApiEndpoints.register,
    ApiEndpoints.login,
    ApiEndpoints.refresh,
    ApiEndpoints.forgotPassword,
    ApiEndpoints.resetPassword,
    ApiEndpoints.health,
  };

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final isRefreshable = err.response?.statusCode == 401 &&
        !_publicPaths.contains(options.path) &&
        options.extra[_retriedKey] != true;

    if (!isRefreshable) {
      handler.next(err);
      return;
    }

    final refreshToken = await _storage.readRefreshToken();
    if (refreshToken == null) {
      onSessionExpired();
      handler.next(err);
      return;
    }

    try {
      // Bare client: no interceptors, so a failing refresh can't recurse.
      final response = await Dio(
        BaseOptions(baseUrl: baseUrl),
      ).post<Map<String, dynamic>>(
        ApiEndpoints.refresh,
        data: {'refreshToken': refreshToken},
      );
      final tokens =
          (response.data!['data'] as Map<String, dynamic>)['tokens']
              as Map<String, dynamic>;
      await _storage.saveSession(
        accessToken: tokens['accessToken'] as String,
        refreshToken: tokens['refreshToken'] as String,
      );

      final retryResponse = await Dio(
        BaseOptions(baseUrl: baseUrl),
      ).fetch<dynamic>(
        options
          ..headers['Authorization'] = 'Bearer ${tokens['accessToken']}'
          ..extra[_retriedKey] = true,
      );
      handler.resolve(retryResponse);
    } on DioException {
      await _storage.clearSession();
      onSessionExpired();
      handler.next(err);
    }
  }
}
