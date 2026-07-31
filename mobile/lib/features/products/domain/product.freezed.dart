// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CatalogProduct {

 String get id; String get slug; String get name; String get brand; String get category;
/// Create a copy of CatalogProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogProductCopyWith<CatalogProduct> get copyWith => _$CatalogProductCopyWithImpl<CatalogProduct>(this as CatalogProduct, _$identity);

  /// Serializes this CatalogProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,name,brand,category);

@override
String toString() {
  return 'CatalogProduct(id: $id, slug: $slug, name: $name, brand: $brand, category: $category)';
}


}

/// @nodoc
abstract mixin class $CatalogProductCopyWith<$Res>  {
  factory $CatalogProductCopyWith(CatalogProduct value, $Res Function(CatalogProduct) _then) = _$CatalogProductCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String name, String brand, String category
});




}
/// @nodoc
class _$CatalogProductCopyWithImpl<$Res>
    implements $CatalogProductCopyWith<$Res> {
  _$CatalogProductCopyWithImpl(this._self, this._then);

  final CatalogProduct _self;
  final $Res Function(CatalogProduct) _then;

/// Create a copy of CatalogProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? brand = null,Object? category = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogProduct].
extension CatalogProductPatterns on CatalogProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogProduct value)  $default,){
final _that = this;
switch (_that) {
case _CatalogProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogProduct value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String brand,  String category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogProduct() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.brand,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String brand,  String category)  $default,) {final _that = this;
switch (_that) {
case _CatalogProduct():
return $default(_that.id,_that.slug,_that.name,_that.brand,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String name,  String brand,  String category)?  $default,) {final _that = this;
switch (_that) {
case _CatalogProduct() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.brand,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CatalogProduct implements CatalogProduct {
  const _CatalogProduct({required this.id, this.slug = '', required this.name, required this.brand, required this.category});
  factory _CatalogProduct.fromJson(Map<String, dynamic> json) => _$CatalogProductFromJson(json);

@override final  String id;
@override@JsonKey() final  String slug;
@override final  String name;
@override final  String brand;
@override final  String category;

/// Create a copy of CatalogProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogProductCopyWith<_CatalogProduct> get copyWith => __$CatalogProductCopyWithImpl<_CatalogProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,name,brand,category);

@override
String toString() {
  return 'CatalogProduct(id: $id, slug: $slug, name: $name, brand: $brand, category: $category)';
}


}

/// @nodoc
abstract mixin class _$CatalogProductCopyWith<$Res> implements $CatalogProductCopyWith<$Res> {
  factory _$CatalogProductCopyWith(_CatalogProduct value, $Res Function(_CatalogProduct) _then) = __$CatalogProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String name, String brand, String category
});




}
/// @nodoc
class __$CatalogProductCopyWithImpl<$Res>
    implements _$CatalogProductCopyWith<$Res> {
  __$CatalogProductCopyWithImpl(this._self, this._then);

  final _CatalogProduct _self;
  final $Res Function(_CatalogProduct) _then;

/// Create a copy of CatalogProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? brand = null,Object? category = null,}) {
  return _then(_CatalogProduct(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ProductDetail {

 String get id; String get slug; String get name; String get brand; String get category; String get description; String? get imageUrl; List<String> get ingredientNames; int? get safetyScore; String? get safetyBand; List<String> get suitableSkinTypes; List<String> get benefits; List<String> get sideEffects;
/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailCopyWith<ProductDetail> get copyWith => _$ProductDetailCopyWithImpl<ProductDetail>(this as ProductDetail, _$identity);

  /// Serializes this ProductDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.ingredientNames, ingredientNames)&&(identical(other.safetyScore, safetyScore) || other.safetyScore == safetyScore)&&(identical(other.safetyBand, safetyBand) || other.safetyBand == safetyBand)&&const DeepCollectionEquality().equals(other.suitableSkinTypes, suitableSkinTypes)&&const DeepCollectionEquality().equals(other.benefits, benefits)&&const DeepCollectionEquality().equals(other.sideEffects, sideEffects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,name,brand,category,description,imageUrl,const DeepCollectionEquality().hash(ingredientNames),safetyScore,safetyBand,const DeepCollectionEquality().hash(suitableSkinTypes),const DeepCollectionEquality().hash(benefits),const DeepCollectionEquality().hash(sideEffects));

@override
String toString() {
  return 'ProductDetail(id: $id, slug: $slug, name: $name, brand: $brand, category: $category, description: $description, imageUrl: $imageUrl, ingredientNames: $ingredientNames, safetyScore: $safetyScore, safetyBand: $safetyBand, suitableSkinTypes: $suitableSkinTypes, benefits: $benefits, sideEffects: $sideEffects)';
}


}

/// @nodoc
abstract mixin class $ProductDetailCopyWith<$Res>  {
  factory $ProductDetailCopyWith(ProductDetail value, $Res Function(ProductDetail) _then) = _$ProductDetailCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String name, String brand, String category, String description, String? imageUrl, List<String> ingredientNames, int? safetyScore, String? safetyBand, List<String> suitableSkinTypes, List<String> benefits, List<String> sideEffects
});




}
/// @nodoc
class _$ProductDetailCopyWithImpl<$Res>
    implements $ProductDetailCopyWith<$Res> {
  _$ProductDetailCopyWithImpl(this._self, this._then);

  final ProductDetail _self;
  final $Res Function(ProductDetail) _then;

/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? brand = null,Object? category = null,Object? description = null,Object? imageUrl = freezed,Object? ingredientNames = null,Object? safetyScore = freezed,Object? safetyBand = freezed,Object? suitableSkinTypes = null,Object? benefits = null,Object? sideEffects = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,ingredientNames: null == ingredientNames ? _self.ingredientNames : ingredientNames // ignore: cast_nullable_to_non_nullable
as List<String>,safetyScore: freezed == safetyScore ? _self.safetyScore : safetyScore // ignore: cast_nullable_to_non_nullable
as int?,safetyBand: freezed == safetyBand ? _self.safetyBand : safetyBand // ignore: cast_nullable_to_non_nullable
as String?,suitableSkinTypes: null == suitableSkinTypes ? _self.suitableSkinTypes : suitableSkinTypes // ignore: cast_nullable_to_non_nullable
as List<String>,benefits: null == benefits ? _self.benefits : benefits // ignore: cast_nullable_to_non_nullable
as List<String>,sideEffects: null == sideEffects ? _self.sideEffects : sideEffects // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductDetail].
extension ProductDetailPatterns on ProductDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductDetail value)  $default,){
final _that = this;
switch (_that) {
case _ProductDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String brand,  String category,  String description,  String? imageUrl,  List<String> ingredientNames,  int? safetyScore,  String? safetyBand,  List<String> suitableSkinTypes,  List<String> benefits,  List<String> sideEffects)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.brand,_that.category,_that.description,_that.imageUrl,_that.ingredientNames,_that.safetyScore,_that.safetyBand,_that.suitableSkinTypes,_that.benefits,_that.sideEffects);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String brand,  String category,  String description,  String? imageUrl,  List<String> ingredientNames,  int? safetyScore,  String? safetyBand,  List<String> suitableSkinTypes,  List<String> benefits,  List<String> sideEffects)  $default,) {final _that = this;
switch (_that) {
case _ProductDetail():
return $default(_that.id,_that.slug,_that.name,_that.brand,_that.category,_that.description,_that.imageUrl,_that.ingredientNames,_that.safetyScore,_that.safetyBand,_that.suitableSkinTypes,_that.benefits,_that.sideEffects);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String name,  String brand,  String category,  String description,  String? imageUrl,  List<String> ingredientNames,  int? safetyScore,  String? safetyBand,  List<String> suitableSkinTypes,  List<String> benefits,  List<String> sideEffects)?  $default,) {final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.brand,_that.category,_that.description,_that.imageUrl,_that.ingredientNames,_that.safetyScore,_that.safetyBand,_that.suitableSkinTypes,_that.benefits,_that.sideEffects);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductDetail extends ProductDetail {
  const _ProductDetail({required this.id, this.slug = '', required this.name, required this.brand, required this.category, this.description = '', this.imageUrl, final  List<String> ingredientNames = const <String>[], this.safetyScore, this.safetyBand, final  List<String> suitableSkinTypes = const <String>[], final  List<String> benefits = const <String>[], final  List<String> sideEffects = const <String>[]}): _ingredientNames = ingredientNames,_suitableSkinTypes = suitableSkinTypes,_benefits = benefits,_sideEffects = sideEffects,super._();
  factory _ProductDetail.fromJson(Map<String, dynamic> json) => _$ProductDetailFromJson(json);

@override final  String id;
@override@JsonKey() final  String slug;
@override final  String name;
@override final  String brand;
@override final  String category;
@override@JsonKey() final  String description;
@override final  String? imageUrl;
 final  List<String> _ingredientNames;
@override@JsonKey() List<String> get ingredientNames {
  if (_ingredientNames is EqualUnmodifiableListView) return _ingredientNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredientNames);
}

