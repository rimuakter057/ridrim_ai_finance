import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_loading.dart';

/// Left-aligned "AI is typing..." placeholder bubble shown while a reply
/// is being generated. Glassmorphic to match [ChatBubble]'s AI bubbles.
class TypingBubble extends StatelessWidget {
  const TypingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final BorderRadius radius =
        BorderRadius.circular(responsive.radius(AppRadius.lg));

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: responsive.spacing(AppSpacing.md)),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.spacing(AppSpacing.lg),
                vertical: responsive.spacing(AppSpacing.md),
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.glassOverlayDark
                    : AppColors.glassOverlayLight,
                borderRadius: radius,
                border: Border.all(
                  color: isDark
                      ? AppColors.glassBorderDark
                      : AppColors.glassBorderLight,
                ),
              ),
              child: const AppLoading.small(),
            ),
          ),
        ),
      ),
    );
  }
}
