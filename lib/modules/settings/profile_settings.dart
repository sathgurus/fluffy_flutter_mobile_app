import 'dart:convert';
import 'dart:io';

import 'package:fluffy/modules/settings/settings_business_hours.dart';
import 'package:fluffy/modules/settings/settings_service.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  Map<String, dynamic> user = {};
  String userName = "";
  String? userShopLogo;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

   Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('userDetails');

    if (userString != null) {
      final decodedUser = jsonDecode(userString);

      setState(() {
        user = decodedUser;
        userName = decodedUser['name'] ?? "User";
        userShopLogo = decodedUser['shopVerification']?['shopLogo'];
      });

      print("User Data Loaded: $userShopLogo");

      // ✅ CLEAN INVALID CACHE PATH
      if (userShopLogo != null && !File(userShopLogo!).existsSync()) {
        debugPrint("Invalid image path removed");
        userShopLogo = null;
      }
    }
  }

  /// ✅ IMAGE PROVIDER (100% SAFE)
  ImageProvider shopImageProvider(String? path) {
    if (path == null || path.isEmpty) {
      return const AssetImage("assets/fluffy.jpeg");
    }

    if (path.startsWith("http")) {
      return NetworkImage(path);
    }

    final file = File(path);
    if (file.existsSync()) return FileImage(file);

    return const AssetImage("assets/fluffy.jpeg");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            //  Navigator.pop(context);
          },
        ),
      ),

      body: Column(
        children: [
          // ✅ Profile Top Section (Auto Height)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Manage account details, and more",
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          _MiniTag(label: "1 Store"),
                          // SizedBox(width: 8),
                          // _MiniTag(label: "12 Services"),
                        ],
                      ),
                    ],
                  ),
                ),
               CircleAvatar(
                  radius: 28,
                  backgroundImage: shopImageProvider(userShopLogo),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ✅ FULL Screen White Section
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),

              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Title
                    const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 12),
                      child: Text(
                        "Accounts Setting",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SettingsTile(
                      icon: Icons.store,
                      title: "Business Information",
                      onTap: () {},
                    ),
                    SettingsTile(
                      icon: Icons.access_time_rounded,
                      title: "Business Hours",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsBusinessHours(),
                          ),
                        );
                      },
                    ),
                    SettingsTile(
                      icon: Icons.tag,
                      title: "Service & Pricing",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsService(),
                          ),
                        );
                      },
                    ),
                    SettingsTile(
                      icon: Icons.notifications_none,
                      title: "Notification",
                      onTap: () {},
                    ),
                    SettingsTile(
                      icon: Icons.lock_outline,
                      title: "Change Password",
                      onTap: () {},
                    ),

                    const SizedBox(height: 36),

                    // ✅ Logout Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();

                          await prefs.clear();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LoginTabsScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffF8F8F8),
                          foregroundColor: Colors.red,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                        child: const Text("Log Out"),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final String label;
  const _MiniTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          leading: Icon(icon, color: Colors.black87),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        //const Divider(height: 1),
        const SizedBox(height: 10),
      ],
    );
  }
}
