import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/finance_provider.dart';
import '../widgets/transaction_tile.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txState = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Movimientos')),
      body: txState.when(
        data: (txs) {
          if (txs.isEmpty) {
            return const Center(child: Text('Sin movimientos todavía'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: txs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) => TransactionTile(transaction: txs[i]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}