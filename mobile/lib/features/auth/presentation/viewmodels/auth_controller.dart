import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_providers.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/services/session_events.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';

/// App-wide authentication state driving the router redirects.
sealed class AuthState {
  const AuthState();
}

/// Startup: session not yet checked.
class AuthUnknown extends AuthState {
  const AuthUnknown();
}

/// A session exists but the user must pass the biometric gate first.
class AuthLocked extends AuthState {
  const AuthLocked();
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class Authenticated extends AuthState {
  const Authenticated(this.user);

  final User user;
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    final events = ref.watch(sessionEventsProvider);
    events.addListener(sessionExpired);
    ref.onDispose(() => events.removeListener(sessionExpired));
    return const AuthUnknown();
  }

  /// Called once from the splash screen. Throws on network failure so the
  /// splash can show a retry state.
  Future<void> restoreSession() async {
    final repository = ref.read(authRepositoryProvider);
    if (!await repository.hasStoredSession()) {
      state = const Unauthenticated();
      return;
    }
    // The stored preference alone is not enough: biometrics can stop being
    // available after it was switched on (sensor unenrolled, device changed).
    // Gating on the preference only would strand the user on an unlock screen
    // they can never pass, so availability is re-checked every launch.
    if (ref.read(preferencesServiceProvider).biometricEnabled &&
        await ref.read(biometricServiceProvider).isSupported()) {
      state = const AuthLocked();
      return;
    }
    await _loadUser();
  }

  /// Called by the biometric gate after a successful local authentication.
  Future<void> completeUnlock() => _loadUser();

  Future<void> _loadUser() async {
    final repository = ref.read(authRepositoryProvider);
    try {
      state = Authenticated(await repository.getCurrentUser());
    } on UnauthorizedException {
      state = const Unauthenticated();
    }
  }

  Future<void> login({required String email, required String password}) async {
    final user = await ref
        .read(authRepositoryProvider)
        .login(email: email, password: password);
    state = Authenticated(user);
  }

  Future<void> loginWithGoogle(String idToken) async {
    final user =
        await ref.read(authRepositoryProvider).loginWithGoogle(idToken);
    state = Authenticated(user);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = await ref
        .read(authRepositoryProvider)
        .register(name: name, email: email, password: password);
    state = Authenticated(user);
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const Unauthenticated();
  }

  /// Used by the refresh interceptor when the session is irrecoverable.
  void sessionExpired() {
    if (state is Authenticated || state is AuthLocked) {
      state = const Unauthenticated();
    }
  }

  /// Re-arms the startup gate when the app returns to the foreground after
  /// being genuinely backgrounded (see [AppLifecycleGate]).
  ///
  /// Android frequently keeps the process — and every Riverpod provider —
  /// alive while the app is merely backgrounded, so reopening it does not
  /// necessarily rebuild anything: without this, the user would just resume
  /// whatever screen was on top, skipping the splash and the biometric
  /// re-check entirely. Only resets from [Authenticated]: if the biometric
  /// gate was already showing ([AuthLocked]), it stays exactly as it is
  /// rather than being interrupted mid-unlock.
  void lockForResume() {
    if (state is Authenticated) {
      state = const AuthUnknown();
    }
  }

  /// Keeps the in-memory user in sync after profile edits.
  void updateUser(User user) {
    state = Authenticated(user);
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
