import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Three-segment Light/Dark/System theme mode switch.
class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  static const Map<ThemeMode, String> _labels = {
    ThemeMode.light: AppStrings.themeLight,
    ThemeMode.dark: AppStrings.themeDark,
    ThemeMode.system: AppStrings.themeSystem,
  };

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
          for (final MapEntry<ThemeMode, String> entry in _labels.entries)
            Expanded(
              child: _Segment(
                label: entry.value,
                selected: entry.key == mode,
                onTap: () => onChanged(entry.key),
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
