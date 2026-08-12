

import 'package:ai_saas/core/theme/app_radius.dart';
import 'package:ai_saas/core/theme/app_spacing.dart';
import 'package:ai_saas/core/utils/extensions.dart';
import 'package:ai_saas/core/utils/helpers.dart';
import 'package:ai_saas/core/utils/responsive.dart';
import 'package:ai_saas/core/utils/transaction_category_style.dart';
import 'package:ai_saas/domain/entities/transaction.dart';
import 'package:flutter/material.dart';

class CategoryRankRow extends StatelessWidget {
  const CategoryRankRow({super.key,
    required this.rank,
    required this.category,
    required this.amount,
    required this.fraction,
  });

  final int rank;
  final TransactionCategory category;
  final double amount;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Row(
      children: [
        Text(
          '#$rank',
          style: context.textTheme.labelMedium
              ?.copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
        SizedBox(width: responsive.spacing(AppSpacing.sm)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.label,
                    style: context.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    AppHelpers.formatCurrency(amount),
                    style: context.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: LinearProgressIndicator(
                  value: fraction.clamp(0, 1),
                  minHeight: 6,
                  backgroundColor: context.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(category.iconColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}