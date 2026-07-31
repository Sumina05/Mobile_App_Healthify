// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Ingredient _$IngredientFromJson(Map<String, dynamic> json) => _Ingredient(
  id: json['id'] as String,
  name: json['name'] as String,
  aliases:
      (json['aliases'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  tagline: json['tagline'] as String,
  purpose: json['purpose'] as String,
  description: json['description'] as String,
  benefits:
      (json['benefits'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  sideEffects:
      (json['sideEffects'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  safetyRating: json['safetyRating'] as String,
  goodForSkinTypes:
      (json['goodForSkinTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  cautionForSkinTypes:
      (json['cautionForSkinTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  concernsTargeted:
      (json['concernsTargeted'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  isCommonAllergen: json['isCommonAllergen'] as bool? ?? false,
);

Map<String, dynamic> _$IngredientToJson(_Ingredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'aliases': instance.aliases,
      'tagline': instance.tagline,
      'purpose': instance.purpose,
      'description': instance.description,
      'benefits': instance.benefits,
      'sideEffects': instance.sideEffects,
      'safetyRating': instance.safetyRating,
      'goodForSkinTypes': instance.goodForSkinTypes,
      'cautionForSkinTypes': instance.cautionForSkinTypes,
      'concernsTargeted': instance.concernsTargeted,
      'isCommonAllergen': instance.isCommonAllergen,
    };
