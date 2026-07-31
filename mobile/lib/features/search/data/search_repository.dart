import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ingredients/data/ingredients_repository.dart';
import '../../ingredients/domain/ingredient.dart';
import '../../products/data/products_repository.dart';
import '../../products/domain/product.dart';

class SearchResults {
  const SearchResults({required this.ingredients, required this.products});

  final List<Ingredient> ingredients;
  final List<CatalogProduct> products;

  bool get isEmpty => ingredients.isEmpty && products.isEmpty;
}

/// Fans one query out across the ingredient database and the product
/// catalog; each side owns its own repository.
class SearchRepository {
  const SearchRepository(this._ingredients, this._products);

  final IngredientsRepository _ingredients;
  final ProductsRepository _products;

  Future<SearchResults> search(String query) async {
    final results = await Future.wait([
      _ingredients.search(query),
      _products.search(query),
    ]);
    return SearchResults(
      ingredients: results[0] as List<Ingredient>,
      products: results[1] as List<CatalogProduct>,
    );
  }
}

final searchRepositoryProvider = Provider<SearchRepository>(
  (ref) => SearchRepository(
    ref.watch(ingredientsRepositoryProvider),
    ref.watch(productsRepositoryProvider),
  ),
);
