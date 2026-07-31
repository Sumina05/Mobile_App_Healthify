// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorites_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FavoriteItem {

 String get id; Ingredient get ingredient;
/// Create a copy of FavoriteItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteItemCopyWith<FavoriteItem> get copyWith => _$FavoriteItemCopyWithImpl<FavoriteItem>(this as FavoriteItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteItem&&(identical(other.id, id) || other.id == id)&&(identical(other.ingredient, ingredient) || other.ingredient == ingredient));
}


@override
int get hashCode => Object.hash(runtimeType,id,ingredient);

@override
String toString() {
  return 'FavoriteItem(id: $id, ingredient: $ingredient)';
}


}

/// @nodoc
abstract mixin class $FavoriteItemCopyWith<$Res>  {
  factory $FavoriteItemCopyWith(FavoriteItem value, $Res Function(FavoriteItem) _then) = _$FavoriteItemCopyWithImpl;
@useResult
$Res call({
 String id, Ingredient ingredient
});


$IngredientCopyWith<$Res> get ingredient;

}
/// @nodoc
class _$FavoriteItemCopyWithImpl<$Res>
    implements $FavoriteItemCopyWith<$Res> {
  _$FavoriteItemCopyWithImpl(this._self, this._then);

  final FavoriteItem _self;
  final $Res Function(FavoriteItem) _then;

/// Create a copy of FavoriteItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ingredient = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ingredient: null == ingredient ? _self.ingredient : ingredient // ignore: cast_nullable_to_non_nullable
as Ingredient,
  ));
}
/// Create a copy of FavoriteItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IngredientCopyWith<$Res> get ingredient {
  
  return $IngredientCopyWith<$Res>(_self.ingredient, (value) {
    return _then(_self.copyWith(ingredient: value));
  });
}
}


/// Adds pattern-matching-related methods to [FavoriteItem].
extension FavoriteItemPatterns on FavoriteItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteItem value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteItem value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Ingredient ingredient)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteItem() when $default != null:
return $default(_that.id,_that.ingredient);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Ingredient ingredient)  $default,) {final _that = this;
switch (_that) {
case _FavoriteItem():
return $default(_that.id,_that.ingredient);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Ingredient ingredient)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteItem() when $default != null:
return $default(_that.id,_that.ingredient);case _:
  return null;

}
}

}

/// @nodoc


class _FavoriteItem implements FavoriteItem {
  const _FavoriteItem({required this.id, required this.ingredient});
  

@override final  String id;
@override final  Ingredient ingredient;

/// Create a copy of FavoriteItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteItemCopyWith<_FavoriteItem> get copyWith => __$FavoriteItemCopyWithImpl<_FavoriteItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteItem&&(identical(other.id, id) || other.id == id)&&(identical(other.ingredient, ingredient) || other.ingredient == ingredient));
}


@override
int get hashCode => Object.hash(runtimeType,id,ingredient);

@override
String toString() {
  return 'FavoriteItem(id: $id, ingredient: $ingredient)';
}


}

/// @nodoc
abstract mixin class _$FavoriteItemCopyWith<$Res> implements $FavoriteItemCopyWith<$Res> {
  factory _$FavoriteItemCopyWith(_FavoriteItem value, $Res Function(_FavoriteItem) _then) = __$FavoriteItemCopyWithImpl;
@override @useResult
$Res call({
 String id, Ingredient ingredient
});


@override $IngredientCopyWith<$Res> get ingredient;

}
/// @nodoc
class __$FavoriteItemCopyWithImpl<$Res>
    implements _$FavoriteItemCopyWith<$Res> {
  __$FavoriteItemCopyWithImpl(this._self, this._then);

  final _FavoriteItem _self;
  final $Res Function(_FavoriteItem) _then;

/// Create a copy of FavoriteItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ingredient = null,}) {
  return _then(_FavoriteItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ingredient: null == ingredient ? _self.ingredient : ingredient // ignore: cast_nullable_to_non_nullable
as Ingredient,
  ));
}

/// Create a copy of FavoriteItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IngredientCopyWith<$Res> get ingredient {
  
  return $IngredientCopyWith<$Res>(_self.ingredient, (value) {
    return _then(_self.copyWith(ingredient: value));
  });
}
}

// dart format on
