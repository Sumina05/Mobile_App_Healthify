// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SkinProfile _$SkinProfileFromJson(Map<String, dynamic> json) => _SkinProfile(
  age: (json['age'] as num?)?.toInt(),
  gender: json['gender'] as String?,
  skinType: json['skinType'] as String,
  concerns:
      (json['concerns'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  allergies:
      (json['allergies'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  preferredIngredients:
      (json['preferredIngredients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  avoidIngredients:
      (json['avoidIngredients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  goals:
      (json['goals'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$SkinProfileToJson(_SkinProfile instance) =>
    <String, dynamic>{
      'age': instance.age,
      'gender': instance.gender,
      'skinType': instance.skinType,
      'concerns': instance.concerns,
      'allergies': instance.allergies,
      'preferredIngredients': instance.preferredIngredients,
      'avoidIngredients': instance.avoidIngredients,
      'goals': instance.goals,
    };

_PremiumStatus _$PremiumStatusFromJson(Map<String, dynamic> json) =>
    _PremiumStatus(
      plan: json['plan'] as String,
      activatedAt: DateTime.parse(json['activatedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$PremiumStatusToJson(_PremiumStatus instance) =>
    <String, dynamic>{
      'plan': instance.plan,
      'activatedAt': instance.activatedAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
    };

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  role: json['role'] as String? ?? 'user',
  avatarUrl: json['avatarUrl'] as String?,
  skinProfile: json['skinProfile'] == null
      ? null
      : SkinProfile.fromJson(json['skinProfile'] as Map<String, dynamic>),
  premium: json['premium'] == null
      ? null
      : PremiumStatus.fromJson(json['premium'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'role': instance.role,
  'avatarUrl': instance.avatarUrl,
  'skinProfile': instance.skinProfile,
  'premium': instance.premium,
};
