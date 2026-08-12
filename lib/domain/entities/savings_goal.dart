/// A savings goal the user is contributing toward.
///
/// Pure domain entity -- no Flutter or data-layer dependencies.
class SavingsGoal {
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.iconKey,
  });

  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;

  /// Presentation-layer icon lookup key (e.g. `'travel'`, `'home'`) --
  /// kept as a plain string so the entity stays Flutter-free.
  final String iconKey;

  double get progress =>
      targetAmount <= 0 ? 0 : (currentAmount / targetAmount).clamp(0, 1);
  double get remaining => (targetAmount - currentAmount).clamp(0, double.infinity);
  bool get isComplete => currentAmount >= targetAmount;

  int get daysRemaining => targetDate.difference(DateTime.now()).inDays;
}
