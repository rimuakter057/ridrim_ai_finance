import '../entities/savings_goal.dart';
import '../repositories/savings_goal_repository.dart';

/// Fetches the user's savings goals.
class GetSavingsGoals {
  const GetSavingsGoals(this._repository);

  final SavingsGoalRepository _repository;

  Future<List<SavingsGoal>> call() => _repository.getGoals();
}
