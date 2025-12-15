import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:flutter/material.dart';

class FinancialSummaryCard extends StatelessWidget {
  final double totalRevenue;
  final int totalClients; // optional, you can pass dynamically
  const FinancialSummaryCard({
    required this.totalRevenue,
    this.totalClients = 230, // default value
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Convert double to string
              _SummaryItem(
                title: "Total Revenue",
                value: "₹ ${totalRevenue.toStringAsFixed(2)}",
              ),
              _SummaryItem(
                title: "Total Clients",
                value: totalClients.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;
  const _SummaryItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ],
    );
  }
}
