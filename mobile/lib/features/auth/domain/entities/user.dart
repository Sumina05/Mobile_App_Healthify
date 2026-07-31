import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class SkinProfile with _$SkinProfile {
  const factory SkinProfile({
    int? age,
    String? gender,
    required String skinType,
    @Default(<String>[]) List<String> concerns,
    @Default(<String>[]) List<String> allergies,
    @Default(<String>[]) List<String> preferredIngredients,
    @Default(<String>[]) List<String> avoidIngredients,
    @Default(<String>[]) List<String> goals,
  }) = _SkinProfile;

  factory SkinProfile.fromJson(Map<String, dynamic> json) =>
      _$SkinProfileFromJson(json);
}

@freezed
abstract class PremiumStatus with _$PremiumStatus {
  const factory PremiumStatus({
    required String plan,
    required DateTime activatedAt,
    required DateTime expiresAt,
  }) = _PremiumStatus;

  factory PremiumStatus.fromJson(Map<String, dynamic> json) =>
      _$PremiumStatusFromJson(json);
}

@freezed
abstract class User with _$User {
  const User._();

  const factory User({
    required String id,
    required String name,
    required String email,
    @Default('user') String role,
    String? avatarUrl,
    SkinProfile? skinProfile,
    PremiumStatus? premium,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  bool get isPremium =>
      premium != null && premium!.expiresAt.isAfter(DateTime.now());
}