@override final  int? safetyScore;
@override final  String? safetyBand;
 final  List<String> _suitableSkinTypes;
@override@JsonKey() List<String> get suitableSkinTypes {
  if (_suitableSkinTypes is EqualUnmodifiableListView) return _suitableSkinTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suitableSkinTypes);
}

 final  List<String> _benefits;
@override@JsonKey() List<String> get benefits {
  if (_benefits is EqualUnmodifiableListView) return _benefits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_benefits);
}

 final  List<String> _sideEffects;
@override@JsonKey() List<String> get sideEffects {
  if (_sideEffects is EqualUnmodifiableListView) return _sideEffects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sideEffects);
}


/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductDetailCopyWith<_ProductDetail> get copyWith => __$ProductDetailCopyWithImpl<_ProductDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._ingredientNames, _ingredientNames)&&(identical(other.safetyScore, safetyScore) || other.safetyScore == safetyScore)&&(identical(other.safetyBand, safetyBand) || other.safetyBand == safetyBand)&&const DeepCollectionEquality().equals(other._suitableSkinTypes, _suitableSkinTypes)&&const DeepCollectionEquality().equals(other._benefits, _benefits)&&const DeepCollectionEquality().equals(other._sideEffects, _sideEffects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,name,brand,category,description,imageUrl,const DeepCollectionEquality().hash(_ingredientNames),safetyScore,safetyBand,const DeepCollectionEquality().hash(_suitableSkinTypes),const DeepCollectionEquality().hash(_benefits),const DeepCollectionEquality().hash(_sideEffects));

