// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CatalogProduct _$CatalogProductFromJson(Map<String, dynamic> json) =>
    _CatalogProduct(
      id: json['id'] as String,
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String,
    );

Map<String, dynamic> _$CatalogProductToJson(_CatalogProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'brand': instance.brand,
      'category': instance.category,
    };

_ProductDetail _$ProductDetailFromJson(Map<String, dynamic> json) =>
    _ProductDetail(
      id: json['id'] as String,
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      ingredientNames:
          (json['ingredientNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      safetyScore: (json['safetyScore'] as num?)?.toInt(),
      safetyBand: json['safetyBand'] as String?,
      suitableSkinTypes:
          (json['suitableSkinTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      benefits:
          (json['benefits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      sideEffects:
          (json['sideEffects'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$ProductDetailToJson(_ProductDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'brand': instance.brand,
      'category': instance.category,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'ingredientNames': instance.ingredientNames,
      'safetyScore': instance.safetyScore,
      'safetyBand': instance.safetyBand,
      'suitableSkinTypes': instance.suitableSkinTypes,
      'benefits': instance.benefits,
      'sideEffects': instance.sideEffects,
    };

_BarcodeProduct _$BarcodeProductFromJson(Map<String, dynamic> json) =>
    _BarcodeProduct(
      id: json['id'] as String,
      slug: json['slug'] as String? ?? '',
      barcode: json['barcode'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      ingredientNames:
          (json['ingredientNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      safetyScore: (json['safetyScore'] as num?)?.toInt(),
      safetyBand: json['safetyBand'] as String?,
      suitableSkinTypes:
          (json['suitableSkinTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      benefits:
          (json['benefits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      sideEffects:
          (json['sideEffects'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      source: json['source'] as String? ?? 'catalog',
    );

Map<String, dynamic> _$BarcodeProductToJson(_BarcodeProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'barcode': instance.barcode,
      'name': instance.name,
      'brand': instance.brand,
      'category': instance.category,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'ingredientNames': instance.ingredientNames,
      'safetyScore': instance.safetyScore,
      'safetyBand': instance.safetyBand,
      'suitableSkinTypes': instance.suitableSkinTypes,
      'benefits': instance.benefits,
      'sideEffects': instance.sideEffects,
      'source': instance.source,
    };
