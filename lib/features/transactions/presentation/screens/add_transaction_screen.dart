import 'package:ai_saas/features/transactions/presentation/controller/add_transaction_controller.dart';
import 'package:ai_saas/features/transactions/presentation/widgets/picked_field.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/transaction_category_style.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../domain/entities/transaction.dart';


class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with AddTransactionControllerMixin {
  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Scaffold(
      appBar: const AppAppBar(title: 'Add Transaction'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<TransactionType>(
                  segments: const [
                    ButtonSegment(
                      value: TransactionType.expense,
                      label: Text('Expense'),
                      icon: Icon(Icons.arrow_upward_rounded),
                    ),
                    ButtonSegment(
                      value: TransactionType.income,
                      label: Text('Income'),
                      icon: Icon(Icons.arrow_downward_rounded),
                    ),
                  ],
                  selected: {type},
                  onSelectionChanged: (selection) => setType(selection.first),
                ),
                SizedBox(height: responsive.spacing(AppSpacing.xl)),
                AppTextField(
                  label: 'Amount',
                  hint: '0.00',
                  controller: amountController,
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: Icons.attach_money_rounded,
                  validator: validateAmount,
                ),
                SizedBox(height: responsive.spacing(AppSpacing.lg)),
                AppTextField(
                  label: 'Title',
                  hint: 'e.g. Groceries',
                  controller: titleController,
                  validator: validateTitle,
                ),
                SizedBox(height: responsive.spacing(AppSpacing.lg)),
                PickerField(
                  label: 'Category',
                  value: category.label,
                  icon: category.icon,
                  onTap: pickCategory,
                ),
                SizedBox(height: responsive.spacing(AppSpacing.lg)),
                PickerField(
                  label: 'Account',
                  value: selectedAccount?.name ?? 'Select an account',
                  icon: Icons.account_balance_wallet_outlined,
                  onTap: pickAccount,
                ),
                SizedBox(height: responsive.spacing(AppSpacing.lg)),
                AppTextField(
                  label: 'Note (optional)',
                  hint: 'Add a note...',
                  controller: noteController,
                  maxLines: 3,
                ),
                SizedBox(height: responsive.spacing(AppSpacing.xxl)),
                AppButton(
                  label: 'Save Transaction',
                  isLoading: isSubmitting,
                  fullWidth: true,
                  onPressed: submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}