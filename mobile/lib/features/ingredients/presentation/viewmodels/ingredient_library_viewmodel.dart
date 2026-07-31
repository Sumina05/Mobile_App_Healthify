import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/ingredients_repository.dart';
import '../../domain/ingredient.dart';

part 'ingredient_library_viewmodel.freezed.dart';

@freezed
abstract class IngredientLibraryState with _$IngredientLibraryState {
  const factory IngredientLibraryState({
    Ingredient? ingredientOfTheDay,
    @Default(<Ingredient>[]) List<Ingredient> recommended,
    @Default(<Ingredient>[]) List<Ingredient> results,
    @Default('') String query,
    @Default(false) bool isSearching,
  }) = _IngredientLibraryState;

  const IngredientLibraryState._();

  /// The featured and recommended rails only make sense while browsing;
  /// once the user types, the screen is a pure result list.
  bool get showsDiscovery => query.isEmpty;
}

/// Backs the ingredient library: the daily feature, profile-ranked
/// recommendations, and debounced search across the ingredient database.
class IngredientLibraryViewModel extends AsyncNotifier<IngredientLibraryState> {
  static const Duration debounce = Duration(milliseconds: 300);

  Timer? _debounceTimer;

  @override
  Future<IngredientLibraryState> build() async {
    ref.onDispose(() => _debounceTimer?.cancel());
    return _load();
  }

  Future<IngredientLibraryState> _load() async {
    final repository = ref.read(ingredientsRepositoryProvider);
    final results = await Future.wait([
      repository.ingredientOfTheDay(),
      repository.recommended(),
      repository.search(''),
    ]);
    return IngredientLibraryState(
      ingredientOfTheDay: results[0] as Ingredient?,
      recommended: results[1] as List<Ingredient>,
      results: results[2] as List<Ingredient>,
    );
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  /// Debounced so typing does not fire a request per keystroke.
  void search(String query) {
    final trimmed = query.trim();
    final current = state.value;
    if (current == null) return;
    if (trimmed == current.query) return;

    state = AsyncData(current.copyWith(query: trimmed, isSearching: true));
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounce, () => runSearch(trimmed));
  }

  /// Performs the search immediately, bypassing the debounce.
  Future<void> runSearch(String query) async {
    final repository = ref.read(ingredientsRepositoryProvider);
    try {
      final results = await repository.search(query);
      final current = state.value;
      // A newer keystroke already superseded this request.
      if (current == null || current.query != query) return;
      state = AsyncData(
        current.copyWith(results: results, isSearching: false),
      );
    } catch (error, stackTrace) {
      final current = state.value;
      if (current == null || current.query != query) return;
      state = AsyncError(error, stackTrace);
    }
  }
}

final ingredientLibraryViewModelProvider =
    AsyncNotifierProvider<IngredientLibraryViewModel, IngredientLibraryState>(
  IngredientLibraryViewModel.new,
);
