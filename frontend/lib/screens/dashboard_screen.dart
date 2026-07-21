import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../providers/finance_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/spending_chart.dart';
import '../widgets/transaction_tile.dart';
import 'add_transaction_screen.dart';
import 'transaction_screen.dart';
import 'create_account_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalBalance = ref.watch(totalBalanceProvider);
    final txState = ref.watch(transactionsProvider);
    final spending = ref.watch(spendingByCategoryProvider);
    final accountsState = ref.watch(accountsProvider);
    final hasNoAccounts = accountsState.valueOrNull?.isEmpty ?? false;

    if (hasNoAccounts) {
      return Scaffold(
        appBar: AppBar(title: const Text('FinTrack')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Aún no tienes ninguna cuenta',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Crea una para empezar a registrar tus movimientos.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
                  ),
                  child: const Text('Crear cuenta'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final income = (txState.valueOrNull ?? [])
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    final expenses = spending.values.fold(0.0, (sum, v) => sum + v);

    return Scaffold(
      appBar: AppBar(title: const Text('FinTrack')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1B3A2F),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(transactionsProvider),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
          children: [
            totalBalance.when(
              data: (balance) => BalanceCard(balance: balance, income: income, expenses: expenses),
              loading: () => const SizedBox(height: 180, child: Center(child: CircularProgressIndicator())),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 20),
            SpendingChart(spendingByCategory: spending),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('MOVIMIENTOS RECIENTES', style: Theme.of(context).textTheme.labelSmall),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TransactionsScreen()),
                  ),
                  child: const Text('Ver todos'),
                ),
              ],
            ),
            txState.when(
              data: (txs) => Column(
                children: txs.take(5).map((t) => TransactionTile(transaction: t)).toList(),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }
}