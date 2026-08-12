import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_radius.dart';

/// Reusable icon/image widget for the official app logo.
/// Provides default sizing, rounded corners, and fit.
class AppLogoIcon extends StatelessWidget {
  const AppLogoIcon({
    super.key,
    this.size = 28,
    this.radius = AppRadius.sm,
    this.fit = BoxFit.contain,
  });

  final double size;
  final double radius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        AppAssets.appLogo,
        fit: fit,
      ),
    );
  }
}
