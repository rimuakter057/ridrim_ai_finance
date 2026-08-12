import 'package:flutter/material.dart';

import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_empty_state.dart';


class InvestmentsScreen extends StatelessWidget {
  const InvestmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Investments'),
      body: const AppEmptyState(
        icon: Icons.candlestick_chart_outlined,
        title: 'Portfolio tracking is coming soon',
        description: 'Stocks, ETFs, and crypto, with AI portfolio insights.',
      ),
    );
  }
}
