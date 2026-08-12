import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Detects card brand from the leading digit(s) of a card number.
String detectCardBrand(String number) {
  final String n = number.replaceAll(' ', '');
  if (n.startsWith('4')) return 'Visa';
  if (n.startsWith('5') || n.startsWith('2')) return 'Mastercard';
  if (n.startsWith('3')) return 'Amex';
  return '';
}

Color cardBrandColor(String brand) {
  switch (brand) {
    case 'Visa':
      return AppColors.tileBlueIcon;
    case 'Mastercard':
      return AppColors.tileOrangeIcon;
    case 'Amex':
      return AppColors.tileGreenIcon;
    default:
      return Colors.grey;
  }
}

/// Formats card number input as groups of 4: "1234 5678 9012 3456"
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final String text = newValue.text.replaceAll(' ', '');
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    final String formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formats expiry input as "MM/YY"
class ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final String text = newValue.text.replaceAll('/', '');
    if (text.length > 4) return oldValue;
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(text[i]);
    }
    final String formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}