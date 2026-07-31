// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'skin_profile_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SkinProfileForm {

 int get step; int? get age; String? get gender; String? get skinType; Set<String> get concerns; Set<String> get allergies; Set<String> get goals; bool get submitting;
/// Create a copy of SkinProfileForm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkinProfileFormCopyWith<SkinProfileForm> get copyWith => _$SkinProfileFormCopyWithImpl<SkinProfileForm>(this as SkinProfileForm, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkinProfileForm&&(identical(other.step, step) || other.step == step)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.skinType, skinType) || other.skinType == skinType)&&const DeepCollectionEquality().equals(other.concerns, concerns)&&const DeepCollectionEquality().equals(other.allergies, allergies)&&const DeepCollectionEquality().equals(other.goals, goals)&&(identical(other.submitting, submitting) || other.submitting == submitting));
}


@override
int get hashCode => Object.hash(runtimeType,step,age,gender,skinType,const DeepCollectionEquality().hash(concerns),const DeepCollectionEquality().hash(allergies),const DeepCollectionEquality().hash(goals),submitting);

@override
String toString() {
  return 'SkinProfileForm(step: $step, age: $age, gender: $gender, skinType: $skinType, concerns: $concerns, allergies: $allergies, goals: $goals, submitting: $submitting)';
}


}

/// @nodoc
abstract mixin class $SkinProfileFormCopyWith<$Res>  {
  factory $SkinProfileFormCopyWith(SkinProfileForm value, $Res Function(SkinProfileForm) _then) = _$SkinProfileFormCopyWithImpl;
@useResult
$Res call({
 int step, int? age, String? gender, String? skinType, Set<String> concerns, Set<String> allergies, Set<String> goals, bool submitting
});




}
/// @nodoc
class _$SkinProfileFormCopyWithImpl<$Res>
    implements $SkinProfileFormCopyWith<$Res> {
  _$SkinProfileFormCopyWithImpl(this._self, this._then);

  final SkinProfileForm _self;
  final $Res Function(SkinProfileForm) _then;

/// Create a copy of SkinProfileForm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? age = freezed,Object? gender = freezed,Object? skinType = freezed,Object? concerns = null,Object? allergies = null,Object? goals = null,Object? submitting = null,}) {
  return _then(_self.copyWith(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,skinType: freezed == skinType ? _self.skinType : skinType // ignore: cast_nullable_to_non_nullable
as String?,concerns: null == concerns ? _self.concerns : concerns // ignore: cast_nullable_to_non_nullable
as Set<String>,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as Set<String>,goals: null == goals ? _self.goals : goals // ignore: cast_nullable_to_non_nullable
as Set<String>,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SkinProfileForm].
extension SkinProfileFormPatterns on SkinProfileForm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SkinProfileForm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SkinProfileForm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SkinProfileForm value)  $default,){
final _that = this;
switch (_that) {
case _SkinProfileForm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SkinProfileForm value)?  $default,){
final _that = this;
switch (_that) {
case _SkinProfileForm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int step,  int? age,  String? gender,  String? skinType,  Set<String> concerns,  Set<String> allergies,  Set<String> goals,  bool submitting)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SkinProfileForm() when $default != null:
return $default(_that.step,_that.age,_that.gender,_that.skinType,_that.concerns,_that.allergies,_that.goals,_that.submitting);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int step,  int? age,  String? gender,  String? skinType,  Set<String> concerns,  Set<String> allergies,  Set<String> goals,  bool submitting)  $default,) {final _that = this;
switch (_that) {
case _SkinProfileForm():
return $default(_that.step,_that.age,_that.gender,_that.skinType,_that.concerns,_that.allergies,_that.goals,_that.submitting);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int step,  int? age,  String? gender,  String? skinType,  Set<String> concerns,  Set<String> allergies,  Set<String> goals,  bool submitting)?  $default,) {final _that = this;
switch (_that) {
case _SkinProfileForm() when $default != null:
return $default(_that.step,_that.age,_that.gender,_that.skinType,_that.concerns,_that.allergies,_that.goals,_that.submitting);case _:
  return null;

}
}

}

