import 'package:ridrim/core/theme/app_radius.dart';
import 'package:ridrim/core/theme/app_spacing.dart' show AppSpacing;
import 'package:ridrim/core/utils/extensions.dart';
import 'package:ridrim/core/utils/responsive.dart';
import 'package:ridrim/core/widgets/app_card.dart';
import 'package:flutter/material.dart';



class FactorCard extends StatelessWidget {
  const FactorCard({super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.score,
  });

  final IconData icon;
  final String title;
  final String description;
  final double score;

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final Color color = score >= 60
        ? context.colorScheme.primary
        : score >= 40
        ? Colors.amber.shade700
        : context.colorScheme.error;

    return AppCard(
      child: Row(
        children: [
          Container(
            width: responsive.width(40),
            height: responsive.width(40),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: responsive.spacing(AppSpacing.md)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(description, style: context.textTheme.bodySmall),
                SizedBox(height: responsive.spacing(AppSpacing.xs)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: LinearProgressIndicator(
                    value: (score / 100).clamp(0, 1),
                    minHeight: 6,
                    backgroundColor: context.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: responsive.spacing(AppSpacing.sm)),
          Text(
            score.round().toString(),
            style: context.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}