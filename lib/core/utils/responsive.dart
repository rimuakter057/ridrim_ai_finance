import 'package:flutter/material.dart';

/// Device size categories used across the design system.
enum DeviceType { mobile, tablet, largeTablet, desktop }

/// Screen-width breakpoints (logical pixels) used to classify [DeviceType].
///
/// - mobile: below [tablet]
/// - tablet: [tablet] to below [largeTablet]
/// - largeTablet: [largeTablet] to below [desktop]
/// - desktop: [desktop] and above
class ResponsiveBreakpoints {
  const ResponsiveBreakpoints._();

  static const double tablet = 600;
  static const double largeTablet = 900;
  static const double desktop = 1200;

  static DeviceType deviceTypeForWidth(double width) {
    if (width >= desktop) return DeviceType.desktop;
    if (width >= largeTablet) return DeviceType.largeTablet;
    if (width >= tablet) return DeviceType.tablet;
    return DeviceType.mobile;
  }
}

/// Reusable, context-scoped responsive sizing helper.
///
/// Create one per build via [ResponsiveHelper.of] -- it holds no
/// static/global mutable state, so it always reflects the current
/// [MediaQuery] for its [context] rather than a stale cached value.
class ResponsiveHelper {
  ResponsiveHelper(this.context);

  factory ResponsiveHelper.of(BuildContext context) =>
      ResponsiveHelper(context);

  final BuildContext context;

  static const double _referenceWidth = 375;
  static const double _referenceHeight = 812;
  static const double _minScale = 0.85;
  static const double _maxScale = 1.25;

  Size get _size => MediaQuery.sizeOf(context);
  EdgeInsets get _viewPadding => MediaQuery.paddingOf(context);

  double get screenWidth => _size.width;
  double get screenHeight => _size.height;

  double get safeAreaTop => _viewPadding.top;
  double get safeAreaBottom => _viewPadding.bottom;

  DeviceType get deviceType =>
      ResponsiveBreakpoints.deviceTypeForWidth(screenWidth);

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isLargeTablet => deviceType == DeviceType.largeTablet;
  bool get isDesktop => deviceType == DeviceType.desktop;

  double get _widthScale =>
      (screenWidth / _referenceWidth).clamp(_minScale, _maxScale);

  double get _heightScale =>
      (screenHeight / _referenceHeight).clamp(_minScale, _maxScale);

  /// Scales [value] against a 375-wide reference design, clamped to avoid
  /// aggressive scaling on very small or very large screens.
  double width(double value) => value * _widthScale;

  /// Scales [value] against an 812-tall reference design, clamped to avoid
  /// aggressive scaling on very short or very tall screens.
  double height(double value) => value * _heightScale;

  /// Returns [percent] (0-100) of the screen width in logical pixels.
  double widthPercent(double percent) => screenWidth * (percent / 100);

  /// Returns [percent] (0-100) of the screen height in logical pixels.
  double heightPercent(double percent) => screenHeight * (percent / 100);

  double fontSize(double size) => size * _widthScale;
  double spacing(double value) => value * _widthScale;
  double padding(double value) => value * _widthScale;
  double iconSize(double value) => value * _widthScale;
  double radius(double value) => value * _widthScale;
  double buttonHeight(double value) => value * _widthScale;

  /// Picks a value for the current [deviceType], falling back to the
  /// next-smaller breakpoint's value when a larger one isn't supplied.
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? largeTablet,
    T? desktop,
  }) {
    switch (deviceType) {
      case DeviceType.desktop:
        return desktop ?? largeTablet ?? tablet ?? mobile;
      case DeviceType.largeTablet:
        return largeTablet ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.mobile:
        return mobile;
    }
  }

  /// Sensible max content width for centering layouts on large screens.
  double get maxContentWidth => responsiveValue<double>(
        mobile: screenWidth,
        tablet: 600,
        largeTablet: 840,
        desktop: 1120,
      );
}

/// [LayoutBuilder]-based alternative to [ResponsiveHelper] for widgets that
/// need to respond to their local constraints rather than the full screen
/// (e.g. inside a side panel, split view, or nested layout).
class ResponsiveLayoutBuilder extends StatelessWidget {
  const ResponsiveLayoutBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final DeviceType deviceType =
            ResponsiveBreakpoints.deviceTypeForWidth(constraints.maxWidth);
        return builder(context, deviceType);
      },
    );
  }
}
