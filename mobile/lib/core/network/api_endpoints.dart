/// Single source of truth for backend routes.
///
/// The base URL itself is resolved once at startup by
/// [resolveApiBaseUrl] and injected through `apiBaseUrlProvider`, because
/// telling an Android emulator from a physical device needs a platform probe.
abstract final class ApiEndpoints {
  /// Points a build at an arbitrary backend. Required on a physical device,
  /// which has no route to the dev machine's loopback:
  /// `flutter run --dart-define=HEALTHIFY_API_BASE_URL=http://192.168.1.10:5000/api/v1`
  static const String baseUrlOverride = String.fromEnvironment(
    'HEALTHIFY_API_BASE_URL',
  );

  /// 10.0.2.2 is the Android emulator's alias for the host's loopback.
  /// It is meaningless on a real device.
  static const String androidEmulatorBaseUrl = 'http://10.0.2.2:5000/api/v1';
  static const String localhostBaseUrl = 'http://localhost:5000/api/v1';
  static const String productionBaseUrl = 'https://api.healthify.app/api/v1';

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String googleLogin = '/auth/google';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Profile
  static const String me = '/users/me';
  static const String skinProfile = '/users/me/skin-profile';
  static const String avatar = '/users/me/avatar';

  // Core product loop
  static const String analyze = '/analysis';
  static const String history = '/analysis/history';
  static const String ingredients = '/ingredients';
  static const String ingredientOfTheDay = '/ingredients/daily';
  static const String recommendedIngredients = '/ingredients/recommended';
  static const String products = '/products';
  static const String favorites = '/favorites';
  static const String chat = '/chat';

  static const String health = '/health';
}
