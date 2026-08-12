import '../entities/alert.dart';
import '../repositories/alert_repository.dart';

/// Fetches the user's alerts, newest first.
class GetAlerts {
  const GetAlerts(this._repository);

  final AlertRepository _repository;

  Future<List<Alert>> call() async {
    final List<Alert> alerts = await _repository.getAlerts();
    final List<Alert> sorted = List.of(alerts)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted;
  }
}