/// @nodoc


class _SkinProfileForm implements SkinProfileForm {
  const _SkinProfileForm({this.step = 0, this.age, this.gender, this.skinType, final  Set<String> concerns = const <String>{}, final  Set<String> allergies = const <String>{}, final  Set<String> goals = const <String>{}, this.submitting = false}): _concerns = concerns,_allergies = allergies,_goals = goals;
  

@override@JsonKey() final  int step;
@override final  int? age;
@override final  String? gender;
@override final  String? skinType;
 final  Set<String> _concerns;
@override@JsonKey() Set<String> get concerns {
  if (_concerns is EqualUnmodifiableSetView) return _concerns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_concerns);
}

 final  Set<String> _allergies;
@override@JsonKey() Set<String> get allergies {
  if (_allergies is EqualUnmodifiableSetView) return _allergies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_allergies);
}

 final  Set<String> _goals;
@override@JsonKey() Set<String> get goals {
  if (_goals is EqualUnmodifiableSetView) return _goals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_goals);
}

@override@JsonKey() final  bool submitting;

/// Create a copy of SkinProfileForm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SkinProfileFormCopyWith<_SkinProfileForm> get copyWith => __$SkinProfileFormCopyWithImpl<_SkinProfileForm>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkinProfileForm&&(identical(other.step, step) || other.step == step)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.skinType, skinType) || other.skinType == skinType)&&const DeepCollectionEquality().equals(other._concerns, _concerns)&&const DeepCollectionEquality().equals(other._allergies, _allergies)&&const DeepCollectionEquality().equals(other._goals, _goals)&&(identical(other.submitting, submitting) || other.submitting == submitting));
}


@override
int get hashCode => Object.hash(runtimeType,step,age,gender,skinType,const DeepCollectionEquality().hash(_concerns),const DeepCollectionEquality().hash(_allergies),const DeepCollectionEquality().hash(_goals),submitting);

@override
String toString() {
  return 'SkinProfileForm(step: $step, age: $age, gender: $gender, skinType: $skinType, concerns: $concerns, allergies: $allergies, goals: $goals, submitting: $submitting)';
}


}

/// @nodoc
abstract mixin class _$SkinProfileFormCopyWith<$Res> implements $SkinProfileFormCopyWith<$Res> {
  factory _$SkinProfileFormCopyWith(_SkinProfileForm value, $Res Function(_SkinProfileForm) _then) = __$SkinProfileFormCopyWithImpl;
@override @useResult
$Res call({
 int step, int? age, String? gender, String? skinType, Set<String> concerns, Set<String> allergies, Set<String> goals, bool submitting
});




}
/// @nodoc
class __$SkinProfileFormCopyWithImpl<$Res>
    implements _$SkinProfileFormCopyWith<$Res> {
  __$SkinProfileFormCopyWithImpl(this._self, this._then);

  final _SkinProfileForm _self;
  final $Res Function(_SkinProfileForm) _then;

/// Create a copy of SkinProfileForm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? age = freezed,Object? gender = freezed,Object? skinType = freezed,Object? concerns = null,Object? allergies = null,Object? goals = null,Object? submitting = null,}) {
  return _then(_SkinProfileForm(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,skinType: freezed == skinType ? _self.skinType : skinType // ignore: cast_nullable_to_non_nullable
as String?,concerns: null == concerns ? _self._concerns : concerns // ignore: cast_nullable_to_non_nullable
as Set<String>,allergies: null == allergies ? _self._allergies : allergies // ignore: cast_nullable_to_non_nullable
as Set<String>,goals: null == goals ? _self._goals : goals // ignore: cast_nullable_to_non_nullable
as Set<String>,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
