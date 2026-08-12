import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

/// App-wide text scale options, selectable from Settings > General >
/// Font Size and applied globally via [MaterialApp.builder] in `main.dart`.
enum FontSizeOption { small, medium, large, extraLarge }

extension FontSizeOptionX on FontSizeOption {
  double get scaleFactor => switch (this) {
        FontSizeOption.small => 0.9,
        FontSizeOption.medium => 1.0,
        FontSizeOption.large => 1.15,
        FontSizeOption.extraLarge => 1.3,
      };

  String get label => switch (this) {
        FontSizeOption.small => AppStrings.fontSizeSmall,
        FontSizeOption.medium => AppStrings.fontSizeMedium,
        FontSizeOption.large => AppStrings.fontSizeLarge,
        FontSizeOption.extraLarge => AppStrings.fontSizeExtraLarge,
      };
}

/// Lives outside `main.dart` for the same reason as `themeModeNotifier`:
/// avoids a circular import between `main.dart` and the Settings screen.
final ValueNotifier<FontSizeOption> fontScaleNotifier =
    ValueNotifier<FontSizeOption>(FontSizeOption.medium);
