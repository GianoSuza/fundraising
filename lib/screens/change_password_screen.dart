import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New passwords do not match')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final userEmail = prefs.getString('userEmail');

      if (userId == null || userEmail == null) {
        throw Exception('User not found');
      }

      // Get user document from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final currentPassword = userData['password'];

      // Verify current password
      if (currentPassword != _currentPasswordController.text) {
        throw Exception('Current password is incorrect');
      }

      // Update password in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'password': _newPasswordController.text,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error changing password: $e')),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2DAA9E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Change password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Password Field
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
                        controller: _currentPasswordController,
                        obscureText: _obscureCurrentPassword,
                        decoration: InputDecoration(
                          hintText: 'Current Password',
                          hintStyle: const TextStyle(
                            color: Colors.black38,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureCurrentPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black38,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureCurrentPassword =
                                    !_obscureCurrentPassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Color(0xFF2DAA9E),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    // New Password Field
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
                        controller: _newPasswordController,
                        obscureText: _obscureNewPassword,
                        decoration: InputDecoration(
                          hintText: 'New Password',
                          hintStyle: const TextStyle(
                            color: Colors.black38,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureNewPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black38,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Confirm Password Field
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
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: const TextStyle(
                            color: Colors.black38,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black38,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Change Password Button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2DAA9E),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
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
                        'Change password',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
