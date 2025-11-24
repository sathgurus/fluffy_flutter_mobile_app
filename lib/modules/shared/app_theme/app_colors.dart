import 'package:flutter/material.dart';

Color appPrimaryColor = Color(0xFFAE8FE5);

class AppColors {
  static const Color background = Color(0xFFF2F4F8);
  static const Color cardBackground = Colors.white;
  static const Color primary = Color(0xFFAE8FE5);
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.grey;
  static const Color navInactive = Colors.grey;
  static const Color appBarColor = Color(0xffC3A2FF);
  static const Color whiteColor = Colors.white;

}

Future<void> initializeAppColors() async {
  // Initialize flavor from PackageInfo

  // Set the primary color based on the active flavor

  appPrimaryColor = Color(0xFFAE8FE5);
}
