import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/transaction_category_style.dart';
import '../../../../domain/entities/budget.dart';

/// Compact progress bars for a handful of budgets -- used on the Dashboard
/// to surface the categories closest to (or over) their limit.
class BudgetProgressList extends StatelessWidget {
  const BudgetProgressList({super.key, required this.budgets});

  final List<Budget> budgets;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Column(
      children: [
        for (final budget in budgets)
          Padding(
            padding: EdgeInsets.only(
              bottom: responsive.spacing(AppSpacing.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      budget.category.label,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${AppHelpers.formatCurrency(budget.spent)} / '
                      '${AppHelpers.formatCurrency(budget.limit)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: responsive.spacing(AppSpacing.xs)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: LinearProgressIndicator(
                    value: budget.progress.clamp(0, 1).toDouble(),
                    minHeight: 8,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      budget.isOverLimit
                          ? theme.colorScheme.error
                          : budget.category.iconColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
