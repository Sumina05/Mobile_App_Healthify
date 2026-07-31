import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/network/safe_api_call.dart';
import '../domain/dashboard_data.dart';

class DashboardRepository {
  const DashboardRepository(this._dio);

  final Dio _dio;

  Future<DashboardData> fetch() {
    return safeApiCall(() async {
      final response =
          await _dio.get<Map<String, dynamic>>('/dashboard');
      return DashboardData.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    });
  }
}

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => DashboardRepository(ref.watch(dioProvider)),
);
