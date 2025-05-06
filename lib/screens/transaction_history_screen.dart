import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../models/transaction.dart' as model;

class TransactionHistoryScreen extends StatefulWidget {
  @override
  _TransactionHistoryScreenState createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4ECDC4),
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar and App Bar
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.popAndPushNamed(context, '/home');
                    },
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Transaction',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    children: [
                      // Search Bar
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search transaction',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value.toLowerCase();
                                  });
                                },
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      // Transaction List
                      Expanded(
                        child: StreamBuilder<firestore.QuerySnapshot>(
                          stream: firestore.FirebaseFirestore.instance
                              .collection('transactions')
                              .orderBy('date', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final transactions = snapshot.data!.docs
                                .map((doc) => model.Transaction.fromFirestore(
                                    doc.data() as Map<String, dynamic>, doc.id))
                                .where((transaction) => _searchQuery.isEmpty ||
                                    transaction.name.toLowerCase().contains(_searchQuery) ||
                                    transaction.category.toLowerCase().contains(_searchQuery) ||
                                    NumberFormat('#,###').format(transaction.amount).contains(_searchQuery))
                                .toList();

                            if (transactions.isEmpty) {
                              return Center(
                                child: Text(
                                  _searchQuery.isEmpty
                                      ? 'No transactions found'
                                      : 'No transactions match your search',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }

                            // Group transactions by month
                            Map<String, List<model.Transaction>> groupedTransactions = {};

                            for (var transaction in transactions) {
                              final monthYear = DateFormat('MMM yyyy').format(transaction.date);

                              if (!groupedTransactions.containsKey(monthYear)) {
                                groupedTransactions[monthYear] = [];
                              }

                              groupedTransactions[monthYear]!.add(transaction);
                            }

                            return ListView.builder(
                              itemCount: groupedTransactions.length,
                              itemBuilder: (context, index) {
                                final monthYear = groupedTransactions.keys.elementAt(index);
                                final monthTransactions = groupedTransactions[monthYear]!;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      child: Text(
                                        index == 0 ? 'This month' : monthYear,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    ...monthTransactions.map((transaction) {
                                      return _buildTransactionItem(transaction);
                                    }).toList(),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(model.Transaction transaction) {
    final isIncome = transaction.category == 'income';
    final formattedDate = DateFormat('d MMM yyyy').format(transaction.date);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isIncome ? Colors.green[50] : Colors.red[50],
            ),
            child: Icon(
              isIncome ? Icons.add : Icons.remove,
              color: isIncome ? Colors.green : Colors.red,
              size: 16,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            isIncome
                ? '+Rp ${NumberFormat('#,###').format(transaction.amount)}'
                : '-Rp ${NumberFormat('#,###').format(transaction.amount.abs())}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
