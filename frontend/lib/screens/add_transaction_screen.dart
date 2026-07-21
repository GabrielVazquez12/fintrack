import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../providers/finance_provider.dart';
import '../theme/app_theme.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  TransactionType _type = TransactionType.expense;
  String _categoryId = Category.expenseCategories.first.id;
  bool _saving = false;

  List<Category> get _categories =>
      _type == TransactionType.income ? Category.incomeCategories : Category.expenseCategories;

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '.'));
    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Revisa el título y el monto')),
      );
      return;
    }
    setState(() => _saving = true);
    final tx = FinanceTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      type: _type,
      categoryId: _categoryId,
      date: DateTime.now(),
      accountId: '1',
    );
    await ref.read(transactionsProvider.notifier).addTransaction(tx);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo movimiento')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SegmentedButton<TransactionType>(
              segments: const [
                ButtonSegment(value: TransactionType.expense, label: Text('Gasto')),
                ButtonSegment(value: TransactionType.income, label: Text('Ingreso')),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() {
                _type = s.first;
                _categoryId = _categories.first.id;
              }),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountCtrl,
              decoration: const InputDecoration(labelText: 'Monto', prefixText: '\$ '),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            Text('Categoría', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((c) {
                final selected = c.id == _categoryId;
                return ChoiceChip(
                  label: Text(c.name),
                  selected: selected,
                  onSelected: (_) => setState(() => _categoryId = c.id),
                  selectedColor: c.color.withOpacity(0.2),
                  labelStyle: TextStyle(color: selected ? c.color : AppColors.ink),
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}