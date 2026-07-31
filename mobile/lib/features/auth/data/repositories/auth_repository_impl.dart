import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_providers.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote, this._storage);

  final AuthRemoteDataSource _remote;
  final SecureStorageService _storage;

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    }
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final result = await _remote.register(
        name: name,
        email: email,
        password: password,
      );
      await _storage.saveSession(
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
      );
      return result.user;
    });
  }

  @override
  Future<User> login({required String email, required String password}) {
    return _guard(() async {
      final result = await _remote.login(email: email, password: password);
      await _storage.saveSession(
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
      );
      return result.user;
    });
  }

  @override
  Future<User> loginWithGoogle(String idToken) {
    return _guard(() async {
      final result = await _remote.loginWithGoogle(idToken);
      await _storage.saveSession(
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
      );
      return result.user;
    });
  }

  @override
  Future<User> getCurrentUser() => _guard(_remote.getMe);

  @override
  Future<String?> requestPasswordReset(String email) =>
      _guard(() => _remote.forgotPassword(email));

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) {
    return _guard(
      () => _remote.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      ),
    );
  }

  @override
  Future<void> logout() async {
    final refreshToken = await _storage.readRefreshToken();
    if (refreshToken != null) {
      try {
        await _remote.logout(refreshToken);
      } on DioException {
        // Best-effort server-side revocation; local logout always succeeds.
      }
    }
    await _storage.clearSession();
  }

  @override
  Future<bool> hasStoredSession() => _storage.hasSession();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    AuthRemoteDataSource(ref.watch(dioProvider)),
    ref.watch(secureStorageProvider),
  );
});
