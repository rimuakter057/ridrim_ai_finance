import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Gradient card showing the current plan, credits usage, and upgrade button.
class ProfilePlanCard extends StatelessWidget {
  const ProfilePlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.planCardGradient,
        borderRadius: BorderRadius.circular(
          responsive.radius(AppRadius.lg),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.currentPlanLabel.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white70,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: responsive.spacing(AppSpacing.xs / 2)),
                  Row(
                    children: [
                      Text(
                        '${AppStrings.planPro} Plan',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: responsive.spacing(AppSpacing.xs)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.spacing(AppSpacing.xs),
                          vertical: responsive.spacing(AppSpacing.xs / 2),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(
                            responsive.radius(AppRadius.sm),
                          ),
                        ),
                        child: Text(
                          AppStrings.activeStatusBadge,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.push(AppRoutes.subscription),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.buttonDarkForeground,
                  shape: const StadiumBorder(),
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.spacing(AppSpacing.lg),
                    vertical: responsive.spacing(AppSpacing.xs),
                  ),
                ),
                child: const Text(
                  AppStrings.upgradeLabel,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(AppSpacing.lg)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.creditsUsedLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
              Text(
                AppStrings.creditsValue,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(AppSpacing.xs)),
          ClipRRect(
            borderRadius: BorderRadius.circular(
              responsive.radius(AppRadius.pill),
            ),
            child: const LinearProgressIndicator(
              value: 0.64,
              minHeight: 6,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.progressCyan,
              ),
            ),
          ),
          SizedBox(height: responsive.spacing(AppSpacing.xs)),
          Text(
            AppStrings.resetInfo,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white60,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
