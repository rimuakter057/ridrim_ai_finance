import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_loading.dart';

/// Premium call-to-action button filled with the centralized brand blue
/// gradient (deep navy blue -> primary blue -> soft blue highlight).
class AppGradientButton extends StatelessWidget {
  const AppGradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
    this.width,
    this.height = 52,
    this.radius = AppRadius.md,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  final double? width;
  final double height;
  final double radius;

  bool get _isDisabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .labelLarge
        ?.copyWith(color: colorScheme.onPrimary);
    final BorderRadius borderRadius = BorderRadius.circular(radius);

    return Opacity(
      opacity: _isDisabled && !isLoading ? 0.5 : 1,
      child: SizedBox(
        width: fullWidth ? double.infinity : width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: borderRadius,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: borderRadius,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: _isDisabled ? null : onPressed,
              child: Center(
                child: isLoading
                    ? AppLoading.button(color: colorScheme.onPrimary)
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[
                            Icon(icon, size: 18, color: colorScheme.onPrimary),
                            const SizedBox(width: AppSpacing.sm),
                          ],
                          Text(label, style: labelStyle),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
