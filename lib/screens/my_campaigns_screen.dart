import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'donation_screen.dart';
import 'package:fundraising/utils/formatter.dart';

class MyCampaignsScreen extends StatefulWidget {
  const MyCampaignsScreen({super.key});

  @override
  State<MyCampaignsScreen> createState() => _MyCampaignsScreenState();
}

class _MyCampaignsScreenState extends State<MyCampaignsScreen> {
  List<Map<String, dynamic>> campaigns = [];
  String? userId;
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      userName = prefs.getString('userName');
    });
    if (userName != null) {
      await loadCampaigns();
    }
  }

  Future<void> loadCampaigns() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('donations')
          .where('organization', isEqualTo: userName)
          .get();

      final loadedCampaigns = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['name'] ?? '',
          'organization': data['organization'] ?? '',
          'target': data['target'] ?? 0,
          'category': data['category'] ?? '',
          'progress': data['progress'] ?? 0,
          'icon': _getCategoryIcon(data['category'] ?? ''),
          'finishDate': data['finishDate'],
          'createdAt': data['createdAt'],
          'imageUrls': data['imageUrls'],
        };
      }).toList();

      setState(() {
        campaigns = loadedCampaigns;
      });
    } catch (e) {
      print('Error loading campaigns: $e');
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Bencana Alam':
        return Icons.flood;
      case 'Kesehatan':
        return Icons.medical_services;
      case 'Lingkungan':
        return Icons.eco;
      case 'Dhuafa':
        return Icons.volunteer_activism;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4ECDC4),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16),
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
                        'My Campaigns',
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
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: campaigns.isEmpty
                    ? const Center(
                        child: Text(
                          'No campaigns yet',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: campaigns.length,
                        itemBuilder: (context, index) {
                          final campaign = campaigns[index];
                          return CampaignCard(
                            title: campaign['title'] as String,
                            organization: campaign['organization'] as String,
                            target: campaign['target'] as int,
                            icon: campaign['icon'] as IconData,
                            progress: campaign['progress'] as double,
                            campaignId: campaign['id'] as String,
                            imageUrls: campaign['imageUrls'] as List<dynamic>?,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4ECDC4),
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/create-campaign');
              break;
            case 2:
              // Already on my campaigns page
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'My Campaigns',
          ),
        ],
      ),
    );
  }
}

class CampaignCard extends StatelessWidget {
  final String title;
  final String organization;
  final int target;
  final IconData icon;
  final double progress;
  final String campaignId;
  final List<dynamic>? imageUrls;

  const CampaignCard({
    super.key,
    required this.title,
    required this.organization,
    required this.target,
    required this.icon,
    required this.progress,
    required this.campaignId,
    this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DonationDetailsPage(
                  campaignId: campaignId,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(10),
          splashColor: const Color(0xFF4ECDC4).withOpacity(0.2),
          highlightColor: const Color(0xFF4ECDC4).withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image or placeholder
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: imageUrls != null && imageUrls!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.network(
                          imageUrls![0],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                icon,
                                size: 30,
                                color: Colors.grey.shade500,
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Icon(
                          icon,
                          size: 30,
                          color: Colors.grey.shade500,
                        ),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              organization,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF4ECDC4),
                            size: 14,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (progress.toInt()) / (target),
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Collected: Rp ${Formatter.formatCurrency(progress.toInt())}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 