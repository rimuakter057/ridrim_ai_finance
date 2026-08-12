import 'package:flutter/material.dart';

import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_empty_state.dart';

/// Debt tracking (credit cards, loans, mortgages) with a payoff plan.
/// Placeholder for this pass; full build is a follow-up.
class DebtScreen extends StatelessWidget {
  const DebtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Debt'),
      body: const AppEmptyState(
        icon: Icons.credit_score_outlined,
        title: 'Debt tracking is coming soon',
        description:
            'Track credit cards, loans, and mortgages with an AI payoff plan.',
      ),
    );
  }
}
