import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// A catalog product **summary** — what a list/search result carries. The
/// backend's list endpoint returns only a count of ingredients, never the
/// INCI list itself, so [slug] is what lets the detail sheet fetch the rest
/// via [ProductDetail] when the product is actually opened.
@freezed
abstract class CatalogProduct with _$CatalogProduct {
  const factory CatalogProduct({
    required String id,
    @Default('') String slug,
    required String name,
    required String brand,
    required String category,
  }) = _CatalogProduct;

  factory CatalogProduct.fromJson(Map<String, dynamic> json) =>
      _$CatalogProductFromJson(json);
}

/// Full catalogue detail — the complete record a [CatalogProduct] summary is
/// missing. One shape shared by every way of reaching a product (search,
/// category browse, barcode scan), matching the backend's single
/// `mapWebProductDetail` mapper, so no screen ever has to special-case which
/// entry point it came from.
@freezed
abstract class ProductDetail with _$ProductDetail {
  const factory ProductDetail({
    required String id,
    @Default('') String slug,
    required String name,
    required String brand,
    required String category,
    @Default('') String description,
    String? imageUrl,
    @Default(<String>[]) List<String> ingredientNames,
    int? safetyScore,
    String? safetyBand,
    @Default(<String>[]) List<String> suitableSkinTypes,
    @Default(<String>[]) List<String> benefits,
    @Default(<String>[]) List<String> sideEffects,
  }) = _ProductDetail;

  const ProductDetail._();

  factory ProductDetail.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailFromJson(json);

  /// A [CatalogProduct] summary is a strict subset of this, so a detail
  /// screen and a list tile can render from the same reference.
  CatalogProduct toSummary() => CatalogProduct(
        id: id,
        slug: slug,
        name: name,
        brand: brand,
        category: category,
      );
}

/// A barcode resolved by the backend, already carrying the same full detail
/// as [ProductDetail] — the web API's barcode and slug lookups return an
/// identical shape, so a scanned product needs no extra fetch before it can
/// be shown or analyzed.
@freezed
abstract class BarcodeProduct with _$BarcodeProduct {
  const factory BarcodeProduct({
    required String id,
    @Default('') String slug,
    required String barcode,
    required String name,
    required String brand,
    required String category,
    @Default('') String description,
    String? imageUrl,
    @Default(<String>[]) List<String> ingredientNames,
    int? safetyScore,
    String? safetyBand,
    @Default(<String>[]) List<String> suitableSkinTypes,
    @Default(<String>[]) List<String> benefits,
    @Default(<String>[]) List<String> sideEffects,

    /// 'catalog' for the curated catalogue, 'external' for Open Facts data,
    /// which is community-sourced and worth flagging in the UI.
    @Default('catalog') String source,
  }) = _BarcodeProduct;

  const BarcodeProduct._();

  factory BarcodeProduct.fromJson(Map<String, dynamic> json) =>
      _$BarcodeProductFromJson(json);

  bool get isCommunitySourced => source == 'external';

  /// Feeds the same product-detail sheet a search/catalogue hit does — the
  /// data is already complete, so this never triggers another fetch.
  ProductDetail toProductDetail() => ProductDetail(
        id: id,
        slug: slug,
        name: name,
        brand: brand,
        category: category,
        description: description,
        imageUrl: imageUrl,
        ingredientNames: ingredientNames,
        safetyScore: safetyScore,
        safetyBand: safetyBand,
        suitableSkinTypes: suitableSkinTypes,
        benefits: benefits,
        sideEffects: sideEffects,
      );
}

/// One page of catalog results plus the facets the backend reports alongside.
@freezed
abstract class ProductPage with _$ProductPage {
  const factory ProductPage({
    @Default(<CatalogProduct>[]) List<CatalogProduct> items,
    @Default(<String>[]) List<String> categories,
    @Default(1) int page,
    @Default(1) int totalPages,
    @Default(0) int total,
  }) = _ProductPage;

  const ProductPage._();

  bool get hasMore => page < totalPages;
}
