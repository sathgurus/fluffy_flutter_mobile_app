import 'package:flutter/material.dart';

class PetSetupCompleteScreen extends StatefulWidget {
  const PetSetupCompleteScreen({super.key});

  @override
  State<PetSetupCompleteScreen> createState() => _PetSetupCompleteScreenState();
}

class _PetSetupCompleteScreenState extends State<PetSetupCompleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),

            // Illustration
            Container(
              height: 100,
              width: 100,
              child: Image.asset(
                "assets/dog.jpg", // Replace with your image asset
               // height: 180,
              ),
            ),

            const SizedBox(height: 20),

            // Celebration Text
            const Text(
              "🎉 “Bruno's all set!”",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "“Let’s find the best care for him 🐾💛”",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF777777),
              ),
            ),

            const SizedBox(height: 50),

            // Explore Services Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF758C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Explore Services",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // View Profile Button (Outlined)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFFFF758C),
                      width: 1.4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "View Bruno's Profile",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF758C),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
