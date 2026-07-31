// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnalysisSummary {

 String get id; String get productName; String? get brand; int get score; String get verdict; String get summary; List<String> get warnings; DateTime get createdAt;
/// Create a copy of AnalysisSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalysisSummaryCopyWith<AnalysisSummary> get copyWith => _$AnalysisSummaryCopyWithImpl<AnalysisSummary>(this as AnalysisSummary, _$identity);

  /// Serializes this AnalysisSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalysisSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.score, score) || other.score == score)&&(identical(other.verdict, verdict) || other.verdict == verdict)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.warnings, warnings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productName,brand,score,verdict,summary,const DeepCollectionEquality().hash(warnings),createdAt);

@override
String toString() {
  return 'AnalysisSummary(id: $id, productName: $productName, brand: $brand, score: $score, verdict: $verdict, summary: $summary, warnings: $warnings, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AnalysisSummaryCopyWith<$Res>  {
  factory $AnalysisSummaryCopyWith(AnalysisSummary value, $Res Function(AnalysisSummary) _then) = _$AnalysisSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String productName, String? brand, int score, String verdict, String summary, List<String> warnings, DateTime createdAt
});




}
/// @nodoc
class _$AnalysisSummaryCopyWithImpl<$Res>
    implements $AnalysisSummaryCopyWith<$Res> {
  _$AnalysisSummaryCopyWithImpl(this._self, this._then);

  final AnalysisSummary _self;
  final $Res Function(AnalysisSummary) _then;

/// Create a copy of AnalysisSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productName = null,Object? brand = freezed,Object? score = null,Object? verdict = null,Object? summary = null,Object? warnings = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalysisSummary].
extension AnalysisSummaryPatterns on AnalysisSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalysisSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalysisSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalysisSummary value)  $default,){
final _that = this;
switch (_that) {
case _AnalysisSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalysisSummary value)?  $default,){
final _that = this;
switch (_that) {
case _AnalysisSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String productName,  String? brand,  int score,  String verdict,  String summary,  List<String> warnings,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalysisSummary() when $default != null:
return $default(_that.id,_that.productName,_that.brand,_that.score,_that.verdict,_that.summary,_that.warnings,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String productName,  String? brand,  int score,  String verdict,  String summary,  List<String> warnings,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AnalysisSummary():
return $default(_that.id,_that.productName,_that.brand,_that.score,_that.verdict,_that.summary,_that.warnings,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String productName,  String? brand,  int score,  String verdict,  String summary,  List<String> warnings,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AnalysisSummary() when $default != null:
return $default(_that.id,_that.productName,_that.brand,_that.score,_that.verdict,_that.summary,_that.warnings,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalysisSummary implements AnalysisSummary {
  const _AnalysisSummary({required this.id, this.productName = 'Scanned product', this.brand, required this.score, required this.verdict, this.summary = '', final  List<String> warnings = const <String>[], required this.createdAt}): _warnings = warnings;
  factory _AnalysisSummary.fromJson(Map<String, dynamic> json) => _$AnalysisSummaryFromJson(json);

@override final  String id;
@override@JsonKey() final  String productName;
@override final  String? brand;
@override final  int score;
@override final  String verdict;
@override@JsonKey() final  String summary;
 final  List<String> _warnings;
@override@JsonKey() List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}

@override final  DateTime createdAt;

/// Create a copy of AnalysisSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalysisSummaryCopyWith<_AnalysisSummary> get copyWith => __$AnalysisSummaryCopyWithImpl<_AnalysisSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalysisSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalysisSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.score, score) || other.score == score)&&(identical(other.verdict, verdict) || other.verdict == verdict)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._warnings, _warnings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productName,brand,score,verdict,summary,const DeepCollectionEquality().hash(_warnings),createdAt);

@override
String toString() {
  return 'AnalysisSummary(id: $id, productName: $productName, brand: $brand, score: $score, verdict: $verdict, summary: $summary, warnings: $warnings, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AnalysisSummaryCopyWith<$Res> implements $AnalysisSummaryCopyWith<$Res> {
  factory _$AnalysisSummaryCopyWith(_AnalysisSummary value, $Res Function(_AnalysisSummary) _then) = __$AnalysisSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String productName, String? brand, int score, String verdict, String summary, List<String> warnings, DateTime createdAt
});




}
/// @nodoc
class __$AnalysisSummaryCopyWithImpl<$Res>
    implements _$AnalysisSummaryCopyWith<$Res> {
  __$AnalysisSummaryCopyWithImpl(this._self, this._then);

  final _AnalysisSummary _self;
  final $Res Function(_AnalysisSummary) _then;

/// Create a copy of AnalysisSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productName = null,Object? brand = freezed,Object? score = null,Object? verdict = null,Object? summary = null,Object? warnings = null,Object? createdAt = null,}) {
  return _then(_AnalysisSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
