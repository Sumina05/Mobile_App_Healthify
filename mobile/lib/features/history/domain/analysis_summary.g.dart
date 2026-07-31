// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnalysisSummary _$AnalysisSummaryFromJson(Map<String, dynamic> json) =>
    _AnalysisSummary(
      id: json['id'] as String,
      productName: json['productName'] as String? ?? 'Scanned product',
      brand: json['brand'] as String?,
      score: (json['score'] as num).toInt(),
      verdict: json['verdict'] as String,
      summary: json['summary'] as String? ?? '',
      warnings:
          (json['warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AnalysisSummaryToJson(_AnalysisSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'brand': instance.brand,
      'score': instance.score,
      'verdict': instance.verdict,
      'summary': instance.summary,
      'warnings': instance.warnings,
      'createdAt': instance.createdAt.toIso8601String(),
    };
