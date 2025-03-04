import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? selectedMethod = 'qris';

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Payment Method',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Payment Methods
                      _buildPaymentMethodItem(
                        'bca',
                        'Bank Central Asia',
                        'BCA',
                      ),
                      _buildPaymentMethodItem('mandiri', 'Mandiri', 'M'),
                      _buildPaymentMethodItem('bri', 'Bri', 'BRI'),
                      _buildPaymentMethodItem(
                        'qris',
                        'Qris',
                        'QRIS',
                        isSelected: true,
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
                              '/payment-confirmation',
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

  Widget _buildPaymentMethodItem(
    String id,
    String name,
    String logoText, {
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = id;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                logoText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: id == 'qris' ? 12 : 14,
                ),
              ),
            ),
            SizedBox(width: 16),
            Text(
              name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      id == selectedMethod
                          ? Color(0xFF4ECDC4)
                          : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child:
                  id == selectedMethod
                      ? Container(
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF4ECDC4),
                        ),
                      )
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
