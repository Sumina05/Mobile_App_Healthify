import 'package:freezed_annotation/freezed_annotation.dart';

part 'analysis_summary.freezed.dart';
part 'analysis_summary.g.dart';

@freezed
abstract class AnalysisSummary with _$AnalysisSummary {
  const factory AnalysisSummary({
    required String id,
    @Default('Scanned product') String productName,
    String? brand,
    required int score,
    required String verdict,
    @Default('') String summary,
    @Default(<String>[]) List<String> warnings,
    required DateTime createdAt,
  }) = _AnalysisSummary;

  factory AnalysisSummary.fromJson(Map<String, dynamic> json) =>
      _$AnalysisSummaryFromJson(json);
}
