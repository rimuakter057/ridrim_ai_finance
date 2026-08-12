import '../entities/alert.dart';

/// Contract for retrieving and acknowledging alerts.
abstract class AlertRepository {
  Future<List<Alert>> getAlerts();

  Future<Alert> markRead(String alertId);
}
