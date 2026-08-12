import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../domain/entities/subscription_plan.dart';

/// Two-segment Monthly/Yearly billing period switch.
class BillingPeriodToggle extends StatelessWidget {
  const BillingPeriodToggle({
    super.key,
    required this.period,
    required this.onChanged,
  });

  final BillingPeriod period;
  final ValueChanged<BillingPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final BorderRadius radius =
        BorderRadius.circular(responsive.radius(AppRadius.pill));

    return Container(
      padding: EdgeInsets.all(responsive.spacing(AppSpacing.xs)),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: radius,
      ),
      child: Row(
        children: [
          Expanded(
            child: _Segment(
              label: AppStrings.billingMonthly,
              selected: period == BillingPeriod.monthly,
              onTap: () => onChanged(BillingPeriod.monthly),
            ),
          ),
          Expanded(
            child: _Segment(
              label: AppStrings.billingYearly,
              selected: period == BillingPeriod.yearly,
              onTap: () => onChanged(BillingPeriod.yearly),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final BorderRadius radius =
        BorderRadius.circular(responsive.radius(AppRadius.pill));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.shortAnimationDuration,
        padding: EdgeInsets.symmetric(
          vertical: responsive.spacing(AppSpacing.sm),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: radius,
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: selected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
