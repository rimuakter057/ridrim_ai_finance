import 'package:flutter/material.dart';

/// App-wide theme mode, changeable from the Settings screen. A plain
/// [ValueNotifier] keeps this state-management-package-free while still
/// letting any screen update the live theme -- `main.dart` listens to it
/// via [ValueListenableBuilder] and any screen can update
/// [themeModeNotifier.value].
final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier<ThemeMode>(ThemeMode.dark);
