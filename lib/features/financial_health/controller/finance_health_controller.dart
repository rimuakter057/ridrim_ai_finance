import 'package:ai_saas/core/utils/extensions.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

import '../../../../core/utils/financial_health_calculator.dart';
import '../../../../data/datasources/mock/mock_account_data.dart';
import '../../../../data/datasources/mock/mock_budget_data.dart';
import '../../../../data/datasources/mock/mock_transaction_data.dart';
import '../../../../data/repositories/account_repository_impl.dart';
import '../../../../data/repositories/budget_repository_impl.dart';
import '../../../../data/repositories/transaction_repository_impl.dart';
import '../../../../domain/entities/account.dart';
import '../../../../domain/entities/budget.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/repositories/account_repository.dart';
import '../../../../domain/repositories/budget_repository.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/usecases/get_accounts.dart';
import '../../../../domain/usecases/get_budgets.dart';
import '../../../../domain/usecases/get_transactions.dart';

/// Holds data loading + derived (computed) financial-health state.
/// Mix this into `_FinancialHealthScreenState` so the screen only deals
/// with UI.
mixin FinancialHealthControllerMixin<T extends StatefulWidget> on State<T> {
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

  List<Account> accounts = [];
  List<Transaction> transactions = [];
  List<Budget> budgets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFinancialHealth();
  }

  Future<void> loadFinancialHealth() async {
    final results = await Future.wait([
      _getAccounts(),
      _getTransactions(),
      _getBudgets(),
    ]);
    if (!mounted) return;
    setState(() {
      accounts = results[0] as List<Account>;
      transactions = results[1] as List<Transaction>;
      budgets = results[2] as List<Budget>;
      isLoading = false;
    });
  }

  double get budgetAdherenceScore =>
      FinancialHealthCalculator.budgetAdherenceScore(budgets);

  double get savingsRateScore =>
      FinancialHealthCalculator.savingsRateScore(transactions);

  double get emergencyFundScore =>
      FinancialHealthCalculator.emergencyFundScore(accounts, transactions);

  double get overallScore => FinancialHealthCalculator.overallScore(
    accounts: accounts,
    transactions: transactions,
    budgets: budgets,
  );

  /// Maps a score to a (label, color) rating. Kept here since it's pure
  /// derived presentation data, not widget-building logic.
  (String, Color) ratingFor(double score, BuildContext context) {
    if (score >= 80) return ('Excellent', context.colorScheme.primary);
    if (score >= 60) return ('Good', context.colorScheme.primary);
    if (score >= 40) return ('Fair', Colors.amber.shade700);
    return ('Needs Attention', context.colorScheme.error);
  }
}