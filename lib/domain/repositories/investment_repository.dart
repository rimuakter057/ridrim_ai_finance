import '../entities/investment.dart';

/// Contract for retrieving the user's investment portfolio.
abstract class InvestmentRepository {
  Future<List<Investment>> getInvestments();
}
