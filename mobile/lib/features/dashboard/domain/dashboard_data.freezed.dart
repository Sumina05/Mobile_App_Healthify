// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyInsight {

 String get title; String get body; String get tag;
/// Create a copy of DailyInsight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyInsightCopyWith<DailyInsight> get copyWith => _$DailyInsightCopyWithImpl<DailyInsight>(this as DailyInsight, _$identity);

  /// Serializes this DailyInsight to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyInsight&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.tag, tag) || other.tag == tag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,body,tag);

@override
String toString() {
  return 'DailyInsight(title: $title, body: $body, tag: $tag)';
}


}

/// @nodoc
abstract mixin class $DailyInsightCopyWith<$Res>  {
  factory $DailyInsightCopyWith(DailyInsight value, $Res Function(DailyInsight) _then) = _$DailyInsightCopyWithImpl;
@useResult
$Res call({
 String title, String body, String tag
});




}
/// @nodoc
class _$DailyInsightCopyWithImpl<$Res>
    implements $DailyInsightCopyWith<$Res> {
  _$DailyInsightCopyWithImpl(this._self, this._then);

  final DailyInsight _self;
  final $Res Function(DailyInsight) _then;

/// Create a copy of DailyInsight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? body = null,Object? tag = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyInsight].
extension DailyInsightPatterns on DailyInsight {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyInsight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyInsight() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyInsight value)  $default,){
final _that = this;
switch (_that) {
case _DailyInsight():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyInsight value)?  $default,){
final _that = this;
switch (_that) {
case _DailyInsight() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String body,  String tag)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyInsight() when $default != null:
return $default(_that.title,_that.body,_that.tag);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String body,  String tag)  $default,) {final _that = this;
switch (_that) {
case _DailyInsight():
return $default(_that.title,_that.body,_that.tag);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String body,  String tag)?  $default,) {final _that = this;
switch (_that) {
case _DailyInsight() when $default != null:
return $default(_that.title,_that.body,_that.tag);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyInsight implements DailyInsight {
  const _DailyInsight({required this.title, required this.body, required this.tag});
  factory _DailyInsight.fromJson(Map<String, dynamic> json) => _$DailyInsightFromJson(json);

@override final  String title;
@override final  String body;
@override final  String tag;

/// Create a copy of DailyInsight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyInsightCopyWith<_DailyInsight> get copyWith => __$DailyInsightCopyWithImpl<_DailyInsight>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyInsightToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyInsight&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.tag, tag) || other.tag == tag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,body,tag);

@override
String toString() {
  return 'DailyInsight(title: $title, body: $body, tag: $tag)';
}


}

/// @nodoc
abstract mixin class _$DailyInsightCopyWith<$Res> implements $DailyInsightCopyWith<$Res> {
  factory _$DailyInsightCopyWith(_DailyInsight value, $Res Function(_DailyInsight) _then) = __$DailyInsightCopyWithImpl;
@override @useResult
$Res call({
 String title, String body, String tag
});




}
/// @nodoc
class __$DailyInsightCopyWithImpl<$Res>
    implements _$DailyInsightCopyWith<$Res> {
  __$DailyInsightCopyWithImpl(this._self, this._then);

  final _DailyInsight _self;
  final $Res Function(_DailyInsight) _then;

/// Create a copy of DailyInsight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? body = null,Object? tag = null,}) {
  return _then(_DailyInsight(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$WeeklyStats {

 int get scans; int? get averageScore;
/// Create a copy of WeeklyStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyStatsCopyWith<WeeklyStats> get copyWith => _$WeeklyStatsCopyWithImpl<WeeklyStats>(this as WeeklyStats, _$identity);

  /// Serializes this WeeklyStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyStats&&(identical(other.scans, scans) || other.scans == scans)&&(identical(other.averageScore, averageScore) || other.averageScore == averageScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scans,averageScore);

@override
String toString() {
  return 'WeeklyStats(scans: $scans, averageScore: $averageScore)';
}


}

/// @nodoc
abstract mixin class $WeeklyStatsCopyWith<$Res>  {
  factory $WeeklyStatsCopyWith(WeeklyStats value, $Res Function(WeeklyStats) _then) = _$WeeklyStatsCopyWithImpl;
@useResult
$Res call({
 int scans, int? averageScore
});




}
/// @nodoc
class _$WeeklyStatsCopyWithImpl<$Res>
    implements $WeeklyStatsCopyWith<$Res> {
  _$WeeklyStatsCopyWithImpl(this._self, this._then);

  final WeeklyStats _self;
  final $Res Function(WeeklyStats) _then;

/// Create a copy of WeeklyStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scans = null,Object? averageScore = freezed,}) {
  return _then(_self.copyWith(
scans: null == scans ? _self.scans : scans // ignore: cast_nullable_to_non_nullable
as int,averageScore: freezed == averageScore ? _self.averageScore : averageScore // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyStats].
extension WeeklyStatsPatterns on WeeklyStats {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyStats() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyStats value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyStats():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyStats value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyStats() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int scans,  int? averageScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyStats() when $default != null:
return $default(_that.scans,_that.averageScore);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int scans,  int? averageScore)  $default,) {final _that = this;
switch (_that) {
case _WeeklyStats():
return $default(_that.scans,_that.averageScore);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int scans,  int? averageScore)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyStats() when $default != null:
return $default(_that.scans,_that.averageScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeeklyStats implements WeeklyStats {
  const _WeeklyStats({this.scans = 0, this.averageScore});
  factory _WeeklyStats.fromJson(Map<String, dynamic> json) => _$WeeklyStatsFromJson(json);

@override@JsonKey() final  int scans;
@override final  int? averageScore;

/// Create a copy of WeeklyStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyStatsCopyWith<_WeeklyStats> get copyWith => __$WeeklyStatsCopyWithImpl<_WeeklyStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklyStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyStats&&(identical(other.scans, scans) || other.scans == scans)&&(identical(other.averageScore, averageScore) || other.averageScore == averageScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scans,averageScore);

@override
String toString() {
  return 'WeeklyStats(scans: $scans, averageScore: $averageScore)';
}


}

/// @nodoc
abstract mixin class _$WeeklyStatsCopyWith<$Res> implements $WeeklyStatsCopyWith<$Res> {
  factory _$WeeklyStatsCopyWith(_WeeklyStats value, $Res Function(_WeeklyStats) _then) = __$WeeklyStatsCopyWithImpl;
@override @useResult
$Res call({
 int scans, int? averageScore
});




}
/// @nodoc
class __$WeeklyStatsCopyWithImpl<$Res>
    implements _$WeeklyStatsCopyWith<$Res> {
  __$WeeklyStatsCopyWithImpl(this._self, this._then);

  final _WeeklyStats _self;
  final $Res Function(_WeeklyStats) _then;

/// Create a copy of WeeklyStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scans = null,Object? averageScore = freezed,}) {
  return _then(_WeeklyStats(
scans: null == scans ? _self.scans : scans // ignore: cast_nullable_to_non_nullable
as int,averageScore: freezed == averageScore ? _self.averageScore : averageScore // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$DashboardData {

 User get user; int? get skinScore; DailyInsight get todayInsight; Ingredient? get todayIngredient; List<AnalysisSummary> get recentAnalyses; List<Ingredient> get recommendations; WeeklyStats get weeklyStats; int get unreadNotifications;
/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardDataCopyWith<DashboardData> get copyWith => _$DashboardDataCopyWithImpl<DashboardData>(this as DashboardData, _$identity);

  /// Serializes this DashboardData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardData&&(identical(other.user, user) || other.user == user)&&(identical(other.skinScore, skinScore) || other.skinScore == skinScore)&&(identical(other.todayInsight, todayInsight) || other.todayInsight == todayInsight)&&(identical(other.todayIngredient, todayIngredient) || other.todayIngredient == todayIngredient)&&const DeepCollectionEquality().equals(other.recentAnalyses, recentAnalyses)&&const DeepCollectionEquality().equals(other.recommendations, recommendations)&&(identical(other.weeklyStats, weeklyStats) || other.weeklyStats == weeklyStats)&&(identical(other.unreadNotifications, unreadNotifications) || other.unreadNotifications == unreadNotifications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,skinScore,todayInsight,todayIngredient,const DeepCollectionEquality().hash(recentAnalyses),const DeepCollectionEquality().hash(recommendations),weeklyStats,unreadNotifications);

@override
String toString() {
  return 'DashboardData(user: $user, skinScore: $skinScore, todayInsight: $todayInsight, todayIngredient: $todayIngredient, recentAnalyses: $recentAnalyses, recommendations: $recommendations, weeklyStats: $weeklyStats, unreadNotifications: $unreadNotifications)';
}


}

/// @nodoc
abstract mixin class $DashboardDataCopyWith<$Res>  {
  factory $DashboardDataCopyWith(DashboardData value, $Res Function(DashboardData) _then) = _$DashboardDataCopyWithImpl;
@useResult
$Res call({
 User user, int? skinScore, DailyInsight todayInsight, Ingredient? todayIngredient, List<AnalysisSummary> recentAnalyses, List<Ingredient> recommendations, WeeklyStats weeklyStats, int unreadNotifications
});


$UserCopyWith<$Res> get user;$DailyInsightCopyWith<$Res> get todayInsight;$IngredientCopyWith<$Res>? get todayIngredient;$WeeklyStatsCopyWith<$Res> get weeklyStats;

}
/// @nodoc
class _$DashboardDataCopyWithImpl<$Res>
    implements $DashboardDataCopyWith<$Res> {
  _$DashboardDataCopyWithImpl(this._self, this._then);

  final DashboardData _self;
  final $Res Function(DashboardData) _then;

/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? skinScore = freezed,Object? todayInsight = null,Object? todayIngredient = freezed,Object? recentAnalyses = null,Object? recommendations = null,Object? weeklyStats = null,Object? unreadNotifications = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,skinScore: freezed == skinScore ? _self.skinScore : skinScore // ignore: cast_nullable_to_non_nullable
as int?,todayInsight: null == todayInsight ? _self.todayInsight : todayInsight // ignore: cast_nullable_to_non_nullable
as DailyInsight,todayIngredient: freezed == todayIngredient ? _self.todayIngredient : todayIngredient // ignore: cast_nullable_to_non_nullable
as Ingredient?,recentAnalyses: null == recentAnalyses ? _self.recentAnalyses : recentAnalyses // ignore: cast_nullable_to_non_nullable
as List<AnalysisSummary>,recommendations: null == recommendations ? _self.recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,weeklyStats: null == weeklyStats ? _self.weeklyStats : weeklyStats // ignore: cast_nullable_to_non_nullable
as WeeklyStats,unreadNotifications: null == unreadNotifications ? _self.unreadNotifications : unreadNotifications // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyInsightCopyWith<$Res> get todayInsight {
  
  return $DailyInsightCopyWith<$Res>(_self.todayInsight, (value) {
    return _then(_self.copyWith(todayInsight: value));
  });
}/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IngredientCopyWith<$Res>? get todayIngredient {
    if (_self.todayIngredient == null) {
    return null;
  }

  return $IngredientCopyWith<$Res>(_self.todayIngredient!, (value) {
    return _then(_self.copyWith(todayIngredient: value));
  });
}/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeeklyStatsCopyWith<$Res> get weeklyStats {
  
  return $WeeklyStatsCopyWith<$Res>(_self.weeklyStats, (value) {
    return _then(_self.copyWith(weeklyStats: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardData].
extension DashboardDataPatterns on DashboardData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardData value)  $default,){
final _that = this;
switch (_that) {
case _DashboardData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardData value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( User user,  int? skinScore,  DailyInsight todayInsight,  Ingredient? todayIngredient,  List<AnalysisSummary> recentAnalyses,  List<Ingredient> recommendations,  WeeklyStats weeklyStats,  int unreadNotifications)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
return $default(_that.user,_that.skinScore,_that.todayInsight,_that.todayIngredient,_that.recentAnalyses,_that.recommendations,_that.weeklyStats,_that.unreadNotifications);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( User user,  int? skinScore,  DailyInsight todayInsight,  Ingredient? todayIngredient,  List<AnalysisSummary> recentAnalyses,  List<Ingredient> recommendations,  WeeklyStats weeklyStats,  int unreadNotifications)  $default,) {final _that = this;
switch (_that) {
case _DashboardData():
return $default(_that.user,_that.skinScore,_that.todayInsight,_that.todayIngredient,_that.recentAnalyses,_that.recommendations,_that.weeklyStats,_that.unreadNotifications);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( User user,  int? skinScore,  DailyInsight todayInsight,  Ingredient? todayIngredient,  List<AnalysisSummary> recentAnalyses,  List<Ingredient> recommendations,  WeeklyStats weeklyStats,  int unreadNotifications)?  $default,) {final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
return $default(_that.user,_that.skinScore,_that.todayInsight,_that.todayIngredient,_that.recentAnalyses,_that.recommendations,_that.weeklyStats,_that.unreadNotifications);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardData implements DashboardData {
  const _DashboardData({required this.user, this.skinScore, required this.todayInsight, this.todayIngredient, final  List<AnalysisSummary> recentAnalyses = const <AnalysisSummary>[], final  List<Ingredient> recommendations = const <Ingredient>[], required this.weeklyStats, this.unreadNotifications = 0}): _recentAnalyses = recentAnalyses,_recommendations = recommendations;
  factory _DashboardData.fromJson(Map<String, dynamic> json) => _$DashboardDataFromJson(json);

@override final  User user;
@override final  int? skinScore;
@override final  DailyInsight todayInsight;
@override final  Ingredient? todayIngredient;
 final  List<AnalysisSummary> _recentAnalyses;
@override@JsonKey() List<AnalysisSummary> get recentAnalyses {
  if (_recentAnalyses is EqualUnmodifiableListView) return _recentAnalyses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentAnalyses);
}

 final  List<Ingredient> _recommendations;
@override@JsonKey() List<Ingredient> get recommendations {
  if (_recommendations is EqualUnmodifiableListView) return _recommendations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommendations);
}

@override final  WeeklyStats weeklyStats;
@override@JsonKey() final  int unreadNotifications;

/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardDataCopyWith<_DashboardData> get copyWith => __$DashboardDataCopyWithImpl<_DashboardData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardData&&(identical(other.user, user) || other.user == user)&&(identical(other.skinScore, skinScore) || other.skinScore == skinScore)&&(identical(other.todayInsight, todayInsight) || other.todayInsight == todayInsight)&&(identical(other.todayIngredient, todayIngredient) || other.todayIngredient == todayIngredient)&&const DeepCollectionEquality().equals(other._recentAnalyses, _recentAnalyses)&&const DeepCollectionEquality().equals(other._recommendations, _recommendations)&&(identical(other.weeklyStats, weeklyStats) || other.weeklyStats == weeklyStats)&&(identical(other.unreadNotifications, unreadNotifications) || other.unreadNotifications == unreadNotifications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,skinScore,todayInsight,todayIngredient,const DeepCollectionEquality().hash(_recentAnalyses),const DeepCollectionEquality().hash(_recommendations),weeklyStats,unreadNotifications);

@override
String toString() {
  return 'DashboardData(user: $user, skinScore: $skinScore, todayInsight: $todayInsight, todayIngredient: $todayIngredient, recentAnalyses: $recentAnalyses, recommendations: $recommendations, weeklyStats: $weeklyStats, unreadNotifications: $unreadNotifications)';
}


}

/// @nodoc
abstract mixin class _$DashboardDataCopyWith<$Res> implements $DashboardDataCopyWith<$Res> {
  factory _$DashboardDataCopyWith(_DashboardData value, $Res Function(_DashboardData) _then) = __$DashboardDataCopyWithImpl;
@override @useResult
$Res call({
 User user, int? skinScore, DailyInsight todayInsight, Ingredient? todayIngredient, List<AnalysisSummary> recentAnalyses, List<Ingredient> recommendations, WeeklyStats weeklyStats, int unreadNotifications
});


@override $UserCopyWith<$Res> get user;@override $DailyInsightCopyWith<$Res> get todayInsight;@override $IngredientCopyWith<$Res>? get todayIngredient;@override $WeeklyStatsCopyWith<$Res> get weeklyStats;

}
/// @nodoc
class __$DashboardDataCopyWithImpl<$Res>
    implements _$DashboardDataCopyWith<$Res> {
  __$DashboardDataCopyWithImpl(this._self, this._then);

  final _DashboardData _self;
  final $Res Function(_DashboardData) _then;

/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? skinScore = freezed,Object? todayInsight = null,Object? todayIngredient = freezed,Object? recentAnalyses = null,Object? recommendations = null,Object? weeklyStats = null,Object? unreadNotifications = null,}) {
  return _then(_DashboardData(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,skinScore: freezed == skinScore ? _self.skinScore : skinScore // ignore: cast_nullable_to_non_nullable
as int?,todayInsight: null == todayInsight ? _self.todayInsight : todayInsight // ignore: cast_nullable_to_non_nullable
as DailyInsight,todayIngredient: freezed == todayIngredient ? _self.todayIngredient : todayIngredient // ignore: cast_nullable_to_non_nullable
as Ingredient?,recentAnalyses: null == recentAnalyses ? _self._recentAnalyses : recentAnalyses // ignore: cast_nullable_to_non_nullable
as List<AnalysisSummary>,recommendations: null == recommendations ? _self._recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,weeklyStats: null == weeklyStats ? _self.weeklyStats : weeklyStats // ignore: cast_nullable_to_non_nullable
as WeeklyStats,unreadNotifications: null == unreadNotifications ? _self.unreadNotifications : unreadNotifications // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyInsightCopyWith<$Res> get todayInsight {
  
  return $DailyInsightCopyWith<$Res>(_self.todayInsight, (value) {
    return _then(_self.copyWith(todayInsight: value));
  });
}/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IngredientCopyWith<$Res>? get todayIngredient {
    if (_self.todayIngredient == null) {
    return null;
  }

  return $IngredientCopyWith<$Res>(_self.todayIngredient!, (value) {
    return _then(_self.copyWith(todayIngredient: value));
  });
}/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeeklyStatsCopyWith<$Res> get weeklyStats {
  
  return $WeeklyStatsCopyWith<$Res>(_self.weeklyStats, (value) {
    return _then(_self.copyWith(weeklyStats: value));
  });
}
}

// dart format on
