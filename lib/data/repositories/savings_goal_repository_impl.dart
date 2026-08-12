import '../../domain/entities/savings_goal.dart';
import '../../domain/repositories/savings_goal_repository.dart';
import '../datasources/mock/mock_savings_goal_data.dart';

/// [SavingsGoalRepository] backed by [MockSavingsGoalDataSource]. Swap the
/// data source for an API-backed one later without touching call sites --
/// they only depend on the [SavingsGoalRepository] interface.
class SavingsGoalRepositoryImpl implements SavingsGoalRepository {
  const SavingsGoalRepositoryImpl(this._dataSource);

  final MockSavingsGoalDataSource _dataSource;

  @override
  Future<List<SavingsGoal>> getGoals() => _dataSource.getGoals();

  @override
  Future<SavingsGoal> addGoal(SavingsGoal goal) => _dataSource.addGoal(goal);

  @override
  Future<SavingsGoal> contribute(String goalId, double amount) =>
      _dataSource.contribute(goalId, amount);
}
