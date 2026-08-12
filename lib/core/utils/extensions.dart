import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';

/// Semantic types for custom SnackBar styling.
enum SnackBarType { info, success, warning, error }

/// Internal manager for displaying floating top toasts smoothly.
class _TopToastManager {
  static OverlayEntry? _currentEntry;

  static void show({
    required BuildContext context,
    required String message,
    IconData? icon,
    SnackBarType? type,
    Duration duration = const Duration(milliseconds: 2500),
  }) {
    _currentEntry?.remove();
    _currentEntry = null;

    final OverlayState? overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    final ThemeData themeData = Theme.of(context);
    final double topPadding = MediaQuery.of(context).padding.top;

    // Auto-detect message semantic type if not explicitly provided
    final String lowerMsg = message.toLowerCase();
    final SnackBarType resolvedType = type ??
        (lowerMsg.contains('copied') ||
                lowerMsg.contains('updated') ||
                lowerMsg.contains('success') ||
                lowerMsg.contains('created') ||
                lowerMsg.contains('generated') ||
                lowerMsg.contains('enabled') ||
                lowerMsg.contains('connected') ||
                lowerMsg.contains('pinned') ||
                lowerMsg.contains('resent')
            ? SnackBarType.success
            : (lowerMsg.contains('deleted') ||
                    lowerMsg.contains('removed') ||
                    lowerMsg.contains('revoked') ||
                    lowerMsg.contains('error') ||
                    lowerMsg.contains('do not match') ||
                    lowerMsg.contains('fill in') ||
                    lowerMsg.contains('required'))
                ? SnackBarType.warning
                : SnackBarType.info);

    final IconData defaultIcon = switch (resolvedType) {
      SnackBarType.success => Icons.check_circle_rounded,
      SnackBarType.warning => Icons.info_rounded,
      SnackBarType.error => Icons.error_outline_rounded,
      SnackBarType.info => Icons.auto_awesome_rounded,
    };

    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _TopToastWidget(
        message: message,
        icon: icon ?? defaultIcon,
        duration: duration,
        topPadding: topPadding,
        themeData: themeData,
        onDismiss: () {
          if (_currentEntry == entry) {
            entry.remove();
            _currentEntry = null;
          }
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }
}

/// Animated floating widget that slides down from the TOP of the screen.
class _TopToastWidget extends StatefulWidget {
  const _TopToastWidget({
    required this.message,
    required this.icon,
    required this.duration,
    required this.topPadding,
    required this.themeData,
    required this.onDismiss,
  });

  final String message;
  final IconData icon;
  final Duration duration;
  final double topPadding;
  final ThemeData themeData;
  final VoidCallback onDismiss;

  @override
  State<_TopToastWidget> createState() => _TopToastWidgetState();
}

class _TopToastWidgetState extends State<_TopToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _fadeAnimation;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted && !_dismissed) {
        _dismiss();
      }
    });
  }

  void _dismiss() {
    if (_dismissed) return;
    _dismissed = true;
    _controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.topPadding + 8,
      left: 16,
      right: 16,
      child: SafeArea(
        top: false,
        child: SlideTransition(
          position: _offsetAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.primaryDelta != null && details.primaryDelta! < -4) {
                    _dismiss();
                  }
                },
                onTap: _dismiss,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: AppColors.planCardGradient,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.icon,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.message,
                          style: widget.themeData.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Reusable [BuildContext] shortcuts. Deliberately excludes screen-size,
/// breakpoint or device-type helpers -- see `ResponsiveHelper` in
/// `responsive.dart` for those.
extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  double get keyboardHeight => MediaQuery.viewInsetsOf(this).bottom;
  bool get isKeyboardVisible => keyboardHeight > 0;

  void hideKeyboard() => FocusScope.of(this).unfocus();

  /// Displays a custom, animated floating notification toast sliding down from the TOP of the screen.
  void showSnackBar(
    String message, {
    SnackBarType? type,
    IconData? icon,
    Duration duration = const Duration(milliseconds: 2500),
  }) {
    _TopToastManager.show(
      context: this,
      message: message,
      type: type,
      icon: icon,
      duration: duration,
    );
  }

}

/// Reusable [String] helpers for generic text formatting.
extension StringX on String {
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  /// Up to [maxInitials] uppercase initials from the words in this string,
  /// e.g. `'Ada Lovelace'.initials()` -> `'AL'`. Useful for avatar
  /// placeholders.
  String initials({int maxInitials = 2}) {
    final List<String> words =
        trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
    return words
        .take(maxInitials)
        .map((word) => word[0].toUpperCase())
        .join();
  }
}

/// Null-safety helpers for nullable [String]s.
extension NullableStringX on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
}

/// Reusable [DateTime] helpers for generic date/time display.
extension DateTimeX on DateTime {
  static const List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  bool get isToday {
    final DateTime now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// A short, human-friendly relative time such as `'just now'`, `'5m ago'`,
  /// `'3h ago'`, `'2d ago'`, falling back to [toFormattedDate] beyond a week.
  String get timeAgo {
    final Duration diff = DateTime.now().difference(this);
    if (diff.inSeconds < 60) return AppStrings.justNow;
    if (diff.inMinutes < 60) return AppStrings.minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return AppStrings.hoursAgo(diff.inHours);
    if (diff.inDays < 7) return AppStrings.daysAgo(diff.inDays);
    return toFormattedDate();
  }

  /// A time-of-day greeting: `'Good morning'`/`'Good afternoon'`/
  /// `'Good evening'`.
  String get greeting {
    if (hour < 12) return AppStrings.goodMorning;
    if (hour < 17) return AppStrings.goodAfternoon;
    return AppStrings.goodEvening;
  }

  /// e.g. `'Aug 9, 2026'`.
  String toFormattedDate() => '${_monthNames[month - 1]} $day, $year';

  /// e.g. `'2:05 PM'`.
  String toFormattedTime() {
    final int hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final String minutePadded = minute.toString().padLeft(2, '0');
    final String period = hour < 12 ? 'AM' : 'PM';
    return '$hour12:$minutePadded $period';
  }
}

/// Reusable [Widget] composition helpers.
extension WidgetX on Widget {
  Widget paddingAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: this,
      );

  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      Padding(
        padding:
            EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
        child: this,
      );

  Widget center() => Center(child: this);

  Widget onTap(VoidCallback onTap) =>
      GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque, child: this);

  Widget visible(bool visible) => Visibility(visible: visible, child: this);
}
