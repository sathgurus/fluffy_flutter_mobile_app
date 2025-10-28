import 'package:flutter/material.dart';

class SnapshotItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const SnapshotItem({
    required this.icon,
    required this.label,
    required this.value,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.redAccent, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