@override
String toString() {
  return 'ProductDetail(id: $id, slug: $slug, name: $name, brand: $brand, category: $category, description: $description, imageUrl: $imageUrl, ingredientNames: $ingredientNames, safetyScore: $safetyScore, safetyBand: $safetyBand, suitableSkinTypes: $suitableSkinTypes, benefits: $benefits, sideEffects: $sideEffects)';
}


}

/// @nodoc
abstract mixin class _$ProductDetailCopyWith<$Res> implements $ProductDetailCopyWith<$Res> {
  factory _$ProductDetailCopyWith(_ProductDetail value, $Res Function(_ProductDetail) _then) = __$ProductDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String name, String brand, String category, String description, String? imageUrl, List<String> ingredientNames, int? safetyScore, String? safetyBand, List<String> suitableSkinTypes, List<String> benefits, List<String> sideEffects
});




}
/// @nodoc
class __$ProductDetailCopyWithImpl<$Res>
    implements _$ProductDetailCopyWith<$Res> {
  __$ProductDetailCopyWithImpl(this._self, this._then);

  final _ProductDetail _self;
  final $Res Function(_ProductDetail) _then;

/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? brand = null,Object? category = null,Object? description = null,Object? imageUrl = freezed,Object? ingredientNames = null,Object? safetyScore = freezed,Object? safetyBand = freezed,Object? suitableSkinTypes = null,Object? benefits = null,Object? sideEffects = null,}) {
  return _then(_ProductDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,ingredientNames: null == ingredientNames ? _self._ingredientNames : ingredientNames // ignore: cast_nullable_to_non_nullable
as List<String>,safetyScore: freezed == safetyScore ? _self.safetyScore : safetyScore // ignore: cast_nullable_to_non_nullable
as int?,safetyBand: freezed == safetyBand ? _self.safetyBand : safetyBand // ignore: cast_nullable_to_non_nullable
as String?,suitableSkinTypes: null == suitableSkinTypes ? _self._suitableSkinTypes : suitableSkinTypes // ignore: cast_nullable_to_non_nullable
as List<String>,benefits: null == benefits ? _self._benefits : benefits // ignore: cast_nullable_to_non_nullable
as List<String>,sideEffects: null == sideEffects ? _self._sideEffects : sideEffects // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$BarcodeProduct {

 String get id; String get slug; String get barcode; String get name; String get brand; String get category; String get description; String? get imageUrl; List<String> get ingredientNames; int? get safetyScore; String? get safetyBand; List<String> get suitableSkinTypes; List<String> get benefits; List<String> get sideEffects;/// 'catalog' for the curated catalogue, 'external' for Open Facts data,
/// which is community-sourced and worth flagging in the UI.
 String get source;
/// Create a copy of BarcodeProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BarcodeProductCopyWith<BarcodeProduct> get copyWith => _$BarcodeProductCopyWithImpl<BarcodeProduct>(this as BarcodeProduct, _$identity);

  /// Serializes this BarcodeProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BarcodeProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.ingredientNames, ingredientNames)&&(identical(other.safetyScore, safetyScore) || other.safetyScore == safetyScore)&&(identical(other.safetyBand, safetyBand) || other.safetyBand == safetyBand)&&const DeepCollectionEquality().equals(other.suitableSkinTypes, suitableSkinTypes)&&const DeepCollectionEquality().equals(other.benefits, benefits)&&const DeepCollectionEquality().equals(other.sideEffects, sideEffects)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,barcode,name,brand,category,description,imageUrl,const DeepCollectionEquality().hash(ingredientNames),safetyScore,safetyBand,const DeepCollectionEquality().hash(suitableSkinTypes),const DeepCollectionEquality().hash(benefits),const DeepCollectionEquality().hash(sideEffects),source);

@override
String toString() {
  return 'BarcodeProduct(id: $id, slug: $slug, barcode: $barcode, name: $name, brand: $brand, category: $category, description: $description, imageUrl: $imageUrl, ingredientNames: $ingredientNames, safetyScore: $safetyScore, safetyBand: $safetyBand, suitableSkinTypes: $suitableSkinTypes, benefits: $benefits, sideEffects: $sideEffects, source: $source)';
}


}

/// @nodoc
abstract mixin class $BarcodeProductCopyWith<$Res>  {
  factory $BarcodeProductCopyWith(BarcodeProduct value, $Res Function(BarcodeProduct) _then) = _$BarcodeProductCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String barcode, String name, String brand, String category, String description, String? imageUrl, List<String> ingredientNames, int? safetyScore, String? safetyBand, List<String> suitableSkinTypes, List<String> benefits, List<String> sideEffects, String source
});




}
/// @nodoc
class _$BarcodeProductCopyWithImpl<$Res>
    implements $BarcodeProductCopyWith<$Res> {
  _$BarcodeProductCopyWithImpl(this._self, this._then);

  final BarcodeProduct _self;
  final $Res Function(BarcodeProduct) _then;

/// Create a copy of BarcodeProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? barcode = null,Object? name = null,Object? brand = null,Object? category = null,Object? description = null,Object? imageUrl = freezed,Object? ingredientNames = null,Object? safetyScore = freezed,Object? safetyBand = freezed,Object? suitableSkinTypes = null,Object? benefits = null,Object? sideEffects = null,Object? source = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,ingredientNames: null == ingredientNames ? _self.ingredientNames : ingredientNames // ignore: cast_nullable_to_non_nullable
as List<String>,safetyScore: freezed == safetyScore ? _self.safetyScore : safetyScore // ignore: cast_nullable_to_non_nullable
as int?,safetyBand: freezed == safetyBand ? _self.safetyBand : safetyBand // ignore: cast_nullable_to_non_nullable
as String?,suitableSkinTypes: null == suitableSkinTypes ? _self.suitableSkinTypes : suitableSkinTypes // ignore: cast_nullable_to_non_nullable
as List<String>,benefits: null == benefits ? _self.benefits : benefits // ignore: cast_nullable_to_non_nullable
as List<String>,sideEffects: null == sideEffects ? _self.sideEffects : sideEffects // ignore: cast_nullable_to_non_nullable
as List<String>,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BarcodeProduct].
extension BarcodeProductPatterns on BarcodeProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BarcodeProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BarcodeProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BarcodeProduct value)  $default,){
final _that = this;
switch (_that) {
case _BarcodeProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BarcodeProduct value)?  $default,){
final _that = this;
switch (_that) {
case _BarcodeProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String barcode,  String name,  String brand,  String category,  String description,  String? imageUrl,  List<String> ingredientNames,  int? safetyScore,  String? safetyBand,  List<String> suitableSkinTypes,  List<String> benefits,  List<String> sideEffects,  String source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BarcodeProduct() when $default != null:
return $default(_that.id,_that.slug,_that.barcode,_that.name,_that.brand,_that.category,_that.description,_that.imageUrl,_that.ingredientNames,_that.safetyScore,_that.safetyBand,_that.suitableSkinTypes,_that.benefits,_that.sideEffects,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String barcode,  String name,  String brand,  String category,  String description,  String? imageUrl,  List<String> ingredientNames,  int? safetyScore,  String? safetyBand,  List<String> suitableSkinTypes,  List<String> benefits,  List<String> sideEffects,  String source)  $default,) {final _that = this;
switch (_that) {
case _BarcodeProduct():
return $default(_that.id,_that.slug,_that.barcode,_that.name,_that.brand,_that.category,_that.description,_that.imageUrl,_that.ingredientNames,_that.safetyScore,_that.safetyBand,_that.suitableSkinTypes,_that.benefits,_that.sideEffects,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String barcode,  String name,  String brand,  String category,  String description,  String? imageUrl,  List<String> ingredientNames,  int? safetyScore,  String? safetyBand,  List<String> suitableSkinTypes,  List<String> benefits,  List<String> sideEffects,  String source)?  $default,) {final _that = this;
switch (_that) {
case _BarcodeProduct() when $default != null:
return $default(_that.id,_that.slug,_that.barcode,_that.name,_that.brand,_that.category,_that.description,_that.imageUrl,_that.ingredientNames,_that.safetyScore,_that.safetyBand,_that.suitableSkinTypes,_that.benefits,_that.sideEffects,_that.source);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BarcodeProduct extends BarcodeProduct {
  const _BarcodeProduct({required this.id, this.slug = '', required this.barcode, required this.name, required this.brand, required this.category, this.description = '', this.imageUrl, final  List<String> ingredientNames = const <String>[], this.safetyScore, this.safetyBand, final  List<String> suitableSkinTypes = const <String>[], final  List<String> benefits = const <String>[], final  List<String> sideEffects = const <String>[], this.source = 'catalog'}): _ingredientNames = ingredientNames,_suitableSkinTypes = suitableSkinTypes,_benefits = benefits,_sideEffects = sideEffects,super._();
  factory _BarcodeProduct.fromJson(Map<String, dynamic> json) => _$BarcodeProductFromJson(json);

@override final  String id;
@override@JsonKey() final  String slug;
@override final  String barcode;
@override final  String name;
@override final  String brand;
@override final  String category;
@override@JsonKey() final  String description;
@override final  String? imageUrl;
 final  List<String> _ingredientNames;
@override@JsonKey() List<String> get ingredientNames {
  if (_ingredientNames is EqualUnmodifiableListView) return _ingredientNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredientNames);
}

@override final  int? safetyScore;
@override final  String? safetyBand;
 final  List<String> _suitableSkinTypes;
@override@JsonKey() List<String> get suitableSkinTypes {
  if (_suitableSkinTypes is EqualUnmodifiableListView) return _suitableSkinTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suitableSkinTypes);
}

 final  List<String> _benefits;
@override@JsonKey() List<String> get benefits {
  if (_benefits is EqualUnmodifiableListView) return _benefits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_benefits);
}

 final  List<String> _sideEffects;
@override@JsonKey() List<String> get sideEffects {
  if (_sideEffects is EqualUnmodifiableListView) return _sideEffects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sideEffects);
}

/// 'catalog' for the curated catalogue, 'external' for Open Facts data,
/// which is community-sourced and worth flagging in the UI.
@override@JsonKey() final  String source;

/// Create a copy of BarcodeProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BarcodeProductCopyWith<_BarcodeProduct> get copyWith => __$BarcodeProductCopyWithImpl<_BarcodeProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BarcodeProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BarcodeProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._ingredientNames, _ingredientNames)&&(identical(other.safetyScore, safetyScore) || other.safetyScore == safetyScore)&&(identical(other.safetyBand, safetyBand) || other.safetyBand == safetyBand)&&const DeepCollectionEquality().equals(other._suitableSkinTypes, _suitableSkinTypes)&&const DeepCollectionEquality().equals(other._benefits, _benefits)&&const DeepCollectionEquality().equals(other._sideEffects, _sideEffects)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,barcode,name,brand,category,description,imageUrl,const DeepCollectionEquality().hash(_ingredientNames),safetyScore,safetyBand,const DeepCollectionEquality().hash(_suitableSkinTypes),const DeepCollectionEquality().hash(_benefits),const DeepCollectionEquality().hash(_sideEffects),source);

@override
String toString() {
  return 'BarcodeProduct(id: $id, slug: $slug, barcode: $barcode, name: $name, brand: $brand, category: $category, description: $description, imageUrl: $imageUrl, ingredientNames: $ingredientNames, safetyScore: $safetyScore, safetyBand: $safetyBand, suitableSkinTypes: $suitableSkinTypes, benefits: $benefits, sideEffects: $sideEffects, source: $source)';
}


}

