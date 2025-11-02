import 'package:fluffy/modules/app_theme/app_colors.dart';
import 'package:fluffy/modules/auth/provider/auth_provider.dart';
import 'package:fluffy/modules/clients/client_screen.dart';
import 'package:fluffy/modules/dashoboard/home.dart';
import 'package:fluffy/modules/layout/more_menu.dart';
import 'package:fluffy/modules/orders/orders.dart';
import 'package:fluffy/modules/service/services.dart';
import 'package:fluffy/modules/settings/profile_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<LoginProvider>(context, listen: false);

    final List<Widget> pages = [
      HomeScreen(),
      authProvider.userDetails!['role'] == "business_owner"
          ? OrdersScreen()
          : ServicesScreen(),
      authProvider.userDetails!['role'] == "business_owner"
          ? ClientScreen()
          : OrdersScreen(),
      ProfileSettings(),
    ];
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.navInactive,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label:
                authProvider.userDetails!['role'] == "business_owner"
                    ? "Bookings"
                    : "Service",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label:
                authProvider.userDetails!['role'] == "business_owner"
                    ? "Clients"
                    : "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
