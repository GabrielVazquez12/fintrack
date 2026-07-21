class FinanceAccount {
  final String id;
  final String name;
  final double balance;

  const FinanceAccount({
    required this.id,
    required this.name,
    required this.balance,
  });

  factory FinanceAccount.fromJson(Map<String, dynamic> json) {
    return FinanceAccount(
      id: json['id'].toString(),
      name: json['name'] as String,
      balance: (json['balance'] as num).toDouble(),
    );
  }
}