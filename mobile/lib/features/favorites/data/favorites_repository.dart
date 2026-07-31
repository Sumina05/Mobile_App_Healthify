import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/safe_api_call.dart';
import '../../ingredients/domain/ingredient.dart';

part 'favorites_repository.freezed.dart';

@freezed
abstract class FavoriteItem with _$FavoriteItem {
  const factory FavoriteItem({
    required String id,
    required Ingredient ingredient,
  }) = _FavoriteItem;
}

class FavoritesRepository {
  const FavoritesRepository(this._dio);

  final Dio _dio;

  Future<List<FavoriteItem>> fetchAll() {
    return safeApiCall(() async {
      final response =
          await _dio.get<Map<String, dynamic>>(ApiEndpoints.favorites);
      final items = (response.data!['data']
          as Map<String, dynamic>)['items'] as List<dynamic>;
      return items
          .whereType<Map<String, dynamic>>()
          .where((e) => e['ingredientId'] is Map<String, dynamic>)
          .map(
            (e) => FavoriteItem(
              id: e['id'] as String,
              ingredient: Ingredient.fromJson(
                e['ingredientId'] as Map<String, dynamic>,
              ),
            ),
          )
          .toList();
    });
  }

  Future<void> add(String ingredientId) {
    return safeApiCall(() async {
      await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.favorites,
        data: {'ingredientId': ingredientId},
      );
    });
  }

  Future<void> remove(String favoriteId) {
    return safeApiCall(() async {
      await _dio
          .delete<Map<String, dynamic>>('${ApiEndpoints.favorites}/$favoriteId');
    });
  }
}

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(ref.watch(dioProvider)),
);
