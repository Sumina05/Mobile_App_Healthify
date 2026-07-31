import 'package:freezed_annotation/freezed_annotation.dart';

import '../../auth/domain/entities/user.dart';
import '../../history/domain/analysis_summary.dart';
import '../../ingredients/domain/ingredient.dart';

part 'dashboard_data.freezed.dart';
part 'dashboard_data.g.dart';

@freezed
abstract class DailyInsight with _$DailyInsight {
  const factory DailyInsight({
    required String title,
    required String body,
    required String tag,
  }) = _DailyInsight;

  factory DailyInsight.fromJson(Map<String, dynamic> json) =>
      _$DailyInsightFromJson(json);
}

@freezed
abstract class WeeklyStats with _$WeeklyStats {
  const factory WeeklyStats({
    @Default(0) int scans,
    int? averageScore,
  }) = _WeeklyStats;

  factory WeeklyStats.fromJson(Map<String, dynamic> json) =>
      _$WeeklyStatsFromJson(json);
}

@freezed
abstract class DashboardData with _$DashboardData {
  const factory DashboardData({
    required User user,
    int? skinScore,
    required DailyInsight todayInsight,
    Ingredient? todayIngredient,
    @Default(<AnalysisSummary>[]) List<AnalysisSummary> recentAnalyses,
    @Default(<Ingredient>[]) List<Ingredient> recommendations,
    required WeeklyStats weeklyStats,
    @Default(0) int unreadNotifications,
  }) = _DashboardData;

  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);
}
