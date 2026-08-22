import '../../domain/entities/debt.dart';
import '../../domain/repositories/debt_repository.dart';
import '../datasources/mock/mock_debt_data.dart';

/// [DebtRepository] backed by [MockDebtDataSource]. Swap the data source
/// for an API-backed one later without touching call sites -- they only
/// depend on the [DebtRepository] interface.
class DebtRepositoryImpl implements DebtRepository {
  const DebtRepositoryImpl(this._dataSource);

  final MockDebtDataSource _dataSource;

  @override
  Future<List<Debt>> getDebts() => _dataSource.getDebts();
}
