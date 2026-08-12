import 'package:flutter/material.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/transaction.dart';
import '../theme/app_colors.dart';

/// Presentation-layer icon/label/color mapping for [TransactionCategory] --
/// kept out of the domain entity, which stays Flutter-free. Shared by
/// Dashboard, Transactions, Accounts and the AI Chat assistant so every
/// screen renders categories identically.
extension TransactionCategoryX on TransactionCategory {
  String get label => switch (this) {
        TransactionCategory.income => 'Income',
        TransactionCategory.groceries => 'Groceries',
        TransactionCategory.food => 'Food & Drink',
        TransactionCategory.transport => 'Transport',
        TransactionCategory.shopping => 'Shopping',
        TransactionCategory.entertainment => 'Entertainment',
        TransactionCategory.billsUtilities => 'Bills & Utilities',
        TransactionCategory.health => 'Health',
        TransactionCategory.travel => 'Travel',
        TransactionCategory.other => 'Other',
      };

  IconData get icon => switch (this) {
        TransactionCategory.income => Icons.attach_money_rounded,
        TransactionCategory.groceries => Icons.local_grocery_store_outlined,
        TransactionCategory.food => Icons.restaurant_outlined,
        TransactionCategory.transport => Icons.directions_car_filled_outlined,
        TransactionCategory.shopping => Icons.shopping_bag_outlined,
        TransactionCategory.entertainment => Icons.movie_outlined,
        TransactionCategory.billsUtilities => Icons.receipt_long_outlined,
        TransactionCategory.health => Icons.favorite_border_rounded,
        TransactionCategory.travel => Icons.flight_takeoff_rounded,
        TransactionCategory.other => Icons.more_horiz_rounded,
      };

  Color get iconColor => switch (this) {
        TransactionCategory.income => AppColors.tileGreenIcon,
        TransactionCategory.groceries => AppColors.tileTealIcon,
        TransactionCategory.food => AppColors.tileOrangeIcon,
        TransactionCategory.transport => AppColors.tileBlueIcon,
        TransactionCategory.shopping => AppColors.tilePinkIcon,
        TransactionCategory.entertainment => AppColors.tilePurpleIcon,
        TransactionCategory.billsUtilities => AppColors.tileAmberIcon,
        TransactionCategory.health => AppColors.tileRoseIcon,
        TransactionCategory.travel => AppColors.tileSkyIcon,
        TransactionCategory.other => AppColors.tileSlateIcon,
      };

  Color get bgColor => switch (this) {
        TransactionCategory.income => AppColors.tileGreenBg,
        TransactionCategory.groceries => AppColors.tileTealBg,
        TransactionCategory.food => AppColors.tileOrangeBg,
        TransactionCategory.transport => AppColors.tileBlueBg,
        TransactionCategory.shopping => AppColors.tilePinkBg,
        TransactionCategory.entertainment => AppColors.tilePurpleBg,
        TransactionCategory.billsUtilities => AppColors.tileAmberBg,
        TransactionCategory.health => AppColors.tileRedBg,
        TransactionCategory.travel => AppColors.tileSkyBg,
        TransactionCategory.other => AppColors.tileSlateBg,
      };
}

extension AccountTypeX on AccountType {
  String get label => switch (this) {
        AccountType.checking => 'Checking',
        AccountType.savings => 'Savings',
        AccountType.credit => 'Credit Card',
        AccountType.investment => 'Investment',
      };

  IconData get icon => switch (this) {
        AccountType.checking => Icons.account_balance_outlined,
        AccountType.savings => Icons.savings_outlined,
        AccountType.credit => Icons.credit_card_rounded,
        AccountType.investment => Icons.trending_up_rounded,
      };
}
