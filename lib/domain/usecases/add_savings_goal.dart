import '../entities/savings_goal.dart';
import '../repositories/savings_goal_repository.dart';

/// Creates a new savings goal.
class AddSavingsGoal {
  const AddSavingsGoal(this._repository);

  final SavingsGoalRepository _repository;

  Future<SavingsGoal> call(SavingsGoal goal) => _repository.addGoal(goal);
}
