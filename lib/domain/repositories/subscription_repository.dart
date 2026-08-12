import '../entities/subscription_plan.dart';

/// Contract for retrieving available subscription plans. Implemented
/// against the mock data source today, and against a real API data
/// source once the backend exists.
abstract class SubscriptionRepository {
  Future<List<SubscriptionPlan>> getSubscriptionPlans();
}
