import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/safe_api_call.dart';
import '../domain/product_analysis.dart';

class AnalysisRepository {
  const AnalysisRepository(this._dio);

  final Dio _dio;

  Future<ProductAnalysis> analyze({
    String? productName,
    String? brand,
    String? rawText,
    required List<String> ingredients,
  }) {
    return safeApiCall(() async {
      final name = (productName?.isEmpty ?? true) ? null : productName;
      final brandName = (brand?.isEmpty ?? true) ? null : brand;
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.analyze,
        data: {
          'productName': ?name,
          'brand': ?brandName,
          'rawText': ?rawText,
          'ingredients': ingredients,
        },
      );
      return ProductAnalysis.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    });
  }

  Future<ProductAnalysis> getById(String id) {
    return safeApiCall(() async {
      final response = await _dio
          .get<Map<String, dynamic>>('${ApiEndpoints.analyze}/$id');
      return ProductAnalysis.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    });
  }

  Future<ProductAnalysis> toggleFavorite(String id) {
    return safeApiCall(() async {
      final response = await _dio.patch<Map<String, dynamic>>(
        '${ApiEndpoints.analyze}/$id/favorite',
      );
      return ProductAnalysis.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    });
  }

  Future<ComparisonResult> compare(String idA, String idB) {
    return safeApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '${ApiEndpoints.analyze}/compare',
        data: {'analysisIdA': idA, 'analysisIdB': idB},
      );
      return ComparisonResult.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    });
  }
}

final analysisRepositoryProvider = Provider<AnalysisRepository>(
  (ref) => AnalysisRepository(ref.watch(dioProvider)),
);
