// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SkinProfile {

 int? get age; String? get gender; String get skinType; List<String> get concerns; List<String> get allergies; List<String> get preferredIngredients; List<String> get avoidIngredients; List<String> get goals;
/// Create a copy of SkinProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkinProfileCopyWith<SkinProfile> get copyWith => _$SkinProfileCopyWithImpl<SkinProfile>(this as SkinProfile, _$identity);

  /// Serializes this SkinProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkinProfile&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.skinType, skinType) || other.skinType == skinType)&&const DeepCollectionEquality().equals(other.concerns, concerns)&&const DeepCollectionEquality().equals(other.allergies, allergies)&&const DeepCollectionEquality().equals(other.preferredIngredients, preferredIngredients)&&const DeepCollectionEquality().equals(other.avoidIngredients, avoidIngredients)&&const DeepCollectionEquality().equals(other.goals, goals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,age,gender,skinType,const DeepCollectionEquality().hash(concerns),const DeepCollectionEquality().hash(allergies),const DeepCollectionEquality().hash(preferredIngredients),const DeepCollectionEquality().hash(avoidIngredients),const DeepCollectionEquality().hash(goals));

@override
String toString() {
  return 'SkinProfile(age: $age, gender: $gender, skinType: $skinType, concerns: $concerns, allergies: $allergies, preferredIngredients: $preferredIngredients, avoidIngredients: $avoidIngredients, goals: $goals)';
}


}

