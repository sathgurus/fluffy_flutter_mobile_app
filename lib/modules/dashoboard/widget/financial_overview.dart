import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/dashoboard/widget/financial_Card.dart';
import 'package:fluffy/modules/dashoboard/widget/service_tile_card.dart';
import 'package:flutter/material.dart';

class FinancialOverview extends StatefulWidget {
  const FinancialOverview({super.key});

  @override
  State<FinancialOverview> createState() => _FinancialOverviewState();
}

class _FinancialOverviewState extends State<FinancialOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Financial Overview"),
        centerTitle: true,
        backgroundColor: AppColors.appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      backgroundColor: const Color(0xffF5F6FA),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FinancialSummaryCard(),
            const SizedBox(height: 20),

            const Text(
              "Service Performance",
              style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Search Box
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search Service Name",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ✅ Date Filter (Static for example)
            Chip(
              label: const Text("18th April 2025 - 24th April 2025"),
              backgroundColor: Colors.white,
              deleteIcon: const Icon(Icons.close),
              onDeleted: () {},
            ),

            const SizedBox(height: 16),

            // ✅ Service List Example
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                return ServiceTile(
                  title: "Service Name ${index + 1}",
                  duration: "15 Minutes",
                  value: "₹1250.00",
                  totalOrders: "5",
                  color: Colors.primaries[index % Colors.primaries.length],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}