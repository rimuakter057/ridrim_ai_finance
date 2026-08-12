import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../data/datasources/mock/mock_alert_data.dart';
import '../../../../data/repositories/alert_repository_impl.dart';
import '../../../../domain/entities/alert.dart';
import '../../../../domain/repositories/alert_repository.dart';
import '../../../../domain/usecases/get_alerts.dart';
import '../../../../domain/usecases/mark_alert_read.dart';
import '../widgets/alert_tile.dart';

/// Spending and account alerts, newest first, with a severity-colored
/// notification-feed layout distinct from the rest of the app's card grid.
class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final AlertRepository _repository =
      const AlertRepositoryImpl(MockAlertDataSource());
  late final GetAlerts _getAlerts = GetAlerts(_repository);
  late final MarkAlertRead _markRead = MarkAlertRead(_repository);

  List<Alert> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<Alert> alerts = await _getAlerts();
    if (!mounted) return;
    setState(() {
      _alerts = alerts;
      _isLoading = false;
    });
  }

  Future<void> _handleTap(Alert alert) async {
    if (alert.isRead) return;
    await _markRead(alert.id);
    if (!mounted) return;
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final int unreadCount = _alerts.where((a) => !a.isRead).length;

    return Scaffold(
      appBar: AppAppBar(
        title: 'Alerts',
        subtitle: unreadCount > 0 ? '$unreadCount unread' : null,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: AppLoading())
            : _alerts.isEmpty
                ? const AppEmptyState(
                    icon: Icons.notifications_none_rounded,
                    title: 'No alerts yet',
                    description: 'Spending and account alerts will show up here.',
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(responsive.spacing(AppSpacing.lg)),
                    itemCount: _alerts.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: responsive.spacing(AppSpacing.sm)),
                    itemBuilder: (context, index) {
                      final Alert alert = _alerts[index];
                      return AlertTile(
                        alert: alert,
                        onTap: () => _handleTap(alert),
                      );
                    },
                  ),
      ),
    );
  }
}
