import 'package:flutter/material.dart';

import '../../../../data/datasources/mock/mock_transaction_data.dart';
import '../../../../data/repositories/transaction_repository_impl.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/usecases/get_transactions.dart';

/// Holds data loading + derived (computed) analytics state.
/// Mix this into `_AnalyticsScreenState` so the screen only deals with UI.
mixin AnalyticsControllerMixin<T extends StatefulWidget> on State<T> {
  final TransactionRepository _repository =
  const TransactionRepositoryImpl(MockTransactionDataSource());
  late final GetTransactions _getTransactions = GetTransactions(_repository);

  List<Transaction> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    final List<Transaction> loaded = await _getTransactions();
    if (!mounted) return;
    setState(() {
      transactions = loaded;
      isLoading = false;
    });
  }

  double get totalIncome => transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);

  /// Total expense per week for the last 4 weeks, oldest first.
  List<double> get weeklyTotals {
    final DateTime now = DateTime.now();
    final List<double> weeks = [];
    for (int i = 3; i >= 0; i--) {
      final DateTime weekStart = now.subtract(Duration(days: (i + 1) * 7));
      final DateTime weekEnd = now.subtract(Duration(days: i * 7));
      final double total = transactions
          .where((t) =>
      t.type == TransactionType.expense &&
          t.date.isAfter(weekStart) &&
          !t.date.isAfter(weekEnd))
          .fold(0.0, (sum, t) => sum + t.amount);
      weeks.add(total);
    }
    return weeks;
  }

  Map<TransactionCategory, double> get totalsByCategory {
    final Map<TransactionCategory, double> totals = {};
    for (final Transaction t in transactions) {
      if (t.type != TransactionType.expense) continue;
      totals.update(t.category, (v) => v + t.amount, ifAbsent: () => t.amount);
    }
    return totals;
  }
}