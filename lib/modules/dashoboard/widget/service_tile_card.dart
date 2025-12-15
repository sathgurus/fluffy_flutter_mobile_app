import 'package:flutter/material.dart';

class ServiceTile extends StatelessWidget {
  final String title;
  final String duration;
  final String value;
  final String totalOrders;
  final Color color;
  final String clientName;

  const ServiceTile({
    super.key,
    required this.title,
    required this.duration,
    required this.value,
    required this.totalOrders,
    required this.color,
    required this.clientName
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: const Text(
                "S",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text("Client Name: $clientName"),
                  const SizedBox(height: 5),
                  Text("Serviced Duration: $duration"),
                  const SizedBox(height: 5),
                  Text(
                    "Order Value: $value   Total Orders: $totalOrders",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
