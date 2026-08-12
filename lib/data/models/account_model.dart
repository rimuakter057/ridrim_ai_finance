import '../../domain/entities/account.dart';

/// Data-layer representation of [Account]. Kept separate from the domain
/// entity so JSON (de)serialization can be added here later without
/// leaking data-layer concerns into the domain layer.
class AccountModel extends Account {
  const AccountModel({
    required super.id,
    required super.name,
    required super.type,
    required super.balance,
    required super.currency,
    required super.institution,
  });
}
