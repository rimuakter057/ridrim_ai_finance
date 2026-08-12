import '../../domain/entities/bill.dart';

/// Data-layer representation of [Bill]. Kept separate from the domain
/// entity so JSON (de)serialization can be added here later without
/// leaking data-layer concerns into the domain layer.
class BillModel extends Bill {
  const BillModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.dueDate,
    required super.recurrence,
    super.isPaid,
    super.payee,
  });
}
