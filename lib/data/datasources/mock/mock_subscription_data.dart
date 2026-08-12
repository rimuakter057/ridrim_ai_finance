import '../../../core/constants/app_strings.dart';
import '../../models/subscription_plan_model.dart';

/// In-memory mock data source standing in for a real billing/subscription
/// API.
///
/// Replace with an `ApiSubscriptionDataSource` (same method signature)
/// once a backend exists -- [SubscriptionRepositoryImpl] wouldn't need
/// to change.
class MockSubscriptionDataSource {
  const MockSubscriptionDataSource();

  Future<List<SubscriptionPlanModel>> getPlans() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return const [
      SubscriptionPlanModel(
        id: 'plan_free',
        name: AppStrings.planFree,
        monthlyPrice: 0,
        yearlyPrice: 0,
        features: [
          AppStrings.featureBasicChat,
          AppStrings.featureLimitedMessages,
          AppStrings.featureStandardSpeed,
        ],
        isCurrent: true,
      ),
      SubscriptionPlanModel(
        id: 'plan_pro',
        name: AppStrings.planPro,
        monthlyPrice: 12,
        yearlyPrice: 120,
        features: [
          AppStrings.featureUnlimitedChat,
          AppStrings.featureAllTools,
          AppStrings.featurePrioritySpeed,
          AppStrings.featureAdvancedModels,
        ],
        isPopular: true,
      ),
      SubscriptionPlanModel(
        id: 'plan_business',
        name: AppStrings.planBusiness,
        monthlyPrice: 29,
        yearlyPrice: 290,
        features: [
          AppStrings.featureAllTools,
          AppStrings.featureTeamSeats,
          AppStrings.featureApiAccess,
          AppStrings.featureDedicatedSupport,
        ],
      ),
    ];
  }
}
