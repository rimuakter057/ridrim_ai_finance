import '../entities/savings_goal.dart';
import '../repositories/savings_goal_repository.dart';

/// Adds a contribution to an existing savings goal.
class ContributeToGoal {
  const ContributeToGoal(this._repository);

  final SavingsGoalRepository _repository;

  Future<SavingsGoal> call(String goalId, double amount) =>
      _repository.contribute(goalId, amount);
}
