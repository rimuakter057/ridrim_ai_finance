import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';
import '../constants/app_strings.dart';

/// Reusable form-field validators shaped as [FormFieldValidator]s, ready
/// to pass straight to `AppTextField(validator: ...)`.
class Validators {
  const Validators._();

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequiredMessage;
    }
    return null;
  }

  static String? email(String? value) {
    final String? requiredError = required(value);
    if (requiredError != null) return requiredError;

    final RegExp emailPattern = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!emailPattern.hasMatch(value!.trim())) {
      return AppStrings.invalidEmailMessage;
    }
    return null;
  }

  static FormFieldValidator<String> minLength(int length, {String? message}) {
    return (String? value) {
      if (value == null || value.length < length) {
        return message ?? 'Must be at least $length characters.';
      }
      return null;
    };
  }

  static String? password(String? value, {int minLength = 8}) {
    final String? requiredError = required(value);
    if (requiredError != null) return requiredError;
    if (value!.length < minLength) {
      return AppStrings.passwordTooShortMessage;
    }
    return null;
  }

  static FormFieldValidator<String> matches(
    String other, {
    String? message,
  }) {
    return (String? value) {
      if (value != other) {
        return message ?? AppStrings.passwordsDoNotMatchMessage;
      }
      return null;
    };
  }
}

/// Debounces rapid, repeated calls (search-as-you-type, resize handlers)
/// down to a single trailing invocation after [delay] of inactivity.
class Debouncer {
  Debouncer({this.delay = AppConstants.debounceDuration});

  final Duration delay;
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() => _timer?.cancel();

  void dispose() => _timer?.cancel();
}

/// Small, generic, stateless formatting/utility functions shared across features.
class AppHelpers {
  const AppHelpers._();

  /// Safely launches an HTTP/HTTPS URL on both iOS and Android.
  static Future<bool> launchAppUrl(
    String urlString, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    final Uri? uri = Uri.tryParse(urlString);
    if (uri == null) return false;
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: mode);
      }
    } catch (_) {}
    return false;
  }

  /// e.g. `formatFileSize(1536)` -> `'1.5 KB'`.
  static String formatFileSize(int bytes) {
    const List<String> units = ['B', 'KB', 'MB', 'GB', 'TB'];
    if (bytes <= 0) return '0 B';

    final int unitIndex = (log(bytes) / log(1024)).floor().clamp(
          0,
          units.length - 1,
        );
    final double size = bytes / pow(1024, unitIndex);
    final String formatted =
        unitIndex == 0 ? size.toStringAsFixed(0) : size.toStringAsFixed(1);
    return '$formatted ${units[unitIndex]}';
  }

  /// e.g. `formatCompactNumber(1500)` -> `'1.5K'`.
  static String formatCompactNumber(num value) {
    if (value < 1000) return value.toString();

    const List<String> suffixes = ['', 'K', 'M', 'B', 'T'];
    final int magnitude = (log(value) / log(1000)).floor().clamp(
          0,
          suffixes.length - 1,
        );
    final double scaled = value / pow(1000, magnitude);
    final String formatted =
        scaled.truncateToDouble() == scaled
            ? scaled.toStringAsFixed(0)
            : scaled.toStringAsFixed(1);
    return '$formatted${suffixes[magnitude]}';
  }

  /// e.g. `formatCurrency(1234.5)` -> `'$1,234.50'`,
  /// `formatCurrency(-42)` -> `'-$42.00'`.
  static String formatCurrency(num amount, {String symbol = '\$'}) {
    final bool isNegative = amount < 0;
    final double absValue = amount.abs().toDouble();
    final List<String> parts = absValue.toStringAsFixed(2).split('.');
    final String wholePart = parts[0];

    final StringBuffer grouped = StringBuffer();
    for (int i = 0; i < wholePart.length; i++) {
      final int fromEnd = wholePart.length - i;
      if (i > 0 && fromEnd % 3 == 0) grouped.write(',');
      grouped.write(wholePart[i]);
    }

    return '${isNegative ? '-' : ''}$symbol$grouped.${parts[1]}';
  }

  /// A short, non-cryptographic unique-enough id for local/mock data.
  static String generateId() {
    final int timestamp = DateTime.now().microsecondsSinceEpoch;
    final int random = Random().nextInt(0xFFFFFF);
    return '${timestamp.toRadixString(36)}${random.toRadixString(36)}';
  }
}
