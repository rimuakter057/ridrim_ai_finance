import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';

/// Static "About" screen featuring official logo from [AppAssets.appLogo].
class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final double logoSize = responsive.width(88);

    return Scaffold(
      appBar: const AppAppBar(title: AppStrings.aboutAppLabel),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.xxl)),
          children: [
            SizedBox(height: responsive.spacing(AppSpacing.xl)),
            Center(
              child: Container(
                width: logoSize,
                height: logoSize,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(responsive.radius(AppRadius.xl)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  AppAssets.appLogo,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.lg)),
            Center(
              child: Text(
                AppStrings.appName,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xs)),
            Center(
              child: Text(
                AppStrings.appTagline,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xs)),
            Center(
              child: Text(
                AppStrings.appVersion(AppStrings.appVersionNumber),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.section)),
            Text(
              AppStrings.aboutAppDescription,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.section)),
            Center(
              child: Text(
                AppStrings.aboutAppMadeWith,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xs)),
            Center(
              child: Text(
                AppStrings.aboutAppCopyright,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
