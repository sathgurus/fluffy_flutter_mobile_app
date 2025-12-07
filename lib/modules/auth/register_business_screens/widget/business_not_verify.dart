import 'package:fluffy/modules/auth/login.dart';
import 'package:flutter/material.dart';

class BusinessNotVerifiedScreen extends StatelessWidget {
  final String message;

  const BusinessNotVerifiedScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ❌ Warning icon
            Icon(Icons.error_outline, color: Colors.redAccent, size: 90),
            const SizedBox(height: 20),

            // ❗ Title
            Text(
              "Business Not Verified",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // 📌 Message from API
            Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginTabsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Retry Login",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 📞 Contact Support Button
            TextButton(
              onPressed: () {
                // Add customer care logic if needed
              },
              child: const Text(
                "Contact Customer Care",
                style: TextStyle(color: Colors.blueAccent, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
