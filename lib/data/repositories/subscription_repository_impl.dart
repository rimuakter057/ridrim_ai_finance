import '../../domain/entities/subscription_plan.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/mock/mock_subscription_data.dart';

/// [SubscriptionRepository] backed by [MockSubscriptionDataSource]. Swap
/// the data source for an API-backed one later without touching call
/// sites -- they only depend on the [SubscriptionRepository] interface.
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  const SubscriptionRepositoryImpl(this._dataSource);

  final MockSubscriptionDataSource _dataSource;

  @override
  Future<List<SubscriptionPlan>> getSubscriptionPlans() =>
      _dataSource.getPlans();
}
