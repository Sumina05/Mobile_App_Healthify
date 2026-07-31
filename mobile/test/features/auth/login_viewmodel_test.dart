import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify_mobile/core/di/app_providers.dart';
import 'package:healthify_mobile/core/error/app_exception.dart';
import 'package:healthify_mobile/core/services/biometric_service.dart';
import 'package:healthify_mobile/core/services/google_auth_service.dart';
import 'package:healthify_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:healthify_mobile/features/auth/domain/entities/user.dart';
import 'package:healthify_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:healthify_mobile/features/auth/presentation/viewmodels/auth_controller.dart';
import 'package:healthify_mobile/features/auth/presentation/viewmodels/auth_form_viewmodels.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockBiometricService extends Mock implements BiometricService {}

class MockGoogleAuthService extends Mock implements GoogleAuthService {}

const testUser = User(id: 'u1', name: 'Sarah Johnson', email: 'sarah@test.dev');

void main() {
  late MockAuthRepository repository;
  late MockGoogleAuthService googleAuth;

  Future<ProviderContainer> makeContainer() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repository = MockAuthRepository();
    googleAuth = MockGoogleAuthService();
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        authRepositoryProvider.overrideWithValue(repository),
        biometricServiceProvider.overrideWithValue(MockBiometricService()),
        googleAuthServiceProvider.overrideWithValue(googleAuth),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('LoginViewModel.submitGoogle', () {
    test('a successful sign-in authenticates through AuthController',
        () async {
      final container = await makeContainer();
      when(() => googleAuth.signIn()).thenAnswer((_) async => 'id-token');
      when(() => repository.loginWithGoogle('id-token'))
          .thenAnswer((_) async => testUser);

      final result = await container
          .read(loginViewModelProvider.notifier)
          .submitGoogle();

      expect(result, isTrue);
      expect(container.read(authControllerProvider), isA<Authenticated>());
    });

    test('a cancelled picker (null idToken) is not an error', () async {
      final container = await makeContainer();
      when(() => googleAuth.signIn()).thenAnswer((_) async => null);

      final result = await container
          .read(loginViewModelProvider.notifier)
          .submitGoogle();

      expect(result, isFalse);
      expect(
        container.read(loginViewModelProvider).hasError,
        isFalse,
      );
      verifyNever(() => repository.loginWithGoogle(any()));
    });

    test('a backend rejection surfaces as an error state', () async {
      final container = await makeContainer();
      when(() => googleAuth.signIn()).thenAnswer((_) async => 'id-token');
      when(() => repository.loginWithGoogle('id-token')).thenThrow(
        const UnauthorizedException('Invalid Google sign-in token'),
      );

      final result = await container
          .read(loginViewModelProvider.notifier)
          .submitGoogle();

      expect(result, isFalse);
      expect(container.read(loginViewModelProvider).hasError, isTrue);
    });
  });
}
