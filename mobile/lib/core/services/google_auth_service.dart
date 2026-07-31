import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Wraps native Google Sign-In so the app never touches the plugin directly.
///
/// The server client id is the SAME Google OAuth client id the Healthify web
/// app uses (`GOOGLE_CLIENT_ID` there, `GOOGLE_CLIENT_ID` on this API) — it
/// is what google-auth-library checks as the token audience server-side, so
/// one Google Cloud project backs both apps' Google Sign-In. Supplied at
/// build time, the same way the API base URL is:
/// `flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=xxxx.apps.googleusercontent.com`
class GoogleAuthService {
  GoogleAuthService([GoogleSignIn? instance])
      : _instance = instance ?? GoogleSignIn.instance;

  static const String serverClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );

  final GoogleSignIn _instance;
  bool _initialized = false;

  bool get isConfigured => serverClientId.isNotEmpty;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await _instance.initialize(serverClientId: serverClientId);
    _initialized = true;
  }

  /// Runs the sign-in flow and returns a Google ID token to send to the
  /// backend, or `null` if the user cancelled. Throws [GoogleSignInException]
  /// (or a platform exception) on genuine failure — callers surface that as
  /// an error state, not a silent cancel.
  Future<String?> signIn() async {
    await _ensureInitialized();
    if (!_instance.supportsAuthenticate()) {
      throw StateError(
        'Google Sign-In is not supported via authenticate() on this platform',
      );
    }
    try {
      final account = await _instance.authenticate();
      return account.authentication.idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  Future<void> signOut() async {
    if (!_initialized) return;
    await _instance.signOut();
  }
}

final googleAuthServiceProvider = Provider<GoogleAuthService>(
  (ref) => GoogleAuthService(),
);
