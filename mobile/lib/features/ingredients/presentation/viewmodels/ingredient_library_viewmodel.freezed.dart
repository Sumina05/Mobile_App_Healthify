// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingredient_library_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IngredientLibraryState {

 Ingredient? get ingredientOfTheDay; List<Ingredient> get recommended; List<Ingredient> get results; String get query; bool get isSearching;
/// Create a copy of IngredientLibraryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngredientLibraryStateCopyWith<IngredientLibraryState> get copyWith => _$IngredientLibraryStateCopyWithImpl<IngredientLibraryState>(this as IngredientLibraryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IngredientLibraryState&&(identical(other.ingredientOfTheDay, ingredientOfTheDay) || other.ingredientOfTheDay == ingredientOfTheDay)&&const DeepCollectionEquality().equals(other.recommended, recommended)&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.query, query) || other.query == query)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching));
}


@override
int get hashCode => Object.hash(runtimeType,ingredientOfTheDay,const DeepCollectionEquality().hash(recommended),const DeepCollectionEquality().hash(results),query,isSearching);

@override
String toString() {
  return 'IngredientLibraryState(ingredientOfTheDay: $ingredientOfTheDay, recommended: $recommended, results: $results, query: $query, isSearching: $isSearching)';
}


}

/// @nodoc
abstract mixin class $IngredientLibraryStateCopyWith<$Res>  {
  factory $IngredientLibraryStateCopyWith(IngredientLibraryState value, $Res Function(IngredientLibraryState) _then) = _$IngredientLibraryStateCopyWithImpl;
@useResult
$Res call({
 Ingredient? ingredientOfTheDay, List<Ingredient> recommended, List<Ingredient> results, String query, bool isSearching
});


$IngredientCopyWith<$Res>? get ingredientOfTheDay;

}
/// @nodoc
class _$IngredientLibraryStateCopyWithImpl<$Res>
    implements $IngredientLibraryStateCopyWith<$Res> {
  _$IngredientLibraryStateCopyWithImpl(this._self, this._then);

  final IngredientLibraryState _self;
  final $Res Function(IngredientLibraryState) _then;

/// Create a copy of IngredientLibraryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ingredientOfTheDay = freezed,Object? recommended = null,Object? results = null,Object? query = null,Object? isSearching = null,}) {
  return _then(_self.copyWith(
ingredientOfTheDay: freezed == ingredientOfTheDay ? _self.ingredientOfTheDay : ingredientOfTheDay // ignore: cast_nullable_to_non_nullable
as Ingredient?,recommended: null == recommended ? _self.recommended : recommended // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of IngredientLibraryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IngredientCopyWith<$Res>? get ingredientOfTheDay {
    if (_self.ingredientOfTheDay == null) {
    return null;
  }

  return $IngredientCopyWith<$Res>(_self.ingredientOfTheDay!, (value) {
    return _then(_self.copyWith(ingredientOfTheDay: value));
  });
}
}


/// Adds pattern-matching-related methods to [IngredientLibraryState].
extension IngredientLibraryStatePatterns on IngredientLibraryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IngredientLibraryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IngredientLibraryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IngredientLibraryState value)  $default,){
final _that = this;
switch (_that) {
case _IngredientLibraryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IngredientLibraryState value)?  $default,){
final _that = this;
switch (_that) {
case _IngredientLibraryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Ingredient? ingredientOfTheDay,  List<Ingredient> recommended,  List<Ingredient> results,  String query,  bool isSearching)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IngredientLibraryState() when $default != null:
return $default(_that.ingredientOfTheDay,_that.recommended,_that.results,_that.query,_that.isSearching);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Ingredient? ingredientOfTheDay,  List<Ingredient> recommended,  List<Ingredient> results,  String query,  bool isSearching)  $default,) {final _that = this;
switch (_that) {
case _IngredientLibraryState():
return $default(_that.ingredientOfTheDay,_that.recommended,_that.results,_that.query,_that.isSearching);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Ingredient? ingredientOfTheDay,  List<Ingredient> recommended,  List<Ingredient> results,  String query,  bool isSearching)?  $default,) {final _that = this;
switch (_that) {
case _IngredientLibraryState() when $default != null:
return $default(_that.ingredientOfTheDay,_that.recommended,_that.results,_that.query,_that.isSearching);case _:
  return null;

}
}

}

