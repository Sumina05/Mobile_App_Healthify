// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BreakdownEntry {

 String get name; bool get matched; String get status; String get reason; String? get ingredientId;
/// Create a copy of BreakdownEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreakdownEntryCopyWith<BreakdownEntry> get copyWith => _$BreakdownEntryCopyWithImpl<BreakdownEntry>(this as BreakdownEntry, _$identity);

  /// Serializes this BreakdownEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreakdownEntry&&(identical(other.name, name) || other.name == name)&&(identical(other.matched, matched) || other.matched == matched)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.ingredientId, ingredientId) || other.ingredientId == ingredientId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,matched,status,reason,ingredientId);

@override
String toString() {
  return 'BreakdownEntry(name: $name, matched: $matched, status: $status, reason: $reason, ingredientId: $ingredientId)';
}


}

/// @nodoc
abstract mixin class $BreakdownEntryCopyWith<$Res>  {
  factory $BreakdownEntryCopyWith(BreakdownEntry value, $Res Function(BreakdownEntry) _then) = _$BreakdownEntryCopyWithImpl;
@useResult
$Res call({
 String name, bool matched, String status, String reason, String? ingredientId
});




}
/// @nodoc
class _$BreakdownEntryCopyWithImpl<$Res>
    implements $BreakdownEntryCopyWith<$Res> {
  _$BreakdownEntryCopyWithImpl(this._self, this._then);

  final BreakdownEntry _self;
  final $Res Function(BreakdownEntry) _then;

/// Create a copy of BreakdownEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? matched = null,Object? status = null,Object? reason = null,Object? ingredientId = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,matched: null == matched ? _self.matched : matched // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,ingredientId: freezed == ingredientId ? _self.ingredientId : ingredientId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BreakdownEntry].
extension BreakdownEntryPatterns on BreakdownEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BreakdownEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BreakdownEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BreakdownEntry value)  $default,){
final _that = this;
switch (_that) {
case _BreakdownEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BreakdownEntry value)?  $default,){
final _that = this;
switch (_that) {
case _BreakdownEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  bool matched,  String status,  String reason,  String? ingredientId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BreakdownEntry() when $default != null:
return $default(_that.name,_that.matched,_that.status,_that.reason,_that.ingredientId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  bool matched,  String status,  String reason,  String? ingredientId)  $default,) {final _that = this;
switch (_that) {
case _BreakdownEntry():
return $default(_that.name,_that.matched,_that.status,_that.reason,_that.ingredientId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  bool matched,  String status,  String reason,  String? ingredientId)?  $default,) {final _that = this;
switch (_that) {
case _BreakdownEntry() when $default != null:
return $default(_that.name,_that.matched,_that.status,_that.reason,_that.ingredientId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BreakdownEntry implements BreakdownEntry {
  const _BreakdownEntry({required this.name, required this.matched, required this.status, required this.reason, this.ingredientId});
  factory _BreakdownEntry.fromJson(Map<String, dynamic> json) => _$BreakdownEntryFromJson(json);

@override final  String name;
@override final  bool matched;
@override final  String status;
@override final  String reason;
@override final  String? ingredientId;

/// Create a copy of BreakdownEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreakdownEntryCopyWith<_BreakdownEntry> get copyWith => __$BreakdownEntryCopyWithImpl<_BreakdownEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BreakdownEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreakdownEntry&&(identical(other.name, name) || other.name == name)&&(identical(other.matched, matched) || other.matched == matched)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.ingredientId, ingredientId) || other.ingredientId == ingredientId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,matched,status,reason,ingredientId);

@override
String toString() {
  return 'BreakdownEntry(name: $name, matched: $matched, status: $status, reason: $reason, ingredientId: $ingredientId)';
}


}

/// @nodoc
abstract mixin class _$BreakdownEntryCopyWith<$Res> implements $BreakdownEntryCopyWith<$Res> {
  factory _$BreakdownEntryCopyWith(_BreakdownEntry value, $Res Function(_BreakdownEntry) _then) = __$BreakdownEntryCopyWithImpl;
@override @useResult
$Res call({
 String name, bool matched, String status, String reason, String? ingredientId
});




}
/// @nodoc
class __$BreakdownEntryCopyWithImpl<$Res>
    implements _$BreakdownEntryCopyWith<$Res> {
  __$BreakdownEntryCopyWithImpl(this._self, this._then);

  final _BreakdownEntry _self;
  final $Res Function(_BreakdownEntry) _then;

/// Create a copy of BreakdownEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? matched = null,Object? status = null,Object? reason = null,Object? ingredientId = freezed,}) {
  return _then(_BreakdownEntry(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,matched: null == matched ? _self.matched : matched // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,ingredientId: freezed == ingredientId ? _self.ingredientId : ingredientId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AlternativeProduct {

 String? get productId; String get name; String get brand; String get category; int get matchPercent;
/// Create a copy of AlternativeProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlternativeProductCopyWith<AlternativeProduct> get copyWith => _$AlternativeProductCopyWithImpl<AlternativeProduct>(this as AlternativeProduct, _$identity);

  /// Serializes this AlternativeProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlternativeProduct&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&(identical(other.matchPercent, matchPercent) || other.matchPercent == matchPercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,name,brand,category,matchPercent);

@override
String toString() {
  return 'AlternativeProduct(productId: $productId, name: $name, brand: $brand, category: $category, matchPercent: $matchPercent)';
}


}

/// @nodoc
abstract mixin class $AlternativeProductCopyWith<$Res>  {
  factory $AlternativeProductCopyWith(AlternativeProduct value, $Res Function(AlternativeProduct) _then) = _$AlternativeProductCopyWithImpl;
@useResult
$Res call({
 String? productId, String name, String brand, String category, int matchPercent
});




}
/// @nodoc
class _$AlternativeProductCopyWithImpl<$Res>
    implements $AlternativeProductCopyWith<$Res> {
  _$AlternativeProductCopyWithImpl(this._self, this._then);

  final AlternativeProduct _self;
  final $Res Function(AlternativeProduct) _then;

/// Create a copy of AlternativeProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = freezed,Object? name = null,Object? brand = null,Object? category = null,Object? matchPercent = null,}) {
  return _then(_self.copyWith(
productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,matchPercent: null == matchPercent ? _self.matchPercent : matchPercent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AlternativeProduct].
extension AlternativeProductPatterns on AlternativeProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlternativeProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlternativeProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlternativeProduct value)  $default,){
final _that = this;
switch (_that) {
case _AlternativeProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlternativeProduct value)?  $default,){
final _that = this;
switch (_that) {
case _AlternativeProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? productId,  String name,  String brand,  String category,  int matchPercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlternativeProduct() when $default != null:
return $default(_that.productId,_that.name,_that.brand,_that.category,_that.matchPercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? productId,  String name,  String brand,  String category,  int matchPercent)  $default,) {final _that = this;
switch (_that) {
case _AlternativeProduct():
return $default(_that.productId,_that.name,_that.brand,_that.category,_that.matchPercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? productId,  String name,  String brand,  String category,  int matchPercent)?  $default,) {final _that = this;
switch (_that) {
case _AlternativeProduct() when $default != null:
return $default(_that.productId,_that.name,_that.brand,_that.category,_that.matchPercent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlternativeProduct implements AlternativeProduct {
  const _AlternativeProduct({this.productId, required this.name, required this.brand, required this.category, required this.matchPercent});
  factory _AlternativeProduct.fromJson(Map<String, dynamic> json) => _$AlternativeProductFromJson(json);

@override final  String? productId;
@override final  String name;
@override final  String brand;
@override final  String category;
@override final  int matchPercent;

/// Create a copy of AlternativeProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlternativeProductCopyWith<_AlternativeProduct> get copyWith => __$AlternativeProductCopyWithImpl<_AlternativeProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlternativeProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlternativeProduct&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&(identical(other.matchPercent, matchPercent) || other.matchPercent == matchPercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,name,brand,category,matchPercent);

@override
String toString() {
  return 'AlternativeProduct(productId: $productId, name: $name, brand: $brand, category: $category, matchPercent: $matchPercent)';
}


}

/// @nodoc
abstract mixin class _$AlternativeProductCopyWith<$Res> implements $AlternativeProductCopyWith<$Res> {
  factory _$AlternativeProductCopyWith(_AlternativeProduct value, $Res Function(_AlternativeProduct) _then) = __$AlternativeProductCopyWithImpl;
@override @useResult
$Res call({
 String? productId, String name, String brand, String category, int matchPercent
});




}
/// @nodoc
class __$AlternativeProductCopyWithImpl<$Res>
    implements _$AlternativeProductCopyWith<$Res> {
  __$AlternativeProductCopyWithImpl(this._self, this._then);

  final _AlternativeProduct _self;
  final $Res Function(_AlternativeProduct) _then;

/// Create a copy of AlternativeProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = freezed,Object? name = null,Object? brand = null,Object? category = null,Object? matchPercent = null,}) {
  return _then(_AlternativeProduct(
productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,matchPercent: null == matchPercent ? _self.matchPercent : matchPercent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProductAnalysis {

 String get id; String get productName; String? get brand; List<String> get ingredientNames; int get score; String get verdict; String get safetyRating; String get summary; String get recommendationReason; String get aiExplanation; List<String> get warnings; List<BreakdownEntry> get breakdown; List<AlternativeProduct> get alternatives; int get goodCount; int get watchCount; int get matchedCount; bool get favorite; DateTime get createdAt;
/// Create a copy of ProductAnalysis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductAnalysisCopyWith<ProductAnalysis> get copyWith => _$ProductAnalysisCopyWithImpl<ProductAnalysis>(this as ProductAnalysis, _$identity);

  /// Serializes this ProductAnalysis to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductAnalysis&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.brand, brand) || other.brand == brand)&&const DeepCollectionEquality().equals(other.ingredientNames, ingredientNames)&&(identical(other.score, score) || other.score == score)&&(identical(other.verdict, verdict) || other.verdict == verdict)&&(identical(other.safetyRating, safetyRating) || other.safetyRating == safetyRating)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.recommendationReason, recommendationReason) || other.recommendationReason == recommendationReason)&&(identical(other.aiExplanation, aiExplanation) || other.aiExplanation == aiExplanation)&&const DeepCollectionEquality().equals(other.warnings, warnings)&&const DeepCollectionEquality().equals(other.breakdown, breakdown)&&const DeepCollectionEquality().equals(other.alternatives, alternatives)&&(identical(other.goodCount, goodCount) || other.goodCount == goodCount)&&(identical(other.watchCount, watchCount) || other.watchCount == watchCount)&&(identical(other.matchedCount, matchedCount) || other.matchedCount == matchedCount)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productName,brand,const DeepCollectionEquality().hash(ingredientNames),score,verdict,safetyRating,summary,recommendationReason,aiExplanation,const DeepCollectionEquality().hash(warnings),const DeepCollectionEquality().hash(breakdown),const DeepCollectionEquality().hash(alternatives),goodCount,watchCount,matchedCount,favorite,createdAt);

@override
String toString() {
  return 'ProductAnalysis(id: $id, productName: $productName, brand: $brand, ingredientNames: $ingredientNames, score: $score, verdict: $verdict, safetyRating: $safetyRating, summary: $summary, recommendationReason: $recommendationReason, aiExplanation: $aiExplanation, warnings: $warnings, breakdown: $breakdown, alternatives: $alternatives, goodCount: $goodCount, watchCount: $watchCount, matchedCount: $matchedCount, favorite: $favorite, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ProductAnalysisCopyWith<$Res>  {
  factory $ProductAnalysisCopyWith(ProductAnalysis value, $Res Function(ProductAnalysis) _then) = _$ProductAnalysisCopyWithImpl;
@useResult
$Res call({
 String id, String productName, String? brand, List<String> ingredientNames, int score, String verdict, String safetyRating, String summary, String recommendationReason, String aiExplanation, List<String> warnings, List<BreakdownEntry> breakdown, List<AlternativeProduct> alternatives, int goodCount, int watchCount, int matchedCount, bool favorite, DateTime createdAt
});




}
/// @nodoc
class _$ProductAnalysisCopyWithImpl<$Res>
    implements $ProductAnalysisCopyWith<$Res> {
  _$ProductAnalysisCopyWithImpl(this._self, this._then);

  final ProductAnalysis _self;
  final $Res Function(ProductAnalysis) _then;

/// Create a copy of ProductAnalysis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productName = null,Object? brand = freezed,Object? ingredientNames = null,Object? score = null,Object? verdict = null,Object? safetyRating = null,Object? summary = null,Object? recommendationReason = null,Object? aiExplanation = null,Object? warnings = null,Object? breakdown = null,Object? alternatives = null,Object? goodCount = null,Object? watchCount = null,Object? matchedCount = null,Object? favorite = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,ingredientNames: null == ingredientNames ? _self.ingredientNames : ingredientNames // ignore: cast_nullable_to_non_nullable
as List<String>,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as String,safetyRating: null == safetyRating ? _self.safetyRating : safetyRating // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,recommendationReason: null == recommendationReason ? _self.recommendationReason : recommendationReason // ignore: cast_nullable_to_non_nullable
as String,aiExplanation: null == aiExplanation ? _self.aiExplanation : aiExplanation // ignore: cast_nullable_to_non_nullable
as String,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,breakdown: null == breakdown ? _self.breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as List<BreakdownEntry>,alternatives: null == alternatives ? _self.alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<AlternativeProduct>,goodCount: null == goodCount ? _self.goodCount : goodCount // ignore: cast_nullable_to_non_nullable
as int,watchCount: null == watchCount ? _self.watchCount : watchCount // ignore: cast_nullable_to_non_nullable
as int,matchedCount: null == matchedCount ? _self.matchedCount : matchedCount // ignore: cast_nullable_to_non_nullable
as int,favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductAnalysis].
extension ProductAnalysisPatterns on ProductAnalysis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductAnalysis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductAnalysis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductAnalysis value)  $default,){
final _that = this;
switch (_that) {
case _ProductAnalysis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductAnalysis value)?  $default,){
final _that = this;
switch (_that) {
case _ProductAnalysis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String productName,  String? brand,  List<String> ingredientNames,  int score,  String verdict,  String safetyRating,  String summary,  String recommendationReason,  String aiExplanation,  List<String> warnings,  List<BreakdownEntry> breakdown,  List<AlternativeProduct> alternatives,  int goodCount,  int watchCount,  int matchedCount,  bool favorite,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductAnalysis() when $default != null:
return $default(_that.id,_that.productName,_that.brand,_that.ingredientNames,_that.score,_that.verdict,_that.safetyRating,_that.summary,_that.recommendationReason,_that.aiExplanation,_that.warnings,_that.breakdown,_that.alternatives,_that.goodCount,_that.watchCount,_that.matchedCount,_that.favorite,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String productName,  String? brand,  List<String> ingredientNames,  int score,  String verdict,  String safetyRating,  String summary,  String recommendationReason,  String aiExplanation,  List<String> warnings,  List<BreakdownEntry> breakdown,  List<AlternativeProduct> alternatives,  int goodCount,  int watchCount,  int matchedCount,  bool favorite,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ProductAnalysis():
return $default(_that.id,_that.productName,_that.brand,_that.ingredientNames,_that.score,_that.verdict,_that.safetyRating,_that.summary,_that.recommendationReason,_that.aiExplanation,_that.warnings,_that.breakdown,_that.alternatives,_that.goodCount,_that.watchCount,_that.matchedCount,_that.favorite,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String productName,  String? brand,  List<String> ingredientNames,  int score,  String verdict,  String safetyRating,  String summary,  String recommendationReason,  String aiExplanation,  List<String> warnings,  List<BreakdownEntry> breakdown,  List<AlternativeProduct> alternatives,  int goodCount,  int watchCount,  int matchedCount,  bool favorite,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ProductAnalysis() when $default != null:
return $default(_that.id,_that.productName,_that.brand,_that.ingredientNames,_that.score,_that.verdict,_that.safetyRating,_that.summary,_that.recommendationReason,_that.aiExplanation,_that.warnings,_that.breakdown,_that.alternatives,_that.goodCount,_that.watchCount,_that.matchedCount,_that.favorite,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductAnalysis implements ProductAnalysis {
  const _ProductAnalysis({required this.id, this.productName = 'Scanned product', this.brand, final  List<String> ingredientNames = const <String>[], required this.score, required this.verdict, this.safetyRating = 'low_risk', this.summary = '', this.recommendationReason = '', this.aiExplanation = '', final  List<String> warnings = const <String>[], final  List<BreakdownEntry> breakdown = const <BreakdownEntry>[], final  List<AlternativeProduct> alternatives = const <AlternativeProduct>[], this.goodCount = 0, this.watchCount = 0, this.matchedCount = 0, this.favorite = false, required this.createdAt}): _ingredientNames = ingredientNames,_warnings = warnings,_breakdown = breakdown,_alternatives = alternatives;
  factory _ProductAnalysis.fromJson(Map<String, dynamic> json) => _$ProductAnalysisFromJson(json);

@override final  String id;
@override@JsonKey() final  String productName;
@override final  String? brand;
 final  List<String> _ingredientNames;
@override@JsonKey() List<String> get ingredientNames {
  if (_ingredientNames is EqualUnmodifiableListView) return _ingredientNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredientNames);
}

@override final  int score;
@override final  String verdict;
@override@JsonKey() final  String safetyRating;
@override@JsonKey() final  String summary;
@override@JsonKey() final  String recommendationReason;
@override@JsonKey() final  String aiExplanation;
 final  List<String> _warnings;
@override@JsonKey() List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}

 final  List<BreakdownEntry> _breakdown;
@override@JsonKey() List<BreakdownEntry> get breakdown {
  if (_breakdown is EqualUnmodifiableListView) return _breakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_breakdown);
}

 final  List<AlternativeProduct> _alternatives;
@override@JsonKey() List<AlternativeProduct> get alternatives {
  if (_alternatives is EqualUnmodifiableListView) return _alternatives;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alternatives);
}

@override@JsonKey() final  int goodCount;
@override@JsonKey() final  int watchCount;
@override@JsonKey() final  int matchedCount;
@override@JsonKey() final  bool favorite;
@override final  DateTime createdAt;

/// Create a copy of ProductAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductAnalysisCopyWith<_ProductAnalysis> get copyWith => __$ProductAnalysisCopyWithImpl<_ProductAnalysis>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductAnalysisToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductAnalysis&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.brand, brand) || other.brand == brand)&&const DeepCollectionEquality().equals(other._ingredientNames, _ingredientNames)&&(identical(other.score, score) || other.score == score)&&(identical(other.verdict, verdict) || other.verdict == verdict)&&(identical(other.safetyRating, safetyRating) || other.safetyRating == safetyRating)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.recommendationReason, recommendationReason) || other.recommendationReason == recommendationReason)&&(identical(other.aiExplanation, aiExplanation) || other.aiExplanation == aiExplanation)&&const DeepCollectionEquality().equals(other._warnings, _warnings)&&const DeepCollectionEquality().equals(other._breakdown, _breakdown)&&const DeepCollectionEquality().equals(other._alternatives, _alternatives)&&(identical(other.goodCount, goodCount) || other.goodCount == goodCount)&&(identical(other.watchCount, watchCount) || other.watchCount == watchCount)&&(identical(other.matchedCount, matchedCount) || other.matchedCount == matchedCount)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productName,brand,const DeepCollectionEquality().hash(_ingredientNames),score,verdict,safetyRating,summary,recommendationReason,aiExplanation,const DeepCollectionEquality().hash(_warnings),const DeepCollectionEquality().hash(_breakdown),const DeepCollectionEquality().hash(_alternatives),goodCount,watchCount,matchedCount,favorite,createdAt);

@override
String toString() {
  return 'ProductAnalysis(id: $id, productName: $productName, brand: $brand, ingredientNames: $ingredientNames, score: $score, verdict: $verdict, safetyRating: $safetyRating, summary: $summary, recommendationReason: $recommendationReason, aiExplanation: $aiExplanation, warnings: $warnings, breakdown: $breakdown, alternatives: $alternatives, goodCount: $goodCount, watchCount: $watchCount, matchedCount: $matchedCount, favorite: $favorite, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProductAnalysisCopyWith<$Res> implements $ProductAnalysisCopyWith<$Res> {
  factory _$ProductAnalysisCopyWith(_ProductAnalysis value, $Res Function(_ProductAnalysis) _then) = __$ProductAnalysisCopyWithImpl;
@override @useResult
$Res call({
 String id, String productName, String? brand, List<String> ingredientNames, int score, String verdict, String safetyRating, String summary, String recommendationReason, String aiExplanation, List<String> warnings, List<BreakdownEntry> breakdown, List<AlternativeProduct> alternatives, int goodCount, int watchCount, int matchedCount, bool favorite, DateTime createdAt
});




}
/// @nodoc
class __$ProductAnalysisCopyWithImpl<$Res>
    implements _$ProductAnalysisCopyWith<$Res> {
  __$ProductAnalysisCopyWithImpl(this._self, this._then);

  final _ProductAnalysis _self;
  final $Res Function(_ProductAnalysis) _then;

/// Create a copy of ProductAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productName = null,Object? brand = freezed,Object? ingredientNames = null,Object? score = null,Object? verdict = null,Object? safetyRating = null,Object? summary = null,Object? recommendationReason = null,Object? aiExplanation = null,Object? warnings = null,Object? breakdown = null,Object? alternatives = null,Object? goodCount = null,Object? watchCount = null,Object? matchedCount = null,Object? favorite = null,Object? createdAt = null,}) {
  return _then(_ProductAnalysis(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,ingredientNames: null == ingredientNames ? _self._ingredientNames : ingredientNames // ignore: cast_nullable_to_non_nullable
as List<String>,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as String,safetyRating: null == safetyRating ? _self.safetyRating : safetyRating // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,recommendationReason: null == recommendationReason ? _self.recommendationReason : recommendationReason // ignore: cast_nullable_to_non_nullable
as String,aiExplanation: null == aiExplanation ? _self.aiExplanation : aiExplanation // ignore: cast_nullable_to_non_nullable
as String,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,breakdown: null == breakdown ? _self._breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as List<BreakdownEntry>,alternatives: null == alternatives ? _self._alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<AlternativeProduct>,goodCount: null == goodCount ? _self.goodCount : goodCount // ignore: cast_nullable_to_non_nullable
as int,watchCount: null == watchCount ? _self.watchCount : watchCount // ignore: cast_nullable_to_non_nullable
as int,matchedCount: null == matchedCount ? _self.matchedCount : matchedCount // ignore: cast_nullable_to_non_nullable
as int,favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ComparisonResult {

 ProductAnalysis get a; ProductAnalysis get b; String? get winner;
/// Create a copy of ComparisonResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComparisonResultCopyWith<ComparisonResult> get copyWith => _$ComparisonResultCopyWithImpl<ComparisonResult>(this as ComparisonResult, _$identity);

  /// Serializes this ComparisonResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComparisonResult&&(identical(other.a, a) || other.a == a)&&(identical(other.b, b) || other.b == b)&&(identical(other.winner, winner) || other.winner == winner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,a,b,winner);

@override
String toString() {
  return 'ComparisonResult(a: $a, b: $b, winner: $winner)';
}


}

/// @nodoc
abstract mixin class $ComparisonResultCopyWith<$Res>  {
  factory $ComparisonResultCopyWith(ComparisonResult value, $Res Function(ComparisonResult) _then) = _$ComparisonResultCopyWithImpl;
@useResult
$Res call({
 ProductAnalysis a, ProductAnalysis b, String? winner
});


$ProductAnalysisCopyWith<$Res> get a;$ProductAnalysisCopyWith<$Res> get b;

}
/// @nodoc
class _$ComparisonResultCopyWithImpl<$Res>
    implements $ComparisonResultCopyWith<$Res> {
  _$ComparisonResultCopyWithImpl(this._self, this._then);

  final ComparisonResult _self;
  final $Res Function(ComparisonResult) _then;

/// Create a copy of ComparisonResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? a = null,Object? b = null,Object? winner = freezed,}) {
  return _then(_self.copyWith(
a: null == a ? _self.a : a // ignore: cast_nullable_to_non_nullable
as ProductAnalysis,b: null == b ? _self.b : b // ignore: cast_nullable_to_non_nullable
as ProductAnalysis,winner: freezed == winner ? _self.winner : winner // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ComparisonResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductAnalysisCopyWith<$Res> get a {
  
  return $ProductAnalysisCopyWith<$Res>(_self.a, (value) {
    return _then(_self.copyWith(a: value));
  });
}/// Create a copy of ComparisonResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductAnalysisCopyWith<$Res> get b {
  
  return $ProductAnalysisCopyWith<$Res>(_self.b, (value) {
    return _then(_self.copyWith(b: value));
  });
}
}


/// Adds pattern-matching-related methods to [ComparisonResult].
extension ComparisonResultPatterns on ComparisonResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComparisonResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComparisonResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComparisonResult value)  $default,){
final _that = this;
switch (_that) {
case _ComparisonResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComparisonResult value)?  $default,){
final _that = this;
switch (_that) {
case _ComparisonResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProductAnalysis a,  ProductAnalysis b,  String? winner)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComparisonResult() when $default != null:
return $default(_that.a,_that.b,_that.winner);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProductAnalysis a,  ProductAnalysis b,  String? winner)  $default,) {final _that = this;
switch (_that) {
case _ComparisonResult():
return $default(_that.a,_that.b,_that.winner);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProductAnalysis a,  ProductAnalysis b,  String? winner)?  $default,) {final _that = this;
switch (_that) {
case _ComparisonResult() when $default != null:
return $default(_that.a,_that.b,_that.winner);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComparisonResult implements ComparisonResult {
  const _ComparisonResult({required this.a, required this.b, this.winner});
  factory _ComparisonResult.fromJson(Map<String, dynamic> json) => _$ComparisonResultFromJson(json);

@override final  ProductAnalysis a;
@override final  ProductAnalysis b;
@override final  String? winner;

/// Create a copy of ComparisonResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComparisonResultCopyWith<_ComparisonResult> get copyWith => __$ComparisonResultCopyWithImpl<_ComparisonResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComparisonResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComparisonResult&&(identical(other.a, a) || other.a == a)&&(identical(other.b, b) || other.b == b)&&(identical(other.winner, winner) || other.winner == winner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,a,b,winner);

@override
String toString() {
  return 'ComparisonResult(a: $a, b: $b, winner: $winner)';
}


}

/// @nodoc
abstract mixin class _$ComparisonResultCopyWith<$Res> implements $ComparisonResultCopyWith<$Res> {
  factory _$ComparisonResultCopyWith(_ComparisonResult value, $Res Function(_ComparisonResult) _then) = __$ComparisonResultCopyWithImpl;
@override @useResult
$Res call({
 ProductAnalysis a, ProductAnalysis b, String? winner
});


@override $ProductAnalysisCopyWith<$Res> get a;@override $ProductAnalysisCopyWith<$Res> get b;

}
/// @nodoc
class __$ComparisonResultCopyWithImpl<$Res>
    implements _$ComparisonResultCopyWith<$Res> {
  __$ComparisonResultCopyWithImpl(this._self, this._then);

  final _ComparisonResult _self;
  final $Res Function(_ComparisonResult) _then;

/// Create a copy of ComparisonResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? a = null,Object? b = null,Object? winner = freezed,}) {
  return _then(_ComparisonResult(
a: null == a ? _self.a : a // ignore: cast_nullable_to_non_nullable
as ProductAnalysis,b: null == b ? _self.b : b // ignore: cast_nullable_to_non_nullable
as ProductAnalysis,winner: freezed == winner ? _self.winner : winner // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ComparisonResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductAnalysisCopyWith<$Res> get a {
  
  return $ProductAnalysisCopyWith<$Res>(_self.a, (value) {
    return _then(_self.copyWith(a: value));
  });
}/// Create a copy of ComparisonResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductAnalysisCopyWith<$Res> get b {
  
  return $ProductAnalysisCopyWith<$Res>(_self.b, (value) {
    return _then(_self.copyWith(b: value));
  });
}
}

// dart format on
