import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_loading.dart';

enum AppButtonVariant { primary, secondary, outline, text }

/// Reusable button that switches between the app's primary, secondary,
/// outline and text styles while staying fully theme-aware.
///
/// The primary variant renders a glossy vertical gradient (soft highlight
/// -> brand blue -> deep navy) with a subtle blue glow, matching the
/// premium dark-navy SaaS look of the design system.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.leading,
    this.fullWidth = false,
    this.width,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  /// A custom leading widget (e.g. an SVG brand icon) shown instead of
  /// [icon] when provided.
  final Widget? leading;
  final bool fullWidth;
  final double? width;
  final double height;

  bool get _isDisabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final VoidCallback? effectiveOnPressed = _isDisabled ? null : onPressed;

    final Widget child = isLoading
        ? AppLoading.button(color: _loadingColor(colorScheme))
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSpacing.sm),
              ] else if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label),
            ],
          );

    final Widget button = variant == AppButtonVariant.primary
        ? _buildPrimary(context, colorScheme, child, effectiveOnPressed)
        : _buildStandard(context, colorScheme, child, effectiveOnPressed);

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height,
      child: button,
    );
  }

  Widget _buildPrimary(
    BuildContext context,
    ColorScheme colorScheme,
    Widget child,
    VoidCallback? effectiveOnPressed,
  ) {
    final BorderRadius borderRadius = BorderRadius.circular(AppRadius.md);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: _isDisabled ? null : AppColors.primaryButtonGradient,
        color: _isDisabled ? colorScheme.surfaceContainerHighest : null,
        borderRadius: borderRadius,
        boxShadow: _isDisabled
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: effectiveOnPressed,
          child: Center(
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color:
                    _isDisabled ? colorScheme.onSurfaceVariant : Colors.white,
              ),
              child: IconTheme.merge(
                data: IconThemeData(
                  color: _isDisabled
                      ? colorScheme.onSurfaceVariant
                      : Colors.white,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStandard(
    BuildContext context,
    ColorScheme colorScheme,
    Widget child,
    VoidCallback? effectiveOnPressed,
  ) {
    return switch (variant) {
      AppButtonVariant.secondary => ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.secondary,
            foregroundColor: colorScheme.onSecondary,
            disabledBackgroundColor: colorScheme.secondary,
            disabledForegroundColor: colorScheme.onSurfaceVariant,
            side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.3)),
          ),
          child: child,
        ),
      AppButtonVariant.outline => OutlinedButton(
          onPressed: effectiveOnPressed,
          child: child,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: effectiveOnPressed,
          child: child,
        ),
      AppButtonVariant.primary => const SizedBox.shrink(),
    };
  }

  Color _loadingColor(ColorScheme colorScheme) {
    return switch (variant) {
      AppButtonVariant.primary => Colors.white,
      AppButtonVariant.secondary => colorScheme.onSecondary,
      AppButtonVariant.outline || AppButtonVariant.text => colorScheme.primary,
    };
  }
}
