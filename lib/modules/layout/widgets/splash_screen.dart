import 'dart:async';
import 'package:fluffy/core/NavigationService.dart';
import 'package:fluffy/modules/auth/login.dart';
import 'package:fluffy/modules/auth/provider/auth_provider.dart';
import 'package:fluffy/modules/layout/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String firstRouts = '';
  Future<void> _checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print("token $token");
    final nav = NavigationService();

    if (token != null) {
      nav.pushReplacementPage(const BottomNav());
    } else {
      if (dotenv.env['BUILD'] == 'admin') {
        nav.pushReplacementNamed('/adminLogin');
      } else {
        nav.pushReplacementNamed('/login');
      }
    }
  }

  initialRoutes() {
    if (dotenv.env['BUILD']! == 'admin') {
      firstRouts = '/adminLogin';
    } else {
      firstRouts = '/';
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