/// @nodoc
abstract mixin class _$BarcodeProductCopyWith<$Res> implements $BarcodeProductCopyWith<$Res> {
  factory _$BarcodeProductCopyWith(_BarcodeProduct value, $Res Function(_BarcodeProduct) _then) = __$BarcodeProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String barcode, String name, String brand, String category, String description, String? imageUrl, List<String> ingredientNames, int? safetyScore, String? safetyBand, List<String> suitableSkinTypes, List<String> benefits, List<String> sideEffects, String source
});




}
/// @nodoc
class __$BarcodeProductCopyWithImpl<$Res>
    implements _$BarcodeProductCopyWith<$Res> {
  __$BarcodeProductCopyWithImpl(this._self, this._then);

  final _BarcodeProduct _self;
  final $Res Function(_BarcodeProduct) _then;

/// Create a copy of BarcodeProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? barcode = null,Object? name = null,Object? brand = null,Object? category = null,Object? description = null,Object? imageUrl = freezed,Object? ingredientNames = null,Object? safetyScore = freezed,Object? safetyBand = freezed,Object? suitableSkinTypes = null,Object? benefits = null,Object? sideEffects = null,Object? source = null,}) {
  return _then(_BarcodeProduct(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,ingredientNames: null == ingredientNames ? _self._ingredientNames : ingredientNames // ignore: cast_nullable_to_non_nullable
as List<String>,safetyScore: freezed == safetyScore ? _self.safetyScore : safetyScore // ignore: cast_nullable_to_non_nullable
as int?,safetyBand: freezed == safetyBand ? _self.safetyBand : safetyBand // ignore: cast_nullable_to_non_nullable
as String?,suitableSkinTypes: null == suitableSkinTypes ? _self._suitableSkinTypes : suitableSkinTypes // ignore: cast_nullable_to_non_nullable
as List<String>,benefits: null == benefits ? _self._benefits : benefits // ignore: cast_nullable_to_non_nullable
as List<String>,sideEffects: null == sideEffects ? _self._sideEffects : sideEffects // ignore: cast_nullable_to_non_nullable
as List<String>,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ProductPage {

 List<CatalogProduct> get items; List<String> get categories; int get page; int get totalPages; int get total;
/// Create a copy of ProductPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductPageCopyWith<ProductPage> get copyWith => _$ProductPageCopyWithImpl<ProductPage>(this as ProductPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductPage&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(categories),page,totalPages,total);

@override
String toString() {
  return 'ProductPage(items: $items, categories: $categories, page: $page, totalPages: $totalPages, total: $total)';
}


}

/// @nodoc
abstract mixin class $ProductPageCopyWith<$Res>  {
  factory $ProductPageCopyWith(ProductPage value, $Res Function(ProductPage) _then) = _$ProductPageCopyWithImpl;
@useResult
$Res call({
 List<CatalogProduct> items, List<String> categories, int page, int totalPages, int total
});




}
/// @nodoc
class _$ProductPageCopyWithImpl<$Res>
    implements $ProductPageCopyWith<$Res> {
  _$ProductPageCopyWithImpl(this._self, this._then);

  final ProductPage _self;
  final $Res Function(ProductPage) _then;

/// Create a copy of ProductPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? categories = null,Object? page = null,Object? totalPages = null,Object? total = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CatalogProduct>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductPage].
extension ProductPagePatterns on ProductPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductPage value)  $default,){
final _that = this;
switch (_that) {
case _ProductPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductPage value)?  $default,){
final _that = this;
switch (_that) {
case _ProductPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CatalogProduct> items,  List<String> categories,  int page,  int totalPages,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductPage() when $default != null:
return $default(_that.items,_that.categories,_that.page,_that.totalPages,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CatalogProduct> items,  List<String> categories,  int page,  int totalPages,  int total)  $default,) {final _that = this;
switch (_that) {
case _ProductPage():
return $default(_that.items,_that.categories,_that.page,_that.totalPages,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CatalogProduct> items,  List<String> categories,  int page,  int totalPages,  int total)?  $default,) {final _that = this;
switch (_that) {
case _ProductPage() when $default != null:
return $default(_that.items,_that.categories,_that.page,_that.totalPages,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _ProductPage extends ProductPage {
  const _ProductPage({final  List<CatalogProduct> items = const <CatalogProduct>[], final  List<String> categories = const <String>[], this.page = 1, this.totalPages = 1, this.total = 0}): _items = items,_categories = categories,super._();
  

 final  List<CatalogProduct> _items;
@override@JsonKey() List<CatalogProduct> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<String> _categories;
@override@JsonKey() List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override@JsonKey() final  int page;
@override@JsonKey() final  int totalPages;
@override@JsonKey() final  int total;

/// Create a copy of ProductPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductPageCopyWith<_ProductPage> get copyWith => __$ProductPageCopyWithImpl<_ProductPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductPage&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_categories),page,totalPages,total);

@override
String toString() {
  return 'ProductPage(items: $items, categories: $categories, page: $page, totalPages: $totalPages, total: $total)';
}


}

/// @nodoc
abstract mixin class _$ProductPageCopyWith<$Res> implements $ProductPageCopyWith<$Res> {
  factory _$ProductPageCopyWith(_ProductPage value, $Res Function(_ProductPage) _then) = __$ProductPageCopyWithImpl;
@override @useResult
$Res call({
 List<CatalogProduct> items, List<String> categories, int page, int totalPages, int total
});




}
/// @nodoc
class __$ProductPageCopyWithImpl<$Res>
    implements _$ProductPageCopyWith<$Res> {
  __$ProductPageCopyWithImpl(this._self, this._then);

  final _ProductPage _self;
  final $Res Function(_ProductPage) _then;

/// Create a copy of ProductPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? categories = null,Object? page = null,Object? totalPages = null,Object? total = null,}) {
  return _then(_ProductPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CatalogProduct>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
