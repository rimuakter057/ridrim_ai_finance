import '../../domain/entities/alert.dart';
import '../../domain/repositories/alert_repository.dart';
import '../datasources/mock/mock_alert_data.dart';

/// [AlertRepository] backed by [MockAlertDataSource]. Swap the data source
/// for an API-backed one later without touching call sites -- they only
/// depend on the [AlertRepository] interface.
class AlertRepositoryImpl implements AlertRepository {
  const AlertRepositoryImpl(this._dataSource);

  final MockAlertDataSource _dataSource;

  @override
  Future<List<Alert>> getAlerts() => _dataSource.getAlerts();

  @override
  Future<Alert> markRead(String alertId) => _dataSource.markRead(alertId);
}
