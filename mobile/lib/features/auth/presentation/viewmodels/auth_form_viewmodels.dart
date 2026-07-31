import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/google_auth_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'auth_controller.dart';

/// Submission state for the login form. Success flows through
/// [AuthController], which the router listens to.
class LoginViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit({required String email, required String password}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref
          .read(authControllerProvider.notifier)
          .login(email: email, password: password),
    );
    state = result;
    return !result.hasError;
  }

  /// Runs native Google Sign-In and exchanges the resulting ID token for a
  /// session. A user-cancelled picker is not an error — it just returns the
  /// form to idle so the screen doesn't flash a misleading failure message.
  Future<bool> submitGoogle() async {
    state = const AsyncLoading();
    try {
      final idToken = await ref.read(googleAuthServiceProvider).signIn();
      if (idToken == null) {
        state = const AsyncData(null);
        return false;
      }
      await ref.read(authControllerProvider.notifier).loginWithGoogle(idToken);
      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }
}

class RegisterViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref
          .read(authControllerProvider.notifier)
          .register(name: name, email: email, password: password),
    );
    state = result;
    return !result.hasError;
  }
}

/// Returns the dev reset code (non-production backends) so the reset
/// screen can prefill it during development.
class ForgotPasswordViewModel extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async => null;

  Future<bool> submit(String email) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).requestPasswordReset(email),
    );
    state = result;
    return !result.hasError;
  }
}

class ResetPasswordViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).resetPassword(
            email: email,
            code: code,
            newPassword: newPassword,
          ),
    );
    state = result;
    return !result.hasError;
  }
}

final loginViewModelProvider =
    AsyncNotifierProvider.autoDispose<LoginViewModel, void>(LoginViewModel.new);
final registerViewModelProvider =
    AsyncNotifierProvider.autoDispose<RegisterViewModel, void>(
  RegisterViewModel.new,
);
final forgotPasswordViewModelProvider =
    AsyncNotifierProvider.autoDispose<ForgotPasswordViewModel, String?>(
  ForgotPasswordViewModel.new,
);
final resetPasswordViewModelProvider =
    AsyncNotifierProvider.autoDispose<ResetPasswordViewModel, void>(
  ResetPasswordViewModel.new,
);
