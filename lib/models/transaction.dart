import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String id;
  final String name;
  final double amount;
  final String category; // 'income' or 'outcome'
  final DateTime date;

  Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
  });

  factory Transaction.fromFirestore(Map<String, dynamic> data, String id) {
    return Transaction(
      id: id,
      name: data['name'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      category: data['category'] ?? 'outcome',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
    };
  }
} 