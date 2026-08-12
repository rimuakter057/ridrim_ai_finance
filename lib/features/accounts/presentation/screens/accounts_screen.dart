import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../data/datasources/mock/mock_account_data.dart';
import '../../../../data/repositories/account_repository_impl.dart';
import '../../../../domain/entities/account.dart';
import '../../../../domain/repositories/account_repository.dart';
import '../../../../domain/usecases/get_accounts.dart';
import '../widgets/account_card.dart';

/// Every linked account, full-width, with balance and type.
class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  final AccountRepository _repository =
      const AccountRepositoryImpl(MockAccountDataSource());
  late final GetAccounts _getAccounts = GetAccounts(_repository);

  List<Account> _accounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<Account> accounts = await _getAccounts();
    if (!mounted) return;
    setState(() {
      _accounts = accounts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Scaffold(
      appBar: const AppAppBar(title: 'Accounts'),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: AppLoading())
            : _accounts.isEmpty
                ? const AppEmptyState(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'No linked accounts',
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
                    itemCount: _accounts.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: responsive.spacing(AppSpacing.md)),
                    itemBuilder: (context, index) {
                      final Account account = _accounts[index];
                      return AccountCard(
                        account: account,
                        onTap: () => context.push('/accounts/${account.id}'),
                      );
                    },
                  ),
      ),
    );
  }
}
