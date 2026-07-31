import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/products_repository.dart';
import '../../domain/product.dart';

/// Full detail for one product, keyed by slug. A search or catalogue result
/// only ever carries a summary — this is what the detail sheet watches to
/// fill in ingredients, description, safety band and benefits once the
/// product is actually opened.
final productDetailProvider =
    FutureProvider.family<ProductDetail, String>((ref, slug) {
  return ref.read(productsRepositoryProvider).getDetail(slug);
});
