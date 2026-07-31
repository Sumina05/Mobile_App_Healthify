import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/viewmodels/auth_controller.dart';
import '../../../profile/data/profile_repository.dart';

part 'skin_profile_viewmodel.freezed.dart';

@freezed
abstract class SkinProfileForm with _$SkinProfileForm {
  const factory SkinProfileForm({
    @Default(0) int step,
    int? age,
    String? gender,
    String? skinType,
    @Default(<String>{}) Set<String> concerns,
    @Default(<String>{}) Set<String> allergies,
    @Default(<String>{}) Set<String> goals,
    @Default(false) bool submitting,
  }) = _SkinProfileForm;
}

/// Wizard state + submission. Prefilled from the existing profile when the
/// user edits it later from the Profile screen.
class SkinProfileViewModel extends Notifier<SkinProfileForm> {
  static const totalSteps = 4;

  @override
  SkinProfileForm build() {
    final auth = ref.read(authControllerProvider);
    final existing = auth is Authenticated ? auth.user.skinProfile : null;
    if (existing == null) return const SkinProfileForm();
    return SkinProfileForm(
      age: existing.age,
      gender: existing.gender,
      skinType: existing.skinType,
      concerns: existing.concerns.toSet(),
      allergies: existing.allergies.toSet(),
      goals: existing.goals.toSet(),
    );
  }

  void setAge(int? age) => state = state.copyWith(age: age);
  void setGender(String? gender) => state = state.copyWith(gender: gender);
  void setSkinType(String type) => state = state.copyWith(skinType: type);

  void toggleConcern(String concern) {
    final next = {...state.concerns};
    next.contains(concern) ? next.remove(concern) : next.add(concern);
    state = state.copyWith(concerns: next);
  }

  void addAllergy(String allergy) {
    final trimmed = allergy.trim();
    if (trimmed.isEmpty) return;
    state = state.copyWith(allergies: {...state.allergies, trimmed});
  }

  void removeAllergy(String allergy) {
    state = state.copyWith(
      allergies: {...state.allergies}..remove(allergy),
    );
  }

  void toggleGoal(String goal) {
    final next = {...state.goals};
    next.contains(goal) ? next.remove(goal) : next.add(goal);
    state = state.copyWith(goals: next);
  }

  bool get canAdvance {
    return switch (state.step) {
      1 => state.skinType != null,
      _ => true,
    };
  }

  void nextStep() {
    if (state.step < totalSteps - 1) {
      state = state.copyWith(step: state.step + 1);
    }
  }

  void previousStep() {
    if (state.step > 0) state = state.copyWith(step: state.step - 1);
  }

  Future<User?> submit() async {
    if (state.skinType == null) return null;
    state = state.copyWith(submitting: true);
    try {
      final user =
          await ref.read(profileRepositoryProvider).saveSkinProfile({
        if (state.age != null) 'age': state.age,
        if (state.gender != null) 'gender': state.gender,
        'skinType': state.skinType,
        'concerns': state.concerns.toList(),
        'allergies': state.allergies.toList(),
        'goals': state.goals.toList(),
      });
      ref.read(authControllerProvider.notifier).updateUser(user);
      return user;
    } finally {
      state = state.copyWith(submitting: false);
    }
  }
}

final skinProfileViewModelProvider =
    NotifierProvider.autoDispose<SkinProfileViewModel, SkinProfileForm>(
  SkinProfileViewModel.new,
);
