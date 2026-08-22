import 'package:ridrim/core/theme/app_spacing.dart';
import 'package:ridrim/core/utils/extensions.dart';
import 'package:flutter/material.dart';


class DetailRow extends StatelessWidget {
  const DetailRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.textTheme.bodyMedium),
          Flexible(
            child: Text(
              value,
              style: context.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}