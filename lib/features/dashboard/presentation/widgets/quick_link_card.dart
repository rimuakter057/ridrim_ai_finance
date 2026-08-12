import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import 'quick_link_data.dart';

/// A single icon-over-label tile in the Dashboard's quick-links grid.
class QuickLinkCard extends StatelessWidget {
  const QuickLinkCard({super.key, required this.data, required this.onTap});

  final QuickLinkData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: responsive.width(48),
            height: responsive.width(48),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              data.icon,
              color: theme.colorScheme.primary,
              size: responsive.iconSize(22),
            ),
          ),
          SizedBox(height: responsive.spacing(AppSpacing.xs)),
          Text(
            data.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
