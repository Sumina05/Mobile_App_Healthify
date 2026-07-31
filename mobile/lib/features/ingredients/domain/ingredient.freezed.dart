// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingredient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Ingredient {

 String get id; String get name; List<String> get aliases; String get tagline; String get purpose; String get description; List<String> get benefits; List<String> get sideEffects; String get safetyRating; List<String> get goodForSkinTypes; List<String> get cautionForSkinTypes; List<String> get concernsTargeted; bool get isCommonAllergen;
/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngredientCopyWith<Ingredient> get copyWith => _$IngredientCopyWithImpl<Ingredient>(this as Ingredient, _$identity);

  /// Serializes this Ingredient to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ingredient&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.aliases, aliases)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.benefits, benefits)&&const DeepCollectionEquality().equals(other.sideEffects, sideEffects)&&(identical(other.safetyRating, safetyRating) || other.safetyRating == safetyRating)&&const DeepCollectionEquality().equals(other.goodForSkinTypes, goodForSkinTypes)&&const DeepCollectionEquality().equals(other.cautionForSkinTypes, cautionForSkinTypes)&&const DeepCollectionEquality().equals(other.concernsTargeted, concernsTargeted)&&(identical(other.isCommonAllergen, isCommonAllergen) || other.isCommonAllergen == isCommonAllergen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(aliases),tagline,purpose,description,const DeepCollectionEquality().hash(benefits),const DeepCollectionEquality().hash(sideEffects),safetyRating,const DeepCollectionEquality().hash(goodForSkinTypes),const DeepCollectionEquality().hash(cautionForSkinTypes),const DeepCollectionEquality().hash(concernsTargeted),isCommonAllergen);

@override
String toString() {
  return 'Ingredient(id: $id, name: $name, aliases: $aliases, tagline: $tagline, purpose: $purpose, description: $description, benefits: $benefits, sideEffects: $sideEffects, safetyRating: $safetyRating, goodForSkinTypes: $goodForSkinTypes, cautionForSkinTypes: $cautionForSkinTypes, concernsTargeted: $concernsTargeted, isCommonAllergen: $isCommonAllergen)';
}


}

