import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../widgets/faq_data.dart';
import '../widgets/faq_tile.dart';


class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  Future<void> _copyEmail(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: AppStrings.supportEmail));
    if (!context.mounted) return;
    context.showSnackBar(AppStrings.emailCopiedMessage);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Scaffold(
      appBar: const AppAppBar(
        title: AppStrings.helpScreenTitle,
        subtitle: AppStrings.helpScreenSubtitle,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.xxl)),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.contactSupportTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: responsive.spacing(AppSpacing.xs)),
                  Text(
                    AppStrings.contactSupportDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: responsive.spacing(AppSpacing.md)),
                  Row(
                    children: [
                      Icon(
                        Icons.mail_outline_rounded,
                        size: responsive.iconSize(18),
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(width: responsive.spacing(AppSpacing.sm)),
                      Expanded(
                        child: Text(
                          AppStrings.supportEmail,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.spacing(AppSpacing.lg)),
                  AppButton(
                    label: AppStrings.copyEmailLabel,
                    variant: AppButtonVariant.outline,
                    icon: Icons.copy_rounded,
                    fullWidth: true,
                    onPressed: () => _copyEmail(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.section)),
            Text(
              AppStrings.faqSectionTitle,
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: responsive.spacing(AppSpacing.lg)),
            for (final FaqItem item in faqItems)
              Padding(
                padding: EdgeInsets.only(
                  bottom: responsive.spacing(AppSpacing.md),
                ),
                child: FaqTile(item: item),
              ),
          ],
        ),
      ),
    );
  }
}
