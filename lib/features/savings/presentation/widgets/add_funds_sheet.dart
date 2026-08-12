import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Bottom sheet collecting a contribution amount for a savings goal.
/// Returns the parsed amount, or `null` if dismissed without submitting.
Future<double?> showAddFundsSheet(BuildContext context, String goalName) {
  return showModalBottomSheet<double>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _AddFundsSheet(goalName: goalName),
  );
}

class _AddFundsSheet extends StatefulWidget {
  const _AddFundsSheet({required this.goalName});

  final String goalName;

  @override
  State<_AddFundsSheet> createState() => _AddFundsSheetState();
}

class _AddFundsSheetState extends State<_AddFundsSheet> {
  final TextEditingController _amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(double.parse(_amountController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        responsive.spacing(AppSpacing.lg),
        responsive.spacing(AppSpacing.lg),
        responsive.spacing(AppSpacing.lg),
        MediaQuery.viewInsetsOf(context).bottom +
            responsive.spacing(AppSpacing.lg),
      ),
      child: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add funds to ${widget.goalName}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: responsive.spacing(AppSpacing.lg)),
              AppTextField(
                label: 'Amount',
                hint: '0.00',
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: Icons.attach_money_rounded,
                validator: (value) {
                  final double? parsed = double.tryParse(value?.trim() ?? '');
                  if (parsed == null || parsed <= 0) return 'Enter a valid amount';
                  return null;
                },
              ),
              SizedBox(height: responsive.spacing(AppSpacing.xl)),
              AppButton(label: 'Add Funds', fullWidth: true, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
