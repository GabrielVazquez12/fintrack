import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/finance_provider.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final _nameCtrl = TextEditingController();
  final _balanceCtrl = TextEditingController();
  bool _saving = false;
  String? _error;

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final balance = double.tryParse(_balanceCtrl.text.replaceAll(',', '.'));
    if (name.isEmpty || balance == null || balance < 0) {
      setState(() => _error = 'Revisa el nombre y el saldo inicial');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(accountsProvider.notifier).createAccount(name, balance);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = 'No se pudo crear la cuenta. Intenta de nuevo.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva cuenta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crea tu primera cuenta para empezar a registrar movimientos.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre (ej. Cuenta principal)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _balanceCtrl,
              decoration: const InputDecoration(labelText: 'Saldo inicial', prefixText: '\$ '),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
            ],
            const SizedBox(height: 28),
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
                    : const Text('Crear cuenta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}