import '../entities/savings_goal.dart';

/// Contract for retrieving and contributing to savings goals.
abstract class SavingsGoalRepository {
  Future<List<SavingsGoal>> getGoals();

  Future<SavingsGoal> addGoal(SavingsGoal goal);

  Future<SavingsGoal> contribute(String goalId, double amount);
}