/// @nodoc
abstract mixin class $SkinProfileCopyWith<$Res>  {
  factory $SkinProfileCopyWith(SkinProfile value, $Res Function(SkinProfile) _then) = _$SkinProfileCopyWithImpl;
@useResult
$Res call({
 int? age, String? gender, String skinType, List<String> concerns, List<String> allergies, List<String> preferredIngredients, List<String> avoidIngredients, List<String> goals
});




}
/// @nodoc
class _$SkinProfileCopyWithImpl<$Res>
    implements $SkinProfileCopyWith<$Res> {
  _$SkinProfileCopyWithImpl(this._self, this._then);

  final SkinProfile _self;
  final $Res Function(SkinProfile) _then;

/// Create a copy of SkinProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? age = freezed,Object? gender = freezed,Object? skinType = null,Object? concerns = null,Object? allergies = null,Object? preferredIngredients = null,Object? avoidIngredients = null,Object? goals = null,}) {
  return _then(_self.copyWith(
age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,skinType: null == skinType ? _self.skinType : skinType // ignore: cast_nullable_to_non_nullable
as String,concerns: null == concerns ? _self.concerns : concerns // ignore: cast_nullable_to_non_nullable
as List<String>,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,preferredIngredients: null == preferredIngredients ? _self.preferredIngredients : preferredIngredients // ignore: cast_nullable_to_non_nullable
as List<String>,avoidIngredients: null == avoidIngredients ? _self.avoidIngredients : avoidIngredients // ignore: cast_nullable_to_non_nullable
as List<String>,goals: null == goals ? _self.goals : goals // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SkinProfile].
extension SkinProfilePatterns on SkinProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SkinProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SkinProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SkinProfile value)  $default,){
final _that = this;
switch (_that) {
case _SkinProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SkinProfile value)?  $default,){
final _that = this;
switch (_that) {
case _SkinProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? age,  String? gender,  String skinType,  List<String> concerns,  List<String> allergies,  List<String> preferredIngredients,  List<String> avoidIngredients,  List<String> goals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SkinProfile() when $default != null:
return $default(_that.age,_that.gender,_that.skinType,_that.concerns,_that.allergies,_that.preferredIngredients,_that.avoidIngredients,_that.goals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? age,  String? gender,  String skinType,  List<String> concerns,  List<String> allergies,  List<String> preferredIngredients,  List<String> avoidIngredients,  List<String> goals)  $default,) {final _that = this;
switch (_that) {
case _SkinProfile():
return $default(_that.age,_that.gender,_that.skinType,_that.concerns,_that.allergies,_that.preferredIngredients,_that.avoidIngredients,_that.goals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? age,  String? gender,  String skinType,  List<String> concerns,  List<String> allergies,  List<String> preferredIngredients,  List<String> avoidIngredients,  List<String> goals)?  $default,) {final _that = this;
switch (_that) {
case _SkinProfile() when $default != null:
return $default(_that.age,_that.gender,_that.skinType,_that.concerns,_that.allergies,_that.preferredIngredients,_that.avoidIngredients,_that.goals);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SkinProfile implements SkinProfile {
  const _SkinProfile({this.age, this.gender, required this.skinType, final  List<String> concerns = const <String>[], final  List<String> allergies = const <String>[], final  List<String> preferredIngredients = const <String>[], final  List<String> avoidIngredients = const <String>[], final  List<String> goals = const <String>[]}): _concerns = concerns,_allergies = allergies,_preferredIngredients = preferredIngredients,_avoidIngredients = avoidIngredients,_goals = goals;
  factory _SkinProfile.fromJson(Map<String, dynamic> json) => _$SkinProfileFromJson(json);

@override final  int? age;
@override final  String? gender;
@override final  String skinType;
 final  List<String> _concerns;
@override@JsonKey() List<String> get concerns {
  if (_concerns is EqualUnmodifiableListView) return _concerns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_concerns);
}

 final  List<String> _allergies;
@override@JsonKey() List<String> get allergies {
  if (_allergies is EqualUnmodifiableListView) return _allergies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allergies);
}

 final  List<String> _preferredIngredients;
@override@JsonKey() List<String> get preferredIngredients {
  if (_preferredIngredients is EqualUnmodifiableListView) return _preferredIngredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_preferredIngredients);
}

 final  List<String> _avoidIngredients;
@override@JsonKey() List<String> get avoidIngredients {
  if (_avoidIngredients is EqualUnmodifiableListView) return _avoidIngredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_avoidIngredients);
}

 final  List<String> _goals;
@override@JsonKey() List<String> get goals {
  if (_goals is EqualUnmodifiableListView) return _goals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_goals);
}


/// Create a copy of SkinProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SkinProfileCopyWith<_SkinProfile> get copyWith => __$SkinProfileCopyWithImpl<_SkinProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SkinProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkinProfile&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.skinType, skinType) || other.skinType == skinType)&&const DeepCollectionEquality().equals(other._concerns, _concerns)&&const DeepCollectionEquality().equals(other._allergies, _allergies)&&const DeepCollectionEquality().equals(other._preferredIngredients, _preferredIngredients)&&const DeepCollectionEquality().equals(other._avoidIngredients, _avoidIngredients)&&const DeepCollectionEquality().equals(other._goals, _goals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,age,gender,skinType,const DeepCollectionEquality().hash(_concerns),const DeepCollectionEquality().hash(_allergies),const DeepCollectionEquality().hash(_preferredIngredients),const DeepCollectionEquality().hash(_avoidIngredients),const DeepCollectionEquality().hash(_goals));

@override
String toString() {
  return 'SkinProfile(age: $age, gender: $gender, skinType: $skinType, concerns: $concerns, allergies: $allergies, preferredIngredients: $preferredIngredients, avoidIngredients: $avoidIngredients, goals: $goals)';
}


}

