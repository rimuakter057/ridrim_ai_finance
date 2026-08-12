import '../../../domain/entities/savings_goal.dart';
import '../../models/savings_goal_model.dart';

/// In-memory mock data source standing in for a real savings-goals API.
///
/// [_goals] is `static` so every instance shares the same in-memory list --
/// contributions/additions from one screen are visible from any other.
class MockSavingsGoalDataSource {
  const MockSavingsGoalDataSource();

  static final DateTime _now = DateTime.now();

  static final List<SavingsGoalModel> _goals = [
    SavingsGoalModel(
      id: 'goal_emergency',
      name: 'Emergency Fund',
      targetAmount: 15000,
      currentAmount: 12500,
      targetDate: DateTime(_now.year, _now.month + 4, _now.day),
      iconKey: 'shield',
    ),
    SavingsGoalModel(
      id: 'goal_vacation',
      name: 'Japan Trip',
      targetAmount: 4000,
      currentAmount: 1450,
      targetDate: DateTime(_now.year, _now.month + 7, _now.day),
      iconKey: 'travel',
    ),
    SavingsGoalModel(
      id: 'goal_car',
      name: 'New Car Down Payment',
      targetAmount: 8000,
      currentAmount: 3200,
      targetDate: DateTime(_now.year + 1, _now.month, _now.day),
      iconKey: 'car',
    ),
    SavingsGoalModel(
      id: 'goal_home',
      name: 'Home Renovation',
      targetAmount: 6000,
      currentAmount: 6000,
      targetDate: DateTime(_now.year, _now.month + 1, _now.day),
      iconKey: 'home',
    ),
  ];

  Future<List<SavingsGoal>> getGoals() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.of(_goals);
  }

  Future<SavingsGoal> addGoal(SavingsGoal goal) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final SavingsGoalModel model = SavingsGoalModel(
      id: goal.id,
      name: goal.name,
      targetAmount: goal.targetAmount,
      currentAmount: goal.currentAmount,
      targetDate: goal.targetDate,
      iconKey: goal.iconKey,
    );
    _goals.add(model);
    return model;
  }

  Future<SavingsGoal> contribute(String goalId, double amount) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final int index = _goals.indexWhere((g) => g.id == goalId);
    if (index == -1) {
      throw ArgumentError('No savings goal with id $goalId');
    }
    final SavingsGoalModel current = _goals[index];
    final SavingsGoalModel updated = SavingsGoalModel(
      id: current.id,
      name: current.name,
      targetAmount: current.targetAmount,
      currentAmount: current.currentAmount + amount,
      targetDate: current.targetDate,
      iconKey: current.iconKey,
    );
    _goals[index] = updated;
    return updated;
  }
}
