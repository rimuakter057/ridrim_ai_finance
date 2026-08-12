import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_glass_card.dart';

class _PromptItem {
  const _PromptItem({
    required this.label,
    required this.promptText,
    required this.icon,
    required this.color,
  });

  final String label;
  final String promptText;
  final IconData icon;
  final Color color;
}

const List<_PromptItem> _quickPrompts = [
  _PromptItem(
    label: 'Overspending?',
    promptText: 'Where did I overspend this month?',
    icon: Icons.trending_down_rounded,
    color: AppColors.tileRedIcon,
  ),
  _PromptItem(
    label: 'Spending trend',
    promptText: 'Show my spending trend',
    icon: Icons.show_chart_rounded,
    color: AppColors.tileTealIcon,
  ),
  _PromptItem(
    label: 'Savings goal',
    promptText: 'Am I on track for my savings goal?',
    icon: Icons.savings_outlined,
    color: AppColors.tileGreenIcon,
  ),
  _PromptItem(
    label: 'Groceries',
    promptText: 'How much have I spent on groceries this month?',
    icon: Icons.local_grocery_store_outlined,
    color: AppColors.tileAmberIcon,
  ),
];

/// Horizontal scrollable row of finance-flavored quick prompt cards.
class QuickPromptRow extends StatelessWidget {
  const QuickPromptRow({super.key, required this.onSelectPrompt});

  final ValueChanged<String> onSelectPrompt;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Container(
      height: 84,
      padding: EdgeInsets.symmetric(
        vertical: responsive.spacing(AppSpacing.xs),
      ),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.spacing(AppSpacing.lg),
        ),
        scrollDirection: Axis.horizontal,
        itemCount: _quickPrompts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = _quickPrompts[index];
          return SizedBox(
            width: responsive.width(115),
            child: GestureDetector(
              onTap: () => onSelectPrompt(item.promptText),
              child: AppGlassCard(
                radius: AppRadius.lg,
                padding: EdgeInsets.all(responsive.spacing(AppSpacing.sm)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, color: item.color, size: 20),
                    const SizedBox(height: 6),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
