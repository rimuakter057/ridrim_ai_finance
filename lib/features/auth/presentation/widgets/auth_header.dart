import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Branded header shown atop the login, register, and reset password forms:
/// the official app logo plus a title/subtitle pair.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final double markSize = responsive.width(64);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: markSize,
          height: markSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(responsive.radius(AppRadius.lg)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            AppAssets.appLogo,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: responsive.spacing(AppSpacing.xl)),
        Text(title, style: theme.textTheme.headlineMedium),
        SizedBox(height: responsive.spacing(AppSpacing.xs)),
        Text(
          textAlign: TextAlign.center,
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
