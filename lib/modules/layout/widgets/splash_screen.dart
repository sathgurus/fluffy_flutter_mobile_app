import 'dart:async';
import 'package:fluffy/modules/auth/login.dart';
import 'package:fluffy/modules/auth/provider/auth_provider.dart';
import 'package:fluffy/modules/layout/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    // Get provider
    final authProvider = Provider.of<LoginProvider>(context, listen: false);

    // Load persisted user data (from SharedPreferences)
    await authProvider.loadUserData();

    // Wait for splash animation (optional)
    await Future.delayed(const Duration(seconds: 2));

    // Navigate based on login state
    if (!mounted) return;

    print("user details ${authProvider.userDetails}");

    if (authProvider.token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNav()), // home/dashboard
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginTabsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              alignment: Alignment.center,
              child: Image.asset('assets/fluffy.jpeg', fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            Text("Welcome to Fluffy pet care services..!"),
          ],
        ),
      ),
    );
  }
}
