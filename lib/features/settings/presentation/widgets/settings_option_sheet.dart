import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Opens a single-select bottom sheet listing [options], with [selected]
/// pre-checked. Returns the tapped option, or `null` if dismissed without
/// a selection. Shared by every Settings tile that picks one value from a
/// fixed list (Default Model, Response Style, Data Retention, Language,
/// Font Size).
Future<T?> showSettingsOptionSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> options,
  required T selected,
  String Function(T option)? labelBuilder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    builder: (_) => _SettingsOptionSheet<T>(
      title: title,
      options: options,
      selected: selected,
      labelBuilder: labelBuilder ?? (option) => option.toString(),
    ),
  );
}

class _SettingsOptionSheet<T> extends StatelessWidget {
  const _SettingsOptionSheet({
    required this.title,
    required this.options,
    required this.selected,
    required this.labelBuilder,
  });

  final String title;
  final List<T> options;
  final T selected;
  final String Function(T option) labelBuilder;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          responsive.spacing(AppSpacing.lg),
          responsive.spacing(AppSpacing.xs),
          responsive.spacing(AppSpacing.lg),
          responsive.spacing(AppSpacing.sm),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            SizedBox(height: responsive.spacing(AppSpacing.xs)),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final T option = options[index];
                  final bool isSelected = option == selected;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => Navigator.of(context).pop(option),
                    title: Text(
                      labelBuilder(option),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? theme.colorScheme.primary : null,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
