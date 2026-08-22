import 'package:ridrim/features/profile/controller/payment_method_controller.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';


/// Screen to manage credit/debit cards and payment methods.
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen>
    with PaymentMethodsControllerMixin {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Scaffold(
      appBar: const AppAppBar(
        title: AppStrings.paymentMethodsScreenTitle,
        subtitle: AppStrings.paymentMethodsScreenSubtitle,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
          children: [
            Text(
              AppStrings.savedCardsHeader,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.spacing(AppSpacing.xs)),
            for (final card in cards) ...[
              AppCard(
                padding: EdgeInsets.all(responsive.spacing(AppSpacing.md)),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 32,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Center(
                        child: Text(
                          card.brand,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: card.brand == 'Visa'
                                ? AppColors.tileBlueIcon
                                : AppColors.tileOrangeIcon,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: responsive.spacing(AppSpacing.md)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '•••• •••• •••• ${card.last4}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (card.isDefault) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withValues(alpha: 0.15),
                                    borderRadius:
                                    BorderRadius.circular(AppRadius.sm),
                                  ),
                                  child: Text(
                                    AppStrings.defaultBadge,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Expires ${card.expiry}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      onSelected: (val) {
                        if (val == 'default') setDefault(card.id);
                        if (val == 'delete') deleteCard(card.id);
                      },
                      itemBuilder: (_) => [
                        if (!card.isDefault)
                          const PopupMenuItem(
                            value: 'default',
                            child: Text(AppStrings.makeDefaultLabel),
                          ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            AppStrings.removeLabel,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.spacing(AppSpacing.xs)),
            ],

            SizedBox(height: responsive.spacing(AppSpacing.md)),

            AppButton(
              label: AppStrings.addPaymentMethodLabel,
              icon: Icons.add_rounded,
              onPressed: addCard,
            ),
          ],
        ),
      ),
    );
  }
}