import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/transaction_category_style.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../domain/entities/account.dart';

/// A single linked-account card: institution, type icon, name, balance.
class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.account,
    this.onTap,
    this.compact = false,
  });

  final Account account;
  final VoidCallback? onTap;

  /// Narrower, fixed-width rendering for horizontal carousels (Dashboard).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final bool isNegative = account.balance < 0;

    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: responsive.width(36),
              height: responsive.width(36),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                account.type.icon,
                color: theme.colorScheme.primary,
                size: responsive.iconSize(18),
              ),
            ),
            SizedBox(width: responsive.spacing(AppSpacing.sm)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    account.institution,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.spacing(AppSpacing.md)),
        Text(
          AppHelpers.formatCurrency(account.balance),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isNegative ? theme.colorScheme.error : null,
          ),
        ),
        Text(account.type.label, style: theme.textTheme.bodySmall),
      ],
    );

    return SizedBox(
      width: compact ? responsive.width(190) : null,
      child: AppCard(onTap: onTap, child: content),
    );
  }
}
