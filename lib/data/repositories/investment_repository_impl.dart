import '../../domain/entities/investment.dart';
import '../../domain/repositories/investment_repository.dart';
import '../datasources/mock/mock_investment_data.dart';

/// [InvestmentRepository] backed by [MockInvestmentDataSource]. Swap the
/// data source for an API-backed one later without touching call sites --
/// they only depend on the [InvestmentRepository] interface.
class InvestmentRepositoryImpl implements InvestmentRepository {
  const InvestmentRepositoryImpl(this._dataSource);

  final MockInvestmentDataSource _dataSource;

  @override
  Future<List<Investment>> getInvestments() => _dataSource.getInvestments();
}
