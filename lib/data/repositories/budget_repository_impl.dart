import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/mock/mock_budget_data.dart';

/// [BudgetRepository] backed by [MockBudgetDataSource]. Swap the data
/// source for an API-backed one later without touching call sites -- they
/// only depend on the [BudgetRepository] interface.
class BudgetRepositoryImpl implements BudgetRepository {
  const BudgetRepositoryImpl(this._dataSource);

  final MockBudgetDataSource _dataSource;

  @override
  Future<List<Budget>> getBudgets() => _dataSource.getBudgets();
}
