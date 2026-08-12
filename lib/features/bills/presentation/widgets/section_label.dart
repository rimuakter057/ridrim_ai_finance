import 'package:ai_saas/core/theme/app_spacing.dart';
import 'package:ai_saas/core/utils/extensions.dart';
import 'package:flutter/material.dart';


class SectionLabel extends StatelessWidget {
  const SectionLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Text(
        label,
        style: context.textTheme.labelLarge
            ?.copyWith(color: context.colorScheme.onSurfaceVariant),
      ),
    );
  }
}