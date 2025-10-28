import 'package:flutter/material.dart';

Color appPrimaryColor = Color(0xFFFF8A80);

class AppColors {
  static const Color background = Color(0xFFF2F4F8);
  static const Color cardBackground = Colors.white;
  static const Color primary = Color(0xFFFF8A80);
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.grey;
  static const Color navInactive = Colors.grey;
}

Future<void> initializeAppColors() async {
  // Initialize flavor from PackageInfo

  // Set the primary color based on the active flavor

  appPrimaryColor = Color(0xFFFF8A80);
}
