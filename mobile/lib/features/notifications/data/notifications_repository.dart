import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/network/safe_api_call.dart';
import '../domain/app_notification.dart';

class NotificationsRepository {
  const NotificationsRepository(this._dio);

  final Dio _dio;

  Future<({List<AppNotification> items, int unread})> fetchAll() {
    return safeApiCall(() async {
      final response =
          await _dio.get<Map<String, dynamic>>('/notifications');
      final data = response.data!['data'] as Map<String, dynamic>;
      return (
        items: (data['items'] as List<dynamic>)
            .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
            .toList(),
        unread: data['unread'] as int? ?? 0,
      );
    });
  }

  Future<void> markRead(String id) {
    return safeApiCall(() async {
      await _dio.patch<Map<String, dynamic>>('/notifications/$id/read');
    });
  }

  Future<void> markAllRead() {
    return safeApiCall(() async {
      await _dio.post<Map<String, dynamic>>('/notifications/read-all');
    });
  }
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepository(ref.watch(dioProvider)),
);
