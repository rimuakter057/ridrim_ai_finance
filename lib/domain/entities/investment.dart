/// The kind of investment holding.
enum InvestmentType { stock, etf, mutualFund, crypto, bond }

/// A single portfolio holding.
///
/// Pure domain entity -- no Flutter or data-layer dependencies.
class Investment {
  const Investment({
    required this.id,
    required this.name,
    required this.symbol,
    required this.type,
    required this.units,
    required this.currentPrice,
    required this.costBasisPrice,
  });

  final String id;
  final String name;
  final String symbol;
  final InvestmentType type;
  final double units;

  /// Current price per unit/share.
  final double currentPrice;

  /// Average price per unit/share paid when acquired.
  final double costBasisPrice;

  double get currentValue => units * currentPrice;
  double get costBasis => units * costBasisPrice;
  double get gainLoss => currentValue - costBasis;
  double get gainLossPercent =>
      costBasis <= 0 ? 0 : (gainLoss / costBasis) * 100;
  bool get isGaining => gainLoss >= 0;
}
