import 'package:flutter/material.dart';

/// App-wide signed-in flag, toggled by the auth screens. A plain
/// [ValueNotifier] keeps this state-management-package-free -- mirrors
/// [themeModeNotifier] in `theme_mode_notifier.dart`. [AppRouter] listens to
/// this via `GoRouter(refreshListenable: ...)` to guard protected routes.
final ValueNotifier<bool> isLoggedInNotifier = ValueNotifier<bool>(false);
