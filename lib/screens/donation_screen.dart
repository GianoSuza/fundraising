import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF7FDFD4),
        scaffoldBackgroundColor: const Color(0xFF7FDFD4),
        fontFamily: 'Roboto',
      ),
      home: const DonationDetailsPage(),
    );
  }
}

class DonationDetailsPage extends StatelessWidget {
  const DonationDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7FDFD4),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Handle back button press
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  const Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle favorite button press
                    },
                    child: const Icon(Icons.favorite_border, color: Colors.black),
                  ),
                ],
              ),
            ),
            
            // Content - Popup style with rounded top corners
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Screenshot%202025-04-13%20at%2007.35.14-imKS8zYFztTUNnaVdd2yevfpIosgCv.png',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Title
                        const Text(
                          'Bantu Banjir Demak Kembali Pulih.',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Location and Views
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    'Demak',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.visibility_outlined, size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    '10.000',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.share_outlined),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: 0.6,
                            minHeight: 8,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7FDFD4)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // Collected Amount and Days Left
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Collected',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '20 days to go',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Rp 24.000.000',
                              style: TextStyle(
                                color: Color(0xFF7FDFD4),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(''),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Organizer Profile
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.blue[100],
                                child: const CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage('https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Screenshot%202025-04-13%20at%2007.35.14-imKS8zYFztTUNnaVdd2yevfpIosgCv.png'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Text(
                                        'WISNU BISA',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.verified,
                                        color: Color(0xFF7FDFD4),
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    'Verified Account',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Donate Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DonationAmountPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7FDFD4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Donate Now',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Bottom Indicator
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
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

class DonationAmountPage extends StatefulWidget {
  const DonationAmountPage({Key? key}) : super(key: key);

  @override
  State<DonationAmountPage> createState() => _DonationAmountPageState();
}

class _DonationAmountPageState extends State<DonationAmountPage> {
  final TextEditingController _amountController = TextEditingController(text: '200.000');
  final List<String> _predefinedAmounts = ['10.000', '50.000', '100.000', '150.000', '200.000', '250.000'];
  String _selectedAmount = '200.000';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7FDFD4),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  const Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle favorite button press
                    },
                    child: const Icon(Icons.favorite_border, color: Colors.black),
                  ),
                ],
              ),
            ),
            
            // Content - Popup style with rounded top corners
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Screenshot%202025-04-13%20at%2007.35.14-imKS8zYFztTUNnaVdd2yevfpIosgCv.png',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Fill the nominal
                        const Text(
                          'Fill the nominal',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Amount Input Field
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Rp',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.right,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '0',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAmount = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Predefined Amounts
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (int i = 0; i < 3; i++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedAmount = _predefinedAmounts[i];
                                    _amountController.text = _predefinedAmounts[i];
                                  });
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).size.width - 48) / 3,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color: _selectedAmount == _predefinedAmounts[i]
                                        ? const Color(0xFF7FDFD4).withOpacity(0.1)
                                        : Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Rp ${_predefinedAmounts[i]}',
                                      style: TextStyle(
                                        fontWeight: _selectedAmount == _predefinedAmounts[i]
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (int i = 3; i < 6; i++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedAmount = _predefinedAmounts[i];
                                    _amountController.text = _predefinedAmounts[i];
                                  });
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).size.width - 48) / 3,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color: _selectedAmount == _predefinedAmounts[i]
                                        ? const Color(0xFF7FDFD4).withOpacity(0.1)
                                        : Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Rp ${_predefinedAmounts[i]}',
                                      style: TextStyle(
                                        fontWeight: _selectedAmount == _predefinedAmounts[i]
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        
                        // Select Payment Method Button
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PaymentMethodPage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Select Payment Methode',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Continue Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle continue button press
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7FDFD4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Bottom Indicator
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
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

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({Key? key}) : super(key: key);

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'Bank Central Asia',
      'logo': 'BCA',
      'isSelected': false,
    },
    {
      'name': 'Mandiri',
      'logo': 'Mandiri',
      'isSelected': false,
    },
    {
      'name': 'Bri',
      'logo': 'Bri',
      'isSelected': false,
    },
    {
      'name': 'Qris',
      'logo': 'QRIS',
      'isSelected': false,
    },
    {
      'name': 'Saldo Bantu.in',
      'logo': '',
      'isSelected': true,
    },
  ];

  int _selectedMethodIndex = 4; // Default to Saldo Bantu.in

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7FDFD4),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 24), // For balance in the app bar
                ],
              ),
            ),
            
            // Content - Popup style with rounded top corners
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Select Payment Method',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Payment Methods List
                      Expanded(
                        child: ListView.builder(
                          itemCount: _paymentMethods.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedMethodIndex = index;
                                  for (int i = 0; i < _paymentMethods.length; i++) {
                                    _paymentMethods[i]['isSelected'] = i == index;
                                  }
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    // Logo placeholder
                                    SizedBox(
                                      width: 40,
                                      child: _getPaymentLogo(_paymentMethods[index]['logo']),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _paymentMethods[index]['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _paymentMethods[index]['isSelected']
                                            ? const Color(0xFF7FDFD4)
                                            : Colors.white,
                                        border: Border.all(
                                          color: _paymentMethods[index]['isSelected']
                                              ? const Color(0xFF7FDFD4)
                                              : Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Next Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle next button press
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7FDFD4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Bottom Indicator
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(2),
                          ),
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

  Widget _getPaymentLogo(String logo) {
    switch (logo) {
      case 'BCA':
        return const Text(
          'BCA',
          style: TextStyle(
            color: Color(0xFF0066AE),
            fontWeight: FontWeight.bold,
          ),
        );
      case 'Mandiri':
        return const Text(
          'M',
          style: TextStyle(
            color: Color(0xFFFFB700),
            fontWeight: FontWeight.bold,
          ),
        );
      case 'Bri':
        return const Text(
          'BRI',
          style: TextStyle(
            color: Color(0xFF00529C),
            fontWeight: FontWeight.bold,
          ),
        );
      case 'QRIS':
        return const Text(
          'QRIS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      default:
        return const SizedBox();
    }
  }
}