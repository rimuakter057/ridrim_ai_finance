import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../widgets/legal_content.dart';

/// Generic sectioned document screen shared by Terms of Service and
/// Privacy Policy -- each just supplies its own title and sections.
class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({
    super.key,
    required this.title,
    required this.sections,
  });

  final String title;
  final List<LegalSection> sections;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Scaffold(
      appBar: AppAppBar(title: title),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.xxl)),
          children: [
            Text(
              AppStrings.legalLastUpdated,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.lg)),
            for (final section in sections) ...[
              Text(section.heading, style: theme.textTheme.titleMedium),
              SizedBox(height: responsive.spacing(AppSpacing.xs)),
              Text(
                section.body,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              SizedBox(height: responsive.spacing(AppSpacing.xl)),
            ],
          ],
        ),
      ),
    );
  }
}
