import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

/// Fetches the user's category budgets.
class GetBudgets {
  const GetBudgets(this._repository);

  final BudgetRepository _repository;

  Future<List<Budget>> call() => _repository.getBudgets();
}
