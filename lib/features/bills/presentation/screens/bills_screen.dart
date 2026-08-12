import 'package:ai_saas/features/bills/presentation/widgets/section_label.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../data/datasources/mock/mock_bill_data.dart';
import '../../../../data/repositories/bill_repository_impl.dart';
import '../../../../domain/entities/bill.dart';
import '../../../../domain/repositories/bill_repository.dart';
import '../../../../domain/usecases/get_bills.dart';
import '../../../../domain/usecases/set_bill_paid.dart';
import '../widgets/bill_tile.dart';

/// Upcoming, overdue, and paid bills, with an inline paid-toggle checklist.
class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final BillRepository _repository = const BillRepositoryImpl(MockBillDataSource());
  late final GetBills _getBills = GetBills(_repository);
  late final SetBillPaid _setBillPaid = SetBillPaid(_repository);

  List<Bill> _bills = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<Bill> bills = await _getBills();
    if (!mounted) return;
    setState(() {
      _bills = bills;
      _isLoading = false;
    });
  }

  Future<void> _togglePaid(Bill bill, bool isPaid) async {
    await _setBillPaid(bill.id, isPaid);
    if (!mounted) return;
    context.showSnackBar(isPaid ? '${bill.name} marked paid' : '${bill.name} marked unpaid');
    _load();
  }

  double get _totalDue => _bills
      .where((b) => !b.isPaid)
      .fold(0, (sum, b) => sum + b.amount);

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final List<Bill> overdue = _bills.where((b) => b.isOverdue).toList();
    final List<Bill> upcoming =
        _bills.where((b) => !b.isPaid && !b.isOverdue).toList();
    final List<Bill> paid = _bills.where((b) => b.isPaid).toList();

    return Scaffold(
      appBar: const AppAppBar(title: 'Bills'),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: AppLoading())
            : _bills.isEmpty
                ? const AppEmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'No bills yet',
                  )
                : ListView(
                    padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
                    children: [
                      AppCard(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total due', style: context.textTheme.bodySmall),
                                Text(
                                  AppHelpers.formatCurrency(_totalDue),
                                  style: context.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            if (overdue.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.error
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '${overdue.length} overdue',
                                  style: context.textTheme.labelMedium?.copyWith(
                                    color: context.colorScheme.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: responsive.spacing(AppSpacing.xl)),
                      if (overdue.isNotEmpty) ...[
                        SectionLabel('Overdue'),
                        for (final bill in overdue)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: responsive.spacing(AppSpacing.sm),
                            ),
                            child: BillTile(
                              bill: bill,
                              onTogglePaid: (v) => _togglePaid(bill, v),
                            ),
                          ),
                        SizedBox(height: responsive.spacing(AppSpacing.md)),
                      ],
                      if (upcoming.isNotEmpty) ...[
                        SectionLabel('Upcoming'),
                        for (final bill in upcoming)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: responsive.spacing(AppSpacing.sm),
                            ),
                            child: BillTile(
                              bill: bill,
                              onTogglePaid: (v) => _togglePaid(bill, v),
                            ),
                          ),
                        SizedBox(height: responsive.spacing(AppSpacing.md)),
                      ],
                      if (paid.isNotEmpty) ...[
                        SectionLabel('Paid'),
                        for (final bill in paid)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: responsive.spacing(AppSpacing.sm),
                            ),
                            child: BillTile(
                              bill: bill,
                              onTogglePaid: (v) => _togglePaid(bill, v),
                            ),
                          ),
                      ],
                    ],
                  ),
      ),
    );
  }
}


