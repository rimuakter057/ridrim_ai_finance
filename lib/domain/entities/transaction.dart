/// Broad spending/income category used across transactions and budgets.
enum TransactionCategory {
  income,
  groceries,
  food,
  transport,
  shopping,
  entertainment,
  billsUtilities,
  health,
  travel,
  other,
}

/// Whether a transaction added or removed money from an account.
enum TransactionType { income, expense }

/// A single posted transaction against an [Account].
///
/// Pure domain entity -- no Flutter or data-layer dependencies.
class Transaction {
  const Transaction({
    required this.id,
    required this.accountId,
    required this.title,
    required this.category,
    required this.amount,
    required this.type,
    required this.date,
    this.merchant,
    this.note,
  });

  final String id;
  final String accountId;
  final String title;
  final TransactionCategory category;

  /// Always positive -- sign is carried by [type].
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String? merchant;
  final String? note;

  /// Signed amount: positive for income, negative for expense -- convenient
  /// for summing net cash flow.
  double get signedAmount => type == TransactionType.income ? amount : -amount;
}