/// @nodoc
abstract mixin class _$SkinProfileCopyWith<$Res> implements $SkinProfileCopyWith<$Res> {
  factory _$SkinProfileCopyWith(_SkinProfile value, $Res Function(_SkinProfile) _then) = __$SkinProfileCopyWithImpl;
@override @useResult
$Res call({
 int? age, String? gender, String skinType, List<String> concerns, List<String> allergies, List<String> preferredIngredients, List<String> avoidIngredients, List<String> goals
});




}
/// @nodoc
class __$SkinProfileCopyWithImpl<$Res>
    implements _$SkinProfileCopyWith<$Res> {
  __$SkinProfileCopyWithImpl(this._self, this._then);

  final _SkinProfile _self;
  final $Res Function(_SkinProfile) _then;

/// Create a copy of SkinProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? age = freezed,Object? gender = freezed,Object? skinType = null,Object? concerns = null,Object? allergies = null,Object? preferredIngredients = null,Object? avoidIngredients = null,Object? goals = null,}) {
  return _then(_SkinProfile(
age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,skinType: null == skinType ? _self.skinType : skinType // ignore: cast_nullable_to_non_nullable
as String,concerns: null == concerns ? _self._concerns : concerns // ignore: cast_nullable_to_non_nullable
as List<String>,allergies: null == allergies ? _self._allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,preferredIngredients: null == preferredIngredients ? _self._preferredIngredients : preferredIngredients // ignore: cast_nullable_to_non_nullable
as List<String>,avoidIngredients: null == avoidIngredients ? _self._avoidIngredients : avoidIngredients // ignore: cast_nullable_to_non_nullable
as List<String>,goals: null == goals ? _self._goals : goals // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$PremiumStatus {

 String get plan; DateTime get activatedAt; DateTime get expiresAt;
/// Create a copy of PremiumStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PremiumStatusCopyWith<PremiumStatus> get copyWith => _$PremiumStatusCopyWithImpl<PremiumStatus>(this as PremiumStatus, _$identity);

  /// Serializes this PremiumStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PremiumStatus&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.activatedAt, activatedAt) || other.activatedAt == activatedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,plan,activatedAt,expiresAt);

@override
String toString() {
  return 'PremiumStatus(plan: $plan, activatedAt: $activatedAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $PremiumStatusCopyWith<$Res>  {
  factory $PremiumStatusCopyWith(PremiumStatus value, $Res Function(PremiumStatus) _then) = _$PremiumStatusCopyWithImpl;
@useResult
$Res call({
 String plan, DateTime activatedAt, DateTime expiresAt
});




}
/// @nodoc
class _$PremiumStatusCopyWithImpl<$Res>
    implements $PremiumStatusCopyWith<$Res> {
  _$PremiumStatusCopyWithImpl(this._self, this._then);

  final PremiumStatus _self;
  final $Res Function(PremiumStatus) _then;

/// Create a copy of PremiumStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plan = null,Object? activatedAt = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as String,activatedAt: null == activatedAt ? _self.activatedAt : activatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PremiumStatus].
extension PremiumStatusPatterns on PremiumStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PremiumStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PremiumStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PremiumStatus value)  $default,){
final _that = this;
switch (_that) {
case _PremiumStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PremiumStatus value)?  $default,){
final _that = this;
switch (_that) {
case _PremiumStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String plan,  DateTime activatedAt,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PremiumStatus() when $default != null:
return $default(_that.plan,_that.activatedAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String plan,  DateTime activatedAt,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _PremiumStatus():
return $default(_that.plan,_that.activatedAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String plan,  DateTime activatedAt,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _PremiumStatus() when $default != null:
return $default(_that.plan,_that.activatedAt,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PremiumStatus implements PremiumStatus {
  const _PremiumStatus({required this.plan, required this.activatedAt, required this.expiresAt});
  factory _PremiumStatus.fromJson(Map<String, dynamic> json) => _$PremiumStatusFromJson(json);

@override final  String plan;
@override final  DateTime activatedAt;
@override final  DateTime expiresAt;

/// Create a copy of PremiumStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PremiumStatusCopyWith<_PremiumStatus> get copyWith => __$PremiumStatusCopyWithImpl<_PremiumStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PremiumStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PremiumStatus&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.activatedAt, activatedAt) || other.activatedAt == activatedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,plan,activatedAt,expiresAt);

@override
String toString() {
  return 'PremiumStatus(plan: $plan, activatedAt: $activatedAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$PremiumStatusCopyWith<$Res> implements $PremiumStatusCopyWith<$Res> {
  factory _$PremiumStatusCopyWith(_PremiumStatus value, $Res Function(_PremiumStatus) _then) = __$PremiumStatusCopyWithImpl;
@override @useResult
$Res call({
 String plan, DateTime activatedAt, DateTime expiresAt
});




}
/// @nodoc
class __$PremiumStatusCopyWithImpl<$Res>
    implements _$PremiumStatusCopyWith<$Res> {
  __$PremiumStatusCopyWithImpl(this._self, this._then);

  final _PremiumStatus _self;
  final $Res Function(_PremiumStatus) _then;

/// Create a copy of PremiumStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plan = null,Object? activatedAt = null,Object? expiresAt = null,}) {
  return _then(_PremiumStatus(
plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as String,activatedAt: null == activatedAt ? _self.activatedAt : activatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$User {

 String get id; String get name; String get email; String get role; String? get avatarUrl; SkinProfile? get skinProfile; PremiumStatus? get premium;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.skinProfile, skinProfile) || other.skinProfile == skinProfile)&&(identical(other.premium, premium) || other.premium == premium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,role,avatarUrl,skinProfile,premium);

@override
String toString() {
  return 'User(id: $id, name: $name, email: $email, role: $role, avatarUrl: $avatarUrl, skinProfile: $skinProfile, premium: $premium)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, String role, String? avatarUrl, SkinProfile? skinProfile, PremiumStatus? premium
});


$SkinProfileCopyWith<$Res>? get skinProfile;$PremiumStatusCopyWith<$Res>? get premium;

}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? role = null,Object? avatarUrl = freezed,Object? skinProfile = freezed,Object? premium = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,skinProfile: freezed == skinProfile ? _self.skinProfile : skinProfile // ignore: cast_nullable_to_non_nullable
as SkinProfile?,premium: freezed == premium ? _self.premium : premium // ignore: cast_nullable_to_non_nullable
as PremiumStatus?,
  ));
}
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SkinProfileCopyWith<$Res>? get skinProfile {
    if (_self.skinProfile == null) {
    return null;
  }

  return $SkinProfileCopyWith<$Res>(_self.skinProfile!, (value) {
    return _then(_self.copyWith(skinProfile: value));
  });
}/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PremiumStatusCopyWith<$Res>? get premium {
    if (_self.premium == null) {
    return null;
  }

  return $PremiumStatusCopyWith<$Res>(_self.premium!, (value) {
    return _then(_self.copyWith(premium: value));
  });
}
}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String role,  String? avatarUrl,  SkinProfile? skinProfile,  PremiumStatus? premium)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.role,_that.avatarUrl,_that.skinProfile,_that.premium);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String role,  String? avatarUrl,  SkinProfile? skinProfile,  PremiumStatus? premium)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.name,_that.email,_that.role,_that.avatarUrl,_that.skinProfile,_that.premium);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  String role,  String? avatarUrl,  SkinProfile? skinProfile,  PremiumStatus? premium)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.role,_that.avatarUrl,_that.skinProfile,_that.premium);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User extends User {
  const _User({required this.id, required this.name, required this.email, this.role = 'user', this.avatarUrl, this.skinProfile, this.premium}): super._();
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  String id;
@override final  String name;
@override final  String email;
@override@JsonKey() final  String role;
@override final  String? avatarUrl;
@override final  SkinProfile? skinProfile;
@override final  PremiumStatus? premium;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.skinProfile, skinProfile) || other.skinProfile == skinProfile)&&(identical(other.premium, premium) || other.premium == premium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,role,avatarUrl,skinProfile,premium);

