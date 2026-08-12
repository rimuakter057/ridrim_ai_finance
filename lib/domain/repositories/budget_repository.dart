import '../entities/budget.dart';

/// Contract for retrieving the user's category budgets.
abstract class BudgetRepository {
  Future<List<Budget>> getBudgets();
}
