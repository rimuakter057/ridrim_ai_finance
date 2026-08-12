import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../data/datasources/mock/mock_transaction_data.dart';
import '../../../../data/repositories/transaction_repository_impl.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/usecases/get_transactions.dart';
import '../widgets/category_filter_row.dart';
import '../widgets/transaction_tile.dart';

/// Full transaction history: search, category filter, grouped by date.
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TransactionRepository _repository =
      const TransactionRepositoryImpl(MockTransactionDataSource());
  late final GetTransactions _getTransactions = GetTransactions(_repository);

  final TextEditingController _searchController = TextEditingController();

  List<Transaction> _transactions = [];
  bool _isLoading = true;
  TransactionCategory? _categoryFilter;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final List<Transaction> transactions = await _getTransactions();
    if (!mounted) return;
    setState(() {
      _transactions = transactions;
      _isLoading = false;
    });
  }

  List<Transaction> get _filtered {
    return _transactions.where((t) {
      final bool matchesCategory =
          _categoryFilter == null || t.category == _categoryFilter;
      final bool matchesQuery = _query.isEmpty ||
          t.title.toLowerCase().contains(_query.toLowerCase()) ||
          (t.merchant?.toLowerCase().contains(_query.toLowerCase()) ?? false);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  Map<String, List<Transaction>> _groupedByDate(List<Transaction> items) {
    final Map<String, List<Transaction>> grouped = {};
    for (final Transaction t in items) {
      final String key = t.date.isToday
          ? 'Today'
          : t.date.isYesterday
              ? 'Yesterday'
              : t.date.toFormattedDate();
      grouped.putIfAbsent(key, () => []).add(t);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final List<Transaction> filtered = _filtered;
    final Map<String, List<Transaction>> grouped = _groupedByDate(filtered);

    return Scaffold(
      appBar: AppAppBar(
        title: 'Transactions',
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => context.push(AppRoutes.addTransaction),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: AppLoading())
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      responsive.spacing(AppSpacing.lg),
                      responsive.spacing(AppSpacing.sm),
                      responsive.spacing(AppSpacing.lg),
                      0,
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                      decoration: const InputDecoration(
                        hintText: 'Search transactions...',
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.spacing(AppSpacing.md)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.spacing(AppSpacing.lg),
                    ),
                    child: CategoryFilterRow(
                      selected: _categoryFilter,
                      onSelected: (category) =>
                          setState(() => _categoryFilter = category),
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? const AppEmptyState(
                            icon: Icons.receipt_long_outlined,
                            title: 'No transactions found',
                            description: 'Try a different search or filter.',
                          )
                        : ListView(
                            padding: EdgeInsets.all(
                              responsive.spacing(AppSpacing.lg),
                            ),
                            children: [
                              for (final entry in grouped.entries) ...[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        responsive.spacing(AppSpacing.sm),
                                  ),
                                  child: Text(
                                    entry.key,
                                    style: context.textTheme.labelLarge
                                        ?.copyWith(
                                      color: context
                                          .colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                for (final t in entry.value)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom:
                                          responsive.spacing(AppSpacing.xs),
                                    ),
                                    child: TransactionTile(
                                      transaction: t,
                                      onTap: () => context.push(
                                        AppRoutes.transactionDetail(t.id),
                                      ),
                                    ),
                                  ),
                              ],
                            ],
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
