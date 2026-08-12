import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

enum AppLoadingSize { small, button, normal, fullScreen }

/// Reusable loading indicator with size presets sourced from the design
/// system's spacing scale.
class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.size = AppLoadingSize.normal,
    this.color,
    this.message,
  });

  const AppLoading.small({super.key, this.color})
      : size = AppLoadingSize.small,
        message = null;

  const AppLoading.button({super.key, this.color})
      : size = AppLoadingSize.button,
        message = null;

  const AppLoading.fullScreen({super.key, this.color, this.message})
      : size = AppLoadingSize.fullScreen;

  final AppLoadingSize size;
  final Color? color;
  final String? message;

  double get _dimension => switch (size) {
        AppLoadingSize.small => 16,
        AppLoadingSize.button => 18,
        AppLoadingSize.normal => 28,
        AppLoadingSize.fullScreen => 36,
      };

  double get _strokeWidth => switch (size) {
        AppLoadingSize.small || AppLoadingSize.button => 2,
        AppLoadingSize.normal || AppLoadingSize.fullScreen => 3,
      };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color indicatorColor = color ?? theme.colorScheme.primary;

    final Widget indicator = SizedBox(
      width: _dimension,
      height: _dimension,
      child: CircularProgressIndicator(
        strokeWidth: _strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
      ),
    );

    if (size != AppLoadingSize.fullScreen) {
      return indicator;
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          if (message != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              message!,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
