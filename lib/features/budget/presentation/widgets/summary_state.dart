import 'package:ridrim/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class SummaryStat extends StatelessWidget {
  const SummaryStat({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: context.textTheme.bodySmall),
      ],
    );
  }
}