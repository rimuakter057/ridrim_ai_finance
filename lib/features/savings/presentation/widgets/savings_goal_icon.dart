import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Maps a [SavingsGoal.iconKey] to an [IconData] + accent color pair.
/// Presentation-only lookup -- the domain entity stores just the key.
(IconData, Color) savingsGoalVisual(String iconKey) {
  return switch (iconKey) {
    'shield' => (Icons.shield_outlined, AppColors.tileGreenIcon),
    'travel' => (Icons.flight_takeoff_rounded, AppColors.tileSkyIcon),
    'car' => (Icons.directions_car_filled_outlined, AppColors.tileIndigoIcon),
    'home' => (Icons.home_outlined, AppColors.tileAmberIcon),
    'tech' => (Icons.devices_outlined, AppColors.tilePurpleIcon),
    'gift' => (Icons.card_giftcard_rounded, AppColors.tilePinkIcon),
    _ => (Icons.savings_outlined, AppColors.tileTealIcon),
  };
}

const List<String> savingsGoalIconKeys = [
  'shield', 'travel', 'car', 'home', 'tech', 'gift',
];
