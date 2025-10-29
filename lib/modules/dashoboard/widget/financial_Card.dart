import 'package:flutter/material.dart';

class FinancialSummaryCard extends StatelessWidget {
  const FinancialSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xffC3A2FF), Color(0xffFF9AE1)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _SummaryItem(title: "Total Revenue", value: "₹18500.00"),
              _SummaryItem(title: "Total Clients", value: "230"),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            "Receive ₹2,572.50 this month.",
            style: TextStyle(color: Colors.white70),
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
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
