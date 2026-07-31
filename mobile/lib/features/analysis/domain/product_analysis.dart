import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_analysis.freezed.dart';
part 'product_analysis.g.dart';

@freezed
abstract class BreakdownEntry with _$BreakdownEntry {
  const factory BreakdownEntry({
    required String name,
    required bool matched,
    required String status,
    required String reason,
    String? ingredientId,
  }) = _BreakdownEntry;

  factory BreakdownEntry.fromJson(Map<String, dynamic> json) =>
      _$BreakdownEntryFromJson(json);
}

@freezed
abstract class AlternativeProduct with _$AlternativeProduct {
  const factory AlternativeProduct({
    String? productId,
    required String name,
    required String brand,
    required String category,
    required int matchPercent,
  }) = _AlternativeProduct;

  factory AlternativeProduct.fromJson(Map<String, dynamic> json) =>
      _$AlternativeProductFromJson(json);
}

@freezed
abstract class ProductAnalysis with _$ProductAnalysis {
  const factory ProductAnalysis({
    required String id,
    @Default('Scanned product') String productName,
    String? brand,
    @Default(<String>[]) List<String> ingredientNames,
    required int score,
    required String verdict,
    @Default('low_risk') String safetyRating,
    @Default('') String summary,
    @Default('') String recommendationReason,
    @Default('') String aiExplanation,
    @Default(<String>[]) List<String> warnings,
    @Default(<BreakdownEntry>[]) List<BreakdownEntry> breakdown,
    @Default(<AlternativeProduct>[]) List<AlternativeProduct> alternatives,
    @Default(0) int goodCount,
    @Default(0) int watchCount,
    @Default(0) int matchedCount,
    @Default(false) bool favorite,
    required DateTime createdAt,
  }) = _ProductAnalysis;

  factory ProductAnalysis.fromJson(Map<String, dynamic> json) =>
      _$ProductAnalysisFromJson(json);
}

@freezed
abstract class ComparisonResult with _$ComparisonResult {
  const factory ComparisonResult({
    required ProductAnalysis a,
    required ProductAnalysis b,
    String? winner,
  }) = _ComparisonResult;

  factory ComparisonResult.fromJson(Map<String, dynamic> json) =>
      _$ComparisonResultFromJson(json);
}