/// @nodoc


class _IngredientLibraryState extends IngredientLibraryState {
  const _IngredientLibraryState({this.ingredientOfTheDay, final  List<Ingredient> recommended = const <Ingredient>[], final  List<Ingredient> results = const <Ingredient>[], this.query = '', this.isSearching = false}): _recommended = recommended,_results = results,super._();
  

@override final  Ingredient? ingredientOfTheDay;
 final  List<Ingredient> _recommended;
@override@JsonKey() List<Ingredient> get recommended {
  if (_recommended is EqualUnmodifiableListView) return _recommended;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommended);
}

 final  List<Ingredient> _results;
@override@JsonKey() List<Ingredient> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@JsonKey() final  String query;
@override@JsonKey() final  bool isSearching;

/// Create a copy of IngredientLibraryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IngredientLibraryStateCopyWith<_IngredientLibraryState> get copyWith => __$IngredientLibraryStateCopyWithImpl<_IngredientLibraryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IngredientLibraryState&&(identical(other.ingredientOfTheDay, ingredientOfTheDay) || other.ingredientOfTheDay == ingredientOfTheDay)&&const DeepCollectionEquality().equals(other._recommended, _recommended)&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.query, query) || other.query == query)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching));
}


@override
int get hashCode => Object.hash(runtimeType,ingredientOfTheDay,const DeepCollectionEquality().hash(_recommended),const DeepCollectionEquality().hash(_results),query,isSearching);

@override
String toString() {
  return 'IngredientLibraryState(ingredientOfTheDay: $ingredientOfTheDay, recommended: $recommended, results: $results, query: $query, isSearching: $isSearching)';
}


}

/// @nodoc
abstract mixin class _$IngredientLibraryStateCopyWith<$Res> implements $IngredientLibraryStateCopyWith<$Res> {
  factory _$IngredientLibraryStateCopyWith(_IngredientLibraryState value, $Res Function(_IngredientLibraryState) _then) = __$IngredientLibraryStateCopyWithImpl;
@override @useResult
$Res call({
 Ingredient? ingredientOfTheDay, List<Ingredient> recommended, List<Ingredient> results, String query, bool isSearching
});


@override $IngredientCopyWith<$Res>? get ingredientOfTheDay;

}
/// @nodoc
class __$IngredientLibraryStateCopyWithImpl<$Res>
    implements _$IngredientLibraryStateCopyWith<$Res> {
  __$IngredientLibraryStateCopyWithImpl(this._self, this._then);

  final _IngredientLibraryState _self;
  final $Res Function(_IngredientLibraryState) _then;

/// Create a copy of IngredientLibraryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ingredientOfTheDay = freezed,Object? recommended = null,Object? results = null,Object? query = null,Object? isSearching = null,}) {
  return _then(_IngredientLibraryState(
ingredientOfTheDay: freezed == ingredientOfTheDay ? _self.ingredientOfTheDay : ingredientOfTheDay // ignore: cast_nullable_to_non_nullable
as Ingredient?,recommended: null == recommended ? _self._recommended : recommended // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of IngredientLibraryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IngredientCopyWith<$Res>? get ingredientOfTheDay {
    if (_self.ingredientOfTheDay == null) {
    return null;
  }

  return $IngredientCopyWith<$Res>(_self.ingredientOfTheDay!, (value) {
    return _then(_self.copyWith(ingredientOfTheDay: value));
  });
}
}

// dart format on