@override
String toString() {
  return 'User(id: $id, name: $name, email: $email, role: $role, avatarUrl: $avatarUrl, skinProfile: $skinProfile, premium: $premium)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, String role, String? avatarUrl, SkinProfile? skinProfile, PremiumStatus? premium
});


@override $SkinProfileCopyWith<$Res>? get skinProfile;@override $PremiumStatusCopyWith<$Res>? get premium;

}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? role = null,Object? avatarUrl = freezed,Object? skinProfile = freezed,Object? premium = freezed,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,skinProfile: freezed == skinProfile ? _self.skinProfile : skinProfile // ignore: cast_nullable_to_non_nullable
as SkinProfile?,premium: freezed == premium ? _self.premium : premium // ignore: cast_nullable_to_non_nullable
as PremiumStatus?,
  ));
}

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SkinProfileCopyWith<$Res>? get skinProfile {
    if (_self.skinProfile == null) {
    return null;
  }

  return $SkinProfileCopyWith<$Res>(_self.skinProfile!, (value) {
    return _then(_self.copyWith(skinProfile: value));
  });
}/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PremiumStatusCopyWith<$Res>? get premium {
    if (_self.premium == null) {
    return null;
  }

  return $PremiumStatusCopyWith<$Res>(_self.premium!, (value) {
    return _then(_self.copyWith(premium: value));
  });
}
}

// dart format on
