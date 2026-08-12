/// A subscription billing cycle.
enum BillingPeriod { monthly, yearly }

/// A subscription tier offered by the app.
class SubscriptionPlan {
  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.features,
    this.isPopular = false,
    this.isCurrent = false,
  });

  final String id;
  final String name;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<String> features;

  /// Highlighted as the recommended plan.
  final bool isPopular;

  /// Whether this is the signed-in user's active plan.
  final bool isCurrent;

  double priceFor(BillingPeriod period) =>
      period == BillingPeriod.monthly ? monthlyPrice : yearlyPrice;
}
