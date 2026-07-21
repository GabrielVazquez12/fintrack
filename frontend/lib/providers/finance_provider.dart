import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/account.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../services/mock_data_service.dart';

final transactionsProvider =
AsyncNotifierProvider<TransactionsNotifier, List<FinanceTransaction>>(
  TransactionsNotifier.new,
);

class TransactionsNotifier extends AsyncNotifier<List<FinanceTransaction>> {
  @override
  Future<List<FinanceTransaction>> build() async {
    return MockDataService.fetchTransactions();
  }

  Future<void> addTransaction(FinanceTransaction t) async {
    final added = await MockDataService.addTransaction(t);
    final current = state.valueOrNull ?? [];
    state = AsyncData([added, ...current]);
  }
}

final accountsProvider = FutureProvider<List<FinanceAccount>>((ref) async {
  return MockDataService.fetchAccounts();
});

/// Total balance across all accounts.
final totalBalanceProvider = Provider<AsyncValue<double>>((ref) {
  final accounts = ref.watch(accountsProvider);
  return accounts.whenData((list) => list.fold(0.0, (sum, a) => sum + a.balance));
});

/// Spending grouped by category, derived from the current transaction list.
final spendingByCategoryProvider = Provider<Map<String, double>>((ref) {
  final txState = ref.watch(transactionsProvider);
  final txs = txState.valueOrNull ?? [];
  final Map<String, double> totals = {};
  for (final t in txs.where((t) => t.type == TransactionType.expense)) {
    totals[t.categoryId] = (totals[t.categoryId] ?? 0) + t.amount;
  }
  return totals;
});