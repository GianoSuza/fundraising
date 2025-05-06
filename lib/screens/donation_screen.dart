import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fundraising/utils/formatter.dart';

class DonationDetailsPage extends StatefulWidget {
  final String campaignId;
  
  const DonationDetailsPage({
    Key? key,
    required this.campaignId,
  }) : super(key: key);

  @override
  State<DonationDetailsPage> createState() => _DonationDetailsPageState();
}

class _DonationDetailsPageState extends State<DonationDetailsPage> {
  Map<String, dynamic>? campaignData;
  bool isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchCampaignDetails();
  }

  Future<void> _fetchCampaignDetails() async {
    try {
      // First, increment the views count
      await FirebaseFirestore.instance
          .collection('donations')
          .doc(widget.campaignId)
          .update({
            'views': FieldValue.increment(1),
          });

      // Then fetch the updated campaign details
      final doc = await FirebaseFirestore.instance
          .collection('donations')
          .doc(widget.campaignId)
          .get();

      if (doc.exists) {
        setState(() {
          campaignData = doc.data();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching campaign details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF7FDFD4),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (campaignData == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF7FDFD4),
        body: Center(
          child: Text('Campaign not found'),
        ),
      );
    }

    // Calculate days left
    final finishDate = (campaignData!['finishDate'] as Timestamp).toDate();
    final now = DateTime.now();
    final daysLeft = finishDate.difference(now).inDays;

    // Get image URLs
    final List<String> imageUrls = List<String>.from(campaignData!['imageUrls'] ?? []);

    return Scaffold(
      backgroundColor: const Color(0xFF7FDFD4),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
                            // Image Carousel
                            if (imageUrls.isNotEmpty)
                              Column(
                                children: [
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      height: 200,
                                      viewportFraction: 1.0,
                                      enlargeCenterPage: false,
                                      autoPlay: true,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _currentIndex = index;
                                        });
                                      },
                                    ),
                                    items: imageUrls.map((url) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Image.network(
                                              url,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[200],
                                                  child: Center(
                                                    child: Icon(
                                                      _getCategoryIcon(campaignData!['category']),
                                                      size: 50,
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: imageUrls.asMap().entries.map((entry) {
                                      return Container(
                                        width: 8.0,
                                        height: 8.0,
                                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _currentIndex == entry.key
                                              ? const Color(0xFF7FDFD4)
                                              : Colors.grey[300],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              )
                            else
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Icon(
                                    _getCategoryIcon(campaignData!['category']),
                                    size: 50,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),
                            
                            // Title
                            Text(
                              campaignData!['name'] ?? 'No Title',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Description
                            Text(
                              campaignData!['description'] ?? 'No Description',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Category and Views
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _getCategoryIcon(campaignData!['category']),
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        campaignData!['category'] ?? 'Unknown Category',
                                        style: const TextStyle(
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
                                    children: [
                                      const Icon(Icons.visibility_outlined, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${campaignData!['views'] ?? 0}',
                                        style: const TextStyle(
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
                                value: (campaignData!['progress'] ?? 0) / (campaignData!['target'] ?? 1),
                                minHeight: 8,
                                backgroundColor: Colors.grey[200],
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7FDFD4)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            // Progress Info
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Days Left
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Collected',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '$daysLeft days to go',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                
                                // Amounts
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Collected Amount
                                    Flexible(
                                      child: Text(
                                        'Rp ${Formatter.formatCurrency(campaignData!['progress'].toInt() ?? 0)}',
                                        style: const TextStyle(
                                          color: Color(0xFF7FDFD4),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Target Amount
                                    Flexible(
                                      child: Text(
                                        'of Rp ${Formatter.formatCurrency(campaignData!['target'].toInt() ?? 0)}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
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
                                        children: [
                                          Text(
                                            campaignData!['organization'] ?? 'Unknown Organizer',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
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
                            const SizedBox(height: 80), // Add padding for the fixed button
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Fixed Donate Button at the bottom
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DonationAmountPage(
                              campaignId: widget.campaignId,
                              campaignData: campaignData!,
                            ),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'education':
        return Icons.school;
      case 'health':
        return Icons.medical_services;
      case 'environment':
        return Icons.eco;
      case 'social':
        return Icons.people;
      case 'disaster':
        return Icons.warning;
      default:
        return Icons.category;
    }
  }
}

class DonationAmountPage extends StatefulWidget {
  final String campaignId;
  final Map<String, dynamic> campaignData;

  const DonationAmountPage({
    Key? key,
    required this.campaignId,
    required this.campaignData,
  }) : super(key: key);

  @override
  State<DonationAmountPage> createState() => _DonationAmountPageState();
}

class _DonationAmountPageState extends State<DonationAmountPage> {
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;
  bool _isProcessing = false;
  String? _errorMessage;
  int _currentIndex = 0;
  Map<String, dynamic>? _selectedPaymentMethod;

  // Add quick amount list and selected index
  final List<String> _quickAmounts = ['10.000', '50.000', '100.000', '150.000', '200.000', '250.000'];
  int? _selectedQuickAmountIndex;

  @override
  void initState() {
    super.initState();
    _amountController.text = '100000';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // Add set quick amount method
  void _setQuickAmount(int index) {
    setState(() {
      _selectedQuickAmountIndex = index;
      _amountController.text = _quickAmounts[index].replaceAll('.', '');
    });
  }

  // Add build amount button method
  Widget _buildAmountButton(String amount, int index) {
    final isSelected = _selectedQuickAmountIndex == index;
    return GestureDetector(
      onTap: () => _setQuickAmount(index),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7FDFD4) : Colors.white,
          border: Border.all(color: isSelected ? const Color(0xFF7FDFD4) : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          'Rp $amount',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Future<void> _selectPaymentMethod() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentMethodPage(),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedPaymentMethod = result;
      });
    }
  }

  Future<void> _handleDonation() async {
    try {
      // Get user ID from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      // Convert amount to integer (remove dots and convert to int)
      final amount = int.parse(_amountController.text.replaceAll('.', ''));

      if (_selectedPaymentMethod!['name'] == 'Saldo Bantu.in') {
        // Update user's saldo
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (!userDoc.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not found')),
          );
          return;
        }

        final currentSaldo = userDoc.data()!['saldo'] ?? 0;
        if (currentSaldo < amount) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Insufficient balance')),
          );
          return;
        }

        // Update user's saldo
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
              'saldo': currentSaldo - amount,
            });

        // Create transaction record
        await FirebaseFirestore.instance
            .collection('transactions')
            .add({
              'userId': userId,
              'category': 'outcome',
              'name': widget.campaignData['name'],
              'amount': amount,
              'date': FieldValue.serverTimestamp(),
              'campaignId': widget.campaignId,
            });

        // Update campaign's collected amount
        await FirebaseFirestore.instance
            .collection('donations')
            .doc(widget.campaignId)
            .update({
              'progress': FieldValue.increment(amount),
            });

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // For other payment methods, show QR code
        Navigator.pushNamed(
          context,
          '/payment-confirmation',
          arguments: {
            'amount': amount,
            'campaignName': widget.campaignData['name'],
            'campaignId': widget.campaignId,
            'userId': userId,
          },
        );
      }
    } catch (e) {
      print('Error handling donation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get image URLs
    final List<String> imageUrls = List<String>.from(widget.campaignData['imageUrls'] ?? []);

    return Scaffold(
      backgroundColor: const Color(0xFF7FDFD4),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
                            // Image Carousel
                            if (imageUrls.isNotEmpty)
                              Column(
                                children: [
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      height: 200,
                                      viewportFraction: 1.0,
                                      enlargeCenterPage: false,
                                      autoPlay: true,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _currentIndex = index;
                                        });
                                      },
                                    ),
                                    items: imageUrls.map((url) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Image.network(
                                              url,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[200],
                                                  child: Center(
                                                    child: Icon(
                                                      _getCategoryIcon(widget.campaignData['category']),
                                                      size: 50,
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: imageUrls.asMap().entries.map((entry) {
                                      return Container(
                                        width: 8.0,
                                        height: 8.0,
                                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _currentIndex == entry.key
                                              ? const Color(0xFF7FDFD4)
                                              : Colors.grey[300],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              )
                            else
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Icon(
                                    _getCategoryIcon(widget.campaignData['category']),
                                    size: 50,
                                    color: Colors.grey[500],
                                  ),
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
                                          _selectedQuickAmountIndex = null; // Deselect quick amount if user types
                                          _amountController.text = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Add quick amount buttons here
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(3, (i) => _buildAmountButton(_quickAmounts[i], i)),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(3, (i) => _buildAmountButton(_quickAmounts[i + 3], i + 3)),
                            ),
                            const SizedBox(height: 16),
                            
                            // Select Payment Method Button
                            GestureDetector(
                              onTap: _selectPaymentMethod,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _selectedPaymentMethod != null
                                          ? _selectedPaymentMethod!['name']
                                          : 'Select Payment Method',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: _selectedPaymentMethod != null
                                            ? Colors.black
                                            : Colors.grey[600],
                                      ),
                                    ),
                                    if (_selectedPaymentMethod != null)
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFF7FDFD4),
                                          border: Border.all(
                                            color: const Color(0xFF7FDFD4),
                                          ),
                                        ),
                                      )
                                    else
                                      const Icon(Icons.arrow_forward_ios, size: 16),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 80), // Add padding for the fixed button
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Fixed Continue Button at the bottom
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedPaymentMethod != null
                      ? _handleDonation
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedPaymentMethod != null
                        ? const Color(0xFF7FDFD4)
                        : Colors.grey[300],
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
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'education':
        return Icons.school;
      case 'health':
        return Icons.medical_services;
      case 'environment':
        return Icons.eco;
      case 'social':
        return Icons.people;
      case 'disaster':
        return Icons.warning;
      default:
        return Icons.category;
    }
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
      'name': 'BRI',
      'logo': 'BRI',
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
      'isSelected': false,
    },
  ];

  int _selectedMethodIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7FDFD4),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
                          const SizedBox(height: 80), // Add padding for the fixed button
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Fixed Next Button at the bottom
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _paymentMethods[_selectedMethodIndex]);
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
      case 'BRI':
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