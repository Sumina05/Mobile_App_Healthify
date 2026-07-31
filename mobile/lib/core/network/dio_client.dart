import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/app_providers.dart';
import '../services/session_events.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/refresh_interceptor.dart';

/// Configured HTTP client shared by all remote data sources.
final dioProvider = Provider<Dio>((ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  final storage = ref.watch(secureStorageProvider);
  dio.interceptors.addAll([
    AuthInterceptor(storage),
    RefreshInterceptor(
      storage,
      baseUrl: baseUrl,
      onSessionExpired: () => ref.read(sessionEventsProvider).expired(),
    ),
    if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
  ]);
  return dio;
});
