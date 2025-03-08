import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
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
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                      'https://placeholder.com/150x150',
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Profile Info and Buttons
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Mohammad Salah',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          'msalah@gmail.com',
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            SizedBox(
                              height: 32,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/edit-profile');
                                },
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
                                onPressed: () {},
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
                  _buildMenuItem(Icons.favorite_border, 'My donation'),
                  _buildMenuItem(Icons.lock_outline, 'Change password'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        elevation: 0,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.circle_outlined), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: '',
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
      onTap: () {},
    );
  }
}
