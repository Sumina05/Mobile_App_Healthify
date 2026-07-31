import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/safe_api_call.dart';
import '../../auth/domain/entities/user.dart';

class ProfileRepository {
  const ProfileRepository(this._dio);

  final Dio _dio;

  Future<User> updateMe({String? name, String? avatarUrl}) {
    return safeApiCall(() async {
      final response = await _dio.patch<Map<String, dynamic>>(
        ApiEndpoints.me,
        data: {'name': ?name, 'avatarUrl': ?avatarUrl},
      );
      return User.fromJson(response.data!['data'] as Map<String, dynamic>);
    });
  }

  /// Uploads a new profile picture as multipart form data and returns the
  /// updated user, whose [User.avatarUrl] now points at the stored file.
  Future<User> uploadAvatar(String filePath) {
    return safeApiCall(() async {
      final form = FormData.fromMap({
        'image': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.avatar,
        data: form,
      );
      return User.fromJson(response.data!['data'] as Map<String, dynamic>);
    });
  }

  Future<User> saveSkinProfile(Map<String, dynamic> profile) {
    return safeApiCall(() async {
      final response = await _dio.put<Map<String, dynamic>>(
        ApiEndpoints.skinProfile,
        data: profile,
      );
      return User.fromJson(response.data!['data'] as Map<String, dynamic>);
    });
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(dioProvider)),
);
