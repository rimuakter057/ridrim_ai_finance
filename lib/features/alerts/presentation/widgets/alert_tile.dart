import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../domain/entities/alert.dart';

IconData _iconFor(AlertType type) => switch (type) {
      AlertType.budgetExceeded => Icons.pie_chart_outline_rounded,
      AlertType.billDue => Icons.receipt_long_outlined,
      AlertType.lowBalance => Icons.account_balance_wallet_outlined,
      AlertType.unusualSpending => Icons.warning_amber_rounded,
      AlertType.savingsMilestone => Icons.emoji_events_outlined,
    };

Color _colorFor(AlertSeverity severity, BuildContext context) => switch (severity) {
      AlertSeverity.critical => context.colorScheme.error,
      AlertSeverity.warning => Colors.amber.shade700,
      AlertSeverity.info => context.colorScheme.primary,
    };

/// A single alert row: severity-colored icon, title/message, unread dot,
/// and a relative timestamp.
class AlertTile extends StatelessWidget {
  const AlertTile({super.key, required this.alert, required this.onTap});

  final Alert alert;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final Color color = _colorFor(alert.severity, context);
    final ThemeData theme = Theme.of(context);

    return Material(
      color: alert.isRead
          ? theme.cardTheme.color ?? theme.colorScheme.surface
          : color.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.md)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border(left: BorderSide(color: color, width: 3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: responsive.width(36),
                height: responsive.width(36),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(_iconFor(alert.type), size: 18, color: color),
              ),
              SizedBox(width: responsive.spacing(AppSpacing.md)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            alert.title,
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: alert.isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!alert.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 6, top: 4),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: responsive.spacing(AppSpacing.xs) / 2),
                    Text(alert.message, style: context.textTheme.bodySmall),
                    SizedBox(height: responsive.spacing(AppSpacing.xs) / 2),
                    Text(
                      alert.timestamp.timeAgo,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
