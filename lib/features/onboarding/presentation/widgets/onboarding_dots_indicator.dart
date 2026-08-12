import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';


class OnboardingDotsIndicator extends StatelessWidget {
  const OnboardingDotsIndicator({
    super.key,
    required this.pageCount,
    required this.currentIndex,
  });

  final int pageCount;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final double activeWidth = responsive.width(AppSpacing.xxl + AppSpacing.sm);
    final double dotSize = responsive.width(AppSpacing.sm);
    final double dotSpacing = responsive.spacing(AppSpacing.xs / 2);
    final double dotRadius = responsive.radius(AppRadius.pill);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < pageCount; i++)
          AnimatedContainer(
            duration: AppConstants.shortAnimationDuration,
            curve: Curves.easeOutCubic,
            margin: EdgeInsets.symmetric(horizontal: dotSpacing),
            width: i == currentIndex ? activeWidth : dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: i == currentIndex
                  ? colorScheme.primary
                  : colorScheme.outlineVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(dotRadius),
              boxShadow: i == currentIndex
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
      ],
    );
  }
}
