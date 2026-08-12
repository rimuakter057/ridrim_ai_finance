import '../../../domain/entities/alert.dart';
import '../../models/alert_model.dart';

/// In-memory mock data source standing in for a real alerts API.
///
/// [_alerts] is `static` so every instance shares the same in-memory list --
/// marking an alert read from one screen is visible from any other.
class MockAlertDataSource {
  const MockAlertDataSource();

  static final DateTime _now = DateTime.now();

  static final List<AlertModel> _alerts = [
    AlertModel(
      id: 'alert_budget_bills',
      type: AlertType.budgetExceeded,
      severity: AlertSeverity.critical,
      title: 'Bills & Utilities budget nearly used up',
      message: "You've spent \$1,648.41 of your \$1,800 budget this month.",
      timestamp: _now.subtract(const Duration(hours: 3)),
    ),
    AlertModel(
      id: 'alert_bill_electric',
      type: AlertType.billDue,
      severity: AlertSeverity.warning,
      title: 'Electric bill overdue',
      message: 'Your \$118.42 electric bill was due 2 days ago.',
      timestamp: _now.subtract(const Duration(hours: 8)),
    ),
    AlertModel(
      id: 'alert_bill_internet',
      type: AlertType.billDue,
      severity: AlertSeverity.info,
      title: 'Internet bill due soon',
      message: '\$79.99 to Fiberlink is due in 4 days.',
      timestamp: _now.subtract(const Duration(days: 1)),
    ),
    AlertModel(
      id: 'alert_unusual_shopping',
      type: AlertType.unusualSpending,
      severity: AlertSeverity.warning,
      title: 'Unusual spending in Shopping',
      message: 'Shopping spend is 40% higher than your monthly average.',
      timestamp: _now.subtract(const Duration(days: 1, hours: 4)),
      isRead: true,
    ),
    AlertModel(
      id: 'alert_goal_home',
      type: AlertType.savingsMilestone,
      severity: AlertSeverity.info,
      title: 'Goal reached: Home Renovation',
      message: "You've hit your \$6,000 goal for Home Renovation.",
      timestamp: _now.subtract(const Duration(days: 2)),
      isRead: true,
    ),
    AlertModel(
      id: 'alert_low_balance',
      type: AlertType.lowBalance,
      severity: AlertSeverity.critical,
      title: 'Rewards Card balance is negative',
      message: 'Your Rewards Card is carrying a -\$842.30 balance.',
      timestamp: _now.subtract(const Duration(days: 3)),
      isRead: true,
    ),
  ];

  Future<List<Alert>> getAlerts() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.of(_alerts);
  }

  Future<Alert> markRead(String alertId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final int index = _alerts.indexWhere((a) => a.id == alertId);
    if (index == -1) {
      throw ArgumentError('No alert with id $alertId');
    }
    final AlertModel updated = AlertModel(
      id: _alerts[index].id,
      type: _alerts[index].type,
      severity: _alerts[index].severity,
      title: _alerts[index].title,
      message: _alerts[index].message,
      timestamp: _alerts[index].timestamp,
      isRead: true,
    );
    _alerts[index] = updated;
    return updated;
  }
}
