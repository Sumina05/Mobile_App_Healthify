// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyInsight _$DailyInsightFromJson(Map<String, dynamic> json) =>
    _DailyInsight(
      title: json['title'] as String,
      body: json['body'] as String,
      tag: json['tag'] as String,
    );

Map<String, dynamic> _$DailyInsightToJson(_DailyInsight instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'tag': instance.tag,
    };

_WeeklyStats _$WeeklyStatsFromJson(Map<String, dynamic> json) => _WeeklyStats(
  scans: (json['scans'] as num?)?.toInt() ?? 0,
  averageScore: (json['averageScore'] as num?)?.toInt(),
);

Map<String, dynamic> _$WeeklyStatsToJson(_WeeklyStats instance) =>
    <String, dynamic>{
      'scans': instance.scans,
      'averageScore': instance.averageScore,
    };

_DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) =>
    _DashboardData(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      skinScore: (json['skinScore'] as num?)?.toInt(),
      todayInsight: DailyInsight.fromJson(
        json['todayInsight'] as Map<String, dynamic>,
      ),
      todayIngredient: json['todayIngredient'] == null
          ? null
          : Ingredient.fromJson(
              json['todayIngredient'] as Map<String, dynamic>,
            ),
      recentAnalyses:
          (json['recentAnalyses'] as List<dynamic>?)
              ?.map((e) => AnalysisSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AnalysisSummary>[],
      recommendations:
          (json['recommendations'] as List<dynamic>?)
              ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Ingredient>[],
      weeklyStats: WeeklyStats.fromJson(
        json['weeklyStats'] as Map<String, dynamic>,
      ),
      unreadNotifications: (json['unreadNotifications'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DashboardDataToJson(_DashboardData instance) =>
    <String, dynamic>{
      'user': instance.user,
      'skinScore': instance.skinScore,
      'todayInsight': instance.todayInsight,
      'todayIngredient': instance.todayIngredient,
      'recentAnalyses': instance.recentAnalyses,
      'recommendations': instance.recommendations,
      'weeklyStats': instance.weeklyStats,
      'unreadNotifications': instance.unreadNotifications,
    };
