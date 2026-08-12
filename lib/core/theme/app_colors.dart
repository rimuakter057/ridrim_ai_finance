import 'package:flutter/material.dart';


class AppColors {
  const AppColors._();

  // ---------------------------------------------------------------------
  // Core neutrals
  // ---------------------------------------------------------------------
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------
  // Brand teal (the only accent hue -- default primary)
  // ---------------------------------------------------------------------
  static const Color primary = Color(0xFF0D9488);
  static const Color primaryBright = Color(0xFF14B8A6);
  static const Color primarySoft = Color(0xFF2DD4BF);
  static const Color primaryHighlight = Color(0xFF7EE8D6);
  static const Color primaryDeep = Color(0xFF00332D);

  // ---------------------------------------------------------------------
  // Dark theme colors (Black / Dark Grey)
  // ---------------------------------------------------------------------
  static const Color darkBackground = Color(0xFF050912);
  static const Color darkSurface = Color(0xFF0B1220);
  static const Color darkElevatedSurface = Color(0xFF111A2B);
  static const Color darkCardSurface = Color(0xFF101827);
  static const Color darkBorder = Color(0xFF1D2A40);
  static const Color darkTextPrimary = Color(0xFFF5F7FF);
  static const Color darkTextSecondary = Color(0xFFA7B0C3);
  static const Color darkTextMuted = Color(0xFF68758C);

  // ---------------------------------------------------------------------
  // Light theme colors (White / Grey)
  // ---------------------------------------------------------------------
  static const Color lightBackground = Color(0xFFF7F8FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightElevatedSurface = Color(0xFFF1F3F9);
  static const Color lightCardSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE5E7F0);
  static const Color lightTextPrimary = Color(0xFF171725);
  static const Color lightTextSecondary = Color(0xFF686B7C);
  static const Color lightTextMuted = Color(0xFF9497A8);

  // ---------------------------------------------------------------------
  // Status colors -- semantic use ONLY (success/error/warning/info
  // messaging, validation, alerts, notifications, status indicators).
  // Never use these decoratively.
  // ---------------------------------------------------------------------
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFF86EFAC);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFCA5A5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFCD34D);
  static const Color info = Color(0xFF14B8A6);

  // ---------------------------------------------------------------------
  // Profile & Settings UI soft background tints and icon colors
  // ---------------------------------------------------------------------
  static const Color tilePurpleBg = Color(0xFFF3E8FF);
  static const Color tilePurpleIcon = Color(0xFF9333EA);

  static const Color tileAmberBg = Color(0xFFFEF3C7);
  static const Color tileAmberIcon = Color(0xFFD97706);

  static const Color tileOrangeBg = Color(0xFFFFEDD5);
  static const Color tileOrangeIcon = Color(0xFFEA580C);

  static const Color tileIndigoBg = Color(0xFFE0E7FF);
  static const Color tileIndigoIcon = Color(0xFF4F46E5);

  static const Color tileBlueBg = Color(0xFFCFFAFE);
  static const Color tileBlueIcon = Color(0xFF0891B2);

  static const Color tileSkyBg = Color(0xFFE0F2FE);
  static const Color tileSkyIcon = Color(0xFF0284C7);

  static const Color tileGreenBg = Color(0xFFDCFCE7);
  static const Color tileGreenIcon = Color(0xFF16A34A);

  static const Color tileTealBg = Color(0xFFCCFBF1);
  static const Color tileTealIcon = Color(0xFF0D9488);

  static const Color tileYellowBg = Color(0xFFFEF9C3);
  static const Color tileYellowIcon = Color(0xFFCA8A04);

  static const Color tilePinkBg = Color(0xFFFCE7F3);
  static const Color tilePinkIcon = Color(0xFFDB2777);

  static const Color tileRoseIcon = Color(0xFFE11D48);

  static const Color tileRedBg = Color(0xFFFEE2E2);
  static const Color tileRedIcon = Color(0xFFDC2626);

  static const Color tileSlateBg = Color(0xFFF1F5F9);
  static const Color tileSlateIcon = Color(0xFF64748B);

  static const Color tileDarkContainer = Color(0xFF1E293B);
  static const Color tileLightBadgeBg = Color(0xFFEFF6FF);

  static const Color avatarPurple = Color(0xFF6366F1);
  static const Color verifiedBlue = Color(0xFF14B8A6);
  static const Color progressCyan = Color(0xFF38BDF8);
  static const Color progressIndigo = Color(0xFF6366F1);
  static const Color buttonDarkForeground = Color(0xFF0F172A);

  static const LinearGradient planCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF042F2E),
      Color(0xFF0D9488),
    ],
  );

  // ---------------------------------------------------------------------
  // Glassmorphism overlays
  // ---------------------------------------------------------------------
  static const Color glassOverlayDark = Color(0x59101827);
  static const Color glassOverlayLight = Color(0x99FFFFFF);
  static const Color glassBorderDark = Color(0x262DD4BF);
  static const Color glassBorderLight = Color(0x0D171725);

  // ---------------------------------------------------------------------
  // Gradients -- brand blue only, no secondary hues
  // ---------------------------------------------------------------------

  /// Vertical glossy gradient used by [AppButton]'s primary variant:
  /// a soft highlight at the top fading through the brand blue into a
  /// deep navy base.
  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryHighlight, primary, primaryDeep],
    stops: [0.0, 0.22, 1.0],
  );

  /// Brand gradient used by [AppGradientButton]: deep navy blue into the
  /// brand blue and a soft blue highlight -- a monochrome blue treatment,
  /// no secondary hues.
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDeep, primary, primarySoft],
  );

  /// A softened version of [primaryGradient] for subtle backgrounds and
  /// glass surfaces.
  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x3300332D),
      Color(0x330D9488),
      Color(0x332DD4BF),
    ],
  );
}
