// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PremiumPlan _$PremiumPlanFromJson(Map<String, dynamic> json) => _PremiumPlan(
  id: json['id'] as String,
  label: json['label'] as String,
  amountNpr: (json['amountNpr'] as num).toInt(),
  durationDays: (json['durationDays'] as num).toInt(),
  savings: json['savings'] as String?,
);

Map<String, dynamic> _$PremiumPlanToJson(_PremiumPlan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'amountNpr': instance.amountNpr,
      'durationDays': instance.durationDays,
      'savings': instance.savings,
    };

_PlansResponse _$PlansResponseFromJson(Map<String, dynamic> json) =>
    _PlansResponse(
      plans: (json['plans'] as List<dynamic>)
          .map((e) => PremiumPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      features: (json['features'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PlansResponseToJson(_PlansResponse instance) =>
    <String, dynamic>{'plans': instance.plans, 'features': instance.features};

_CheckoutResult _$CheckoutResultFromJson(Map<String, dynamic> json) =>
    _CheckoutResult(
      paymentId: json['paymentId'] as String,
      provider: json['provider'] as String,
      status: json['status'] as String,
      paymentUrl: json['paymentUrl'] as String?,
      providerRef: json['providerRef'] as String,
    );

Map<String, dynamic> _$CheckoutResultToJson(_CheckoutResult instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'provider': instance.provider,
      'status': instance.status,
      'paymentUrl': instance.paymentUrl,
      'providerRef': instance.providerRef,
    };
