import '../entities/user.dart';

/// Domain contract — implemented in the data layer, injected via Riverpod.
abstract interface class AuthRepository {
  Future<User> register({
    required String name,
    required String email,
    required String password,
  });

  Future<User> login({required String email, required String password});

  /// Exchanges a Google ID token (from native Google Sign-In) for a normal
  /// app session. Same backend endpoint/verification as the Healthify web
  /// app's Google login — creates the account on first sign-in, signs in
  /// otherwise.
  Future<User> loginWithGoogle(String idToken);

  /// Loads the current user with the stored session (refresh handled by
  /// the network layer). Throws [UnauthorizedException] when no valid
  /// session exists.
  Future<User> getCurrentUser();

  /// Returns the dev-mode reset code when the backend provides one.
  Future<String?> requestPasswordReset(String email);

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  Future<void> logout();

  Future<bool> hasStoredSession();
}
