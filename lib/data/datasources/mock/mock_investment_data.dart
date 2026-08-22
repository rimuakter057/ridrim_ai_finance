import '../../../domain/entities/investment.dart';
import '../../models/investment_model.dart';

/// In-memory mock data source standing in for a real brokerage/market-data
/// API. Prices are static snapshots -- swap for a live-quote data source
/// (same method signature) once one exists.
class MockInvestmentDataSource {
  const MockInvestmentDataSource();

  static const List<InvestmentModel> _investments = [
    InvestmentModel(
      id: 'inv_sp500',
      name: 'S&P 500 ETF',
      symbol: 'VOO',
      type: InvestmentType.etf,
      units: 12.5,
      currentPrice: 512.30,
      costBasisPrice: 460.10,
    ),
    InvestmentModel(
      id: 'inv_apple',
      name: 'Apple Inc.',
      symbol: 'AAPL',
      type: InvestmentType.stock,
      units: 8,
      currentPrice: 231.80,
      costBasisPrice: 189.40,
    ),
    InvestmentModel(
      id: 'inv_nvidia',
      name: 'NVIDIA Corp.',
      symbol: 'NVDA',
      type: InvestmentType.stock,
      units: 5,
      currentPrice: 138.20,
      costBasisPrice: 152.00,
    ),
    InvestmentModel(
      id: 'inv_bitcoin',
      name: 'Bitcoin',
      symbol: 'BTC',
      type: InvestmentType.crypto,
      units: 0.045,
      currentPrice: 94200.00,
      costBasisPrice: 71500.00,
    ),
    InvestmentModel(
      id: 'inv_bond',
      name: 'US Treasury Bond Fund',
      symbol: 'BND',
      type: InvestmentType.bond,
      units: 20,
      currentPrice: 72.10,
      costBasisPrice: 73.50,
    ),
  ];

  Future<List<Investment>> getInvestments() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.of(_investments);
  }
}
