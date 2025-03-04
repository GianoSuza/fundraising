import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentConfirmationScreen extends StatelessWidget {
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
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Topup',
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Continue payment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 32),

                      // Amount
                      Text(
                        'Amount',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Rp.200.000',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 32),

                      // QR Code
                      Container(
                        width: 200,
                        height: 200,
                        child: QrImageView(
                          data: 'https://donation-app.com/payment/123456789',
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Please scan this QR for top up',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),

                      Spacer(),

                      // Bottom Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/transaction-history',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4ECDC4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Topup now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
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
}
