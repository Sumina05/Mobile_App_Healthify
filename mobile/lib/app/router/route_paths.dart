/// Central route table. Add new paths here so navigation stays typo-free.
abstract final class RoutePaths {
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String unlock = '/auth/unlock';

  static const String skinProfile = '/skin-profile';

  // Shell tabs
  static const String dashboard = '/dashboard';
  static const String history = '/history';
  static const String favorites = '/favorites';
  static const String profile = '/profile';

  // Pushed on top of the shell
  static const String scanner = '/scanner';
  static const String chat = '/chat';
  static const String notifications = '/notifications';
  static const String settings = '/settings';

  static const String analysis = '/analysis';
  static const String premium = '/premium';
  static const String search = '/search';
  static const String ingredients = '/ingredients';
  static const String products = '/products';
  static const String barcodeScanner = '/scan-barcode';
}
