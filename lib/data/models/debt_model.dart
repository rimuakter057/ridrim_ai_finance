import '../../domain/entities/debt.dart';

/// Data-layer representation of [Debt]. Kept separate from the domain
/// entity so JSON (de)serialization can be added here later without
/// leaking data-layer concerns into the domain layer.
class DebtModel extends Debt {
  const DebtModel({
    required super.id,
    required super.name,
    required super.type,
    required super.balance,
    required super.originalAmount,
    required super.interestRate,
    required super.minimumPayment,
    required super.dueDate,
  });
}
