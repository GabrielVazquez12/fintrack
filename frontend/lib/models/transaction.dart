import 'category.dart';

class FinanceTransaction {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String categoryId;
  final DateTime date;
  final String accountId;
  final String? note;

  const FinanceTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    required this.accountId,
    this.note,
  });

  double get signedAmount => type == TransactionType.income ? amount : -amount;

  // Maps to/from the shape the Spring Boot backend will eventually return.
  factory FinanceTransaction.fromJson(Map<String, dynamic> json) {
    return FinanceTransaction(
      id: json['id'].toString(),
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] == 'INCOME' ? TransactionType.income : TransactionType.expense,
      categoryId: json['categoryId'] as String,
      date: DateTime.parse(json['date'] as String),
      accountId: json['accountId'].toString(),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type == TransactionType.income ? 'INCOME' : 'EXPENSE',
      'categoryId': categoryId,
      'date': date.toIso8601String(),
      'accountId': accountId,
      'note': note,
    };
  }
}