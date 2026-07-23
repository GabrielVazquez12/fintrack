import 'package:dio/dio.dart';
import '../models/account.dart';
import '../models/category.dart';
import '../models/transaction.dart';

class ApiService {
  // Your computer's local IP — must be on the same WiFi as the phone.
  static const String baseUrl = 'http://3.129.101.57:8080/api';

  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  String? _token;

  void setToken(String token) {
    _token = token;
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearToken() {
    _token = null;
    _dio.options.headers.remove('Authorization');
  }

  Future<String> register(String email, String password, String name) async {
    final response = await _dio.post('/auth/register', data: {
      'email': email,
      'password': password,
      'name': name,
    });
    final token = response.data['token'] as String;
    setToken(token);
    return token;
  }

  Future<String> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    final token = response.data['token'] as String;
    setToken(token);
    return token;
  }

  Future<List<FinanceAccount>> fetchAccounts() async {
    final response = await _dio.get('/accounts');
    return (response.data as List)
        .map((json) => FinanceAccount.fromJson(json))
        .toList();
  }

  Future<FinanceAccount> createAccount(String name, double balance) async {
    final response = await _dio.post('/accounts', data: {
      'name': name,
      'balance': balance,
    });
    return FinanceAccount.fromJson(response.data);
  }

  Future<List<FinanceTransaction>> fetchTransactions() async {
    final response = await _dio.get('/transactions');
    return (response.data as List)
        .map((json) => _transactionFromApi(json))
        .toList();
  }

  Future<FinanceTransaction> addTransaction(FinanceTransaction t) async {
    final response = await _dio.post('/transactions', data: {
      'title': t.title,
      'amount': t.amount,
      'type': t.type == TransactionType.income ? 'INCOME' : 'EXPENSE',
      'categoryCode': t.categoryId,
      'accountId': int.parse(t.accountId),
    });
    return _transactionFromApi(response.data);
  }

  // The backend's field names differ slightly from the Flutter model's
  // (categoryCode vs categoryId), so this maps between the two instead of
  // relying on Transaction.fromJson directly.
  FinanceTransaction _transactionFromApi(Map<String, dynamic> json) {
    return FinanceTransaction(
      id: json['id'].toString(),
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] == 'INCOME' ? TransactionType.income : TransactionType.expense,
      categoryId: json['categoryCode'] as String,
      date: DateTime.parse(json['date'] as String),
      accountId: json['accountId'].toString(),
    );
  }
}