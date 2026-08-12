import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_loading.dart';

/// Branded launch screen featuring official logo from [AppAssets.appLogo].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.onFinished});

  final VoidCallback? onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.longAnimationDuration,
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    final VoidCallback? onFinished = widget.onFinished;
    if (onFinished != null) {
      _redirectTimer = Timer(AppConstants.splashDuration, onFinished);
    }
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final double logoSize = responsive.width(100);

    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: logoSize,
                  height: logoSize,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(responsive.radius(AppRadius.xxl)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 40,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    AppAssets.appLogo,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: responsive.spacing(AppSpacing.xxl)),
                Text(AppStrings.appName, style: theme.textTheme.headlineLarge),
                SizedBox(height: responsive.spacing(AppSpacing.xs)),
                Text(AppStrings.appTagline, style: theme.textTheme.bodyMedium),
                SizedBox(height: responsive.spacing(AppSpacing.huge)),
                const AppLoading.small(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
