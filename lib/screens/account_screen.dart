import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> with WidgetsBindingObserver {
  String userName = '';
  String userEmail = '';
  String userProfilePic = 'https://placeholder.com/150x150';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
      userEmail = prefs.getString('userEmail') ?? '';
      userProfilePic = prefs.getString('userProfilePic') ?? 'https://placeholder.com/150x150';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2DAA9E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Account',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Profile Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(userProfilePic),
                  ),
                  const SizedBox(width: 16),
                  // Profile Info and Buttons
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          userName.isNotEmpty ? userName : 'No Name',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          userEmail.isNotEmpty ? userEmail : 'No Email',
                          style: const TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            SizedBox(
                              height: 32,
                              child: ElevatedButton.icon(
                                onPressed: _handleEditProfile,
                                icon: const Icon(
                                  Icons.person_outline,
                                  size: 14,
                                ),
                                label: const Text(
                                  'My Profile',
                                  style: TextStyle(fontSize: 12),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  side: const BorderSide(color: Colors.black12),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: 32,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/topup');
                                },
                                icon: const Icon(Icons.wallet, size: 14),
                                label: const Text(
                                  'Top up',
                                  style: TextStyle(fontSize: 12),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  side: const BorderSide(color: Colors.black12),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Menu List Section
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  // _buildMenuItem(Icons.favorite_border, 'My donation'),
                  _buildMenuItem(Icons.lock_outline, 'Change password'),
                  _buildMenuItem(Icons.logout, 'Logout'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4ECDC4),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          // Tambahkan fungsi navigasi untuk bottom bar di sini nanti
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

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Icon(icon, color: Colors.black, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.black54,
        size: 20,
      ),
      onTap: () async {
        if (title == 'Logout') {
          // Show confirmation dialog
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Logout'),
                ),
              ],
            ),
          );

          if (shouldLogout == true) {
            // Clear all SharedPreferences data
            final prefs = await SharedPreferences.getInstance();
            await prefs.clear();

            // Navigate to signin page and remove all previous routes
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/signin',
                (route) => false,
              );
            }
          }
        } else if (title == 'Change password') {
          // Navigate to change password screen
          Navigator.pushNamed(context, '/change-password');
        }
      },
    );
  }

  // Add this method to handle profile edit button tap
  void _handleEditProfile() async {
    await Navigator.pushNamed(context, '/edit-profile');
    // Reload user data after returning from edit profile
    _loadUserData();
  }
}
