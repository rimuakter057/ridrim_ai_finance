import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// A single row in the Profile or Settings screen list: icon, label, optional subtitle,
/// badge/value text, and chevron.
class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    this.subtitleStyle,
    this.labelTrailing,
    this.badgeText,
    this.valueText,
    this.iconColor,
    this.iconBgColor,
    this.textColor,
    this.showChevron = true,
    this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String? subtitle;

  /// Overrides the default subtitle style (e.g. a monospace font for a
  /// key/code snippet). Falls back to `bodySmall` when not provided.
  final TextStyle? subtitleStyle;

  /// An optional small widget rendered immediately after [label] on the
  /// same line (e.g. a "Connected" status badge).
  final Widget? labelTrailing;
  final String? badgeText;
  final String? valueText;
  final Color? iconColor;
  final Color? iconBgColor;
  final Color? textColor;
  final bool showChevron;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final BorderRadius borderRadius =
        BorderRadius.circular(responsive.radius(AppRadius.md));

    final Color effectiveIconBg = iconBgColor ??
        (theme.brightness == Brightness.dark
            ? theme.colorScheme.surfaceContainerHigh
            : theme.colorScheme.primaryContainer.withValues(alpha: 0.35));

    final Color effectiveIconColor =
        iconColor ?? theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.spacing(AppSpacing.sm),
            vertical: responsive.spacing(AppSpacing.sm + 2),
          ),
          child: Row(
            children: [
              Container(
                width: responsive.width(36),
                height: responsive.width(36),
                decoration: BoxDecoration(
                  color: effectiveIconBg,
                  borderRadius:
                      BorderRadius.circular(responsive.radius(AppRadius.sm)),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: responsive.iconSize(18),
                    color: effectiveIconColor,
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(AppSpacing.md)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            label,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: textColor ?? theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (labelTrailing != null) ...[
                          SizedBox(width: responsive.spacing(AppSpacing.xs)),
                          labelTrailing!,
                        ],
                      ],
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: subtitleStyle ??
                            theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                    // Shown as a second line rather than squeezed onto the
                    // label's row -- on a phone-width screen there usually
                    // isn't room for a long label and its current value
                    // side by side without one truncating the other.
                    if (valueText != null && trailing == null) ...[
                      const SizedBox(height: 2),
                      Text(
                        valueText!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else ...[
                if (badgeText != null) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.spacing(AppSpacing.sm),
                      vertical: responsive.spacing(AppSpacing.xs / 2),
                    ),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? AppColors.tileDarkContainer
                          : AppColors.tileLightBadgeBg,
                      borderRadius: BorderRadius.circular(
                        responsive.radius(AppRadius.pill),
                      ),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      badgeText!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.spacing(AppSpacing.xs)),
                ],
                if (showChevron)
                  Icon(
                    Icons.chevron_right_rounded,
                    size: responsive.iconSize(20),
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
