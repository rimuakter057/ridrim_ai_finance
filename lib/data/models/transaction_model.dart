import '../../domain/entities/transaction.dart';

/// Data-layer representation of [Transaction]. Kept separate from the
/// domain entity so JSON (de)serialization can be added here later without
/// leaking data-layer concerns into the domain layer.
class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.accountId,
    required super.title,
    required super.category,
    required super.amount,
    required super.type,
    required super.date,
    super.merchant,
    super.note,
  });
}
