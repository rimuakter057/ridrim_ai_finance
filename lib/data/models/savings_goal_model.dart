import '../../domain/entities/savings_goal.dart';

/// Data-layer representation of [SavingsGoal]. Kept separate from the
/// domain entity so JSON (de)serialization can be added here later
/// without leaking data-layer concerns into the domain layer.
class SavingsGoalModel extends SavingsGoal {
  const SavingsGoalModel({
    required super.id,
    required super.name,
    required super.targetAmount,
    required super.currentAmount,
    required super.targetDate,
    required super.iconKey,
  });
}
