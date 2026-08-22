import 'package:ridrim/core/theme/app_spacing.dart';
import 'package:ridrim/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class PickerField extends StatelessWidget {
  const PickerField({super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: InputDecoration(prefixIcon: Icon(icon)),
            child: Row(
              children: [
                Expanded(child: Text(value)),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
