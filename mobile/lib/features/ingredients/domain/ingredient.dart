import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient.freezed.dart';
part 'ingredient.g.dart';

@freezed
abstract class Ingredient with _$Ingredient {
  const factory Ingredient({
    required String id,
    required String name,
    @Default(<String>[]) List<String> aliases,
    required String tagline,
    required String purpose,
    required String description,
    @Default(<String>[]) List<String> benefits,
    @Default(<String>[]) List<String> sideEffects,
    required String safetyRating,
    @Default(<String>[]) List<String> goodForSkinTypes,
    @Default(<String>[]) List<String> cautionForSkinTypes,
    @Default(<String>[]) List<String> concernsTargeted,
    @Default(false) bool isCommonAllergen,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}
