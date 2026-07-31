import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthify_mobile/app/app.dart';
import 'package:healthify_mobile/core/di/app_providers.dart';
import 'package:healthify_mobile/core/services/biometric_service.dart';
import 'package:healthify_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:healthify_mobile/features/auth/domain/entities/user.dart';
import 'package:healthify_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:healthify_mobile/features/auth/presentation/viewmodels/auth_controller.dart';
import 'package:healthify_mobile/features/startup/presentation/viewmodels/splash_viewmodel.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockBiometricService extends Mock implements BiometricService {}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets(
      'cold start: splash → onboarding for a first-time, signed-out user',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repository = MockAuthRepository();
    when(() => repository.hasStoredSession()).thenAnswer((_) async => false);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authRepositoryProvider.overrideWithValue(repository),
        ],
        child: const HealthifyApp(),
      ),
    );
    await tester.pump();

    // Brand splash is visible during startup.
    expect(find.text('Healthify'), findsOneWidget);

    // Still on splash just before the guaranteed minimum duration elapses —
    // this is the regression check for "splash screen missing": no
    // subsequent screen may appear before this point.
    await tester.pump(
      SplashViewModel.minDisplayDuration - const Duration(milliseconds: 200),
    );
    expect(find.text('Healthify'), findsOneWidget);
    expect(find.textContaining('Scan Any Product'), findsNothing);

    // Startup delay elapses → session restored → router redirects.
    await tester.pumpAndSettle();

    expect(find.textContaining('Scan Any Product'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets(
      'cold start with a stored session and biometrics enabled: splash → '
      'biometric unlock screen, never straight to it', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.seen': true,
      'settings.biometricEnabled': true,
    });
    final prefs = await SharedPreferences.getInstance();
    final repository = MockAuthRepository();
    final biometrics = MockBiometricService();
    when(() => repository.hasStoredSession()).thenAnswer((_) async => true);
    when(() => biometrics.isSupported()).thenAnswer((_) async => true);
    when(() => biometrics.authenticate())
        .thenAnswer((_) async => false);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authRepositoryProvider.overrideWithValue(repository),
          biometricServiceProvider.overrideWithValue(biometrics),
        ],
        child: const HealthifyApp(),
      ),
    );
    await tester.pump();

    // Splash shows first, even though a valid session exists.
    expect(find.text('Healthify'), findsOneWidget);

    await tester.pump(
      SplashViewModel.minDisplayDuration - const Duration(milliseconds: 200),
    );
    expect(find.text('Healthify'), findsOneWidget);

    await tester.pumpAndSettle();

    // Now on the biometric unlock screen — the existing biometric UI is
    // untouched, only reached after the splash.
    expect(find.text('Unlock Healthify'), findsOneWidget);
  });

  testWidgets(
      'warm resume: an already-authenticated session re-arms the splash and '
      'biometric gate on returning from a real background stint, instead of '
      'resuming straight to the last screen', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.seen': true,
      'settings.biometricEnabled': true,
    });
    final prefs = await SharedPreferences.getInstance();
    final repository = MockAuthRepository();
    final biometrics = MockBiometricService();
    when(() => repository.hasStoredSession()).thenAnswer((_) async => true);
    when(() => biometrics.isSupported()).thenAnswer((_) async => true);
    when(() => biometrics.authenticate()).thenAnswer((_) async => true);
    when(() => repository.getCurrentUser()).thenAnswer(
      (_) async => const User(id: 'u1', name: 'Sarah', email: 's@test.dev'),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authRepositoryProvider.overrideWithValue(repository),
          biometricServiceProvider.overrideWithValue(biometrics),
        ],
        child: const HealthifyApp(),
      ),
    );
    // Splash → biometric prompt auto-fires and succeeds → fully
    // authenticated. (Asserted on AuthState directly — the authenticated
    // shell renders a live dashboard fetch this test doesn't mock, which
    // isn't what's under test here.)
    final container =
        ProviderScope.containerOf(tester.element(find.byType(HealthifyApp)));
    await tester.pumpAndSettle(SplashViewModel.minDisplayDuration);
    expect(container.read(authControllerProvider), isA<Authenticated>());

    // A genuine background stint (home button, several seconds away). Real
    // Android transitions always walk resumed -> inactive -> hidden ->
    // paused (and back) rather than jumping directly between endpoints.
    // The re-arm threshold is measured against `package:clock`'s `clock.now()`
    // (real wall-clock time in production), so this drives it with a fake
    // `Clock` instead of actually waiting — Flutter's test binding fakes
    // `Future.delayed` against its own virtual frame clock, which would
    // otherwise hang forever waiting for a `pump()` that never comes.
    final pauseTime = DateTime(2026);
    withClock(Clock.fixed(pauseTime), () {
      tester.binding
          .handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding
          .handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding
          .handleAppLifecycleStateChanged(AppLifecycleState.paused);
    });
    withClock(Clock.fixed(pauseTime.add(const Duration(seconds: 3))), () {
      tester.binding
          .handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding
          .handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding
          .handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    });
    // A couple of extra frames for the router's redirect (driven by a
    // ValueListenable) and the resulting navigation push to settle, without
    // advancing the virtual clock the splash delay itself runs on.
    await tester.pump();
    await tester.pump();

    // Immediately reset — the whole startup gate re-runs, including the
    // splash and the biometric re-check, instead of resuming straight to
    // wherever the app happened to be.
    expect(container.read(authControllerProvider), isA<AuthUnknown>());
    expect(find.text('Healthify'), findsOneWidget);

    // The splash delay elapses, restoreSession() re-runs, and the biometric
    // gate re-fires and succeeds again (this test's mock always succeeds) —
    // landing back on Authenticated, proving the whole re-arm cycle
    // completes rather than getting stuck partway.
    await tester.pumpAndSettle(SplashViewModel.minDisplayDuration);
    expect(container.read(authControllerProvider), isA<Authenticated>());
  });

  testWidgets(
      'a brief pause (e.g. the biometric system dialog itself) does not '
      're-arm the splash — only a real background stint does',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.seen': true,
      'settings.biometricEnabled': true,
    });
    final prefs = await SharedPreferences.getInstance();
    final repository = MockAuthRepository();
    final biometrics = MockBiometricService();
    when(() => repository.hasStoredSession()).thenAnswer((_) async => true);
    when(() => biometrics.isSupported()).thenAnswer((_) async => true);
    when(() => biometrics.authenticate()).thenAnswer((_) async => true);
    when(() => repository.getCurrentUser()).thenAnswer(
      (_) async => const User(id: 'u1', name: 'Sarah', email: 's@test.dev'),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authRepositoryProvider.overrideWithValue(repository),
          biometricServiceProvider.overrideWithValue(biometrics),
        ],
        child: const HealthifyApp(),
      ),
    );
    final container =
        ProviderScope.containerOf(tester.element(find.byType(HealthifyApp)));
    await tester.pumpAndSettle(SplashViewModel.minDisplayDuration);
    expect(container.read(authControllerProvider), isA<Authenticated>());

    // Sub-threshold pause/resume, as the biometric dialog itself would cause.
    final pauseTime = DateTime(2026);
    withClock(Clock.fixed(pauseTime), () {
      tester.binding
          .handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding
          .handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding
          .handleAppLifecycleStateChanged(AppLifecycleState.paused);
    });
    withClock(
      Clock.fixed(pauseTime.add(const Duration(milliseconds: 300))),
      () {
        tester.binding
            .handleAppLifecycleStateChanged(AppLifecycleState.hidden);
        tester.binding
            .handleAppLifecycleStateChanged(AppLifecycleState.inactive);
        tester.binding
            .handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      },
    );
    await tester.pump();

    // Still fully authenticated — no unwanted trip back to splash.
    expect(container.read(authControllerProvider), isA<Authenticated>());
    expect(find.text('Healthify'), findsNothing);
  });

  testWidgets('signed-out returning user lands on the login screen',
      (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding.seen': true});
    final prefs = await SharedPreferences.getInstance();
    final repository = MockAuthRepository();
    when(() => repository.hasStoredSession()).thenAnswer((_) async => false);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authRepositoryProvider.overrideWithValue(repository),
        ],
        child: const HealthifyApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.textContaining('Welcome Back'), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
  });
}
