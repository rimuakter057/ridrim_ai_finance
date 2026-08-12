import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/transaction_category_style.dart';
import '../../../../domain/entities/transaction.dart';

/// Horizontal row of category filter chips, with a leading "All" chip.
/// `null` in [selected]/[onSelected] represents "All".
class CategoryFilterRow extends StatelessWidget {
  const CategoryFilterRow({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final TransactionCategory? selected;
  final ValueChanged<TransactionCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final List<TransactionCategory?> categories = [
      null,
      ...TransactionCategory.values,
    ];

    return SizedBox(
      height: responsive.width(36),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) =>
            SizedBox(width: responsive.spacing(AppSpacing.sm)),
        itemBuilder: (context, index) {
          final TransactionCategory? category = categories[index];
          final bool isSelected = category == selected;
          return ChoiceChip(
            label: Text(category?.label ?? 'All'),
            selected: isSelected,
            onSelected: (_) => onSelected(category),
          );
        },
      ),
    );
  }
}
