import '../../../domain/entities/account.dart';
import '../../models/account_model.dart';

/// In-memory mock data source standing in for a real accounts-linking API
/// (Plaid-style aggregation).
class MockAccountDataSource {
  const MockAccountDataSource();

  static const List<AccountModel> _accounts = [
    AccountModel(
      id: 'acc_checking',
      name: 'Everyday Checking',
      type: AccountType.checking,
      balance: 4820.55,
      currency: 'USD',
      institution: 'Horizon Bank',
    ),
    AccountModel(
      id: 'acc_savings',
      name: 'Emergency Fund',
      type: AccountType.savings,
      balance: 12500,
      currency: 'USD',
      institution: 'Horizon Bank',
    ),
    AccountModel(
      id: 'acc_credit',
      name: 'Rewards Card',
      type: AccountType.credit,
      balance: -842.30,
      currency: 'USD',
      institution: 'Apex Card',
    ),
    AccountModel(
      id: 'acc_investment',
      name: 'Growth Portfolio',
      type: AccountType.investment,
      balance: 8340.10,
      currency: 'USD',
      institution: 'Vantage Invest',
    ),
  ];

  Future<List<Account>> getAccounts() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.of(_accounts);
  }
}
