import 'transaction.dart';

/// The recurrence period a [Budget] limit applies to.
enum BudgetPeriod { weekly, monthly }

/// A spend limit set for a [TransactionCategory] over a [BudgetPeriod].
///
/// Pure domain entity -- no Flutter or data-layer dependencies.
class Budget {
  const Budget({
    required this.id,
    required this.category,
    required this.limit,
    required this.spent,
    required this.period,
  });

  final String id;
  final TransactionCategory category;
  final double limit;
  final double spent;
  final BudgetPeriod period;

  double get progress => limit <= 0 ? 0 : (spent / limit).clamp(0, 1.5);
  bool get isOverLimit => spent > limit;
  double get remaining => (limit - spent).clamp(0, double.infinity);
}
