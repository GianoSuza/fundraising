import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  final int amount;
  final String? campaignName;
  final String? campaignId;
  final String userId;
  final bool isTopup;

  const PaymentConfirmationScreen({
    Key? key,
    required this.amount,
    this.campaignName,
    this.campaignId,
    required this.userId,
    this.isTopup = false,
  }) : super(key: key);

  Future<void> _handleDone(BuildContext context) async {
    try {
      if (isTopup) {
        // Handle top-up transaction
        await FirebaseFirestore.instance
            .collection('transactions')
            .add({
              'userId': userId,
              'category': 'income',
              'name': 'Top Up',
              'amount': amount,
              'date': FieldValue.serverTimestamp(),
            });

        // Update user's balance
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
              'saldo': FieldValue.increment(amount),
            });

        // Update local SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final currentSaldo = prefs.getInt('userSaldo') ?? 0;
        await prefs.setInt('userSaldo', currentSaldo + amount);

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Handle donation transaction
        await FirebaseFirestore.instance
            .collection('transactions')
            .add({
              'userId': userId,
              'category': 'outcome',
              'name': campaignName,
              'amount': amount,
              'date': FieldValue.serverTimestamp(),
              'campaignId': campaignId,
            });

        // Update campaign's collected amount
        await FirebaseFirestore.instance
            .collection('donations')
            .doc(campaignId)
            .update({
              'progress': FieldValue.increment(amount),
            });

        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      print('Error recording transaction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7FDFD4),
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar and App Bar
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Payment Confirmation',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        isTopup ? 'Top Up Confirmation' : 'Continue payment',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Amount
                      const Text(
                        'Amount',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rp ${_formatCurrency(amount)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // QR Code
                      Container(
                        width: 200,
                        height: 200,
                        child: QrImageView(
                          data: isTopup 
                              ? 'https://donation-app.com/topup/$userId/$amount'
                              : 'https://donation-app.com/payment/$campaignId/$amount',
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Please scan this QR for payment',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),

                      const Spacer(),

                      // Bottom Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _handleDone(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7FDFD4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
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

  String _formatCurrency(int amount) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String Function(Match) mathFunc = (Match match) => '${match[1]}.';
    return amount.toString().replaceAllMapped(reg, mathFunc);
  }
}
