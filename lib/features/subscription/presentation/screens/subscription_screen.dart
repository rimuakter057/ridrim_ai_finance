import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../data/datasources/mock/mock_subscription_data.dart';
import '../../../../data/repositories/subscription_repository_impl.dart';
import '../../../../domain/entities/subscription_plan.dart';
import '../../../../domain/repositories/subscription_repository.dart';
import '../../../../domain/usecases/get_subscription_plans.dart';
import '../widgets/billing_period_toggle.dart';
import '../widgets/subscription_plan_card.dart';

/// Subscription plans screen: billing period toggle plus a list of plan
/// cards. Wired through the Clean Architecture stack the same way as the
/// other data-backed screens.
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final SubscriptionRepository _repository =
      const SubscriptionRepositoryImpl(MockSubscriptionDataSource());
  late final GetSubscriptionPlans _getSubscriptionPlans =
      GetSubscriptionPlans(_repository);

  List<SubscriptionPlan> _plans = [];
  bool _isLoading = true;
  BillingPeriod _billingPeriod = BillingPeriod.monthly;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    final List<SubscriptionPlan> plans = await _getSubscriptionPlans();
    if (!mounted) return;
    setState(() {
      _plans = plans;
      _isLoading = false;
    });
  }

  Future<void> _subscribe(BuildContext context, SubscriptionPlan plan) async {
    final bool? confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SubscribeConfirmSheet(
        plan: plan,
        billingPeriod: _billingPeriod,
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Update the current plan locally
    setState(() {
      _plans = _plans.map((p) {
        return SubscriptionPlan(
          id: p.id,
          name: p.name,
          monthlyPrice: p.monthlyPrice,
          yearlyPrice: p.yearlyPrice,
          features: p.features,
          isPopular: p.isPopular,
          isCurrent: p.id == plan.id,
        );
      }).toList();
    });

    context.showSnackBar(
      'Successfully subscribed to ${plan.name} plan! 🎉',
    );
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);

    return Scaffold(
      appBar: const AppAppBar(
        title: AppStrings.subscriptionScreenTitle,
        subtitle: AppStrings.subscriptionScreenSubtitle,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: AppLoading())
            : Center(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: responsive.maxContentWidth),
                  child: ListView(
                    padding:
                        EdgeInsets.all(responsive.spacing(AppSpacing.xxl)),
                    children: [
                      BillingPeriodToggle(
                        period: _billingPeriod,
                        onChanged: (period) =>
                            setState(() => _billingPeriod = period),
                      ),
                      SizedBox(height: responsive.spacing(AppSpacing.xxl)),
                      for (final SubscriptionPlan plan in _plans)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: responsive.spacing(AppSpacing.lg),
                          ),
                          child: SubscriptionPlanCard(
                            plan: plan,
                            billingPeriod: _billingPeriod,
                            onSubscribe: () => _subscribe(context, plan),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

// ── Confirm Sheet ────────────────────────────────────────────────────────────

class _SubscribeConfirmSheet extends StatefulWidget {
  const _SubscribeConfirmSheet({
    required this.plan,
    required this.billingPeriod,
  });

  final SubscriptionPlan plan;
  final BillingPeriod billingPeriod;

  @override
  State<_SubscribeConfirmSheet> createState() => _SubscribeConfirmSheetState();
}

class _SubscribeConfirmSheetState extends State<_SubscribeConfirmSheet> {
  bool _isLoading = false;

  String get _priceText {
    final price = widget.plan.priceFor(widget.billingPeriod);
    if (price == 0) return 'Free';
    return widget.billingPeriod == BillingPeriod.monthly
        ? '\$${price.toStringAsFixed(0)}/month'
        : '\$${price.toStringAsFixed(0)}/year';
  }

  Future<void> _confirm() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Plan summary card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.planCardGradient,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.plan.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _priceText,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.billingPeriod == BillingPeriod.monthly
                      ? 'Billed monthly · Cancel anytime'
                      : 'Billed annually · Cancel anytime',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Features
          Text(
            "What's included",
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          for (final feature in widget.plan.features)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),

          // Payment method note
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.credit_card_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visa •••• 4242',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Default payment method',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Change',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Security note
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                'Secured with 256-bit SSL encryption',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Confirm button
          FilledButton(
            onPressed: _isLoading ? null : _confirm,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Confirm & Subscribe · $_priceText',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          // Cancel
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
