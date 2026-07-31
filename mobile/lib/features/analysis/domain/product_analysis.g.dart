// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BreakdownEntry _$BreakdownEntryFromJson(Map<String, dynamic> json) =>
    _BreakdownEntry(
      name: json['name'] as String,
      matched: json['matched'] as bool,
      status: json['status'] as String,
      reason: json['reason'] as String,
      ingredientId: json['ingredientId'] as String?,
    );

Map<String, dynamic> _$BreakdownEntryToJson(_BreakdownEntry instance) =>
    <String, dynamic>{
      'name': instance.name,
      'matched': instance.matched,
      'status': instance.status,
      'reason': instance.reason,
      'ingredientId': instance.ingredientId,
    };

_AlternativeProduct _$AlternativeProductFromJson(Map<String, dynamic> json) =>
    _AlternativeProduct(
      productId: json['productId'] as String?,
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String,
      matchPercent: (json['matchPercent'] as num).toInt(),
    );

Map<String, dynamic> _$AlternativeProductToJson(_AlternativeProduct instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'name': instance.name,
      'brand': instance.brand,
      'category': instance.category,
      'matchPercent': instance.matchPercent,
    };

_ProductAnalysis _$ProductAnalysisFromJson(
  Map<String, dynamic> json,
) => _ProductAnalysis(
  id: json['id'] as String,
  productName: json['productName'] as String? ?? 'Scanned product',
  brand: json['brand'] as String?,
  ingredientNames:
      (json['ingredientNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  score: (json['score'] as num).toInt(),
  verdict: json['verdict'] as String,
  safetyRating: json['safetyRating'] as String? ?? 'low_risk',
  summary: json['summary'] as String? ?? '',
  recommendationReason: json['recommendationReason'] as String? ?? '',
  aiExplanation: json['aiExplanation'] as String? ?? '',
  warnings:
      (json['warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  breakdown:
      (json['breakdown'] as List<dynamic>?)
          ?.map((e) => BreakdownEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <BreakdownEntry>[],
  alternatives:
      (json['alternatives'] as List<dynamic>?)
          ?.map((e) => AlternativeProduct.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AlternativeProduct>[],
  goodCount: (json['goodCount'] as num?)?.toInt() ?? 0,
  watchCount: (json['watchCount'] as num?)?.toInt() ?? 0,
  matchedCount: (json['matchedCount'] as num?)?.toInt() ?? 0,
  favorite: json['favorite'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ProductAnalysisToJson(_ProductAnalysis instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'brand': instance.brand,
      'ingredientNames': instance.ingredientNames,
      'score': instance.score,
      'verdict': instance.verdict,
      'safetyRating': instance.safetyRating,
      'summary': instance.summary,
      'recommendationReason': instance.recommendationReason,
      'aiExplanation': instance.aiExplanation,
      'warnings': instance.warnings,
      'breakdown': instance.breakdown,
      'alternatives': instance.alternatives,
      'goodCount': instance.goodCount,
      'watchCount': instance.watchCount,
      'matchedCount': instance.matchedCount,
      'favorite': instance.favorite,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_ComparisonResult _$ComparisonResultFromJson(Map<String, dynamic> json) =>
    _ComparisonResult(
      a: ProductAnalysis.fromJson(json['a'] as Map<String, dynamic>),
      b: ProductAnalysis.fromJson(json['b'] as Map<String, dynamic>),
      winner: json['winner'] as String?,
    );

Map<String, dynamic> _$ComparisonResultToJson(_ComparisonResult instance) =>
    <String, dynamic>{
      'a': instance.a,
      'b': instance.b,
      'winner': instance.winner,
    };
