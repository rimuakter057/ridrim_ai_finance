import 'package:flutter/material.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/font_scale_notifier.dart';
import 'core/utils/theme_mode_notifier.dart';

void main() {
  runApp(
    const RimRidFinance(),
  );
}

class RimRidFinance extends StatelessWidget {
  const RimRidFinance({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp.router(
          title: 'RimRid Finance',
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return ValueListenableBuilder<FontSizeOption>(
              valueListenable: fontScaleNotifier,
              builder: (context, fontSize, _) {
                final MediaQueryData mediaQuery = MediaQuery.of(context);
                return MediaQuery(
                  data: mediaQuery.copyWith(
                    textScaler: TextScaler.linear(fontSize.scaleFactor),
                  ),
                  child: child!,
                );
              },
            );
          },
          routerConfig: AppRouter.router,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
        );
      },
    );
  }
}