/// @nodoc
abstract mixin class $IngredientCopyWith<$Res>  {
  factory $IngredientCopyWith(Ingredient value, $Res Function(Ingredient) _then) = _$IngredientCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<String> aliases, String tagline, String purpose, String description, List<String> benefits, List<String> sideEffects, String safetyRating, List<String> goodForSkinTypes, List<String> cautionForSkinTypes, List<String> concernsTargeted, bool isCommonAllergen
});




}
/// @nodoc
class _$IngredientCopyWithImpl<$Res>
    implements $IngredientCopyWith<$Res> {
  _$IngredientCopyWithImpl(this._self, this._then);

  final Ingredient _self;
  final $Res Function(Ingredient) _then;

/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? aliases = null,Object? tagline = null,Object? purpose = null,Object? description = null,Object? benefits = null,Object? sideEffects = null,Object? safetyRating = null,Object? goodForSkinTypes = null,Object? cautionForSkinTypes = null,Object? concernsTargeted = null,Object? isCommonAllergen = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,aliases: null == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,tagline: null == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,benefits: null == benefits ? _self.benefits : benefits // ignore: cast_nullable_to_non_nullable
as List<String>,sideEffects: null == sideEffects ? _self.sideEffects : sideEffects // ignore: cast_nullable_to_non_nullable
as List<String>,safetyRating: null == safetyRating ? _self.safetyRating : safetyRating // ignore: cast_nullable_to_non_nullable
as String,goodForSkinTypes: null == goodForSkinTypes ? _self.goodForSkinTypes : goodForSkinTypes // ignore: cast_nullable_to_non_nullable
as List<String>,cautionForSkinTypes: null == cautionForSkinTypes ? _self.cautionForSkinTypes : cautionForSkinTypes // ignore: cast_nullable_to_non_nullable
as List<String>,concernsTargeted: null == concernsTargeted ? _self.concernsTargeted : concernsTargeted // ignore: cast_nullable_to_non_nullable
as List<String>,isCommonAllergen: null == isCommonAllergen ? _self.isCommonAllergen : isCommonAllergen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Ingredient].
extension IngredientPatterns on Ingredient {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ingredient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ingredient() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ingredient value)  $default,){
final _that = this;
switch (_that) {
case _Ingredient():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ingredient value)?  $default,){
final _that = this;
switch (_that) {
case _Ingredient() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<String> aliases,  String tagline,  String purpose,  String description,  List<String> benefits,  List<String> sideEffects,  String safetyRating,  List<String> goodForSkinTypes,  List<String> cautionForSkinTypes,  List<String> concernsTargeted,  bool isCommonAllergen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ingredient() when $default != null:
return $default(_that.id,_that.name,_that.aliases,_that.tagline,_that.purpose,_that.description,_that.benefits,_that.sideEffects,_that.safetyRating,_that.goodForSkinTypes,_that.cautionForSkinTypes,_that.concernsTargeted,_that.isCommonAllergen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<String> aliases,  String tagline,  String purpose,  String description,  List<String> benefits,  List<String> sideEffects,  String safetyRating,  List<String> goodForSkinTypes,  List<String> cautionForSkinTypes,  List<String> concernsTargeted,  bool isCommonAllergen)  $default,) {final _that = this;
switch (_that) {
case _Ingredient():
return $default(_that.id,_that.name,_that.aliases,_that.tagline,_that.purpose,_that.description,_that.benefits,_that.sideEffects,_that.safetyRating,_that.goodForSkinTypes,_that.cautionForSkinTypes,_that.concernsTargeted,_that.isCommonAllergen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<String> aliases,  String tagline,  String purpose,  String description,  List<String> benefits,  List<String> sideEffects,  String safetyRating,  List<String> goodForSkinTypes,  List<String> cautionForSkinTypes,  List<String> concernsTargeted,  bool isCommonAllergen)?  $default,) {final _that = this;
switch (_that) {
case _Ingredient() when $default != null:
return $default(_that.id,_that.name,_that.aliases,_that.tagline,_that.purpose,_that.description,_that.benefits,_that.sideEffects,_that.safetyRating,_that.goodForSkinTypes,_that.cautionForSkinTypes,_that.concernsTargeted,_that.isCommonAllergen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Ingredient implements Ingredient {
  const _Ingredient({required this.id, required this.name, final  List<String> aliases = const <String>[], required this.tagline, required this.purpose, required this.description, final  List<String> benefits = const <String>[], final  List<String> sideEffects = const <String>[], required this.safetyRating, final  List<String> goodForSkinTypes = const <String>[], final  List<String> cautionForSkinTypes = const <String>[], final  List<String> concernsTargeted = const <String>[], this.isCommonAllergen = false}): _aliases = aliases,_benefits = benefits,_sideEffects = sideEffects,_goodForSkinTypes = goodForSkinTypes,_cautionForSkinTypes = cautionForSkinTypes,_concernsTargeted = concernsTargeted;
  factory _Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);

@override final  String id;
@override final  String name;
 final  List<String> _aliases;
@override@JsonKey() List<String> get aliases {
  if (_aliases is EqualUnmodifiableListView) return _aliases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aliases);
}

@override final  String tagline;
@override final  String purpose;
@override final  String description;
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

@override final  String safetyRating;
 final  List<String> _goodForSkinTypes;
@override@JsonKey() List<String> get goodForSkinTypes {
  if (_goodForSkinTypes is EqualUnmodifiableListView) return _goodForSkinTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_goodForSkinTypes);
}

 final  List<String> _cautionForSkinTypes;
@override@JsonKey() List<String> get cautionForSkinTypes {
  if (_cautionForSkinTypes is EqualUnmodifiableListView) return _cautionForSkinTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cautionForSkinTypes);
}

 final  List<String> _concernsTargeted;
@override@JsonKey() List<String> get concernsTargeted {
  if (_concernsTargeted is EqualUnmodifiableListView) return _concernsTargeted;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_concernsTargeted);
}

@override@JsonKey() final  bool isCommonAllergen;

/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IngredientCopyWith<_Ingredient> get copyWith => __$IngredientCopyWithImpl<_Ingredient>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IngredientToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ingredient&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._aliases, _aliases)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._benefits, _benefits)&&const DeepCollectionEquality().equals(other._sideEffects, _sideEffects)&&(identical(other.safetyRating, safetyRating) || other.safetyRating == safetyRating)&&const DeepCollectionEquality().equals(other._goodForSkinTypes, _goodForSkinTypes)&&const DeepCollectionEquality().equals(other._cautionForSkinTypes, _cautionForSkinTypes)&&const DeepCollectionEquality().equals(other._concernsTargeted, _concernsTargeted)&&(identical(other.isCommonAllergen, isCommonAllergen) || other.isCommonAllergen == isCommonAllergen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_aliases),tagline,purpose,description,const DeepCollectionEquality().hash(_benefits),const DeepCollectionEquality().hash(_sideEffects),safetyRating,const DeepCollectionEquality().hash(_goodForSkinTypes),const DeepCollectionEquality().hash(_cautionForSkinTypes),const DeepCollectionEquality().hash(_concernsTargeted),isCommonAllergen);

