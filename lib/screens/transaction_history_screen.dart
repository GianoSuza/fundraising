import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {
      'type': 'topup',
      'title': 'Top up balance',
      'date': DateTime(2024, 4, 5),
      'amount': 50000,
    },
    {
      'type': 'payment',
      'title': 'Bencana Alam Aceh',
      'date': DateTime(2024, 4, 4),
      'amount': -25000,
    },
    {
      'type': 'payment',
      'title': 'Bangun Masjid',
      'date': DateTime(2024, 4, 4),
      'amount': -25000,
    },
    {
      'type': 'topup',
      'title': 'Top up balance',
      'date': DateTime(2024, 4, 3),
      'amount': 50000,
    },
    {
      'type': 'payment',
      'title': 'Bangun Masjid',
      'date': DateTime(2024, 4, 1),
      'amount': -10000,
    },
    {
      'type': 'payment',
      'title': 'Banjir Demak',
      'date': DateTime(2024, 3, 20),
      'amount': -50000,
    },
    {
      'type': 'payment',
      'title': 'Bantuan sosial',
      'date': DateTime(2024, 3, 20),
      'amount': -50000,
    },
    {
      'type': 'topup',
      'title': 'Top up balance',
      'date': DateTime(2024, 3, 15),
      'amount': 110000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Group transactions by month
    Map<String, List<Map<String, dynamic>>> groupedTransactions = {};

    for (var transaction in transactions) {
      final date = transaction['date'] as DateTime;
      final monthYear = DateFormat('MMM yyyy').format(date);

      if (!groupedTransactions.containsKey(monthYear)) {
        groupedTransactions[monthYear] = [];
      }

      groupedTransactions[monthYear]!.add(transaction);
    }

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
                  // Empty SizedBox to balance the back button
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
                                decoration: InputDecoration(
                                  hintText: 'Search transaction',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            Icon(Icons.filter_list, color: Colors.grey),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      // Transaction List
                      Expanded(
                        child: ListView.builder(
                          itemCount: groupedTransactions.length,
                          itemBuilder: (context, index) {
                            final monthYear = groupedTransactions.keys
                                .elementAt(index);
                            final monthTransactions =
                                groupedTransactions[monthYear]!;

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

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final isTopup = transaction['type'] == 'topup';
    final amount = transaction['amount'] as int;
    final date = transaction['date'] as DateTime;
    final formattedDate = DateFormat('d MMM yyyy').format(date);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isTopup ? Colors.green[50] : Colors.red[50],
            ),
            child: Icon(
              isTopup ? Icons.add : Icons.remove,
              color: isTopup ? Colors.green : Colors.red,
              size: 16,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['title'],
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
            isTopup
                ? '+Rp ${NumberFormat('#,###').format(amount)}'
                : '-Rp ${NumberFormat('#,###').format(amount.abs())}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isTopup ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
