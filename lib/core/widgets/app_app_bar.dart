import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Reusable app bar built on top of [AppBarTheme], with an optional
/// subtitle line and a transparent mode for hero/gradient screens.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.transparent = false,
    this.centerTitle = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final bool transparent;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppBarThemeData appBarTheme = theme.appBarTheme;

    final Widget titleWidget = subtitle == null
        ? Text(title, style: appBarTheme.titleTextStyle)
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: centerTitle
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Text(title, style: appBarTheme.titleTextStyle),
              Text(subtitle!, style: theme.textTheme.bodySmall),
            ],
          );

    return AppBar(
      leading: leading,
      title: titleWidget,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor:
          transparent ? Colors.transparent : appBarTheme.backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        subtitle == null ? kToolbarHeight : kToolbarHeight + AppSpacing.lg,
      );
}
