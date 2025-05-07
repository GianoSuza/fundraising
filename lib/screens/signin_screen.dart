import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bantu.In',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              // Logo
              Center(
                child: Text(
                  'Bantu.In',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4ECDC4),
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(flex: 1),
              // Email field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey[500],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Handle forgot password
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Color(0xFF4ECDC4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Sign in button
              ElevatedButton(
                onPressed: () async {
                  // Handle sign in
                  String email = _emailController.text.trim();
                  String password = _passwordController.text;

                  try {
                    QuerySnapshot snapshot = await FirebaseFirestore.instance
                        .collection('users')
                        .where('email', isEqualTo: email)
                        .where('password', isEqualTo: password) // Not secure, okay for testing
                        .limit(1)
                        .get();

                    if (snapshot.docs.isNotEmpty) {
                      var userData = snapshot.docs.first.data() as Map<String, dynamic>;

                      // Save user data in SharedPreferences
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString('userId', snapshot.docs.first.id);
                      await prefs.setString('userName', userData['name']);
                      await prefs.setString('userPassword', userData['password']);
                      await prefs.setString('userEmail', userData['email']);
                      await prefs.setInt('userSaldo', userData['saldo']);
                      await prefs.setBool('isLoggedIn', true);

                      // Navigate to homepage
                      Navigator.pushReplacementNamed(context, '/home'); // adjust route
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid credentials')),
                      );
                    }
                  } catch (e) {
                    print('Error during sign in: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login failed: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(
                    0xFF4ECDC4,
                  ), // Use primary instead of backgroundColor
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Sign in',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 24),
              // Don't have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle sign up
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Terms and privacy
              Text(
                'By signing in you accept the. Terms of Services and Privacy Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
