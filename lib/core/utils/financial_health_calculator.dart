import '../../domain/entities/account.dart';
import '../../domain/entities/budget.dart';
import '../../domain/entities/transaction.dart';

/// Pure scoring logic shared by the Financial Health screen and the
/// Profile screen's Financial Overview -- kept in one place so the two
/// never drift out of sync.
class FinancialHealthCalculator {
  const FinancialHealthCalculator._();

  static bool _isCurrentMonth(DateTime date) {
    final DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  static double monthlyIncome(List<Transaction> transactions) => transactions
      .where((t) => t.type == TransactionType.income && _isCurrentMonth(t.date))
      .fold(0.0, (sum, t) => sum + t.amount);

  static double monthlyExpense(List<Transaction> transactions) => transactions
      .where((t) => t.type == TransactionType.expense && _isCurrentMonth(t.date))
      .fold(0.0, (sum, t) => sum + t.amount);

  static double budgetAdherenceScore(List<Budget> budgets) {
    if (budgets.isEmpty) return 100;
    final int withinLimit = budgets.where((b) => !b.isOverLimit).length;
    return (withinLimit / budgets.length) * 100;
  }

  static double savingsRateScore(List<Transaction> transactions) {
    final double income = monthlyIncome(transactions);
    if (income <= 0) return 0;
    final double expense = monthlyExpense(transactions);
    final double rate = (income - expense) / income;
    return (rate * 200).clamp(0, 100);
  }

  static double emergencyFundScore(
    List<Account> accounts,
    List<Transaction> transactions,
  ) {
    final double savingsBalance = accounts
        .where((a) => a.type == AccountType.savings)
        .fold(0.0, (sum, a) => sum + a.balance);
    final double expense = monthlyExpense(transactions);
    final double avgMonthlyExpense = expense <= 0 ? 1 : expense;
    final double monthsCovered = savingsBalance / avgMonthlyExpense;
    return (monthsCovered / 3 * 100).clamp(0, 100);
  }

  /// Overall 0-100 score: the average of budget adherence, savings rate,
  /// and emergency-fund coverage.
  static double overallScore({
    required List<Account> accounts,
    required List<Transaction> transactions,
    required List<Budget> budgets,
  }) {
    return (budgetAdherenceScore(budgets) +
            savingsRateScore(transactions) +
            emergencyFundScore(accounts, transactions)) /
        3;
  }
}
