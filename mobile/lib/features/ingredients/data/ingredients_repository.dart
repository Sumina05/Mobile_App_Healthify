import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/safe_api_call.dart';
import '../domain/ingredient.dart';

class IngredientsRepository {
  const IngredientsRepository(this._dio);

  final Dio _dio;

  Future<Ingredient> getById(String id) {
    return safeApiCall(() async {
      final response = await _dio
          .get<Map<String, dynamic>>('${ApiEndpoints.ingredients}/$id');
      return Ingredient.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    });
  }

  /// An empty [query] returns the browsable catalogue rather than nothing.
  Future<List<Ingredient>> search(String query) {
    return safeApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.ingredients,
        queryParameters: {'search': query},
      );
      return _itemsOf(response.data!);
    });
  }

  /// The same featured ingredient for everyone, rotating daily.
  Future<Ingredient?> ingredientOfTheDay() {
    return safeApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.ingredientOfTheDay,
      );
      final data = response.data!['data'];
      if (data == null) return null;
      return Ingredient.fromJson(data as Map<String, dynamic>);
    });
  }

  /// Ranked against the signed-in user's skin profile by the backend.
  Future<List<Ingredient>> recommended() {
    return safeApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.recommendedIngredients,
      );
      return _itemsOf(response.data!);
    });
  }

  List<Ingredient> _itemsOf(Map<String, dynamic> body) {
    final items = (body['data'] as Map<String, dynamic>)['items'] as List<dynamic>;
    return items
        .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

final ingredientsRepositoryProvider = Provider<IngredientsRepository>(
  (ref) => IngredientsRepository(ref.watch(dioProvider)),
);
