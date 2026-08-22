import 'package:ridrim/features/transactions/presentation/widgets/detail_row.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/transaction_category_style.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../data/datasources/mock/mock_transaction_data.dart';
import '../../../../data/repositories/transaction_repository_impl.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/usecases/get_transactions.dart';

/// A single transaction's full detail.
class TransactionDetailScreen extends StatefulWidget {
  const TransactionDetailScreen({super.key, required this.transactionId});

  final String transactionId;

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  final TransactionRepository _repository =
      const TransactionRepositoryImpl(MockTransactionDataSource());
  late final GetTransactions _getTransactions = GetTransactions(_repository);

  Transaction? _transaction;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<Transaction> transactions = await _getTransactions();
    final List<Transaction> matches =
        transactions.where((t) => t.id == widget.transactionId).toList();
    if (!mounted) return;
    setState(() {
      _transaction = matches.isEmpty ? null : matches.first;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final Transaction? transaction = _transaction;

    return Scaffold(
      appBar: const AppAppBar(title: 'Transaction'),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: AppLoading())
            : transaction == null
                ? const AppEmptyState(
                    icon: Icons.error_outline_rounded,
                    title: 'Transaction not found',
                  )
                : ListView(
                    padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: responsive.width(64),
                              height: responsive.width(64),
                              decoration: BoxDecoration(
                                color: transaction.category.bgColor,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.xl),
                              ),
                              child: Icon(
                                transaction.category.icon,
                                color: transaction.category.iconColor,
                                size: responsive.iconSize(30),
                              ),
                            ),
                            SizedBox(height: responsive.spacing(AppSpacing.lg)),
                            Text(
                              '${transaction.type == TransactionType.income ? '+' : '-'}'
                              '${AppHelpers.formatCurrency(transaction.amount)}',
                              style: context.textTheme.displaySmall?.copyWith(
                                color: transaction.type ==
                                        TransactionType.income
                                    ? context.colorScheme.primary
                                    : context.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: responsive.spacing(AppSpacing.xs)),
                            Text(
                              transaction.title,
                              style: context.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: responsive.spacing(AppSpacing.xxl)),
                      AppCard(
                        child: Column(
                          children: [
                            DetailRow(
                              label: 'Category',
                              value: transaction.category.label,
                            ),
                            const Divider(),
                            DetailRow(
                              label: 'Merchant',
                              value: transaction.merchant ?? '—',
                            ),
                            const Divider(),
                            DetailRow(
                              label: 'Date',
                              value: transaction.date.toFormattedDate(),
                            ),
                            const Divider(),
                            DetailRow(
                              label: 'Time',
                              value: transaction.date.toFormattedTime(),
                            ),
                            if (transaction.note != null) ...[
                              const Divider(),
                              DetailRow(
                                label: 'Note',
                                value: transaction.note!,
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


