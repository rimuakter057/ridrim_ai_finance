import '../../domain/entities/subscription_plan.dart';

/// Data-layer representation of [SubscriptionPlan]. Kept separate from
/// the domain entity so JSON (de)serialization can be added here later
/// without leaking data-layer concerns into the domain layer.
class SubscriptionPlanModel extends SubscriptionPlan {
  const SubscriptionPlanModel({
    required super.id,
    required super.name,
    required super.monthlyPrice,
    required super.yearlyPrice,
    required super.features,
    super.isPopular,
    super.isCurrent,
  });
}
