import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';

/// Raw HTTP calls — no error mapping, no storage. That happens one layer up.
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<({User user, AuthTokens tokens})> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: {'name': name, 'email': email, 'password': password},
    );
    return _parseAuthPayload(response);
  }

  Future<({User user, AuthTokens tokens})> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return _parseAuthPayload(response);
  }

  Future<({User user, AuthTokens tokens})> loginWithGoogle(
    String idToken,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.googleLogin,
      data: {'idToken': idToken},
    );
    return _parseAuthPayload(response);
  }

  Future<User> getMe() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.me);
    return User.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  Future<String?> forgotPassword(String email) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
    final data = response.data!['data'];
    return data is Map<String, dynamic> ? data['devCode'] as String? : null;
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.resetPassword,
      data: {'email': email, 'code': code, 'password': newPassword},
    );
  }

  Future<void> logout(String refreshToken) async {
    await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.logout,
      data: {'refreshToken': refreshToken},
    );
  }

  ({User user, AuthTokens tokens}) _parseAuthPayload(
    Response<Map<String, dynamic>> response,
  ) {
    final data = response.data!['data'] as Map<String, dynamic>;
    return (
      user: User.fromJson(data['user'] as Map<String, dynamic>),
      tokens: AuthTokens.fromJson(data['tokens'] as Map<String, dynamic>),
    );
  }
}
