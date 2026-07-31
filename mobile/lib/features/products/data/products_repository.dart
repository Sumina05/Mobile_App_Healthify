import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/safe_api_call.dart';
import '../domain/product.dart';

class ProductsRepository {
  const ProductsRepository(this._dio);

  final Dio _dio;

  /// Both filters are optional; omitting them browses the whole catalog.
  Future<ProductPage> fetch({
    String search = '',
    String category = '',
    int page = 1,
  }) {
    return safeApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.products,
        queryParameters: {
          if (search.isNotEmpty) 'search': search,
          if (category.isNotEmpty) 'category': category,
          'page': page,
        },
      );
      final body = response.data!;
      final data = body['data'] as Map<String, dynamic>;
      final meta = body['meta'] as Map<String, dynamic>? ?? const {};

      return ProductPage(
        items: (data['items'] as List<dynamic>)
            .map((e) => CatalogProduct.fromJson(e as Map<String, dynamic>))
            .toList(),
        categories: (data['categories'] as List<dynamic>? ?? const [])
            .map((e) => e as String)
            .toList(),
        page: (meta['page'] as num?)?.toInt() ?? page,
        totalPages: (meta['totalPages'] as num?)?.toInt() ?? 1,
        total: (meta['total'] as num?)?.toInt() ?? 0,
      );
    });
  }

  Future<List<CatalogProduct>> search(String query) async {
    final page = await fetch(search: query);
    return page.items;
  }

  /// Full detail for one product — what a search/catalogue [CatalogProduct]
  /// summary is missing (ingredients, description, safety band, benefits).
  /// Fetched when the product is actually opened, by the same [slug] every
  /// list item now carries.
  Future<ProductDetail> getDetail(String slug) {
    return safeApiCall(() async {
      final response = await _dio
          .get<Map<String, dynamic>>('${ApiEndpoints.products}/$slug');
      return ProductDetail.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    });
  }

  /// Resolves an EAN/UPC scanned by the camera. Throws [NotFoundException]
  /// when the code is unknown, which the UI turns into the OCR fallback.
  Future<BarcodeProduct> findByBarcode(String code) {
    return safeApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiEndpoints.products}/barcode/$code',
      );
      return BarcodeProduct.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    });
  }
}

final productsRepositoryProvider = Provider<ProductsRepository>(
  (ref) => ProductsRepository(ref.watch(dioProvider)),
);
