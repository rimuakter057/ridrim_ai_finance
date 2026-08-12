import 'package:ai_saas/core/utils/extensions.dart';
import 'package:ai_saas/core/utils/helpers.dart' show AppHelpers;
import 'package:ai_saas/core/utils/transaction_category_style.dart';
import 'package:ai_saas/core/widgets/app_card.dart';
import 'package:ai_saas/domain/entities/budget.dart';
import 'package:ai_saas/features/budget/presentation/widgets/radial_progress_gauge.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';


class BudgetCategoryCard extends StatelessWidget {
  const BudgetCategoryCard({super.key, required this.budget});

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final Color gaugeColor =
    budget.isOverLimit ? context.colorScheme.error : budget.category.iconColor;

    return AppCard(
      child: Row(
        children: [
          RadialProgressGauge(
            size: responsive.width(56),
            strokeWidth: 6,
            progress: budget.progress.clamp(0, 1).toDouble(),
            color: gaugeColor,
            child: Icon(budget.category.icon, size: 20, color: gaugeColor),
          ),
          SizedBox(width: responsive.spacing(AppSpacing.md)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  budget.category.label,
                  style: context.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  budget.isOverLimit
                      ? '${AppHelpers.formatCurrency(budget.spent - budget.limit)} over budget'
                      : '${AppHelpers.formatCurrency(budget.remaining)} left',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: budget.isOverLimit
                        ? context.colorScheme.error
                        : context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppHelpers.formatCurrency(budget.spent),
                style: context.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'of ${AppHelpers.formatCurrency(budget.limit)}',
                style: context.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}