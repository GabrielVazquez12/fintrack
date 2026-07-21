import '../models/account.dart';
import '../models/category.dart';
import '../models/transaction.dart';

/// Stands in for the real API service while the Spring Boot backend is
/// being built. Swap this for `ApiService` (using dio) once the backend
/// endpoints exist — the interface is meant to match 1:1.
class MockDataService {
  static final List<FinanceAccount> accounts = [
    const FinanceAccount(id: '1', name: 'Cuenta principal', balance: 12450.75),
    const FinanceAccount(id: '2', name: 'Tarjeta de crédito', balance: -1320.40),
    const FinanceAccount(id: '3', name: 'Ahorros', balance: 8200.00),
  ];

  static final List<FinanceTransaction> transactions = [
    FinanceTransaction(
      id: '1',
      title: 'Nómina julio',
      amount: 15000,
      type: TransactionType.income,
      categoryId: 'salary',
      date: DateTime.now().subtract(const Duration(days: 2)),
      accountId: '1',
    ),
    FinanceTransaction(
      id: '2',
      title: 'Renta',
      amount: 4500,
      type: TransactionType.expense,
      categoryId: 'housing',
      date: DateTime.now().subtract(const Duration(days: 3)),
      accountId: '1',
    ),
    FinanceTransaction(
      id: '3',
      title: 'Supermercado',
      amount: 980.50,
      type: TransactionType.expense,
      categoryId: 'food',
      date: DateTime.now().subtract(const Duration(days: 4)),
      accountId: '1',
    ),
    FinanceTransaction(
      id: '4',
      title: 'Proyecto freelance',
      amount: 2800,
      type: TransactionType.income,
      categoryId: 'freelance',
      date: DateTime.now().subtract(const Duration(days: 5)),
      accountId: '3',
    ),
    FinanceTransaction(
      id: '5',
      title: 'Gasolina',
      amount: 650,
      type: TransactionType.expense,
      categoryId: 'transport',
      date: DateTime.now().subtract(const Duration(days: 6)),
      accountId: '1',
    ),
    FinanceTransaction(
      id: '6',
      title: 'Cine',
      amount: 220,
      type: TransactionType.expense,
      categoryId: 'entertainment',
      date: DateTime.now().subtract(const Duration(days: 7)),
      accountId: '2',
    ),
    FinanceTransaction(
      id: '7',
      title: 'Consulta médica',
      amount: 500,
      type: TransactionType.expense,
      categoryId: 'health',
      date: DateTime.now().subtract(const Duration(days: 9)),
      accountId: '1',
    ),
  ];

  static Future<List<FinanceTransaction>> fetchTransactions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(transactions);
  }

  static Future<List<FinanceAccount>> fetchAccounts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(accounts);
  }

  static Future<FinanceTransaction> addTransaction(FinanceTransaction t) async {
    await Future.delayed(const Duration(milliseconds: 200));
    transactions.insert(0, t);
    return t;
  }

  static Map<String, double> spendingByCategory() {
    final Map<String, double> totals = {};
    for (final t in transactions.where((t) => t.type == TransactionType.expense)) {
      totals[t.categoryId] = (totals[t.categoryId] ?? 0) + t.amount;
    }
    return totals;
  }
}