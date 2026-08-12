import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Semantic status colors (success/error/warning/info), exposed through
/// [ThemeData.extensions] so widgets can read
/// `Theme.of(context).extension<AppStatusColors>()` instead of reaching
/// into [AppColors] directly. Identical in both themes -- these colors
/// carry meaning, not brightness.
@immutable
class AppStatusColors extends ThemeExtension<AppStatusColors> {
  const AppStatusColors({
    required this.success,
    required this.successLight,
    required this.error,
    required this.errorLight,
    required this.warning,
    required this.warningLight,
    required this.info,
  });

  static const AppStatusColors standard = AppStatusColors(
    success: AppColors.success,
    successLight: AppColors.successLight,
    error: AppColors.error,
    errorLight: AppColors.errorLight,
    warning: AppColors.warning,
    warningLight: AppColors.warningLight,
    info: AppColors.info,
  );

  final Color success;
  final Color successLight;
  final Color error;
  final Color errorLight;
  final Color warning;
  final Color warningLight;
  final Color info;

  @override
  AppStatusColors copyWith({
    Color? success,
    Color? successLight,
    Color? error,
    Color? errorLight,
    Color? warning,
    Color? warningLight,
    Color? info,
  }) {
    return AppStatusColors(
      success: success ?? this.success,
      successLight: successLight ?? this.successLight,
      error: error ?? this.error,
      errorLight: errorLight ?? this.errorLight,
      warning: warning ?? this.warning,
      warningLight: warningLight ?? this.warningLight,
      info: info ?? this.info,
    );
  }

  @override
  AppStatusColors lerp(ThemeExtension<AppStatusColors>? other, double t) {
    if (other is! AppStatusColors) return this;
    return AppStatusColors(
      success: Color.lerp(success, other.success, t)!,
      successLight: Color.lerp(successLight, other.successLight, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorLight: Color.lerp(errorLight, other.errorLight, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningLight: Color.lerp(warningLight, other.warningLight, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

/// Centralized Material 3 theme configuration for the NexaAi design system.
///
/// [lightTheme] and [darkTheme] are the only entry points widgets should
/// use -- every visual token (color, spacing, radius, typography) is
/// sourced from [AppColors], [AppSpacing], [AppRadius] and
/// [AppTextStyles].
class AppTheme {
  const AppTheme._();

  static final ColorScheme _lightColorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.lightElevatedSurface,
    onSecondary: AppColors.lightTextPrimary,
    tertiary: AppColors.primarySoft,
    onTertiary: Colors.white,
    error: AppColors.error,
    onError: Colors.white,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightTextPrimary,
    onSurfaceVariant: AppColors.lightTextSecondary,
    surfaceContainerHighest: AppColors.lightElevatedSurface,
    outline: AppColors.lightBorder,
    outlineVariant: AppColors.lightBorder,
  );

  static final ColorScheme _darkColorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  ).copyWith(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.darkElevatedSurface,
    onSecondary: AppColors.darkTextPrimary,
    tertiary: AppColors.primarySoft,
    onTertiary: Colors.white,
    error: AppColors.error,
    onError: Colors.white,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkTextPrimary,
    onSurfaceVariant: AppColors.darkTextSecondary,
    surfaceContainerHighest: AppColors.darkElevatedSurface,
    outline: AppColors.darkBorder,
    outlineVariant: AppColors.darkBorder,
  );

  static TextTheme _textTheme({
    required Color primaryText,
    required Color secondaryText,
  }) {
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: primaryText),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: primaryText),
      displaySmall: AppTextStyles.headlineLarge.copyWith(color: primaryText),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: primaryText),
      headlineMedium:
          AppTextStyles.headlineMedium.copyWith(color: primaryText),
      headlineSmall: AppTextStyles.titleLarge.copyWith(color: primaryText),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: primaryText),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: primaryText),
      titleSmall: AppTextStyles.labelLarge.copyWith(color: primaryText),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: primaryText),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: secondaryText),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: secondaryText),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: primaryText),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: secondaryText),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: secondaryText),
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color background,
    required Color surface,
    required Color elevatedSurface,
    required Color cardSurface,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
  }) {
    final TextTheme textTheme = _textTheme(
      primaryText: textPrimary,
      secondaryText: textSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      splashColor: colorScheme.primary.withValues(alpha: 0.08),
      highlightColor: Colors.transparent,
      extensions: const [AppStatusColors.standard],
      dividerTheme: DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: cardSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: elevatedSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: border,
          disabledForegroundColor: textMuted,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: border),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: elevatedSurface,
        selectedColor: colorScheme.primary.withValues(alpha: 0.16),
        disabledColor: border,
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle:
            textTheme.labelMedium?.copyWith(color: colorScheme.primary),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: elevatedSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          side: BorderSide(color: border),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalBackgroundColor: surface,
        showDragHandle: true,
        dragHandleColor: border,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.16),
        elevation: 0,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final bool selected = states.contains(WidgetState.selected);
          return textTheme.labelSmall?.copyWith(
            color: selected ? colorScheme.primary : textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final bool selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? colorScheme.primary : textSecondary,
          );
        }),
      ),
    );
  }

  static ThemeData get lightTheme => _buildTheme(
        brightness: Brightness.light,
        colorScheme: _lightColorScheme,
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface,
        elevatedSurface: AppColors.lightElevatedSurface,
        cardSurface: AppColors.lightCardSurface,
        border: AppColors.lightBorder,
        textPrimary: AppColors.lightTextPrimary,
        textSecondary: AppColors.lightTextSecondary,
        textMuted: AppColors.lightTextMuted,
      );

  static ThemeData get darkTheme => _buildTheme(
        brightness: Brightness.dark,
        colorScheme: _darkColorScheme,
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        elevatedSurface: AppColors.darkElevatedSurface,
        cardSurface: AppColors.darkCardSurface,
        border: AppColors.darkBorder,
        textPrimary: AppColors.darkTextPrimary,
        textSecondary: AppColors.darkTextSecondary,
        textMuted: AppColors.darkTextMuted,
      );
}
