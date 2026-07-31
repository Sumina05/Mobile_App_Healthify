// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'premium_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PremiumPlan {

 String get id; String get label; int get amountNpr; int get durationDays; String? get savings;
/// Create a copy of PremiumPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PremiumPlanCopyWith<PremiumPlan> get copyWith => _$PremiumPlanCopyWithImpl<PremiumPlan>(this as PremiumPlan, _$identity);

  /// Serializes this PremiumPlan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PremiumPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.amountNpr, amountNpr) || other.amountNpr == amountNpr)&&(identical(other.durationDays, durationDays) || other.durationDays == durationDays)&&(identical(other.savings, savings) || other.savings == savings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,amountNpr,durationDays,savings);

@override
String toString() {
  return 'PremiumPlan(id: $id, label: $label, amountNpr: $amountNpr, durationDays: $durationDays, savings: $savings)';
}


}

/// @nodoc
abstract mixin class $PremiumPlanCopyWith<$Res>  {
  factory $PremiumPlanCopyWith(PremiumPlan value, $Res Function(PremiumPlan) _then) = _$PremiumPlanCopyWithImpl;
@useResult
$Res call({
 String id, String label, int amountNpr, int durationDays, String? savings
});




}
/// @nodoc
class _$PremiumPlanCopyWithImpl<$Res>
    implements $PremiumPlanCopyWith<$Res> {
  _$PremiumPlanCopyWithImpl(this._self, this._then);

  final PremiumPlan _self;
  final $Res Function(PremiumPlan) _then;

/// Create a copy of PremiumPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? amountNpr = null,Object? durationDays = null,Object? savings = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amountNpr: null == amountNpr ? _self.amountNpr : amountNpr // ignore: cast_nullable_to_non_nullable
as int,durationDays: null == durationDays ? _self.durationDays : durationDays // ignore: cast_nullable_to_non_nullable
as int,savings: freezed == savings ? _self.savings : savings // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PremiumPlan].
extension PremiumPlanPatterns on PremiumPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PremiumPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PremiumPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PremiumPlan value)  $default,){
final _that = this;
switch (_that) {
case _PremiumPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PremiumPlan value)?  $default,){
final _that = this;
switch (_that) {
case _PremiumPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  int amountNpr,  int durationDays,  String? savings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PremiumPlan() when $default != null:
return $default(_that.id,_that.label,_that.amountNpr,_that.durationDays,_that.savings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  int amountNpr,  int durationDays,  String? savings)  $default,) {final _that = this;
switch (_that) {
case _PremiumPlan():
return $default(_that.id,_that.label,_that.amountNpr,_that.durationDays,_that.savings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  int amountNpr,  int durationDays,  String? savings)?  $default,) {final _that = this;
switch (_that) {
case _PremiumPlan() when $default != null:
return $default(_that.id,_that.label,_that.amountNpr,_that.durationDays,_that.savings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PremiumPlan implements PremiumPlan {
  const _PremiumPlan({required this.id, required this.label, required this.amountNpr, required this.durationDays, this.savings});
  factory _PremiumPlan.fromJson(Map<String, dynamic> json) => _$PremiumPlanFromJson(json);

@override final  String id;
@override final  String label;
@override final  int amountNpr;
@override final  int durationDays;
@override final  String? savings;

/// Create a copy of PremiumPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PremiumPlanCopyWith<_PremiumPlan> get copyWith => __$PremiumPlanCopyWithImpl<_PremiumPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PremiumPlanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PremiumPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.amountNpr, amountNpr) || other.amountNpr == amountNpr)&&(identical(other.durationDays, durationDays) || other.durationDays == durationDays)&&(identical(other.savings, savings) || other.savings == savings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,amountNpr,durationDays,savings);

@override
String toString() {
  return 'PremiumPlan(id: $id, label: $label, amountNpr: $amountNpr, durationDays: $durationDays, savings: $savings)';
}


}

/// @nodoc
abstract mixin class _$PremiumPlanCopyWith<$Res> implements $PremiumPlanCopyWith<$Res> {
  factory _$PremiumPlanCopyWith(_PremiumPlan value, $Res Function(_PremiumPlan) _then) = __$PremiumPlanCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, int amountNpr, int durationDays, String? savings
});




}
/// @nodoc
class __$PremiumPlanCopyWithImpl<$Res>
    implements _$PremiumPlanCopyWith<$Res> {
  __$PremiumPlanCopyWithImpl(this._self, this._then);

  final _PremiumPlan _self;
  final $Res Function(_PremiumPlan) _then;

/// Create a copy of PremiumPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? amountNpr = null,Object? durationDays = null,Object? savings = freezed,}) {
  return _then(_PremiumPlan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amountNpr: null == amountNpr ? _self.amountNpr : amountNpr // ignore: cast_nullable_to_non_nullable
as int,durationDays: null == durationDays ? _self.durationDays : durationDays // ignore: cast_nullable_to_non_nullable
as int,savings: freezed == savings ? _self.savings : savings // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PlansResponse {

 List<PremiumPlan> get plans; List<String> get features;
/// Create a copy of PlansResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlansResponseCopyWith<PlansResponse> get copyWith => _$PlansResponseCopyWithImpl<PlansResponse>(this as PlansResponse, _$identity);

  /// Serializes this PlansResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlansResponse&&const DeepCollectionEquality().equals(other.plans, plans)&&const DeepCollectionEquality().equals(other.features, features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(plans),const DeepCollectionEquality().hash(features));

@override
String toString() {
  return 'PlansResponse(plans: $plans, features: $features)';
}


}

/// @nodoc
abstract mixin class $PlansResponseCopyWith<$Res>  {
  factory $PlansResponseCopyWith(PlansResponse value, $Res Function(PlansResponse) _then) = _$PlansResponseCopyWithImpl;
@useResult
$Res call({
 List<PremiumPlan> plans, List<String> features
});




}
/// @nodoc
class _$PlansResponseCopyWithImpl<$Res>
    implements $PlansResponseCopyWith<$Res> {
  _$PlansResponseCopyWithImpl(this._self, this._then);

  final PlansResponse _self;
  final $Res Function(PlansResponse) _then;

/// Create a copy of PlansResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plans = null,Object? features = null,}) {
  return _then(_self.copyWith(
plans: null == plans ? _self.plans : plans // ignore: cast_nullable_to_non_nullable
as List<PremiumPlan>,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlansResponse].
extension PlansResponsePatterns on PlansResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlansResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlansResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlansResponse value)  $default,){
final _that = this;
switch (_that) {
case _PlansResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlansResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PlansResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PremiumPlan> plans,  List<String> features)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlansResponse() when $default != null:
return $default(_that.plans,_that.features);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PremiumPlan> plans,  List<String> features)  $default,) {final _that = this;
switch (_that) {
case _PlansResponse():
return $default(_that.plans,_that.features);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PremiumPlan> plans,  List<String> features)?  $default,) {final _that = this;
switch (_that) {
case _PlansResponse() when $default != null:
return $default(_that.plans,_that.features);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlansResponse implements PlansResponse {
  const _PlansResponse({required final  List<PremiumPlan> plans, required final  List<String> features}): _plans = plans,_features = features;
  factory _PlansResponse.fromJson(Map<String, dynamic> json) => _$PlansResponseFromJson(json);

 final  List<PremiumPlan> _plans;
@override List<PremiumPlan> get plans {
  if (_plans is EqualUnmodifiableListView) return _plans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_plans);
}

 final  List<String> _features;
@override List<String> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}


/// Create a copy of PlansResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlansResponseCopyWith<_PlansResponse> get copyWith => __$PlansResponseCopyWithImpl<_PlansResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlansResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlansResponse&&const DeepCollectionEquality().equals(other._plans, _plans)&&const DeepCollectionEquality().equals(other._features, _features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_plans),const DeepCollectionEquality().hash(_features));

@override
String toString() {
  return 'PlansResponse(plans: $plans, features: $features)';
}


}

/// @nodoc
abstract mixin class _$PlansResponseCopyWith<$Res> implements $PlansResponseCopyWith<$Res> {
  factory _$PlansResponseCopyWith(_PlansResponse value, $Res Function(_PlansResponse) _then) = __$PlansResponseCopyWithImpl;
@override @useResult
$Res call({
 List<PremiumPlan> plans, List<String> features
});




}
/// @nodoc
class __$PlansResponseCopyWithImpl<$Res>
    implements _$PlansResponseCopyWith<$Res> {
  __$PlansResponseCopyWithImpl(this._self, this._then);

  final _PlansResponse _self;
  final $Res Function(_PlansResponse) _then;

/// Create a copy of PlansResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plans = null,Object? features = null,}) {
  return _then(_PlansResponse(
plans: null == plans ? _self._plans : plans // ignore: cast_nullable_to_non_nullable
as List<PremiumPlan>,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$CheckoutResult {

 String get paymentId; String get provider; String get status; String? get paymentUrl; String get providerRef;
/// Create a copy of CheckoutResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutResultCopyWith<CheckoutResult> get copyWith => _$CheckoutResultCopyWithImpl<CheckoutResult>(this as CheckoutResult, _$identity);

  /// Serializes this CheckoutResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutResult&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentUrl, paymentUrl) || other.paymentUrl == paymentUrl)&&(identical(other.providerRef, providerRef) || other.providerRef == providerRef));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,paymentId,provider,status,paymentUrl,providerRef);

@override
String toString() {
  return 'CheckoutResult(paymentId: $paymentId, provider: $provider, status: $status, paymentUrl: $paymentUrl, providerRef: $providerRef)';
}


}

/// @nodoc
abstract mixin class $CheckoutResultCopyWith<$Res>  {
  factory $CheckoutResultCopyWith(CheckoutResult value, $Res Function(CheckoutResult) _then) = _$CheckoutResultCopyWithImpl;
@useResult
$Res call({
 String paymentId, String provider, String status, String? paymentUrl, String providerRef
});




}
/// @nodoc
class _$CheckoutResultCopyWithImpl<$Res>
    implements $CheckoutResultCopyWith<$Res> {
  _$CheckoutResultCopyWithImpl(this._self, this._then);

  final CheckoutResult _self;
  final $Res Function(CheckoutResult) _then;

/// Create a copy of CheckoutResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? paymentId = null,Object? provider = null,Object? status = null,Object? paymentUrl = freezed,Object? providerRef = null,}) {
  return _then(_self.copyWith(
paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paymentUrl: freezed == paymentUrl ? _self.paymentUrl : paymentUrl // ignore: cast_nullable_to_non_nullable
as String?,providerRef: null == providerRef ? _self.providerRef : providerRef // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckoutResult].
extension CheckoutResultPatterns on CheckoutResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckoutResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckoutResult value)  $default,){
final _that = this;
switch (_that) {
case _CheckoutResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckoutResult value)?  $default,){
final _that = this;
switch (_that) {
case _CheckoutResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String paymentId,  String provider,  String status,  String? paymentUrl,  String providerRef)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutResult() when $default != null:
return $default(_that.paymentId,_that.provider,_that.status,_that.paymentUrl,_that.providerRef);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String paymentId,  String provider,  String status,  String? paymentUrl,  String providerRef)  $default,) {final _that = this;
switch (_that) {
case _CheckoutResult():
return $default(_that.paymentId,_that.provider,_that.status,_that.paymentUrl,_that.providerRef);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String paymentId,  String provider,  String status,  String? paymentUrl,  String providerRef)?  $default,) {final _that = this;
switch (_that) {
case _CheckoutResult() when $default != null:
return $default(_that.paymentId,_that.provider,_that.status,_that.paymentUrl,_that.providerRef);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CheckoutResult implements CheckoutResult {
  const _CheckoutResult({required this.paymentId, required this.provider, required this.status, this.paymentUrl, required this.providerRef});
  factory _CheckoutResult.fromJson(Map<String, dynamic> json) => _$CheckoutResultFromJson(json);

@override final  String paymentId;
@override final  String provider;
@override final  String status;
@override final  String? paymentUrl;
@override final  String providerRef;

/// Create a copy of CheckoutResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutResultCopyWith<_CheckoutResult> get copyWith => __$CheckoutResultCopyWithImpl<_CheckoutResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckoutResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutResult&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentUrl, paymentUrl) || other.paymentUrl == paymentUrl)&&(identical(other.providerRef, providerRef) || other.providerRef == providerRef));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,paymentId,provider,status,paymentUrl,providerRef);

@override
String toString() {
  return 'CheckoutResult(paymentId: $paymentId, provider: $provider, status: $status, paymentUrl: $paymentUrl, providerRef: $providerRef)';
}


}

/// @nodoc
abstract mixin class _$CheckoutResultCopyWith<$Res> implements $CheckoutResultCopyWith<$Res> {
  factory _$CheckoutResultCopyWith(_CheckoutResult value, $Res Function(_CheckoutResult) _then) = __$CheckoutResultCopyWithImpl;
@override @useResult
$Res call({
 String paymentId, String provider, String status, String? paymentUrl, String providerRef
});




}
/// @nodoc
class __$CheckoutResultCopyWithImpl<$Res>
    implements _$CheckoutResultCopyWith<$Res> {
  __$CheckoutResultCopyWithImpl(this._self, this._then);

  final _CheckoutResult _self;
  final $Res Function(_CheckoutResult) _then;

/// Create a copy of CheckoutResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? paymentId = null,Object? provider = null,Object? status = null,Object? paymentUrl = freezed,Object? providerRef = null,}) {
  return _then(_CheckoutResult(
paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paymentUrl: freezed == paymentUrl ? _self.paymentUrl : paymentUrl // ignore: cast_nullable_to_non_nullable
as String?,providerRef: null == providerRef ? _self.providerRef : providerRef // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
