import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import 'savings_goal_icon.dart';

/// The data collected by [showAddGoalSheet].
class NewGoalInput {
  const NewGoalInput({
    required this.name,
    required this.targetAmount,
    required this.months,
    required this.iconKey,
  });

  final String name;
  final double targetAmount;
  final int months;
  final String iconKey;
}

/// Bottom sheet for creating a new savings goal. Returns `null` if
/// dismissed without submitting.
Future<NewGoalInput?> showAddGoalSheet(BuildContext context) {
  return showModalBottomSheet<NewGoalInput>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _AddGoalSheet(),
  );
}

class _AddGoalSheet extends StatefulWidget {
  const _AddGoalSheet();

  @override
  State<_AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends State<_AddGoalSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _monthsController =
      TextEditingController(text: '6');
  String _iconKey = savingsGoalIconKeys.first;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _monthsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      NewGoalInput(
        name: _nameController.text.trim(),
        targetAmount: double.parse(_amountController.text.trim()),
        months: int.parse(_monthsController.text.trim()),
        iconKey: _iconKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final ThemeData theme = Theme.of(context);

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
              Text('New Savings Goal', style: theme.textTheme.titleMedium),
              SizedBox(height: responsive.spacing(AppSpacing.lg)),
              Wrap(
                spacing: responsive.spacing(AppSpacing.sm),
                children: [
                  for (final key in savingsGoalIconKeys)
                    _IconChoice(
                      iconKey: key,
                      selected: key == _iconKey,
                      onTap: () => setState(() => _iconKey = key),
                    ),
                ],
              ),
              SizedBox(height: responsive.spacing(AppSpacing.lg)),
              AppTextField(
                label: 'Goal name',
                hint: 'e.g. New Laptop',
                controller: _nameController,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Enter a name' : null,
              ),
              SizedBox(height: responsive.spacing(AppSpacing.lg)),
              AppTextField(
                label: 'Target amount',
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
              SizedBox(height: responsive.spacing(AppSpacing.lg)),
              AppTextField(
                label: 'Months to reach it',
                hint: '6',
                controller: _monthsController,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.calendar_month_outlined,
                validator: (value) {
                  final int? parsed = int.tryParse(value?.trim() ?? '');
                  if (parsed == null || parsed <= 0) return 'Enter a valid number';
                  return null;
                },
              ),
              SizedBox(height: responsive.spacing(AppSpacing.xl)),
              AppButton(label: 'Create Goal', fullWidth: true, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconChoice extends StatelessWidget {
  const _IconChoice({
    required this.iconKey,
    required this.selected,
    required this.onTap,
  });

  final String iconKey;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color) = savingsGoalVisual(iconKey);
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.2) : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}
