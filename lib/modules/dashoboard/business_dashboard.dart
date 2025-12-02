import 'dart:convert';

import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/auth/provider/auth_provider.dart';
import 'package:fluffy/modules/booking/booking_requests.dart';
import 'package:fluffy/modules/dashoboard/widget/daily_shanpshot_card.dart';
import 'package:fluffy/modules/dashoboard/widget/financial_overview.dart';
import 'package:fluffy/modules/dashoboard/widget/revenue_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessDashboard extends StatefulWidget {
  const BusinessDashboard({super.key});

  @override
  State<BusinessDashboard> createState() => _BusinessDashboardState();
}

class _BusinessDashboardState extends State<BusinessDashboard> {
  Map? userDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      //final userId = prefs.getString("userId");
      final userJson = prefs.getString('userDetails');
      if (userJson != null) {
        setState(() {
          userDetails = jsonDecode(userJson); // Convert back to Map
          isLoading = false;
          print("Loaded user: $userDetails");
        });
      } else {
        setState(() {
          userDetails = null;
          isLoading = false;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    final authProvider = Provider.of<LoginProvider>(context, listen: false);
    if (isLoading) {
      // Show loader while data is loading
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (userDetails == null) {
      // No user logged in
      return Scaffold(
        body: Center(child: Text("No user found. Please login.")),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    //backgroundImage: ,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello ${userDetails!['name']},",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Make your day easy with us",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Booking alert cardi
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BookingRequestScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text takes available space
                      Expanded(
                        child: const Text(
                          "You have 5 new booking requests\nA quick look at the new requests you’ve received.",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      // Arrow icon at the end
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 25,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Daily Snapshot
              const Text(
                "Daily Snapshot",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      SnapshotItem(
                        icon: Icons.calendar_today,
                        label: "Appointments Today",
                        value: "12",
                      ),
                      SnapshotItem(
                        icon: Icons.person_add,
                        label: "New Clients",
                        value: "3",
                      ),
                      SnapshotItem(
                        icon: Icons.currency_rupee,
                        label: "Est. Revenue",
                        value: "₹12,000",
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Financial Overview
              const Text(
                "Financial Overview",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FinancialOverview(),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        SnapshotItem(
                          icon: Icons.people,
                          label: "Total Clients",
                          value: "12",
                        ),
                        SnapshotItem(
                          icon: Icons.person_outline,
                          label: "Avg Agents/Day",
                          value: "8",
                        ),
                        SnapshotItem(
                          icon: Icons.currency_rupee,
                          label: "Total Revenue",
                          value: "₹1,15,000",
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Top Services
              const Text(
                "Top 5 Service by Revenue",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              TopServicesBarChart(),

              // Card(
              //   color: Colors.white,

              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   elevation: 2,
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 16,
              //       vertical: 14,
              //     ),
              //     child: Column(
              //       children: [
              //         const RevenueBar(
              //           title: "Grooming",
              //           value: 10000,
              //           color: Colors.teal,
              //         ),
              //         const RevenueBar(
              //           title: "Spa",
              //           value: 7500,
              //           color: Colors.teal,
              //         ),
              //         const RevenueBar(
              //           title: "Nail Clipping",
              //           value: 5000,
              //           color: Colors.teal,
              //         ),
              //         const RevenueBar(
              //           title: "Service 4",
              //           value: 4000,
              //           color: Colors.teal,
              //         ),
              //         const RevenueBar(
              //           title: "Service 5",
              //           value: 3500,
              //           color: Colors.teal,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