@override
String toString() {
  return 'Ingredient(id: $id, name: $name, aliases: $aliases, tagline: $tagline, purpose: $purpose, description: $description, benefits: $benefits, sideEffects: $sideEffects, safetyRating: $safetyRating, goodForSkinTypes: $goodForSkinTypes, cautionForSkinTypes: $cautionForSkinTypes, concernsTargeted: $concernsTargeted, isCommonAllergen: $isCommonAllergen)';
}


}

/// @nodoc
abstract mixin class _$IngredientCopyWith<$Res> implements $IngredientCopyWith<$Res> {
  factory _$IngredientCopyWith(_Ingredient value, $Res Function(_Ingredient) _then) = __$IngredientCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<String> aliases, String tagline, String purpose, String description, List<String> benefits, List<String> sideEffects, String safetyRating, List<String> goodForSkinTypes, List<String> cautionForSkinTypes, List<String> concernsTargeted, bool isCommonAllergen
});




}
/// @nodoc
class __$IngredientCopyWithImpl<$Res>
    implements _$IngredientCopyWith<$Res> {
  __$IngredientCopyWithImpl(this._self, this._then);

  final _Ingredient _self;
  final $Res Function(_Ingredient) _then;

/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? aliases = null,Object? tagline = null,Object? purpose = null,Object? description = null,Object? benefits = null,Object? sideEffects = null,Object? safetyRating = null,Object? goodForSkinTypes = null,Object? cautionForSkinTypes = null,Object? concernsTargeted = null,Object? isCommonAllergen = null,}) {
  return _then(_Ingredient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,aliases: null == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,tagline: null == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,benefits: null == benefits ? _self._benefits : benefits // ignore: cast_nullable_to_non_nullable
as List<String>,sideEffects: null == sideEffects ? _self._sideEffects : sideEffects // ignore: cast_nullable_to_non_nullable
as List<String>,safetyRating: null == safetyRating ? _self.safetyRating : safetyRating // ignore: cast_nullable_to_non_nullable
as String,goodForSkinTypes: null == goodForSkinTypes ? _self._goodForSkinTypes : goodForSkinTypes // ignore: cast_nullable_to_non_nullable
as List<String>,cautionForSkinTypes: null == cautionForSkinTypes ? _self._cautionForSkinTypes : cautionForSkinTypes // ignore: cast_nullable_to_non_nullable
as List<String>,concernsTargeted: null == concernsTargeted ? _self._concernsTargeted : concernsTargeted // ignore: cast_nullable_to_non_nullable
as List<String>,isCommonAllergen: null == isCommonAllergen ? _self.isCommonAllergen : isCommonAllergen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
