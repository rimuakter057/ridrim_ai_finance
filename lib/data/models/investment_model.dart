import '../../domain/entities/investment.dart';

/// Data-layer representation of [Investment]. Kept separate from the
/// domain entity so JSON (de)serialization can be added here later
/// without leaking data-layer concerns into the domain layer.
class InvestmentModel extends Investment {
  const InvestmentModel({
    required super.id,
    required super.name,
    required super.symbol,
    required super.type,
    required super.units,
    required super.currentPrice,
    required super.costBasisPrice,
  });
}
