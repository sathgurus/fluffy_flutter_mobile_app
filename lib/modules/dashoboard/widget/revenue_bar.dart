import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:flutter/material.dart';

class TopServicesBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> services = [
    {'name': 'Grooming', 'revenue': 100},
    {'name': 'Spa', 'revenue': 80},
    {'name': 'Nail Clipping', 'revenue': 70},
    {'name': 'Service 4', 'revenue': 60},
    {'name': 'Service 5', 'revenue': 60},
  ];

  TopServicesBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the highest revenue for scaling
    final int maxRevenue = services
        .map((s) => s['revenue'] as int)
        .reduce((a, b) => a > b ? a : b);

    return Card(
      color: Colors.white,
     // margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final maxBarWidth =
                    constraints.maxWidth -
                    130; // Reserve space for text and margin

                return Column(
                  children:
                      services.map((service) {
                        double percent = (service['revenue'] / maxRevenue);
                        double barWidth = percent * maxBarWidth;
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 90,
                                child: Text(
                                  service['name'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    width: maxBarWidth,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  Container(
                                    width: barWidth,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 8),
                              Text('₹${service['revenue']}'),
                            ],
                          ),
                        );
                      }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
