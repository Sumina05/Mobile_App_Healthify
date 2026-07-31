import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wraps [FlutterSecureStorage] so features never touch raw keys.
class SecureStorageService {
  const SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  static const String _accessTokenKey = 'auth.accessToken';
  static const String _refreshTokenKey = 'auth.refreshToken';

  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<bool> hasSession() async =>
      await _storage.read(key: _refreshTokenKey) != null;
}
