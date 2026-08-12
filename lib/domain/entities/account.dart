/// The kind of financial account.
enum AccountType { checking, savings, credit, investment }

/// A linked financial account (bank account, card, or investment).
///
/// Pure domain entity -- no Flutter or data-layer dependencies.
class Account {
  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.currency,
    required this.institution,
  });

  final String id;
  final String name;
  final AccountType type;

  /// Current balance. Negative for credit accounts carrying a balance owed.
  final double balance;
  final String currency;
  final String institution;
}
