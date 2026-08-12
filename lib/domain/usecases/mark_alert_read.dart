import '../entities/alert.dart';
import '../repositories/alert_repository.dart';

/// Marks a single alert as read.
class MarkAlertRead {
  const MarkAlertRead(this._repository);

  final AlertRepository _repository;

  Future<Alert> call(String alertId) => _repository.markRead(alertId);
}
