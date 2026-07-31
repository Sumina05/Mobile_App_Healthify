import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/favorites_repository.dart';

class FavoritesViewModel extends AsyncNotifier<List<FavoriteItem>> {
  @override
  Future<List<FavoriteItem>> build() =>
      ref.watch(favoritesRepositoryProvider).fetchAll();

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(favoritesRepositoryProvider).fetchAll(),
    );
  }

  /// Optimistic removal with rollback on failure.
  Future<void> remove(FavoriteItem item) async {
    final previous = state.value ?? [];
    state = AsyncData(
      previous.where((f) => f.id != item.id).toList(),
    );
    try {
      await ref.read(favoritesRepositoryProvider).remove(item.id);
    } catch (_) {
      state = AsyncData(previous);
      rethrow;
    }
  }

  /// Adds an ingredient to favorites, then reloads to pick up the id.
  Future<void> addIngredient(String ingredientId) async {
    await ref.read(favoritesRepositoryProvider).add(ingredientId);
    await refresh();
  }

  bool isFavorite(String ingredientId) =>
      (state.value ?? []).any((f) => f.ingredient.id == ingredientId);
}

final favoritesViewModelProvider =
    AsyncNotifierProvider<FavoritesViewModel, List<FavoriteItem>>(
  FavoritesViewModel.new,
);
