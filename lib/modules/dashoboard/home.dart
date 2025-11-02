import 'package:fluffy/modules/auth/provider/auth_provider.dart';
import 'package:fluffy/modules/booking/booking_requests.dart';
import 'package:fluffy/modules/dashoboard/business_dashboard.dart';
import 'package:fluffy/modules/dashoboard/customer_dashboard.dart';
import 'package:fluffy/modules/dashoboard/widget/daily_shanpshot_card.dart';
import 'package:fluffy/modules/dashoboard/widget/financial_overview.dart';
import 'package:fluffy/modules/dashoboard/widget/revenue_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<LoginProvider>(context, listen: false);
    print("user detailes ${authProvider.userDetails}");
    return authProvider.userDetails!['role'] == "business_owner"
        ? BusinessDashboard()
        : CustomerDashboard();
  }
}
