import '../../../domain/entities/budget.dart';
import '../../../domain/entities/transaction.dart';
import '../../models/budget_model.dart';

/// In-memory mock data source standing in for a real budgets API.
class MockBudgetDataSource {
  const MockBudgetDataSource();

  static const List<BudgetModel> _budgets = [
    BudgetModel(
      id: 'bud_groceries',
      category: TransactionCategory.groceries,
      limit: 500,
      spent: 340.22,
      period: BudgetPeriod.monthly,
    ),
    BudgetModel(
      id: 'bud_food',
      category: TransactionCategory.food,
      limit: 250,
      spent: 210.15,
      period: BudgetPeriod.monthly,
    ),
    BudgetModel(
      id: 'bud_transport',
      category: TransactionCategory.transport,
      limit: 150,
      spent: 95.45,
      period: BudgetPeriod.monthly,
    ),
    BudgetModel(
      id: 'bud_shopping',
      category: TransactionCategory.shopping,
      limit: 300,
      spent: 279.49,
      period: BudgetPeriod.monthly,
    ),
    BudgetModel(
      id: 'bud_entertainment',
      category: TransactionCategory.entertainment,
      limit: 120,
      spent: 60.49,
      period: BudgetPeriod.monthly,
    ),
    BudgetModel(
      id: 'bud_bills',
      category: TransactionCategory.billsUtilities,
      limit: 1800,
      spent: 1648.41,
      period: BudgetPeriod.monthly,
    ),
  ];

  Future<List<Budget>> getBudgets() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.of(_budgets);
  }
}
