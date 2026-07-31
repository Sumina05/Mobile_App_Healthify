import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/safe_api_call.dart';
import '../domain/analysis_summary.dart';

class HistoryRepository {
  const HistoryRepository(this._dio);

  final Dio _dio;

  Future<List<AnalysisSummary>> fetchHistory({int page = 1}) {
    return safeApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.history,
        queryParameters: {'page': page},
      );
      final items = (response.data!['data']
          as Map<String, dynamic>)['items'] as List<dynamic>;
      return items
          .map((e) => AnalysisSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }
}

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HistoryRepository(ref.watch(dioProvider)),
);
