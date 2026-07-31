import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/viewmodels/auth_controller.dart';

/// Startup coordinator: shows the brand moment, then asks the
/// [AuthController] to restore the stored session. Network failures
/// surface as an error state with retry; navigation itself is handled by
/// the router's auth redirect.
class SplashViewModel extends AsyncNotifier<void> {
  /// Minimum time the branded splash stays on screen before any session
  /// check can navigate away from it — restoreSession() itself is normally
  /// near-instant (local storage reads only), so without this the splash
  /// would flash by too briefly to register as a real screen.
  static const minDisplayDuration = Duration(milliseconds: 2500);

  @override
  Future<void> build() async {
    await Future<void>.delayed(minDisplayDuration);
    await ref.read(authControllerProvider.notifier).restoreSession();
  }

  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authControllerProvider.notifier).restoreSession(),
    );
  }
}

final splashViewModelProvider =
    AsyncNotifierProvider<SplashViewModel, void>(SplashViewModel.new);
