import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../domain/entities/savings_goal.dart';
import 'savings_goal_icon.dart';

/// A single savings goal: icon, progress bar, target date, and an
/// "Add funds" action.
class SavingsGoalCard extends StatelessWidget {
  const SavingsGoalCard({
    super.key,
    required this.goal,
    required this.onAddFunds,
  });

  final SavingsGoal goal;
  final VoidCallback onAddFunds;

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final (IconData icon, Color color) = savingsGoalVisual(goal.iconKey);
    final int daysLeft = goal.daysRemaining;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: responsive.width(44),
                height: responsive.width(44),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: color, size: responsive.iconSize(22)),
              ),
              SizedBox(width: responsive.spacing(AppSpacing.md)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.name,
                      style: context.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      goal.isComplete
                          ? 'Goal reached!'
                          : daysLeft > 0
                              ? '$daysLeft days left'
                              : 'Target date passed',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: goal.isComplete
                            ? context.colorScheme.primary
                            : context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '${(goal.progress * 100).round()}%',
                  style: context.textTheme.labelSmall
                      ?.copyWith(color: color, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(AppSpacing.md)),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: goal.progress,
              minHeight: 10,
              backgroundColor: context.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          SizedBox(height: responsive.spacing(AppSpacing.sm)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppHelpers.formatCurrency(goal.currentAmount)} of '
                '${AppHelpers.formatCurrency(goal.targetAmount)}',
                style: context.textTheme.bodySmall,
              ),
              if (!goal.isComplete)
                TextButton(
                  onPressed: onAddFunds,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Add funds'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
