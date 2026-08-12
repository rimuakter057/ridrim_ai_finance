import 'package:ai_saas/core/utils/transaction_category_style.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/helpers.dart';
import '../../../../data/datasources/mock/mock_account_data.dart';
import '../../../../data/datasources/mock/mock_budget_data.dart';
import '../../../../data/datasources/mock/mock_transaction_data.dart';
import '../../../../data/datasources/mock/mock_user_data.dart';
import '../../../../data/repositories/account_repository_impl.dart';
import '../../../../data/repositories/budget_repository_impl.dart';
import '../../../../data/repositories/transaction_repository_impl.dart';
import '../../../../data/repositories/user_repository_impl.dart';
import '../../../../domain/entities/account.dart';
import '../../../../domain/entities/budget.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../../../domain/repositories/account_repository.dart';
import '../../../../domain/repositories/budget_repository.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../../domain/usecases/get_accounts.dart';
import '../../../../domain/usecases/get_budgets.dart';
import '../../../../domain/usecases/get_transactions.dart';
import '../../../../domain/usecases/get_user_profile.dart';

/// Holds all data loading + derived (computed) dashboard state.
/// Mix this into `_DashboardScreenState` so the screen only deals with UI.
mixin DashboardLogicMixin<T extends StatefulWidget> on State<T> {
  final AccountRepository _accountRepository =
  const AccountRepositoryImpl(MockAccountDataSource());
  late final GetAccounts _getAccounts = GetAccounts(_accountRepository);

  final TransactionRepository _transactionRepository =
  const TransactionRepositoryImpl(MockTransactionDataSource());
  late final GetTransactions _getTransactions =
  GetTransactions(_transactionRepository);

  final BudgetRepository _budgetRepository =
  const BudgetRepositoryImpl(MockBudgetDataSource());
  late final GetBudgets _getBudgets = GetBudgets(_budgetRepository);

  final UserRepository _userRepository =
  const UserRepositoryImpl(MockUserDataSource());
  late final GetUserProfile _getUserProfile = GetUserProfile(_userRepository);

  List<Account> accounts = [];
  List<Transaction> transactions = [];
  List<Budget> budgets = [];
  UserProfile? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    final results = await Future.wait([
      _getAccounts(),
      _getTransactions(),
      _getBudgets(),
      _getUserProfile(),
    ]);
    if (!mounted) return;
    setState(() {
      accounts = results[0] as List<Account>;
      transactions = results[1] as List<Transaction>;
      budgets = results[2] as List<Budget>;
      profile = results[3] as UserProfile;
      isLoading = false;
    });
  }

  double get netWorth => accounts.fold(0, (sum, a) => sum + a.balance);

  List<double> get sparklineValues {
    final DateTime now = DateTime.now();
    final List<double> values = [];
    for (int i = 13; i >= 0; i--) {
      final DateTime day = DateTime(now.year, now.month, now.day - i);
      final double net = transactions
          .where((t) =>
      t.date.year == day.year &&
          t.date.month == day.month &&
          t.date.day == day.day)
          .fold(0.0, (sum, t) => sum + t.signedAmount);
      final double previous = values.isEmpty ? 0 : values.last;
      values.add(previous + net);
    }
    return values;
  }

  Map<TransactionCategory, double> get monthlySpendByCategory {
    final DateTime now = DateTime.now();
    final Map<TransactionCategory, double> totals = {};
    for (final Transaction t in transactions) {
      if (t.type != TransactionType.expense) continue;
      if (t.date.year != now.year || t.date.month != now.month) continue;
      totals.update(t.category, (v) => v + t.amount, ifAbsent: () => t.amount);
    }
    return totals;
  }

  String get aiInsight {
    final Map<TransactionCategory, double> totals = monthlySpendByCategory;
    if (totals.isEmpty) {
      return "You're all caught up — no spending recorded yet this month.";
    }
    final MapEntry<TransactionCategory, double> top =
    totals.entries.reduce((a, b) => a.value > b.value ? a : b);

    final List<Budget> overBudget = budgets.where((b) => b.isOverLimit).toList();
    if (overBudget.isNotEmpty) {
      final Budget b = overBudget.first;
      return "You're ${AppHelpers.formatCurrency(b.spent - b.limit)} over "
          'your ${b.category.label} budget this month.';
    }

    return 'Your biggest spend this month is ${top.key.label} at '
        '${AppHelpers.formatCurrency(top.value)}.';
  }

  List<Budget> get topBudgets {
    final List<Budget> sorted = List.of(budgets)
      ..sort((a, b) => b.progress.compareTo(a.progress));
    return sorted.take(3).toList();
  }

  List<Transaction> get recentTransactions => transactions.take(5).toList();
}