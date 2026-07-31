import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/network/safe_api_call.dart';

part 'premium_repository.freezed.dart';
part 'premium_repository.g.dart';

@freezed
abstract class PremiumPlan with _$PremiumPlan {
  const factory PremiumPlan({
    required String id,
    required String label,
    required int amountNpr,
    required int durationDays,
    String? savings,
  }) = _PremiumPlan;

  factory PremiumPlan.fromJson(Map<String, dynamic> json) =>
      _$PremiumPlanFromJson(json);
}

@freezed
abstract class PlansResponse with _$PlansResponse {
  const factory PlansResponse({
    required List<PremiumPlan> plans,
    required List<String> features,
  }) = _PlansResponse;

  factory PlansResponse.fromJson(Map<String, dynamic> json) =>
      _$PlansResponseFromJson(json);
}

@freezed
abstract class CheckoutResult with _$CheckoutResult {
  const factory CheckoutResult({
    required String paymentId,
    required String provider,
    required String status,
    String? paymentUrl,
    required String providerRef,
  }) = _CheckoutResult;

  factory CheckoutResult.fromJson(Map<String, dynamic> json) =>
      _$CheckoutResultFromJson(json);
}

class PremiumRepository {
  const PremiumRepository(this._dio);

  final Dio _dio;

  Future<PlansResponse> getPlans() {
    return safeApiCall(() async {
      final response =
          await _dio.get<Map<String, dynamic>>('/premium/plans');
      return PlansResponse.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    });
  }

  Future<CheckoutResult> checkout({
    required String plan,
    required String provider,
  }) {
    return safeApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/premium/checkout',
        data: {'plan': plan, 'provider': provider},
      );
      return CheckoutResult.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    });
  }

  Future<void> verify(String providerRef) {
    return safeApiCall(() async {
      await _dio.post<Map<String, dynamic>>(
        '/premium/verify',
        data: {'providerRef': providerRef},
      );
    });
  }
}

final premiumRepositoryProvider = Provider<PremiumRepository>(
  (ref) => PremiumRepository(ref.watch(dioProvider)),
);
