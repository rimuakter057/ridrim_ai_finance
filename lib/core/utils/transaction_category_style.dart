import 'package:flutter/material.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/debt.dart';
import '../../domain/entities/investment.dart';
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

extension InvestmentTypeX on InvestmentType {
  String get label => switch (this) {
        InvestmentType.stock => 'Stock',
        InvestmentType.etf => 'ETF',
        InvestmentType.mutualFund => 'Mutual Fund',
        InvestmentType.crypto => 'Crypto',
        InvestmentType.bond => 'Bond',
      };

  IconData get icon => switch (this) {
        InvestmentType.stock => Icons.show_chart_rounded,
        InvestmentType.etf => Icons.pie_chart_outline_rounded,
        InvestmentType.mutualFund => Icons.account_balance_outlined,
        InvestmentType.crypto => Icons.currency_bitcoin_rounded,
        InvestmentType.bond => Icons.shield_outlined,
      };

  Color get color => switch (this) {
        InvestmentType.stock => AppColors.tileBlueIcon,
        InvestmentType.etf => AppColors.tileTealIcon,
        InvestmentType.mutualFund => AppColors.tileIndigoIcon,
        InvestmentType.crypto => AppColors.tileAmberIcon,
        InvestmentType.bond => AppColors.tileSlateIcon,
      };
}

extension DebtTypeX on DebtType {
  String get label => switch (this) {
        DebtType.creditCard => 'Credit Card',
        DebtType.personalLoan => 'Personal Loan',
        DebtType.studentLoan => 'Student Loan',
        DebtType.autoLoan => 'Auto Loan',
        DebtType.mortgage => 'Mortgage',
        DebtType.other => 'Other Debt',
      };

  IconData get icon => switch (this) {
        DebtType.creditCard => Icons.credit_card_rounded,
        DebtType.personalLoan => Icons.request_quote_outlined,
        DebtType.studentLoan => Icons.school_outlined,
        DebtType.autoLoan => Icons.directions_car_filled_outlined,
        DebtType.mortgage => Icons.home_outlined,
        DebtType.other => Icons.receipt_long_outlined,
      };

  Color get color => switch (this) {
        DebtType.creditCard => AppColors.tileRedIcon,
        DebtType.personalLoan => AppColors.tileAmberIcon,
        DebtType.studentLoan => AppColors.tileIndigoIcon,
        DebtType.autoLoan => AppColors.tileBlueIcon,
        DebtType.mortgage => AppColors.tilePurpleIcon,
        DebtType.other => AppColors.tileSlateIcon,
      };
}
