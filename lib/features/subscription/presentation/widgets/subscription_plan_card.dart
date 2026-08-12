import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_gradient_button.dart';
import '../../../../domain/entities/subscription_plan.dart';

/// A single subscription plan card: name, price for the selected billing
/// period, feature list, and a subscribe/current-plan action.
class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.billingPeriod,
    required this.onSubscribe,
  });

  final SubscriptionPlan plan;
  final BillingPeriod billingPeriod;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final double price = plan.priceFor(billingPeriod);
    final String priceText = price == 0
        ? AppStrings.planFree
        : billingPeriod == BillingPeriod.monthly
            ? AppStrings.pricePerMonth(price.toStringAsFixed(0))
            : AppStrings.pricePerYear(price.toStringAsFixed(0));
    final BorderRadius borderRadius =
        BorderRadius.circular(responsive.radius(AppRadius.lg));

    return Container(
      padding: EdgeInsets.all(responsive.spacing(AppSpacing.xl)),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: borderRadius,
        border: Border.all(
          color: plan.isPopular
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
          width: plan.isPopular ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(plan.name, style: theme.textTheme.titleLarge),
              if (plan.isPopular)
                _Badge(
                  label: AppStrings.mostPopularBadge,
                  background: theme.colorScheme.primary,
                  foreground: theme.colorScheme.onPrimary,
                )
              else if (plan.isCurrent)
                _Badge(
                  label: AppStrings.currentPlanBadge,
                  background: theme.colorScheme.surfaceContainerHighest,
                  foreground: theme.colorScheme.onSurfaceVariant,
                  bordered: true,
                ),
            ],
          ),
          SizedBox(height: responsive.spacing(AppSpacing.sm)),
          Text(priceText, style: theme.textTheme.headlineMedium),
          SizedBox(height: responsive.spacing(AppSpacing.xl)),
          for (final String feature in plan.features)
            Padding(
              padding: EdgeInsets.only(
                bottom: responsive.spacing(AppSpacing.sm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: responsive.iconSize(18),
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: responsive.spacing(AppSpacing.sm)),
                  Expanded(
                    child: Text(feature, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
          SizedBox(height: responsive.spacing(AppSpacing.md)),
          if (plan.isCurrent)
            AppButton(
              label: AppStrings.currentPlanBadge,
              variant: AppButtonVariant.outline,
              fullWidth: true,
              onPressed: null,
            )
          else if (plan.isPopular)
            AppGradientButton(
              label: AppStrings.getStartedLabel,
              fullWidth: true,
              onPressed: onSubscribe,
            )
          else
            AppButton(
              label: AppStrings.getStartedLabel,
              variant: AppButtonVariant.outline,
              fullWidth: true,
              onPressed: onSubscribe,
            ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.background,
    required this.foreground,
    this.bordered = false,
  });

  final String label;
  final Color background;
  final Color foreground;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.spacing(AppSpacing.sm),
        vertical: responsive.spacing(AppSpacing.xs),
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(responsive.radius(AppRadius.pill)),
        border:
            bordered ? Border.all(color: theme.colorScheme.outline) : null,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(color: foreground),
      ),
    );
  }
}
