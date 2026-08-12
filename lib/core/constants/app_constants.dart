
class AppConstants {
  const AppConstants._();

  // ---------------------------------------------------------------------
  // Animation durations
  // ---------------------------------------------------------------------
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration defaultAnimationDuration =
      Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration debounceDuration = Duration(milliseconds: 400);
  static const Duration snackBarDuration = Duration(seconds: 3);

  // ---------------------------------------------------------------------
  // Pagination
  // ---------------------------------------------------------------------
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int initialPage = 1;

  // ---------------------------------------------------------------------
  // Network defaults (for the future ApiDataSource layer)
  // ---------------------------------------------------------------------
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const int maxRetryAttempts = 3;

  // ---------------------------------------------------------------------
  // Caching
  // ---------------------------------------------------------------------
  static const Duration cacheDuration = Duration(hours: 1);

  // ---------------------------------------------------------------------
  // OTP verification (generic -- reused by any OTP-based flow)
  // ---------------------------------------------------------------------
  static const int otpLength = 6;
  static const Duration otpResendCooldown = Duration(seconds: 30);
}
