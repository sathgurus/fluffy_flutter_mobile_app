import 'package:fluffy/modules/app_theme/app_colors.dart';
import 'package:fluffy/modules/clients/client_screen.dart';
import 'package:fluffy/modules/dashoboard/home.dart';
import 'package:fluffy/modules/layout/more_menu.dart';
import 'package:fluffy/modules/orders/orders.dart';
import 'package:fluffy/modules/service/services.dart';
import 'package:fluffy/modules/settings/profile_settings.dart';
import 'package:flutter/material.dart';



class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    OrdersScreen(),
    ClientScreen(),
    ProfileSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Clients"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}
