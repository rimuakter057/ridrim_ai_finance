import 'package:ai_saas/core/utils/transaction_category_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../data/datasources/mock/mock_account_data.dart';
import '../../../../data/datasources/mock/mock_transaction_data.dart';
import '../../../../data/repositories/account_repository_impl.dart';
import '../../../../data/repositories/transaction_repository_impl.dart';
import '../../../../domain/entities/account.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/repositories/account_repository.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/usecases/add_transaction.dart';
import '../../../../domain/usecases/get_accounts.dart';
import '../../../settings/presentation/widgets/settings_option_sheet.dart';


mixin AddTransactionControllerMixin<T extends StatefulWidget> on State<T> {
  final TransactionRepository _transactionRepository =
  const TransactionRepositoryImpl(MockTransactionDataSource());
  late final AddTransaction _addTransaction =
  AddTransaction(_transactionRepository);

  final AccountRepository _accountRepository =
  const AccountRepositoryImpl(MockAccountDataSource());
  late final GetAccounts _getAccounts = GetAccounts(_accountRepository);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  List<Account> accounts = [];
  Account? selectedAccount;
  TransactionCategory category = TransactionCategory.other;
  TransactionType type = TransactionType.expense;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    loadAccounts();
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> loadAccounts() async {
    final List<Account> loaded = await _getAccounts();
    if (!mounted) return;
    setState(() {
      accounts = loaded;
      selectedAccount = loaded.isNotEmpty ? loaded.first : null;
    });
  }

  void setType(TransactionType value) => setState(() => type = value);

  Future<void> pickCategory() async {
    final TransactionCategory? selected =
    await showSettingsOptionSheet<TransactionCategory>(
      context: context,
      title: 'Category',
      options: TransactionCategory.values,
      selected: category,
      labelBuilder: (c) => c.label,
    );
    if (selected != null) setState(() => category = selected);
  }

  Future<void> pickAccount() async {
    if (accounts.isEmpty) return;
    final Account? selected = await showSettingsOptionSheet<Account>(
      context: context,
      title: 'Account',
      options: accounts,
      selected: selectedAccount ?? accounts.first,
      labelBuilder: (a) => a.name,
    );
    if (selected != null) setState(() => selectedAccount = selected);
  }

  String? validateAmount(String? value) {
    final double? parsed = double.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed <= 0) return 'Enter a valid amount';
    return null;
  }

  String? validateTitle(String? value) =>
      value == null || value.trim().isEmpty ? 'Enter a title' : null;

  Future<void> submit() async {
    context.hideKeyboard();
    if (!formKey.currentState!.validate() || selectedAccount == null) return;

    setState(() => isSubmitting = true);
    final double amount = double.parse(amountController.text.trim());
    await _addTransaction(
      Transaction(
        id: AppHelpers.generateId(),
        accountId: selectedAccount!.id,
        title: titleController.text.trim(),
        category: category,
        amount: amount,
        type: type,
        date: DateTime.now(),
        note: noteController.text.trim().isEmpty
            ? null
            : noteController.text.trim(),
      ),
    );
    if (!mounted) return;
    setState(() => isSubmitting = false);
    context.showSnackBar('Transaction added');
    context.pop();
  }
}