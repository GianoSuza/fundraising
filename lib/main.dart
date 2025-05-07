import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fundraising/screens/my_campaigns_screen.dart';
import 'package:fundraising/screens/onboard.dart';
import 'screens/topup_screen.dart';
import 'screens/payment_method_screen.dart';
import 'screens/payment_confirmation_screen.dart';
import 'screens/transaction_history_screen.dart';
import 'screens/account_screen.dart';
import 'screens/my_profile_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/donation_screen.dart';
import 'screens/create_campaign.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // this is important
  );
  await Supabase.initialize(
    url: 'https://ytsotxeekfpfibulsxnd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl0c290eGVla2ZwZmlidWxzeG5kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzEwNTA5MDMsImV4cCI6MjA0NjYyNjkwM30.QOn5mmpYs2T2rp7lZ_4CneuDIX7axFSHYzb1oxanuUE',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Donation App',
      theme: ThemeData(
        primaryColor: const Color(0xFF4ECDC4),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4ECDC4),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4ECDC4),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/signin': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomePage(),
        '/topup': (context) => TopupScreen(),
        '/payment-method': (context) => PaymentMethodScreen(amount: 0,),
        '/payment-confirmation': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return PaymentConfirmationScreen(
            amount: args['amount'],
            campaignName: args['campaignName'],
            campaignId: args['campaignId'],
            userId: args['userId'],
          );
        },
        '/transaction-history': (context) => TransactionHistoryScreen(),
        '/account': (context) => AccountScreen(),
        '/my-profile': (context) => MyProfileScreen(),
        '/edit-profile': (context) => EditProfileScreen(),
        '/change-password': (context) => ChangePasswordScreen(),
        '/donation': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return DonationDetailsPage(campaignId: args['campaignId']);
        },
        '/create-campaign': (context) => CreateCampaignPage(),
        '/my-campaigns': (context) => const MyCampaignsScreen(),
      },
    );
  }
}