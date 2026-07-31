import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/products_repository.dart';
import '../../domain/product.dart';

part 'product_catalog_viewmodel.freezed.dart';

@freezed
abstract class ProductCatalogState with _$ProductCatalogState {
  const factory ProductCatalogState({
    @Default(<CatalogProduct>[]) List<CatalogProduct> products,
    @Default(<String>[]) List<String> categories,
    @Default('') String query,
    @Default('') String category,
    @Default(1) int page,
    @Default(1) int totalPages,
    @Default(0) int total,
    @Default(false) bool isSearching,
    @Default(false) bool isLoadingMore,
  }) = _ProductCatalogState;

  const ProductCatalogState._();

  bool get hasMore => page < totalPages;
  bool get hasFilters => query.isNotEmpty || category.isNotEmpty;
}

/// Backs the product catalog: debounced search, category facet filtering
/// and append-style pagination.
class ProductCatalogViewModel extends AsyncNotifier<ProductCatalogState> {
  static const Duration debounce = Duration(milliseconds: 300);

  Timer? _debounceTimer;

  @override
  Future<ProductCatalogState> build() async {
    ref.onDispose(() => _debounceTimer?.cancel());
    return _fetch(const ProductCatalogState());
  }

  /// Loads page 1 for the filters carried by [base] and merges the result in.
  Future<ProductCatalogState> _fetch(ProductCatalogState base) async {
    final page = await ref.read(productsRepositoryProvider).fetch(
          search: base.query,
          category: base.category,
        );
    return base.copyWith(
      products: page.items,
      // The backend reports the full category list only when unfiltered, so
      // keep the facets we already know rather than blanking the filter bar.
      categories: page.categories.isNotEmpty ? page.categories : base.categories,
      page: page.page,
      totalPages: page.totalPages,
      total: page.total,
      isSearching: false,
      isLoadingMore: false,
    );
  }

  Future<void> refresh() async {
    final current = state.value ?? const ProductCatalogState();
    state = await AsyncValue.guard(() => _fetch(current));
  }

  /// Debounced so typing does not fire a request per keystroke.
  void search(String query) {
    final trimmed = query.trim();
    final current = state.value;
    if (current == null || trimmed == current.query) return;

    state = AsyncData(current.copyWith(query: trimmed, isSearching: true));
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounce, () => _applyFilters(query: trimmed));
  }

  /// Selecting the active category clears it, so chips toggle.
  Future<void> selectCategory(String category) async {
    final current = state.value;
    if (current == null) return;
    final next = current.category == category ? '' : category;

    _debounceTimer?.cancel();
    state = AsyncData(current.copyWith(category: next, isSearching: true));
    await _applyFilters(category: next);
  }

  Future<void> _applyFilters({String? query, String? category}) async {
    final current = state.value;
    if (current == null) return;
    try {
      final next = await _fetch(current);
      final latest = state.value;
      // A newer keystroke or chip tap already superseded this request.
      if (latest == null) return;
      if (query != null && latest.query != query) return;
      if (category != null && latest.category != category) return;
      state = AsyncData(next);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  /// Appends the next page; a no-op while one is already in flight.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final next = await ref.read(productsRepositoryProvider).fetch(
            search: current.query,
            category: current.category,
            page: current.page + 1,
          );
      final latest = state.value;
      // Filters changed while the page was loading; drop the stale results.
      if (latest == null ||
          latest.query != current.query ||
          latest.category != current.category) {
        return;
      }
      state = AsyncData(
        latest.copyWith(
          products: [...latest.products, ...next.items],
          page: next.page,
          totalPages: next.totalPages,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      final latest = state.value;
      if (latest != null) {
        state = AsyncData(latest.copyWith(isLoadingMore: false));
      }
      rethrow;
    }
  }
}

final productCatalogViewModelProvider =
    AsyncNotifierProvider<ProductCatalogViewModel, ProductCatalogState>(
  ProductCatalogViewModel.new,
);
