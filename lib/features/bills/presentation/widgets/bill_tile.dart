import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../domain/entities/bill.dart';

/// A single bill row: recurrence icon, due-date status, amount, and a
/// checkbox to mark it paid.
class BillTile extends StatelessWidget {
  const BillTile({
    super.key,
    required this.bill,
    required this.onTogglePaid,
  });

  final Bill bill;
  final ValueChanged<bool> onTogglePaid;

  String get _dueLabel {
    if (bill.isPaid) return 'Paid';
    final int days = bill.daysUntilDue;
    if (days < 0) return '${-days}d overdue';
    if (days == 0) return 'Due today';
    return 'Due in ${days}d';
  }

  IconData get _recurrenceIcon => switch (bill.recurrence) {
        BillRecurrence.oneTime => Icons.receipt_outlined,
        BillRecurrence.weekly => Icons.repeat_rounded,
        BillRecurrence.monthly => Icons.calendar_month_outlined,
        BillRecurrence.yearly => Icons.event_repeat_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final Color statusColor = bill.isPaid
        ? context.colorScheme.onSurfaceVariant
        : bill.isOverdue
            ? context.colorScheme.error
            : context.colorScheme.primary;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: bill.isPaid,
            onChanged: (value) => onTogglePaid(value ?? false),
          ),
          Container(
            width: responsive.width(36),
            height: responsive.width(36),
            margin: EdgeInsets.only(top: responsive.spacing(AppSpacing.xs)),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(_recurrenceIcon, size: 18, color: statusColor),
          ),
          SizedBox(width: responsive.spacing(AppSpacing.md)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bill.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration:
                        bill.isPaid ? TextDecoration.lineThrough : null,
                    color: bill.isPaid
                        ? context.colorScheme.onSurfaceVariant
                        : null,
                  ),
                ),
                Text(
                  '${bill.payee ?? ''} · $_dueLabel',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: responsive.spacing(AppSpacing.sm)),
          Text(
            AppHelpers.formatCurrency(bill.amount),
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: bill.isPaid ? context.colorScheme.onSurfaceVariant : null,
            ),
          ),
        ],
      ),
    );
  }
}
