import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/transaction_category_style.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../domain/entities/investment.dart';

/// A single portfolio holding: type icon, name/symbol, current value, and
/// signed, color-coded gain/loss.
class HoldingTile extends StatelessWidget {
  const HoldingTile({super.key, required this.investment});

  final Investment investment;

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final Color gainColor = investment.isGaining
        ? context.colorScheme.primary
        : context.colorScheme.error;

    return AppCard(
      child: Row(
        children: [
          Container(
            width: responsive.width(40),
            height: responsive.width(40),
            decoration: BoxDecoration(
              color: investment.type.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(investment.type.icon, color: investment.type.color, size: 20),
          ),
          SizedBox(width: responsive.spacing(AppSpacing.md)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  investment.name,
                  style: context.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${investment.symbol} · ${investment.units} units',
                  style: context.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppHelpers.formatCurrency(investment.currentValue),
                style: context.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${investment.isGaining ? '+' : ''}'
                '${investment.gainLossPercent.toStringAsFixed(1)}%',
                style: context.textTheme.bodySmall
                    ?.copyWith(color: gainColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
