import '../../domain/entities/budget.dart';

/// Data-layer representation of [Budget]. Kept separate from the domain
/// entity so JSON (de)serialization can be added here later without
/// leaking data-layer concerns into the domain layer.
class BudgetModel extends Budget {
  const BudgetModel({
    required super.id,
    required super.category,
    required super.limit,
    required super.spent,
    required super.period,
  });
}
