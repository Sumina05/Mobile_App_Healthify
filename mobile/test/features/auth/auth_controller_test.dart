import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify_mobile/core/di/app_providers.dart';
import 'package:healthify_mobile/core/error/app_exception.dart';
import 'package:healthify_mobile/core/services/biometric_service.dart';
import 'package:healthify_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:healthify_mobile/features/auth/domain/entities/user.dart';
import 'package:healthify_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:healthify_mobile/features/auth/presentation/viewmodels/auth_controller.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockBiometricService extends Mock implements BiometricService {}

const testUser = User(
  id: 'u1',
  name: 'Sarah Johnson',
  email: 'sarah@test.dev',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository repository;
  late MockBiometricService biometrics;

  Future<ProviderContainer> makeContainer({
    Map<String, Object> prefs = const {},
    bool biometricsAvailable = true,
  }) async {
    SharedPreferences.setMockInitialValues(prefs);
    final sharedPrefs = await SharedPreferences.getInstance();
    repository = MockAuthRepository();
    biometrics = MockBiometricService();
    when(() => biometrics.isSupported())
        .thenAnswer((_) async => biometricsAvailable);
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        authRepositoryProvider.overrideWithValue(repository),
        biometricServiceProvider.overrideWithValue(biometrics),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('AuthController.restoreSession', () {
    test('no stored session → Unauthenticated', () async {
      final container = await makeContainer();
      when(() => repository.hasStoredSession()).thenAnswer((_) async => false);

      await container
          .read(authControllerProvider.notifier)
          .restoreSession();

      expect(container.read(authControllerProvider), isA<Unauthenticated>());
    });

    test('session + biometric enabled → AuthLocked gate', () async {
      final container = await makeContainer(
        prefs: {'settings.biometricEnabled': true},
      );
      when(() => repository.hasStoredSession()).thenAnswer((_) async => true);

      await container
          .read(authControllerProvider.notifier)
          .restoreSession();

      expect(container.read(authControllerProvider), isA<AuthLocked>());
    });

    test(
        'biometric enabled but unavailable → Authenticated, not stranded '
        'at the unlock gate', () async {
      // The preference can outlive the capability: a sensor stops being
      // enrolled, or the setting was carried to a device without one.
      // Gating on the preference alone would leave the user at an unlock
      // screen they can never pass.
      final container = await makeContainer(
        prefs: {'settings.biometricEnabled': true},
        biometricsAvailable: false,
      );
      when(() => repository.hasStoredSession()).thenAnswer((_) async => true);
      when(() => repository.getCurrentUser())
          .thenAnswer((_) async => testUser);

      await container.read(authControllerProvider.notifier).restoreSession();

      expect(container.read(authControllerProvider), isA<Authenticated>());
    });

    test('valid session without biometrics → Authenticated', () async {
      final container = await makeContainer();
      when(() => repository.hasStoredSession()).thenAnswer((_) async => true);
      when(() => repository.getCurrentUser())
          .thenAnswer((_) async => testUser);

      await container
          .read(authControllerProvider.notifier)
          .restoreSession();

      final state = container.read(authControllerProvider);
      expect(state, isA<Authenticated>());
      expect((state as Authenticated).user.email, testUser.email);
    });

    test('rejected session → Unauthenticated', () async {
      final container = await makeContainer();
      when(() => repository.hasStoredSession()).thenAnswer((_) async => true);
      when(() => repository.getCurrentUser())
          .thenThrow(const UnauthorizedException());

      await container
          .read(authControllerProvider.notifier)
          .restoreSession();

      expect(container.read(authControllerProvider), isA<Unauthenticated>());
    });
  });

  group('AuthController auth actions', () {
    test('login stores the user in state', () async {
      final container = await makeContainer();
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => testUser);

      await container
          .read(authControllerProvider.notifier)
          .login(email: testUser.email, password: 'Skincare2026');

      expect(container.read(authControllerProvider), isA<Authenticated>());
    });

    test('failed login propagates and leaves state unauthenticated-safe',
        () async {
      final container = await makeContainer();
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const UnauthorizedException('Incorrect email or password'));

      await expectLater(
        container
            .read(authControllerProvider.notifier)
            .login(email: testUser.email, password: 'wrong'),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(
        container.read(authControllerProvider),
        isNot(isA<Authenticated>()),
      );
    });

    test('loginWithGoogle stores the user in state', () async {
      final container = await makeContainer();
      when(() => repository.loginWithGoogle(any()))
          .thenAnswer((_) async => testUser);

      await container
          .read(authControllerProvider.notifier)
          .loginWithGoogle('a-google-id-token');

      final state = container.read(authControllerProvider);
      expect(state, isA<Authenticated>());
      expect((state as Authenticated).user.email, testUser.email);
    });

    test('failed Google sign-in propagates and leaves state unauthenticated-safe',
        () async {
      final container = await makeContainer();
      when(() => repository.loginWithGoogle(any()))
          .thenThrow(const UnauthorizedException('Invalid Google sign-in token'));

      await expectLater(
        container
            .read(authControllerProvider.notifier)
            .loginWithGoogle('bad-token'),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(
        container.read(authControllerProvider),
        isNot(isA<Authenticated>()),
      );
    });

    test('logout clears back to Unauthenticated', () async {
      final container = await makeContainer();
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => testUser);
      when(() => repository.logout()).thenAnswer((_) async {});

      final controller = container.read(authControllerProvider.notifier);
      await controller.login(email: testUser.email, password: 'x');
      await controller.logout();

      expect(container.read(authControllerProvider), isA<Unauthenticated>());
    });
  });
}
