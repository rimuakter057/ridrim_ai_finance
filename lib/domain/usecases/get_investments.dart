import '../entities/investment.dart';
import '../repositories/investment_repository.dart';

/// Fetches the user's investment portfolio.
class GetInvestments {
  const GetInvestments(this._repository);

  final InvestmentRepository _repository;

  Future<List<Investment>> call() => _repository.getInvestments();
}
