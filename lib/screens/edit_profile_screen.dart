import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('userName') ?? '';
      _emailController.text = prefs.getString('userEmail') ?? '';
    });
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        throw Exception('User not found');
      }

      // Update in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': _nameController.text,
        'email': _emailController.text,
      });

      // Update in SharedPreferences
      await prefs.setString('userName', _nameController.text);
      await prefs.setString('userEmail', _emailController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          // Profile Picture
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 40,
                  color: Colors.grey[400],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 4, bottom: 4),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.photo_camera,
                  color: Colors.black54,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Form Fields
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Full Name Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Full name',
                      hintStyle: TextStyle(color: Colors.black38, fontSize: 15),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Email Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.black38, fontSize: 15),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                      suffixIcon: Icon(
                        Icons.mail_outline,
                        color: Colors.black38,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Save Button
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2DAA9E),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
