import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/account.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(ref.watch(apiServiceProvider));
});

class AuthNotifier extends StateNotifier<bool> {
  final ApiService _api;
  AuthNotifier(this._api) : super(false);

  Future<void> login(String email, String password) async {
    await _api.login(email, password);
    state = true;
  }

  Future<void> register(String email, String password, String name) async {
    await _api.register(email, password, name);
    state = true;
  }

  void logout() {
    _api.clearToken();
    state = false;
  }
}

final transactionsProvider =
    AsyncNotifierProvider<TransactionsNotifier, List<FinanceTransaction>>(
  TransactionsNotifier.new,
);

class TransactionsNotifier extends AsyncNotifier<List<FinanceTransaction>> {
  @override
  Future<List<FinanceTransaction>> build() async {
    return ref.watch(apiServiceProvider).fetchTransactions();
  }

  Future<void> addTransaction(FinanceTransaction t) async {
    final added = await ref.read(apiServiceProvider).addTransaction(t);
    final current = state.valueOrNull ?? [];
    state = AsyncData([added, ...current]);
  }
}

final accountsProvider =
    AsyncNotifierProvider<AccountsNotifier, List<FinanceAccount>>(
  AccountsNotifier.new,
);

class AccountsNotifier extends AsyncNotifier<List<FinanceAccount>> {
  @override
  Future<List<FinanceAccount>> build() async {
    return ref.watch(apiServiceProvider).fetchAccounts();
  }

  Future<void> createAccount(String name, double balance) async {
    final created = await ref.read(apiServiceProvider).createAccount(name, balance);
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, created]);
  }
}

final totalBalanceProvider = Provider<AsyncValue<double>>((ref) {
  final accounts = ref.watch(accountsProvider);
  return accounts.whenData((list) => list.fold(0.0, (sum, a) => sum + a.balance));
});

final spendingByCategoryProvider = Provider<Map<String, double>>((ref) {
  final txState = ref.watch(transactionsProvider);
  final txs = txState.valueOrNull ?? [];
  final Map<String, double> totals = {};
  for (final t in txs.where((t) => t.type == TransactionType.expense)) {
    totals[t.categoryId] = (totals[t.categoryId] ?? 0) + t.amount;
  }
  return totals;
});