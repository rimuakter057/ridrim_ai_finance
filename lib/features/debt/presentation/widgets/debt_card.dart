import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/transaction_category_style.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../domain/entities/debt.dart';

/// A single tracked debt: type icon, payoff progress bar, balance,
/// interest rate, and minimum payment.
class DebtCard extends StatelessWidget {
  const DebtCard({super.key, required this.debt});

  final Debt debt;

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final Color color = debt.type.color;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: responsive.width(40),
                height: responsive.width(40),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(debt.type.icon, color: color, size: 20),
              ),
              SizedBox(width: responsive.spacing(AppSpacing.md)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      debt.name,
                      style: context.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${debt.type.label} · ${debt.interestRate.toStringAsFixed(2)}% APR',
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                AppHelpers.formatCurrency(debt.balance),
                style: context.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(AppSpacing.md)),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: debt.paidOffProgress,
              minHeight: 8,
              backgroundColor: context.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          SizedBox(height: responsive.spacing(AppSpacing.xs)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(debt.paidOffProgress * 100).round()}% paid off',
                style: context.textTheme.bodySmall,
              ),
              Text(
                'Min. ${AppHelpers.formatCurrency(debt.minimumPayment)}/mo',
                style: context.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
