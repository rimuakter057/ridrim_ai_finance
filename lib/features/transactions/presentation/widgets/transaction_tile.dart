import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/transaction_category_style.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../domain/entities/transaction.dart';

/// A single transaction row: category icon, title/merchant, and a signed,
/// color-coded amount. Reused by Transactions, Accounts, and the Dashboard.
class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
  });

  final Transaction transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final bool isIncome = transaction.type == TransactionType.income;
    final Color amountColor =
        isIncome ? theme.colorScheme.primary : theme.colorScheme.onSurface;

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.spacing(AppSpacing.md),
        vertical: responsive.spacing(AppSpacing.sm),
      ),
      child: Row(
        children: [
          Container(
            width: responsive.width(40),
            height: responsive.width(40),
            decoration: BoxDecoration(
              color: transaction.category.bgColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              transaction.category.icon,
              color: transaction.category.iconColor,
              size: responsive.iconSize(20),
            ),
          ),
          SizedBox(width: responsive.spacing(AppSpacing.md)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${transaction.merchant ?? transaction.category.label} · '
                  '${transaction.date.toFormattedDate()}',
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: responsive.spacing(AppSpacing.sm)),
          Text(
            '${isIncome ? '+' : '-'}'
            '${AppHelpers.formatCurrency(transaction.amount)}',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
