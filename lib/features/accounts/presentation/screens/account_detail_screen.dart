import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../data/datasources/mock/mock_account_data.dart';
import '../../../../data/datasources/mock/mock_transaction_data.dart';
import '../../../../data/repositories/account_repository_impl.dart';
import '../../../../data/repositories/transaction_repository_impl.dart';
import '../../../../domain/entities/account.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/repositories/account_repository.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/usecases/get_accounts.dart';
import '../../../../domain/usecases/get_transactions.dart';
import '../../../transactions/presentation/widgets/transaction_tile.dart';
import '../widgets/account_card.dart';

/// A single account's balance plus every transaction posted against it.
class AccountDetailScreen extends StatefulWidget {
  const AccountDetailScreen({super.key, required this.accountId});

  final String accountId;

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  final AccountRepository _accountRepository =
      const AccountRepositoryImpl(MockAccountDataSource());
  late final GetAccounts _getAccounts = GetAccounts(_accountRepository);

  final TransactionRepository _transactionRepository =
      const TransactionRepositoryImpl(MockTransactionDataSource());
  late final GetTransactions _getTransactions =
      GetTransactions(_transactionRepository);

  Account? _account;
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<Account> accounts = await _getAccounts();
    final List<Transaction> transactions = await _getTransactions();
    if (!mounted) return;
    final List<Account> matches =
        accounts.where((a) => a.id == widget.accountId).toList();
    setState(() {
      _account = matches.isEmpty ? null : matches.first;
      _transactions =
          transactions.where((t) => t.accountId == widget.accountId).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final Account? account = _account;

    return Scaffold(
      appBar: AppAppBar(title: account?.name ?? 'Account'),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: AppLoading())
            : account == null
                ? const AppEmptyState(
                    icon: Icons.error_outline_rounded,
                    title: 'Account not found',
                  )
                : ListView(
                    padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
                    children: [
                      AccountCard(account: account),
                      SizedBox(height: responsive.spacing(AppSpacing.xl)),
                      Text(
                        'Transactions',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: responsive.spacing(AppSpacing.sm)),
                      if (_transactions.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: responsive.spacing(AppSpacing.xl),
                          ),
                          child: const AppEmptyState(
                            icon: Icons.receipt_long_outlined,
                            title: 'No transactions on this account yet',
                          ),
                        )
                      else
                        for (final t in _transactions)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: responsive.spacing(AppSpacing.xs),
                            ),
                            child: TransactionTile(transaction: t),
                          ),
                    ],
                  ),
      ),
    );
  }
}
