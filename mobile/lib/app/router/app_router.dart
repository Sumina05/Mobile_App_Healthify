import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/app_providers.dart';
import '../../core/widgets/status_view.dart';
import '../../features/analysis/presentation/views/analysis_view.dart';
import '../../features/analysis/presentation/views/compare_view.dart';
import '../../features/assistant/presentation/views/assistant_view.dart';
import '../../features/auth/presentation/viewmodels/auth_controller.dart';
import '../../features/auth/presentation/views/biometric_gate_view.dart';
import '../../features/auth/presentation/views/forgot_password_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/auth/presentation/views/reset_password_view.dart';
import '../../features/dashboard/presentation/views/dashboard_view.dart';
import '../../features/favorites/presentation/views/favorites_view.dart';
import '../../features/history/presentation/views/history_view.dart';
import '../../features/ingredients/presentation/views/ingredient_library_view.dart';
import '../../features/notifications/presentation/views/notifications_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/premium/presentation/views/premium_view.dart';
import '../../features/products/presentation/views/barcode_scanner_view.dart';
import '../../features/products/presentation/views/product_catalog_view.dart';
import '../../features/profile/presentation/views/profile_view.dart';
import '../../features/scanner/presentation/views/scanner_view.dart';
import '../../features/search/presentation/views/search_view.dart';
import '../../features/settings/presentation/views/settings_view.dart';
import '../../features/skin_profile/presentation/views/skin_profile_wizard_view.dart';
import '../../features/startup/presentation/views/splash_view.dart';
import '../shell/main_shell.dart';
import 'route_paths.dart';

/// Auth-state-driven navigation. The redirect is the single source of
/// truth for which area of the app is reachable.
final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ValueNotifier(0);
  ref.onDispose(refreshNotifier.dispose);
  ref.listen<AuthState>(
    authControllerProvider,
    (previous, next) => refreshNotifier.value++,
  );

  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final prefs = ref.read(preferencesServiceProvider);
      final location = state.matchedLocation;
      final onAuthPage = location.startsWith('/auth');
      final onSplash = location == RoutePaths.splash;
      final onOnboarding = location == RoutePaths.onboarding;

      return switch (auth) {
        AuthUnknown() => onSplash ? null : RoutePaths.splash,
        AuthLocked() =>
          location == RoutePaths.unlock ? null : RoutePaths.unlock,
        Unauthenticated() when !prefs.hasSeenOnboarding =>
          onOnboarding ? null : RoutePaths.onboarding,
        Unauthenticated() => onAuthPage && location != RoutePaths.unlock
            ? null
            : RoutePaths.login,
        Authenticated(:final user) => switch (location) {
            _ when user.skinProfile == null &&
                    location != RoutePaths.skinProfile =>
              RoutePaths.skinProfile,
            _ when onSplash || onAuthPage || onOnboarding =>
              RoutePaths.dashboard,
            _ => null,
          },
      };
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: RoutePaths.register,
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: RoutePaths.resetPassword,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? const {};
          return ResetPasswordView(
            email: extra['email'] as String? ?? '',
            devCode: extra['devCode'] as String?,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.unlock,
        builder: (context, state) => const BiometricGateView(),
      ),
      GoRoute(
        path: RoutePaths.skinProfile,
        builder: (context, state) => const SkinProfileWizardView(),
      ),
      GoRoute(
        path: RoutePaths.scanner,
        builder: (context, state) => const ScannerView(),
      ),
      GoRoute(
        path: RoutePaths.chat,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? const {};
          return AssistantView(
            analysisId: extra['analysisId'] as String?,
            productName: extra['productName'] as String?,
          );
        },
      ),
      GoRoute(
        path: '${RoutePaths.analysis}/:id',
        builder: (context, state) =>
            AnalysisView(analysisId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/compare/:idA/:idB',
        builder: (context, state) => CompareView(
          idA: state.pathParameters['idA']!,
          idB: state.pathParameters['idB']!,
        ),
      ),
      GoRoute(
        path: RoutePaths.notifications,
        builder: (context, state) => const NotificationsView(),
      ),
      GoRoute(
        path: RoutePaths.settings,
        builder: (context, state) => const SettingsView(),
      ),
      GoRoute(
        path: RoutePaths.premium,
        builder: (context, state) => const PremiumView(),
      ),
      GoRoute(
        path: RoutePaths.search,
        builder: (context, state) => const SearchView(),
      ),
      GoRoute(
        path: RoutePaths.ingredients,
        builder: (context, state) => const IngredientLibraryView(),
      ),
      GoRoute(
        path: RoutePaths.products,
        builder: (context, state) => const ProductCatalogView(),
      ),
      GoRoute(
        path: RoutePaths.barcodeScanner,
        builder: (context, state) => const BarcodeScannerView(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.dashboard,
              builder: (context, state) => const DashboardView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.history,
              builder: (context, state) => const HistoryView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.favorites,
              builder: (context, state) => const FavoritesView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.profile,
              builder: (context, state) => const ProfileView(),
            ),
          ]),
        ],
      ),
    ],
    errorBuilder: (context, state) => StatusView.error(
      message: 'The page "${state.uri}" could not be found.',
    ),
  );
});
